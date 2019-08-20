#!/usr/bin/perl

#use diagnostics;

use File::Basename;
use File::Copy;
use JSON::XS;
use YAML::XS qw(LoadFile DumpFile);
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
use Text::Markdown qw(markdown);

binmode STDOUT, ":utf8";

my $here_path   =   File::Basename::dirname( eval { ( caller() )[1] } );
my $config     	=   LoadFile($here_path.'/config.yaml') or die "¡No config.yaml file in this path!";
bless $config;

# command line input
my %args        =   @ARGV;
$args{-filter}	||= q{};
$args{-cleanup}	||= "n";
foreach (keys %args) { $config->{args}->{$_} = $args{$_} }

_check_paths($config);
_delete_generated_files($config);
_process_input_dirs($config);

exit;

################################################################################
################################################################################
################################################################################
# subs
################################################################################
################################################################################
################################################################################

sub _process_yaml {

  my $config 		=   shift;
  my $src_path 	=   shift;
  my $file_name =   shift;
  my $yaml_file =   $src_path.'/'.$file_name;

  print "Reading YAML file \"$yaml_file\"\n";

  my $data      =   LoadFile($yaml_file);
# TODO: Ist this way to get the class name safe?
  my $className	=		(split('/', $data->{'$id'}))[-2];
  
=podmd
The class name is extracted from the __properly formatted__ "$id" value.

Processing is skipped if the class name does not consist of word character, or
if a filter had been provided and the class name doesn't match.

=cut

  if ($className !~ /^\w+?$/) { return }
  
	if ($args{-filter} =~ /.../) {
		if ($className !~ /$args{-filter}/) {
			return } }

  my $jekyll_header =   _create_jekyll_header($config, $className);

=podmd
The web file gets a prefix, to ensure that auto-generated and normal pages can 
be separated w/o using directory logic for the site.

=cut

  my $expl_file = 	$config->{paths}->{'json_path_rel'}.'/'.$className.'-examples.json';
  my $md_file   =   $config->{paths}->{'md_path_rel'}.'/'.$className.'.md';
  my $src_web_file	=		$config->{paths}->{'md_web_schemas_src_rel'}.'/'.$file_name;
  my $md_web_file   =   $config->{paths}->{'md_web_doc_rel'}.'/'.$config->{generator_prefix}.$className.'.md';
  my $yaml_github_web_link 	=   $config->{paths}->{github_repository_path}.'/src/yaml/'.$file_name;
  copy($yaml_file, $src_web_file);

=podmd
The documentation is extracted from the $data object and formatted into a
markdown document.

=cut

  my $markdown  =   <<END;

## $className

### SchemaBlocks Metadata

* {S}[B] Status  [[i]]($config->{links}->{sb_status_levels})
    - __$data->{meta}->{sb_status}__
END

	foreach my $attr (qw(provenance used_by contributors)) {
		if ($data->{meta}->{$attr}) {
			my $label =   $attr;
			$label  	=~  s/\_/ /g;
			$markdown .=  "\n\n* ".ucfirst($label)."  \n";
			foreach (@{$data->{meta}->{$attr}}) {
				my $this		=   $_->{description};
=podmd
The script performs a CURIE to URL expansion for prefixes defined in the
configuration file and links e.g. the 

=cut
				my $id			=		_expand_CURIEs($config, $_->{id});
				if ($id =~ /\:\/\/\w/) {
					$this 		=   '['.$this.']('.$id.')' }
				elsif ($id =~ /\w/) {
					$this 		.=  ' ('.$id.')' }
				$markdown 	.=  "\n    - ".$this."  ";
	}}}
  $markdown  		.=  <<END;

$config->{jekyll_excerpt_separator}

### Properties

<table>
  <tr>
    <th>Property</th>
    <th>Type</th>
  </tr>
END

  foreach my $property ( sort keys %{ $data->{properties} } ) {

    my $type  	=   $data->{properties}->{$property}->{type};
    my $typeLab;
    if ($type =~ /array/) {
    	$typeLab	=		"array of ";
    	$type			=		$data->{properties}->{$property}->{items};
    }
    if (ref($type) =~ /HASH/) {
    	my $key		=		(keys %$type)[0];
    	my $link	=		$type->{ $key };
# TODO: currently the link to the "official" spec is made relative, since this
# hasn't been finalized...
			$link			=~	s/^.+?ga4gh/./;
			$link			=~	s/\/[^\/]+?$/.html/;
   		$typeLab	.=	$key.': <a href="'.$link.'" target="_BLANK">'.$link.'</a>' }
    else {
    	$typeLab	.=	$type }

    $markdown .=  <<END;
  <tr>
    <td>$property</td>
    <td>$typeLab</td>
  </tr>
END
    }

  $markdown   .=  "\n".'</table>'."\n\n";

=podmd
The property overview is followed by the listing of the properties, including
descriptions and examples.

=cut
   
  foreach my $property ( sort keys %{ $data->{properties} } ) {

    my $type  	=   $data->{properties}->{$property}->{type};
    my $typeLab;
    if ($type =~ /array/) {
    	$typeLab	=		"array of ";
    	$type			=		$data->{properties}->{$property}->{items};
    }
    if (ref($type) =~ /HASH/) {
    	my $key		=		(keys %$type)[0];
    	my $link	=		$type->{ $key };
# TODO: currently the link to the "official" spec is made relative, since this
# hasn't been finalized...
			$link			=~	s/^.+?ga4gh/./;
			$link			=~	s/\/[^\/]+?$/.html/;
   		$typeLab	.=	$key.': ['.$link.']('.$link.')' }
    else {
    	$typeLab	.=	$type }
    my $description =   $data->{properties}->{$property}->{'description'};
    
    $markdown   .=  <<END;
    
#### $property

* type: $typeLab

$description

END

		$markdown 	.=  "##### `$property` Value "._pluralize("Example", $data->{properties}->{$property}->{'examples'})."  \n\n";	
		foreach (@{ $data->{properties}->{$property}->{'examples'} }) {
		  $markdown .=  "```\n".JSON::XS->new->pretty( 1 )->allow_nonref->canonical()->encode($_)."```\n";		
		}

	}
   
	if ($data->{'examples'}) {
		$markdown 	.=  "\n### `$className` Value "._pluralize("Example", $data->{'examples'})."  \n\n";
		foreach (@{ $data->{'examples'} }) {
		    $markdown   .=  "```\n".JSON::XS->new->pretty( 1 )->canonical()->allow_nonref->encode($_)."```\n";		
		}
	}

  $markdown   .=  <<END;
    
#### Source

* [raw data](./$file_name)
* [Github]($yaml_github_web_link)

END

	##############################################################################

=podmd


=cut

  my $printout    =   JSON::XS->new->pretty( 1 )->canonical()->encode( $data->{examples} )."\n";
	open  (FILE, ">", $expl_file) || warn 'output file '.$expl_file.' could not be created.';
	print FILE  $printout;
	close FILE;

	print "writing $md_file\n";
	open  (FILE, ">", $md_file) || warn 'output file '. $md_file.' could not be created.';
	print FILE  $markdown."\n";
	close FILE;

  print "writing website file $md_web_file\n";
  open  (FILE, ">", $md_web_file) || warn 'output file '. $md_web_file.' could not be created.';
  print FILE  $jekyll_header.$markdown."\n";
  close FILE;

}

################################################################################

sub _check_paths {

  my $config 		=   shift;

	foreach my $path (grep { /_rel/ } keys %{$config->{paths}}) {
		if (! -d $config->{paths}->{$path}) {
			print <<END;
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

Path "$path" does not exist at 
    $config->{paths}->{$path}
Dying on the spot ...

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
END
	
		}
	}
}

################################################################################

sub _delete_generated_files { 

	my $config		=		shift;

	if ($config->{args}->{-cleanup} !~ /^1|^y/i) { return }

	foreach my $dir (grep{ /_rel/} keys %{$config->{paths}}) {
		if ($config->{generator_prefix} =~ /.../) {
			my $delCMD  =   'rm '.$config->{paths}->{$dir}.'/'.$config->{generator_prefix}.$config->{args}->{-filter}.'*';
			print $delCMD."\n";
			`$delCMD`;
		}
	}

}

################################################################################

sub _process_input_dirs {

	my $config		=		shift;

	foreach my $src_path (@{ $config->{paths}->{'src_paths'} }) {
		opendir DIR, $src_path;
		foreach (grep{ /ya?ml$/ } readdir(DIR)) {
			_process_yaml(
				$config,
				$src_path,
				$_
			);
		}
		close DIR;
	}

}

################################################################################

sub _expand_CURIEs {

	my $config		=		shift;
	my $curie			=		shift;

	if (grep{ $curie =~ /^$_\:/ } keys %{ $config->{prefix_expansions} }) {
		my $pre			=		(grep{ $curie =~ /^$_\:/ } keys %{ $config->{prefix_expansions} })[0];
		$curie			=~	s/$pre\:/$config->{prefix_expansions}->{$pre}/;
	}
	
	return $curie;

}

################################################################################

sub _create_jekyll_header {

# TODO: tune header parameters, e.g. permalink, tags ...

	my $config		=		shift;
	my $className	=		shift;
	return 	<<END;
---
title: '$className'
layout: default
permalink: "$config->{paths}->{md_web_doc_link}/$className.html"
excerpt_separator: $config->{jekyll_excerpt_separator}
category:
  - schemas
tags:
  - code
---

END

}

################################################################################

sub _pluralize {
	my $word			=		shift;
	my $list			=		shift;
	if (@$list > 1) { $word .= 's' }	
	return $word;
}


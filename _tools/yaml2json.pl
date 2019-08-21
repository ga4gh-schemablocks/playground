#!/usr/bin/perl

#use diagnostics;

use Cwd qw(abs_path);
use File::Basename;
use File::Copy;
use JSON::XS;
use YAML::XS qw(LoadFile DumpFile);
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
use Text::Markdown qw(markdown);

binmode STDOUT, ":utf8";

my $here_path   =   File::Basename::dirname(__FILE__);
my $config     	=   LoadFile($here_path.'/config.yaml') or die "¡No config.yaml file in this path!";
bless $config;

my @absPath			=		split('/', abs_path($0));
$config->{repository}	=		$absPath[-3];	# script resides in a dir in repo root

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
# subs
################################################################################
################################################################################

################################################################################
# main process
################################################################################

sub _process_yaml {

  my $config 		=   shift;
  my $src_dir 	=   shift;
  my $file_name =   shift;
  my $yaml_file =   '../'.$src_dir.'/'.$file_name;

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
  my $yaml_github_web_link 	=   $config->{paths}->{github_org_path}.'/'.$config->{repository}.'/blob/master/'.$src_dir.'/'.$file_name;
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
				my $text		=   $_->{description};
=podmd
The script performs a CURIE to URL expansion for prefixes defined in the
configuration file and links e.g. the 

=cut
				my $id	=		_expand_CURIEs($config, $_->{id});
				if ($id =~ /\:\/\/\w/) {
					$text =   '['.$text.']('.$id.')' }
				elsif ($id =~ /\w/) {
					$text .=  ' ('.$id.')' }
				$markdown 	.=  "\n    - ".$text."  ";
	}}}
  $markdown  		.=  <<END;

$config->{jekyll_excerpt_separator}

#### Source

* [raw source](./$file_name)
* [Github]($yaml_github_web_link)

### Properties

<table>
  <tr>
    <th>Property</th>
    <th>Type</th>
  </tr>
END

  foreach my $property ( sort keys %{ $data->{properties} } ) {
    
		my $label	=		_format_property_type_html($data->{properties}->{$property});
    $markdown .=  <<END;
  <tr>
    <td>$property</td>
    <td>$label</td>
  </tr>
END
    }

  $markdown   .=  "\n".'</table>'."\n\n";

=podmd
The property overview is followed by the listing of the properties, including
descriptions and examples.

=cut
   
  foreach my $property ( sort keys %{ $data->{properties} } ) {

		my $label	=		_format_property_type_html($data->{properties}->{$property});
    
    $markdown   .=  <<END;
    
#### $property

* type: $label

$data->{properties}->{$property}->{'description'}

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
# helpers
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

	foreach my $src_dir (@{ $config->{paths}->{'src_dirs'} }) {
		opendir DIR, '../'.$src_dir;
		foreach (grep{ /ya?ml$/ } readdir(DIR)) {
			_process_yaml(
				$config,
				$src_dir,
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

sub _format_property_type_html {

	my $prop_data	=		shift;
  my $typeLab;
	my $type  		=   $prop_data->{type};
	if ($type !~ /.../ && $prop_data->{'$ref'} =~ /.../) {
		$typeLab		=		$prop_data->{'$ref'} }
	elsif ($type =~ /array/ && $prop_data->{items}->{'$ref'} =~ /.../) {
		$typeLab		=		$prop_data->{items}->{'$ref'} }
	else {
		$typeLab		=		$type }
		
	if ($typeLab =~ /\/[\w\-]+?\.\w+?$/) {
		my $yaml		=		$typeLab;
		my $html		=		$typeLab;
		$html				=~	s/\.\w+?$/.html/;
		$typeLab		.=	' [<a href="'.$yaml.'" target="_BLANK">SRC</a>] [<a href="'.$html.'" target="_BLANK">HTML</a>]' }

	if ($type =~ /array/) {
		$typeLab		=		"array of ".$typeLab }
		
		return $typeLab;

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


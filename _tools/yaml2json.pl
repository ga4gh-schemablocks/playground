#!/usr/bin/perl

#use diagnostics;

use File::Basename;
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
  my $className	=		(split('/', $data->{'$id'}))[-2];
  
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
  my $md_web_file   		=   $config->{paths}->{'md_web_path_rel'}.'/'.$config->{generator_prefix}.$className.'.md';
  my $yaml_src_web_link =   $config->{paths}->{github_repository_path}.'/src/yaml/'.$file_name;

=podmd
The documentation is extracted from the $data object and formatted into a
markdown document.

=cut

  my $markdown  =   "## $className\n\n### SchemaBlocks Metadata";

	foreach my $attr (qw(contributors provenance used_by)) {
		if ($data->{meta}->{$attr}) {
			my $label =   $attr;
			$label  	=~  s/\_/ /g;
			$markdown .=  "\n\n##### ".ucfirst($label)."  \n";
			foreach (@{$data->{meta}->{$attr}}) {
				my $this		=   $_->{description} ;
				if ($_->{id} =~ /\/\/\w/) {
					$this 		=   '['.$this.']('.$_->{id}.')' }
				elsif ($_->{id} =~ /\w/) {
					$this 		.=  ' ('.$_->{id}.')' }
				$markdown 	.=  "\n* ".$this."  ";
	}}}
	$markdown 		.=  "\n\n##### {S}[B] Status  \n";
	$markdown 		.=  "\n* ".$data->{meta}->{sb_status}."  \n";
  $markdown  		.=  <<END;

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
   		$typeLab	.=	'['.(keys %$type)[0].']('.$type->{ (keys %$type)[0] }.')' }
    else {
    	$typeLab	.=	$type }
    my $description  =   markdown($data->{properties}->{$property}->{'description'});

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
   		$typeLab	.=	(keys %$type)[0].': ['.$type->{ (keys %$type)[0] }.']('.$type->{ (keys %$type)[0] }.')' }
    else {
    	$typeLab	.=	$type }
    my $description =   $data->{properties}->{$property}->{'description'};
    
    $markdown   .=  <<END;
    
#### $property

* type: $typeLab

$description

##### $property Examples

END
		
		foreach (@{ $data->{properties}->{$property}->{'examples'} }) {
		    $markdown   .=  "```\n"._reformat_example($_)."\n```\n";		
		}
	}

	$markdown 		.=  "\n### $className Examples  \n\n";
   
	if ($data->{'examples'}) {
		foreach (@{ $data->{'examples'} }) {
		    $markdown   .=  "```\n"._reformat_example($_)."\n```\n";		
		}
	}

	##############################################################################

=podmd


=cut

  my $printout    =   JSON::XS->new->pretty( 1 )->canonical()->encode( $data->{examples} )."\n";
	$printout       =   _clean_numbers_booleans_from_text($printout);
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

sub _reformat_example {

  my $example   =   shift;
  my $md_example    =   Dumper($example);
  $md_example	  =~  s/\$VAR1 \= //;
  $md_example	  =~  s/\n {8}/\n/g;
  $md_example	  =~  s/\;//g;
  $md_example	  =~  s/\n$//;
  if (ref( $example) eq "ARRAY" || ref( $example) eq "HASH") {
    $md_example	=		$md_example }
  else {
    $md_example	=~  s/\'//g;
    $md_example	=		'"'.$md_example.'"' }

  return $md_example;

}

################################################################################

sub _clean_numbers_booleans_from_text {

  my $printout  =   shift;

  my @cleaned;

  foreach my $line (split("\n", $printout)) {
    $line       =~  s/\=\>/:/;
    $line       =~  s/\: [\'\"](\d+?(?:\.\d+?)?)[\'\"]/: $1/;
    push(@cleaned, $line);
  }

  return join("\n", @cleaned);

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

sub _create_jekyll_header {

# TODO: tune header parameters, e.g. permalink, tags ...

	my $config		=		shift;
	my $className	=		shift;
	return 	<<END;
---
title: '$className'
layout: default
permalink: "/schemas/blocks/$className.html"
excerpt_separator: <!--more-->
category:
  - schemas
tags:
  - code
---
END

}


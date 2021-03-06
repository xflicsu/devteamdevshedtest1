#!/usr/bin/perl
use strict;
use Getopt::Long;
use vars qw($opt_reference $opt_input $opt_output @opt_zygosity @opt_vartype  @opt_varscorevaf @opt_varscoreeaf @opt_varquality);
$| = 1; # set autoflush to screen

# This is a wrapper for the cgatools varfilter function to run cgatools varfilter in Galaxy.
# The wrapper generates the filter(s) in the correct format to be used with the input file.
# written 6-1-2012 by bcrain@completegenomics.com


#print join("\n", @ARGV), "\n";
&GetOptions("reference=s", "input=s", "output=s", "zygosity=s@", "vartype=s@", "varscorevaf:i@", "varscoreeaf:i@", "varquality=s@");

my $append = '';

for (my $i = 0; $i <= $#opt_zygosity; $i ++)
{
	my $filter = '';
	unless ($opt_zygosity[$i] eq 'NA') {$filter = $opt_zygosity[$i];}
	unless ($opt_vartype[$i] eq 'NA')
	{
		$filter ne '' and $filter .= ':';
		$filter .= 'varType=' . $opt_vartype[$i];
	}
	unless ($opt_varscorevaf[$i] == 0)
	{
		$filter ne '' and $filter .= ':';
		$filter .= 'varScoreVAF<' . $opt_varscorevaf[$i];
	}
	unless ($opt_varscoreeaf[$i] == 0)
	{
		$filter ne '' and $filter .= ':';
		$filter .= 'varScoreEAF<' . $opt_varscoreeaf[$i];
	}
	unless ($opt_varquality[$i] eq 'NA')
	{
		$filter ne '' and $filter .= ':';
		$filter .= 'varQuality!=' . $opt_varquality[$i];
	}
	
	if ($filter ne '')
	{
		if ($append eq '') {$append = '#' . $filter;}
		else {$append .= ',' . $filter;}
	}
}

my $version = `cgatools | head -1`;
print "cgatools varfilter
--beta
--reference $opt_reference
--output $opt_output
--input '${opt_input}${append}'\n";
print "$version\n";

`cgatools varfilter --beta --reference $opt_reference --output $opt_output --input '${opt_input}${append}'`;
#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Std;

our($opt_i, $opt_n,$opt_m,$opt_t, $opt_q, $opt_o);
getopt('inmtqo');
if( (!defined $opt_i) && (!defined $opt_n) && (!defined $opt_m) && (!defined $opt_t) && (!defined $opt_q) && (!defined $opt_o) ){    
	die ("Usage: $0 \n\t -i [ input orthologs file ]\n\t -n [ target row \"0\" ]\n\t -m [ query row \"2\"]\n\t -t [ The chr name of target]\n\t -q [The chr name of query]\n\t -o [output file name]\n");
	}


open In, "$opt_i" or die "$!";

  my %colinear;
  my %Target;
  my %Query;
  my @T;
  my @Q;
  my @Tsort;
  my @Qsort;
  my %orient;
  my %length;

while (<In>) {
	chomp; 
	my @temp=split (/\t/, $_);
        my @unit0;
	my @unit1;

		@unit0= split (/\s/, $temp[$opt_n]);
		@unit1= split (/\s/, $temp[$opt_m]);
          

  if ($unit0[1]=~/$opt_t/ and $unit1[1]=~/$opt_q/) {
	$orient{$unit0[0]}=$unit0[4];
	$orient{$unit1[0]}=$unit1[4];
        $length{$unit0[0]}=$temp[1];
        $length{$unit1[0]}=$unit1[5];
    $colinear{$unit0[0]}=$unit1[0]; 
	 push @T, $unit0[2];
	 push @Q, $unit1[2];
     @Tsort = sort { $a <=> $b } @T; 
     @Qsort = sort { $a <=> $b } @Q;
	 $Target{$unit0[0]}=$unit0[2];
	 $Query{$unit1[0]}=$unit1[2];     
  }	

}

my %Tindex;
my %Qindex;
my %Index;
my $n=0;
foreach my $key ( sort { $Target{$a} <=> $Target{$b} } keys %Target) {
   my $Query=$Query{$colinear{$key}};   # Query gene cordinate      
   my %vi = map { $Qsort[$_] => $_ } 0 .. $#Qsort; # order the query gene cordinate
   my $index = $vi{$Query};  # Query gene ID
$Tindex{$n}=$key;
$Qindex{$index}=$colinear{$key};
$Index{$n}=$index;
$n++;
}


open Out, ">$opt_o" or die "$!";

foreach my $t ( sort { $Index{$a} <=> $Index{$b} } keys %Index) {
my $n=$t-1;
my $m=$t+1;

if ($t==0) {
	my $value = abs ($Index{$t}-$Index{$m});
	if ($value<5) {
		print Out "$Tindex{$t} $opt_t $Target{$Tindex{$t}} $orient{$Tindex{$t}} $length{$Tindex{$t}}\t$Qindex{$Index{$t}} $opt_q $Query{$Qindex{$Index{$t}}} $orient{$Qindex{$Index{$t}}} $length{$Qindex{$Index{$t}}}\n";
	}
} else {

	my $value1 = abs ($Index{$t}-$Index{$n});
	my $value2 = abs ($Index{$t}-$Index{$m});
    if ($value1 < 5 or $value2 < 5) {
		print Out "$Tindex{$t} $opt_t $Target{$Tindex{$t}} $orient{$Tindex{$t}} $length{$Tindex{$t}}\t$Qindex{$Index{$t}} $opt_q $Query{$Qindex{$Index{$t}}} $orient{$Qindex{$Index{$t}}} $length{$Qindex{$Index{$t}}}\n";
	}
}
}





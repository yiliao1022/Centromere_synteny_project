#!/usr/bin/perl
use strict;
use warnings;

open In, "$ARGV[0]" or die "$!";
open Out, ">$ARGV[0].out" or die "$!";

$/="a score=";
my $n=0;
while (<In>) {
        unless ($_=~/\#/) {
                my @temp=split (/\n/, $_);
                shift @temp;
                if ($temp[0]=~/$ARGV[1]/ and $temp[1]=~/$ARGV[2]/) {
                        my @unit1=split(/\s+/, $temp[0]);
                        my @unit2=split(/\s+/, $temp[1]);
            my $rice_end=$unit1[2]+$unit1[3];
                        if ($unit2[4]=~/\+/) {
                                my $ff_end=$unit2[2]+$unit2[3];
                                print Out "AA_block$n $ARGV[1] $unit1[2] $rice_end +\t$unit1[3]\tFF_block$n $ARGV[2] $unit2[2] $ff_end +
 $unit2[3]\n";
                        } elsif ($unit2[4]=~/\-/) {
                                my $ff_start=$unit2[5]-$unit2[2];
                my $ff_end=$unit2[5]-$unit2[2]+$unit2[3];
                                print Out "AA_block$n $ARGV[1] $unit1[2] $rice_end +\t$unit1[3]\tFF_block$n $ARGV[2] $ff_start $ff_end -
 $unit2[3]\n";
                        }

                }

        }
$n++;
}

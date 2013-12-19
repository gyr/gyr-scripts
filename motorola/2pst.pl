#!/usr/local/bin/perl -w

##################################
#
# Author: Gustavo Yokoyama Ribeiro
# File:   2pst.pl
# Update: 20070720
# (C) Copyright 2010 Gustavo Yokoyama Ribeiro
# Licensed under CreativeCommons Attribution-ShareAlike 3.0 Unsupported
# http://creativecommons.org/licenses/by-sa/3.0/ for more info.
#
##################################

# Description: convert data file in pst format
# Input: data file
# Output: pst fomart data

if ($#ARGV == 0)
{
    open(INFO, "$ARGV[0]");           # open input file to read
    $_ = <INFO>;                      # store the 1st of input file in a string
    close(INFO);                      # close file
    s/(..)/0x$1\n/g;                  # parser content
    print $_;                         # print output
#    $output_file = $ARGV[0] . ".pst"; # output file name will be <input_file>.pst
#    open(INFO, ">$output_file");      # create output file and open it to write
#    print INFO $_;                    # wrtie output in file
#    close(INFO);                      # close output file
}
else
{
    print "Syntax: 2pst <input_file>\n";
}

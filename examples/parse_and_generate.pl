#!/usr/bin/perl
#
# This script parses a SDP file
# and then re-generates the SDP file
# so for a valid SDP file the, output should be the same as the input
# 

use Net::SDP;
use strict;

my $sdp = Net::SDP->new();

$sdp->parse( shift @ARGV );

print $sdp->generate();


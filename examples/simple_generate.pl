#!/usr/bin/perl
#
# Simple script to demonstate how to
# create an SDP file using Net::SDP
#
# File output is printed to STDOUT
#

use Net::SDP;
use strict;


my $sdp = new Net::SDP();

$sdp->session_name("My Session");
$sdp->session_info("A fun session");
$sdp->session_uri("http://www.ecs.soton.ac.uk/fun/");
$sdp->session_attribute('tool', "simple_generate.pl version 1.0");


# Add a Time Description
my $time = $sdp->new_time_desc();
$time->start_time_unix( time() );		# Set start time to now
$time->end_time_unix( time()+3600 );	# Finishes in one hour


# Add an Audio Media Description
my $audio = $sdp->new_media_desc( 'audio' );
$audio->address('224.123.234.56');
$audio->port(5004);
$audio->ttl(5);
$audio->attribute('quality', 5);

# Add payload ID 96 with 16-bit, PCM, 22kHz, Mono
$audio->add_format( 96, 'audio/L16/220500/1' );

# static Payload ID 0 - audio/PCMU/8000/1
$audio->add_format( 0 );

# Set the default payload ID to 0
$audio->default_format_num( 0 );


print $sdp->generate();

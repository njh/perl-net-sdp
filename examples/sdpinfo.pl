#!/usr/bin/perl
#
#
# Display information about an SDP file
#

use Net::SDP;
use Data::Dumper;
use strict;


my $sdp = new Net::SDP();

$sdp->parse( shift @ARGV );


#print "\n".Dumper($sdp)."\n\n";

print "Session name: ".$sdp->session_name()."\n";
print "Session info: ".$sdp->session_info()."\n";
print "Session uri: ".$sdp->session_uri()."\n";
print "Session tool: ".$sdp->session_attribute('tool')."\n";



# Get array of Time Descriptions
my $time_list = $sdp->time_desc_arrayref();
foreach my $time ( @$time_list ) {
 	if ($time->is_permanent()) {
		print "Session is permanent.\n";
 	} else {
		print "Session Starts: ".$time->start_time()."\n";
		print "Session Ends: ".$time->end_time()."\n";
 	}
}


# Get array of Media Descriptions
my $media_list = $sdp->media_desc_arrayref();
foreach my $media ( @$media_list ) {
 
 	print "\n";
	print "Media Type: ".$media->media_type()."\n";
	print "Media Title: ".$media->title()."\n";
	print "Media Transport: ".$media->transport()."\n";
	print "Network Address: ".$media->address()."\n";
	print "Network Port: ".$media->port()."\n";
	print "Network TTL: ".$media->ttl()."\n";
	print "Default Payload ID: ".$media->default_format_num()."\n";
	print "Default Format: ".$media->default_format()."\n";
}


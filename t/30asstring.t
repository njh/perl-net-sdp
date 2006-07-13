
use strict;
use Test;

# use a BEGIN block so we print our plan before Net::SDP is loaded
BEGIN { plan tests => 7 }

# load Net::SDP
use Net::SDP;
use Net::SDP::Time;
use Net::SDP::Media;

# Test 1: Modules have loaded sucessfully 
ok(1);


# Check permanent session
my $time = new Net::SDP::Time();
$time->make_permanent();
ok( $time->as_string() eq 'Broadcasts permanently.' );

# Start time, and unbounded end time
$time->start_time_unix( 1152797400 );
$time->make_unbounded();
ok( $time->as_string() eq 'Broadcasts from '.localtime(1152797400).' until Unbounded.' );

# Start time, and unbounded end time
$time->start_time_unix( 1152797400 );
$time->end_time_unix( 1152798898 );
ok( $time->as_string() eq 'Broadcasts from '.localtime(1152797400).' until '.localtime(1152798898).'.' );

# Add a repeat
$time->make_unbounded();
$time->repeat_add( 3600, 600, 0);
ok( $time->as_string() eq 'Broadcasts every hour from 30mins until 40mins past starting '.localtime(1152797400).'.' );

# Add another repeat
$time->end_time_unix( 1152798898 );
$time->repeat_add( 3600, 600, 900);
ok( $time->as_string() eq 'Until '.localtime(1152798898).', broadcasts every hour from 30mins until 40mins past, and again every hour from 45mins until 55mins past starting '.localtime(1152797400).'.' );


# Check a Audio Media Description
my $audio = new Net::SDP::Media( 'audio' );
$audio->title('Media Title');
ok( $audio->as_string() eq 'Audio Stream' );


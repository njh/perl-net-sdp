
use strict;
use Test;

# use a BEGIN block so we print our plan before Net::SDP is loaded
BEGIN { plan tests => 16 }

# load Net::SDP
use Net::SDP;
use Net::SDP::Time;
use Net::SDP::Media;
use Data::Dumper;

# Test 1: Module has loaded sucessfully 
ok(1);


# Test 2: Create an empty Net::SAP object
my $sdp = new Net::SDP();
ok( ref $sdp, 'Net::SDP' );

# Add a Time Description
# (starts now and lasts 1 hour)
my $time = $sdp->new_time_desc();
$time->start_time_unix( time() );
$time->end_time_unix( time()+3600 );
ok( ref($time) eq 'Net::SDP::Time' );

# Add a repeat ( every day for 1 hour, 0 and 6 hour offset )
my ( $interval, $duration ) = ( '1d', '1h' );
my $offsets = [ 0, 21600 ]; # ARRAYREF
ok( $time->repeat_add( $interval, $duration, $offsets) );

# Another repeat - start of every hour for 60 seconds
ok( $time->repeat_add( 3600, 60, '30m') );

# Check that arrayref is defined and has 2 items
ok( defined $time->repeat_desc_arrayref() );
ok( scalar( @{ $time->repeat_desc_arrayref() } ) == 2  );

# Check it generates the right thing
ok ($time->_generate_r() eq "r=1d 1h 0 6h\nr=1h 1m 30m\n" );

# Delete the first item
ok ( $time->repeat_delete( 0 ) == 0 );

# Check remaining is as it should be
my $item = $time->repeat_desc( 0 );
ok (defined $item);
ok ($item->{'interval'} == 3600 );
ok ($item->{'duration'} == 60 );
ok ($item->{'offsets'}->[0] == 1800 );

# Delete all of the items
ok ( $time->repeat_delete_all() == 0 );

# Check that arrayref is defined and has 0 items
ok( defined $time->repeat_desc_arrayref() );
ok( scalar( @{ $time->repeat_desc_arrayref() } ) == 0  );



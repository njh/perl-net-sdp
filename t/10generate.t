
use strict;
use Test;

# use a BEGIN block so we print our plan before Net::SDP is loaded
BEGIN { plan tests => 17 }

# load Net::SDP
use Net::SDP;
use Net::SDP::Time;
use Net::SDP::Media;

# Test 1: Modules have loaded sucessfully
ok(1);


# Test 2: Create an empty Net::SAP object
my $sdp = new Net::SDP();
ok( ref $sdp, 'Net::SDP' );


# Set session attributes
$sdp->session_origin_username('user');
$sdp->session_origin_id( 3303643609 );
$sdp->session_origin_version( 3303643610 );
$sdp->session_origin_net_type( 'IN' );
$sdp->session_origin_addr_type( 'IN6' );
$sdp->session_origin_address( '::1' );
$sdp->session_name('Session Name');
$sdp->session_info('Session Information');
$sdp->session_email( ['email@example.com', 'email2@example.com'] );
$sdp->session_phone( ['0123 456 789', '0987 675 432'] );
$sdp->session_uri("http://www.w3.org/");
$sdp->session_attribute('type', "test");


# Add a Time Description
my $time = $sdp->new_time_desc();
$time->make_permanent();

# Add an Audio Media Description
my $audio = $sdp->new_media_desc( 'audio' );
$audio->title('Media Title');
$audio->address('FF1E::1');
$audio->address_type('IP6');
$audio->port(5000);
$audio->ttl(127);

# Add/set the default format
$audio->add_format( 10, 'audio/L16/44100/2' );




# Now create SDP data from it
my @lines = split(/\n/, $sdp->generate() );

# We can check line by line, because
# rfc2327 specifies the order of lines
ok( shift( @lines ), 'v=0' );
ok( shift( @lines ), 'o=user 3303643609 3303643610 IN IN6 ::1' );
ok( shift( @lines ), 's=Session Name' );
ok( shift( @lines ), 'i=Session Information' );
ok( shift( @lines ), 'u=http://www.w3.org/' );
ok( shift( @lines ), 'e=email@example.com' );
ok( shift( @lines ), 'e=email2@example.com' );
ok( shift( @lines ), 'p=0123 456 789' );
ok( shift( @lines ), 'p=0987 675 432' );
ok( shift( @lines ), 't=0 0' );
ok( shift( @lines ), 'a=type:test' );
ok( shift( @lines ), 'm=audio 5000 RTP/AVP 10' );
ok( shift( @lines ), 'i=Media Title' );
ok( shift( @lines ), 'c=IN IP6 FF1E::1/127' );
ok( shift( @lines ), 'a=rtpmap:10 L16/44100/2' );


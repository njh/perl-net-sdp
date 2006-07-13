
use strict;
use Test;

# use a BEGIN block so we print our plan before Net::SDP is loaded
BEGIN { plan tests => 27 }

# load Net::SDP
use Net::SDP;
use Net::SDP::Time;
use Net::SDP::Media;

# Test 1: Modules have loaded sucessfully
ok(1);



my $minimal_sdp = <<EOF;
v=0
o=njh 3310066404 3310066410 IN IP4 152.78.64.103
s=Session Name
i=Session Information
u=http://www.w3.org/
e=email\@example.com
p=0123 456 789
t=0 0
a=type:test
m=audio 1234 RTP/AVP 10
i=Media Title
c=IN IP4 1.2.3.4/5
EOF


# Now try and parse it
my $sdp = new Net::SDP;
my $parse_result = $sdp->parse( $minimal_sdp );

# Test 2: Did it parse ok ?
ok( $parse_result );


# Test 3-8: Session Origin
ok( $sdp->session_origin_username(), 'njh' );
ok( $sdp->session_origin_id(), '3310066404' );
ok( $sdp->session_origin_version(), '3310066410' );
ok( $sdp->session_origin_net_type(), 'IN' );
ok( $sdp->session_origin_addr_type(), 'IP4' );
ok( $sdp->session_origin_address(), '152.78.64.103' );


# Test 9: Session Name
ok( $sdp->session_name(), 'Session Name' );

# Test 10: Session Information
ok( $sdp->session_info(), 'Session Information' );

# Test 11: Session URI
ok( $sdp->session_uri(), 'http://www.w3.org/' );

# Test 12: Session Email
ok( $sdp->session_email(), 'email@example.com' );

# Test 13: Session Phone
ok( $sdp->session_phone(), '0123 456 789' );

# Test 14: Session Type
ok( $sdp->session_attribute('type'), 'test' );



# Test 15-16: Time Description
my $time = $sdp->time_desc();
ok( ref $time, 'Net::SDP::Time' );
ok( $time->is_permanent() );



# Test 17: Single Media Description
my $media_array = $sdp->media_desc_arrayref();
ok( scalar( @$media_array ), 1 );

# Test 18: Audio Media Description
my $audio = $sdp->media_desc_of_type( 'audio' );
ok( ref $audio, 'Net::SDP::Media' );

# Test 19-27: Media Description properties
ok( $audio->title(), 'Media Title' );
ok( $audio->address(), '1.2.3.4' );
ok( $audio->network_type(), 'IN' );
ok( $audio->address_type(), 'IP4' );
ok( $audio->port(), '1234' );
ok( $audio->ttl(), '5' );
ok( $audio->media_type(), 'audio' );
ok( $audio->transport(), 'RTP/AVP' );
ok( $audio->default_format_num(), 10 );




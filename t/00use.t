
use strict;
use Test;


# use a BEGIN block so we print our plan before Net::SDP is loaded
BEGIN { plan tests => 2 }

# load Net::SDP
use Net::SDP;


# Helpful notes.  All note-lines must start with a "#".
print "# I'm testing Net::SDP version $Net::SDP::VERSION\n";

# Test 1: Module has loaded sucessfully 
ok(1);



# Now try creating a new Net::SDP object
my $sdp = Net::SDP->new();

ok( defined $sdp );

exit;


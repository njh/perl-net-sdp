package Net::SDP::Time;

################
#
# Net::SDP - Session Description Protocol (rfc2327)
#
# Nicholas Humfrey
# njh@ecs.soton.ac.uk
#
# See the bottom of this file for the POD documentation. 
#

use strict;
use vars qw/$VERSION/;
use constant NTPOFFSET => 2208988800;
use Carp;

$VERSION="0.02";



sub new {
	my $class = shift;
	my $self = {
		't_start' => '0',
		't_end' => '0',
	};
	bless $self, $class;	

	# Initial value provided ?
	my ($t) = @_;
	$self->_parse_t($t) if (defined $t);

	return $self;
}

sub _ntptime {
	return time() + NTPOFFSET;
}

#sub remove {
#    my $self=shift;
#
#	### Delete ourselves from our parent's array    
#    
#    undef $self;
#}


sub _parse_t {
	my $self = shift;
	my ($t) = @_;
	
	($self->{'t_start'},
	 $self->{'t_end'}) = split(/\s/, $t);
	
	# Success
	return 1;
}

sub _generate_t {
	my $self = shift;

	return "t=".$self->{'t_start'}.' '.$self->{'t_end'}."\n";
}


sub start_time_ntp {
    my $self=shift;
	my ($start_time) = @_;
    $self->{'t_start'} = $start_time if defined $start_time;
	return $self->{'t_start'};
}

sub end_time_ntp {
    my $self=shift;
	my ($end_time) = @_;
    $self->{'t_end'} = $end_time if defined $end_time;
	return $self->{'t_end'};
}

sub start_time_unix {
    my $self=shift;
	my ($start_time) = @_;
    $self->{'t_start'} = $start_time + NTPOFFSET if defined $start_time;
    return 0 if ($self->{'t_start'}==0);
    return $self->{'t_start'} - NTPOFFSET;
}

sub end_time_unix {
    my $self=shift;
	my ($end_time) = @_;
    $self->{'t_end'} = $end_time+NTPOFFSET if defined $end_time;
    return 0 if ($self->{'t_end'}==0);
    return $self->{'t_end'} - NTPOFFSET;
}

sub start_time {
    my $self=shift;
    return "Permanent" if ($self->is_permanent());
    return scalar(localtime($self->start_time_unix()))
}

sub end_time {
    my $self=shift;
    return "Permanent" if ($self->is_permanent());
	return "Unbounded" if ($self->end_time_ntp()==0);
    return scalar(localtime($self->end_time_unix()))
}

sub is_permanent {
    my $self=shift;
    
    if ($self->start_time_ntp()==0)
			{ return 1; }
	else	{ return 0; }
}

sub make_permanent {
    my $self=shift;
	$self->{'t_start'} = 0;
	$self->{'t_end'} = 0;
}


sub is_unbounded {
    my $self=shift;
    
    if ($self->end_time_ntp()==0)
			{ return 1; }
	else	{ return 0; }
}

sub make_unbounded {
    my $self=shift;
	$self->{'t_end'} = 0;
}

sub as_string {
    my $self=shift;
	return "Permanent Session" if ($self->is_permanent());
	return $self->start_time()." until ".$self->end_time();
}


1;

__END__

=pod

=head1 NAME

Net::SDP::Time - Time Description in an SDP file

=head1 SYNOPSIS

  my $time = $sdp->new_time_desc();

  print "Session started: ".$time->start_time();
  
  $time->make_permanent();

=head1 DESCRIPTION

This class represents a single Time Description (t=) in an SDP file.
When parsing an SDP file, Net::SDP will create an instance of Net::SDP::Time
for each time description. New time descriptions can be created using the 
new_time_desc() method in Net::SDP.

=head2 METHODS

=over 4


=item B<start_time_ntp()>

Get or Set the Start Time as decimal representation of Network Time Protocol (NTP) 
time values in seconds. B<[t=]>

Example:

	$start_ntp = $time->start_time_ntp();
	$time->start_time_ntp( 3303564104 );


=item B<end_time_ntp()>

Get or Set the End Time as decimal representation of Network Time Protocol (NTP) 
time values in seconds. B<[t=]>

Example:

	$end_ntp = $time->end_time_ntp();
	$time->end_time_ntp( 3303567704 );


=item B<start_time_unix()>

Get or Set the Start Time as decimal Unix time stamp. B<[t=]>

Example:

	$start = $time->start_time_unix();
	$time->start_time_unix( time() );


=item B<end_time_unix()>

Get or Set the End Time as decimal Unix time stamp. B<[t=]>

Example:

	$end = $time->end_time_unix();
	$time->end_time_unix( time()+3600 );


=item B<start_time()>

Get a textual representation of the Start Time. B<[t=]>

Example:

	print "Session starts: ".$time->start_time();


=item B<end_time()>

Get a textual representation of the End Time. B<[t=]>

Example:

	print "Session ends: ".$time->end_time();


=item B<is_permanent()>

Returns true if the session is permanent.
Returns false if the session has a start or end time. B<[t=]>


=item B<make_permanent()>

Makes the session permanent - no start or end time. B<[t=]>


=item B<is_unbounded()>

Returns true if the session has no end time.
Returns false if the session has an end time. B<[t=]>


=item B<make_unbounded()>

Makes the session unbounded - no end time. B<[t=]>


=item B<as_string()>

Returns a textual representation/summary of the time description.

Example:

	'Tue Aug  2 11:13:28 2004 until Tue Aug  2 13:15:00 2004'

=back

=head1 AUTHOR

Nicholas Humfrey, njh@ecs.soton.ac.uk

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2004 University of Southampton

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.005 or,
at your option, any later version of Perl 5 you may have available.

=cut

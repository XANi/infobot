package XANi::Infobot::Agent::Echo;

use 5.010000;
use strict;
use warnings;
use Carp qw(cluck croak carp);
use Data::Dumper;
require Exporter;

our @ISA = qw(Exporter);


our %EXPORT_TAGS = ( 'all' => [ qw(

                                 ) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(

               );

our $VERSION = '0.01';

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self = {};
    bless($self, $class);
    return $self;
};

sub info {
    my $s = shift;
    return "Simple echo plugin";
};

sub msg_handler {
    my $s = shift;
    my ($cl, $acc, $msg) = @_;
    my $repl = $msg->make_reply;
    my (undef, $reply) = split(/\s/,$msg->any_body);
    $repl->add_body ( "Echo: " . $reply);
    $repl->send;
};


1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

XANi::Infobot::Agent::Echo;

=head1 SYNOPSIS

Just add it to modules in config


=head1 DESCRIPTION

This module just eches whatever is sent to it


=head1 AUTHOR

xani, E<lt>xani@E<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012 by xani

This library is free software; you can redistribute it and/or modify
  it under the same terms as Perl itself, either Perl version 5.12.3 or,
  at your option, any later version of Perl 5 you may have available.


=cut

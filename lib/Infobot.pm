package Infobot;

use 5.010000;
use strict;
use warnings;
use Carp qw(cluck croak carp);
use Data::Dumper;
use Infobot::Config;
our $VERSION = '0.01';

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self = {};
    bless($self, $class);
    my %cfg = @_;
    my $config = Infobot::Config->new();
    $self->{'cfg'} = $config->get();
    # container for event pointers
    $self->{'ev'} = {};
    return $self;
}


1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Infobot;

=head1 SYNOPSIS

  use Infobot;
  blah blah blah

=head1 DESCRIPTION

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO



=head1 AUTHOR

xani, E<lt>xani@E<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012 by xani

This library is free software; you can redistribute it and/or modify
  it under the same terms as Perl itself, either Perl version 5.12.3 or,
  at your option, any later version of Perl 5 you may have available.


=cut

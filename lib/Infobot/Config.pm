# template for new modules
package Infobot::Config;

use common::sense;
use Carp qw(cluck croak carp);
use Log::Any qw($log);
use Infobot::Config::File;

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self = {};
    bless($self, $class);
    my $backend = Infobot::Config::File->new();
    $self->{'cfg'}= $backend->get();
    return $self;
}

sub get {
    my $self = shift;
    return $self->{'cfg'};
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

xani, E<lt>xani666@gmail.comE<gt>

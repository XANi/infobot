# template for new modules
package Infobot::Config;

use common::sense;
use Carp qw(cluck croak carp);
use Log::Any qw($log);

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self = {};
    bless($self, $class);
    my %cfg = @_;
    $self->{'cfg'} = \%cfg;
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

xani, E<lt>xani666@gmail.comE<gt>

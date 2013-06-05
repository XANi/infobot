# template for new modules
package Infobot::Config::File;

use common::sense;
use Carp qw(cluck croak carp);
use Log::Any qw($log);
use Cwd;
use YAML::XS qw(Dump Load LoadFile);

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self = {};
    bless($self, $class);
    my $search_files = [
        'cfg/config.yaml',
        'cfg/config.default.yaml',
    ];
    my $cfg;
    foreach my $file (@$search_files) {
        if ( -r $file ) {
            eval {
                $cfg = LoadFile($file);
            };
            if ($@) {
                $log->error("Bad config: $@");
                croak("Bad config $@");
            }
            else {
                $log->info("Loaded config from $file");
                $log->debug(Dump($cfg));
                last;
            }
        }
    }
    if (!defined($cfg)) {
        $log->error("No config file found!");
        exit 1;
    }
    $self->{'cfg'} = $cfg;
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

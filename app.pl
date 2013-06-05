#!/usr/bin/perl
use lib './lib';
use common::sense;
use Infobot;

use POSIX qw(strftime);
use Log::Any qw($log);
use Log::Any::Adapter;
use Log::Dispatch;
use Log::Dispatch::Screen;
use Term::ANSIColor qw(color colorstrip);
my $logger = Log::Dispatch->new();
$logger->add(
    Log::Dispatch::Screen->new(
        name      => 'screen',
        min_level => 'debug',
        callbacks => (\&_log_helper_timestamp),
    )
);
Log::Any::Adapter->set( 'Dispatch', dispatcher => $logger );




my $bot = Infobot->new();

sub _log_helper_timestamp() {
    my %a = @_;
    my $out;
    my $multiline_mark = '';
    foreach( split(/\n/,$a{'message'}) ) {
        $out .= color('bright_green') .  strftime('%Y-%m-%dT%H:%M:%S%z',localtime(time)) . color('reset') . ' ' .  &_get_color_by_level($a{'level'}) . ': ' . $multiline_mark . $_ . "\n";
        $multiline_mark = '.  '
    }
    return $out
}

sub _get_color_by_level {
    my $level = shift;
    my $color_map = {
        debug => 'blue',
        error => 'bold red',
        warning => 'bold yellow',
        info => 'green',
        notice => 'cyan',
    };
    my $color;
    if (defined( $color_map->{$level} )) {
        $color = $color_map->{$level}
    } else {
        $color= 'green';
    }
    return color($color) . $level . color('reset');
}

#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'XANi::Infobot' ) || print "Bail out!\n";
}

diag( "Testing XANi::Infobot $XANi::Infobot::VERSION, Perl $], $^X" );

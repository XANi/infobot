#!/usr/bin/perl
use common::sense;
use AnyEvent;
use AnyEvent::XMPP::Client;
use AnyEvent::XMPP::Ext::Disco;
use AnyEvent::XMPP::Ext::Version;
use AnyEvent::XMPP::Namespaces qw(xmpp_ns);
use YAML;
use File::Slurp;
use Carp; qw( carp croak );

my $config_file = 'bot.yaml';
if ( ! -e $config_file) {
    croak("Config file <$config_file> does not exist, copy default from doc/examples/bot.yaml");
}
my $tmp = read_file($config_file) or croak("Can't load config: $!");
my $cfg = Load($tmp) or croak("Can't parse config: $!");


binmode STDOUT, ":utf8";

if (!defined($cfg->{'xmpp_user'}) || !defined($cfg->{'xmpp_pass'}) ) {
    croak("Need xmmp_user and xmpp_pass in config!");
}

my $j       = AnyEvent->condvar;
my $cl      = AnyEvent::XMPP::Client->new (debug => 1);
my $disco   = AnyEvent::XMPP::Ext::Disco->new;
my $version = AnyEvent::XMPP::Ext::Version->new;

$cl->add_extension ($disco);
$cl->add_extension ($version);

$cl->set_presence (undef, 'I\'m a talking bot.', 1);

$cl->add_account ($cfg->{'xmpp_user'}, $cfg->{'xmpp_pass'});
warn "connecting to $cfg->{xmpp_user}...\n";

$cl->reg_cb (
   session_ready => sub {
      my ($cl, $acc) = @_;
      warn "connected!\n";
   },
   message => sub {
      my ($cl, $acc, $msg) = @_;
      my $repl = $msg->make_reply;
      $repl->add_body ("You said '".$msg->any_body."'");
      warn "Got message: '".$msg->any_body."' from ".$msg->from."\n";
      $repl->send;
   },
   contact_request_subscribe => sub {
      my ($cl, $acc, $roster, $contact) = @_;
      $contact->send_subscribed;
      warn "Subscribed to ".$contact->jid."\n";
   },
   error => sub {
      my ($cl, $acc, $error) = @_;
      warn "Error encountered: ".$error->string."\n";
      $j->broadcast;
   },
   disconnect => sub {
      warn "Got disconnected: [@_]\n";
      $j->broadcast;
   },
);

$cl->start;

$j->wait;

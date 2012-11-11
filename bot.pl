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
use Module::Load;

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
my $module = {};
while (my ($name, $module_config) = each %{ $cfg->{'modules'} } ) {
    my $modulename = 'XANi::Infobot::Agent::' . ucfirst($name);
    load $modulename;
    my $m = $modulename->new($module_config);
    $module->{$name}{'info'} = $m->info();
    $module->{$name}{'handler'} = $m;
}


$cl->reg_cb (
   session_ready => sub {
      my ($cl, $acc) = @_;
      warn "connected!\n";
   },
   message => sub {
      my ($cl, $acc, $msg) = @_;
      my ($target_module, undef) = split(/\s+/,$msg->any_body);
      if ( ! defined( $module->{$target_module} ) ) {
          &help($cl, $acc, $msg);
      }
      else {
          $module->{$target_module}{'handler'}->msg_handler($cl, $acc, $msg);
      }
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

sub help {
    my ($cl, $acc, $msg) = @_;
    my $repl = $msg->make_reply;
    my $body = "Supported commands:\n";
    while(my ($name, $config) = each (%$module) ) {
        print Dumper $config;
        $body .= "    $name - " . $config->{'info'} . "\n";
    }
    $repl->add_body ($body);
    warn $msg->from . 'asked for help';
    $repl->send;
}

package XANi::Infobot::Agent::Weather;

use 5.010000;
use strict;
use warnings;
use Carp qw(cluck croak carp);
use Data::Dumper;
use AnyEvent::HTTP;
use XML::Simple

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
    return "Get the weather for given WOEID ( http://woeid.rosselliot.co.nz/ )";
};

sub msg_handler {
    my $s = shift;
    my ($cl, $acc, $msg) = @_;
    my(undef, $woeid) = split (/\s+/,$msg);
    my $repl = $msg->make_reply;
    if ($woeid < 1) {
        $repl->add_body ("Please specify WOEID for your location,  you can look it up at http://woeid.rosselliot.co.nz/");
        $repl->send;
        return;
    }
    else {
       my $req;
       $req = http_request(
            GET => 'http://weather.yahooapis.com/forecastrss?w=' . int($woeid) . '&u=c',
            sub {
                my ($body, $hdr) = @_;
                my $weather=XMLin($body);
                my $forecast =  $weather->{'channel'}{'title'} . "\n";
                if ($forecast =~ /Error/) {
                    $forecast .= "probably bad WOEID";
                }
                else  {
                    $forecast .= $weather->{'channel'}{'item'}{'yweather:condition'}{'text'};
                    $forecast .= ', ' . $weather->{'channel'}{'item'}{'yweather:condition'}{'temp'} . " C\n";
                    $forecast .= "sunrise: " . $weather->{'channel'}{'yweather:astronomy'}{'sunrise'};
                    $forecast .= ", sunset: " . $weather->{'channel'}{'yweather:astronomy'}{'sunset'} . "\n";
                    foreach my $day (@{ $weather->{'channel'}{'item'}{'yweather:forecast'} }) {
                        $forecast .= $day->{'date'} . ': ' .$day->{'low'} . '-' . $day->{'high'} . ' C, ' . $day->{'text'} . "\n";
                    }
                }
                $repl->add_body($forecast);
                $repl->send;
                undef $req;

            }
      );
       return $req;
   }
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
# for reference, what we get from yahoo:
#           'xmlns:yweather' => 'http://xml.weather.yahoo.com/ns/rss/1.0',
#           'xmlns:geo' => 'http://www.w3.org/2003/01/geo/wgs84_pos#',
#           'version' => '2.0',
#           'channel' => {
#                        'link' =>
# 'http://us.rd.yahoo.com/dailynews/rss/weather/Warsaw__PL/*http://weather.yahoo.com/forecast/PLXX0028_c.html',
#                        'yweather:wind' => {
#                                           'chill' => '4',
#                                           'direction' => '180',
#                                           'speed' => '3.22'
#                                         },
#                        'language' => 'en-us',
#                        'ttl' => '60',
#                        'item' => {
#                                  'link' =>
# 'http://us.rd.yahoo.com/dailynews/rss/weather/Warsaw__PL/*http://weather.yahoo.com/forecast/PLXX0028_c.html',
#                                  'yweather:forecast' => [
#                                                         {
#                                                           'high' => '7',
#                                                           'date' => '18 Nov 2012',
#                                                           'text' => 'Foggy',

#                                                           'day' => 'Sun',
#                                                           'low' => '2',
#                                                           'code' => '20'
#                                                         },
#                                                         {
#                                                           'high' => '5',
#                                                           'date' => '19 Nov 2012',
#                                                           'text' => 'AM Fog/PM Clouds',
#                                                           'day' => 'Mon',
#                                                           'low' => '1',
#                                                           'code' => '20'
#                                                         }
#                                                       ],
#                                  'description' => '
# <img src="http://l.yimg.com/a/i/us/we/52/27.gif"/><br />
# <b>Current Conditions:</b><br />
# Mostly Cloudy, 4 C<BR />
# <BR /><b>Forecast:</b><BR />
# Sun - Foggy. High: 7 Low: 2<br />
# Mon - AM Fog/PM Clouds. High: 5 Low: 1<br />
# <br />
# <a
# href="http://us.rd.yahoo.com/dailynews/rss/weather/Warsaw__PL/*http://weather.yahoo.com/forecast/PLXX0028_c.html">Full
# Forecast at Yahoo! Weather</a><BR/><BR/>
# (provided by <a href="http://www.weather.com" >The Weather Channel</a>)<br/>
# ',
#                                  'geo:long' => '21.01',
#                                  'guid' => {
#                                            'isPermaLink' => 'false',
#                                            'content' => 'PLXX0028_2012_11_19_7_00_CET'
#                                          },
#                                  'title' => 'Conditions for Warsaw, PL at 1:00 am CET',
#                                  'geo:lat' => '52.24',
#                                  'pubDate' => 'Mon, 19 Nov 2012 1:00 am CET',
#                                  'yweather:condition' => {
#                                                          'temp' => '4',
#                                                          'date' => 'Mon, 19 Nov 2012 1:00 am CET',
#                                                          'text' => 'Mostly Cloudy',
#                                                          'code' => '27'
#                                                        }
#                                },
#                        'yweather:astronomy' => {
#                                                'sunrise' => '7:03 am',
#                                                'sunset' => '3:37 pm'
#                                              },
#                        'description' => 'Yahoo! Weather for Warsaw, PL',
#                        'image' => {
#                                   'link' => 'http://weather.yahoo.com',
#                                   'width' => '142',
#                                   'url' => 'http://l.yimg.com/a/i/brand/purplelogo//uh/us/news-wea.gif',
#                                   'title' => 'Yahoo! Weather',
#                                   'height' => '18'
#                                 },
#                        'lastBuildDate' => 'Mon, 19 Nov 2012 1:00 am CET',
#                        'yweather:location' => {
#                                               'country' => 'Poland',
#                                               'city' => 'Warsaw',
#                                               'region' => ''
#                                             },
#                        'yweather:units' => {
#                                            'pressure' => 'mb',
#                                            'distance' => 'km',
#                                            'speed' => 'km/h',
#                                            'temperature' => 'C'
#                                          },
#                        'yweather:atmosphere' => {
#                                                 'pressure' => '1015.92',
#                                                 'visibility' => '6',
#                                                 'rising' => '1',
#                                                 'humidity' => '100'
#                                               },
#                        'title' => 'Yahoo! Weather - Warsaw, PL'
#                      }
#         };

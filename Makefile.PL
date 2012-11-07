use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'XANi::Infobot',
    AUTHOR              => q{XANi <xani666@gmail.com>},
    VERSION_FROM        => 'lib/XANi/Infobot.pm',
    ABSTRACT_FROM       => 'lib/XANi/Infobot.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'XANi-Infobot-*' },
);

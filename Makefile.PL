use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'WWW::MyAnimeList::API',
    AUTHOR              => q{Mike Cartmell <mike@mikec.me>},
    VERSION_FROM        => 'lib/WWW/MyAnimeList/API.pm',
    ABSTRACT_FROM       => 'lib/WWW/MyAnimeList/API.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'Moo' => 0,
        'MooX::Types::MooseLike::Base' => 0,
        'WWW::Mechanize' => 0,
        'URI::Escape' => 0,
        'XML::Simple' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'WWW-MyAnimeList-API-*' },
);

#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'WWW::MyAnimeList::API' ) || print "Bail out!\n";
}

diag( "Testing WWW::MyAnimeList::API $WWW::MyAnimeList::API::VERSION, Perl $], $^X" );

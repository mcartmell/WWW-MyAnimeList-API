use Test::More;
use WWW::MyAnimeList::API;

my ($api_user, $api_pass);

if (($api_user = $ENV{WWW_MYANIMELIST_API__USER}) && ($api_pass = $ENV{WWW_MYANIMELIST_API__PASSWORD})) {
  plan tests => 3;
}
else {
  plan skip_all => 'API username and password required for testing. See documentation for details.'
}
my $mal = WWW::MyAnimeList::API->new(user => $api_user, password => $api_pass);
my @entries = $mal->search("07-Ghost");
ok(@entries, 'Some search results returned');

my $entry = $entries[0];
is(ref $entry, 'WWW::MyAnimeList::API::AnimeEntry', 'Search result is a blessed object');
ok($entry->title, 'Title retrieved OK')

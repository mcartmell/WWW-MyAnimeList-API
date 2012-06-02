package WWW::MyAnimeList::API;

use 5.006;

use strict;
use warnings;

use Moo;

use MooX::Types::MooseLike::Base qw(:all);
use WWW::Mechanize;
use URI::Escape qw(uri_escape);
use WWW::MyAnimeList::API::AnimeEntry;
use Carp;

my $SEARCH_URL = "http://myanimelist.net/api/anime/search.xml?q=";

has 'user' => (is => 'ro', isa => Str, required => 1);
has 'password' => (is => 'ro', isa => Str, required => 1);
has 'ua' => (is => 'ro', builder => '_ua', lazy => 1);

sub _ua {
  my $self = shift;
  my $ua = WWW::Mechanize->new;
  $ua->credentials($self->user, $self->password);
  return $ua;
}

=head1 NAME

WWW::MyAnimeList::API - Interface to the MyAnimeList API

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

This module provides an interface to MyAnimeList's REST API (http://myanimelist.net/modules.php?go=api). The API allows you to search and retrieve details on anime and manga titles, as well as maintain the list of anime and manga titles that you've watched.

All requests use HTTP auth, so you'll first need to register an account at http://myanimelist.net/register.php.

  use WWW::MyAnimeList::API;
  my $mal = WWW::MyAnimeList::API->new(user => 'myusername', password => 'mypassword');
  my @titles = $mal->search('Death Note');

  for my $title (@titles) {
    say $title->synopsis;
  }

=head1 METHODS

=over

=cut

=item anime_search, search

  my @titles = $mal->search('Neon Genesis Evangelion');

Performs a search and returns a list of the titles found.

If no results are returned, returns nothing.

If an error is encountered, an exception is raised.

=cut

sub anime_search {
  my $self = shift;
  my $q = shift or croak "search() requires an argument";
  my $ua = $self->ua;
  my $query_url = "$SEARCH_URL" . uri_escape($q);
  $ua->get($query_url);
  if ($ua->status == 204) {
    # Nothing found
    return;
  }
  elsif ($ua->status != 200) {
    croak "Received invalid response from server: ".$ua->status;
  }
  else {
    return WWW::MyAnimeList::API::AnimeEntry->from_xml(xml => $ua->content());
  }
}

sub search { anime_search(@_) }

=back

=head1 TESTING

Since the API requires a username and password, to test this module properly you'll need to set a couple of environment variables:

  export WWW_MYANIMELIST_API__USER=myuser
  export WWW_MYANIMELIST_API__PASSWORD=mypass

=head1 AUTHOR

Mike Cartmell, C<< <mike at mikec.me> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-www-myanimelist-api at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WWW-MyAnimeList-API>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WWW::MyAnimeList::API

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WWW-MyAnimeList-API>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WWW-MyAnimeList-API>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WWW-MyAnimeList-API>

=item * Search CPAN

L<http://search.cpan.org/dist/WWW-MyAnimeList-API/>

=back

=head1 ACKNOWLEDGEMENTS

=head1 LICENSE AND COPYRIGHT

Copyright 2012 Mike Cartmell.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1; # End of WWW::MyAnimeList::API

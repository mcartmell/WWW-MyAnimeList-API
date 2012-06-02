package WWW::MyAnimeList::API::AnimeEntry;

use 5.006;

use strict;
use warnings;

use Moo;
use MooX::Types::MooseLike::Base qw(:all);
use XML::Simple;
use Carp;

for (qw/id score/) {
  has $_ => (is => 'ro', isa => Num, required => 1);
}

for (qw/title english type status start_date end_date synopsis image/) {
  has $_ =>
  (is => 'ro', isa => Str, required => 1);
}

has 'synonyms' => (
  is       => 'ro',
  required => 1,
);

my @SEARCH_FIELDS = qw/id title english type status start_date end_date synopsis image synonyms score/;

=head1 NAME

WWW::MyAnimeList::API::AnimeEntry

=cut

=head1 METHODS 

=over

=item from_xml

  my @entries = WWW::MyAnimeList::API::AnimeEntry->from_xml(xml => $content);

Returns a list of anime titles constructed from the XML. The XML should be the response from a valid API search. See http://myanimelist.net/modules.php?go=api for details.

=cut

sub from_xml {
  my $self = shift;
  my %args = @_;
  my $xml = $args{xml} or croak "from_xml() requires an 'xml' argument";
  my $ref = XML::Simple::XMLin($xml);
  $ref->{entry} or croak "entry key not found in xml";
  my @all_entries;

  # there might be multiple entries returned 
  if (exists $ref->{entry}{id}) {
    @all_entries = ($ref->{entry});
  }
  else {
    @all_entries = values %{$ref->{entry}};
  }

  # Construct objects for each of the entries in the xml
  for my $entry (@all_entries) {
    my %build_args;
    for my $field (@SEARCH_FIELDS) {
      my $val = $entry->{$field};
      $val = '' if (!$val || (ref $val eq 'HASH' && !%$val));
      $build_args{$field} = $val;
    }
    $entry = $self->new(%build_args);
    warn $entry;
  }
  return @all_entries;
}

=back

=head1 AUTHOR

Mike Cartmell, C<< <mike at mikec.me> >>

=head1 LICENSE AND COPYRIGHT

Copyright 2012 Mike Cartmell.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1;

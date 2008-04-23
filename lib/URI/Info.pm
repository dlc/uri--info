package URI::Info;

# -------------------------------------------------------------------
#  URI::Info --
#  Copyright (C) 2005 darren chamberlain <darren@cpan.org>
#
#  This program is free software; you can redistribute it and/or
#  modify it under the terms of the GNU General Public License as
#  published by the Free Software Foundation; version 2.
#
#  This program is distributed in the hope that it will be useful, but
#  WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#  General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
#  02111-1307  USA
# -------------------------------------------------------------------

use strict;
use vars qw($VERSION);

$VERSION = 1.00;

use URI;
use URI::http;

package URI::http;
use LWP::Simple qw($ua);

# Fetch the URI, and return a hash of header information
sub info {
    my $self = shift;
    my $uri = $self->canonical;
    my $res = $ua->get($uri);
    my %info;

    for my $h ($res->header_field_names) {
        my @h = $res->header($h);
        my $type = 'server';

        if ($h =~ s/^X-Meta-//) {
            $type = 'meta';
        }
        elsif ($h eq 'Link') {
            $type = 'link';
            my @L;
            for (@h) {
                my @l = split /;\s+/, $_;
                my $href = shift @l;
                $href =~ s/^<//;
                $href =~ s/>$//;

                my %l = (href => $href);
                for (@l) {
                    my ($n, $v) = split /=/, $_, 2;
                    next if $n eq '/'; # XHTML-style <link ... /> makes an attr called /
                    $v =~ s/^"//;
                    $v =~ s/"$//;
                    $l{ lc $n } = $v;
                }
                push @L, \%l;
            }
            @h = @L;
        }

        $info{$type}->{lc $h} = \@h;
    }

    return \%info;
}

1;

__END__

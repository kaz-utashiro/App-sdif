=head1 NAME

App::sdif::autocolor

=head1 SYNOPSIS

sdif -Mautocolor

=head1 DESCRIPTION

This is a module for L<sdif(1)> command to set operating system
dependent autocolor option.

Each module is expected to set B<--LIGHT-SCREEN> or B<--DARK-SCREEN>
option according to the brightness of a terminal program.

If the environment variable C<BRIGHTNESS> is defined, its value is
used as a brightness without calling submodules.  The value of
C<BRIGHTNESS> is expected in range of 0 to 100.

=head1 SEE ALSO

L<App::sdif::autocolor::Apple_Terminal>

=cut

package App::sdif::autocolor;

use strict;
use warnings;
use v5.14;

sub rgb_to_brightness {
    my($r, $g, $b) = @_;
    int(($r * 30 + $g * 59 + $b * 11) / 65535); # 0 .. 100
}

sub initialize {
    my $mod = shift;

    if ((my $brightness = $ENV{BRIGHTNESS} // '') =~ /^\d+$/) {
	$mod->setopt(default =>
		     $brightness > 50 ? '--LIGHT-SCREEN' : '--DARK-SCREEN');
    }
    elsif (my $term_program = $ENV{TERM_PROGRAM}) {

	if ($term_program eq "Apple_Terminal") {
	    $mod->setopt(default => '-Mautocolor::Apple_Terminal');
	}

    }
}

1;

__DATA__

option --LIGHT-SCREEN --light
option  --DARK-SCREEN --dark

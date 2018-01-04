=head1 NAME

App::sdif::colors

=head1 SYNOPSIS

  sdif -Mcolors --light
  sdif -Mcolors --green
  sdif -Mcolors --cmy
  sdif -Mcolors --mono

  sdif -Mcolors --dark
  sdif -Mcolors --dark-green
  sdif -Mcolors --dark-cmy
  sdif -Mcolors --dark-mono

=head1 DESCRIPTION

Read `perldoc -m App::sdif::colors` to see the actual definition.

=head1 SEE ALSO

L<App::sdif::autocolor>,
L<App::sdif::autocolor::Apple_Terminal>

=cut

package App::sdif::colors;

1;

__DATA__

define {NOP} $<move(0,0)>

option --light {NOP}
option --dark  --dark-green

option	--green \
	--cm ?COMMAND=010/555;S		\
	--cm    ?FILE=010/555;SD	\
	--cm    ?MARK=010/444		\
	--cm    UMARK=			\
	--cm    ?LINE=220		\
	--cm    ?TEXT=K/454		\
	--cm    UTEXT=

option	--cmy \
	--cm OCOMMAND=C/555;S		\
	--cm NCOMMAND=M/555;S		\
	--cm MCOMMAND=Y/555;S		\
	--cm    OFILE=C/555;SD		\
	--cm    NFILE=M/555;SD		\
	--cm    MFILE=Y/555;SD		\
	--cm    OMARK=C/444		\
	--cm    NMARK=M/444		\
	--cm    MMARK=Y/444		\
	--cm    UMARK=/444		\
	--cm    ?LINE=220		\
	--cm    ?TEXT=K/554		\
	--cm    UTEXT=

option	--mono \
	--cm ?COMMAND=111;S	\
	--cm    ?FILE=111;DS	\
	--cm    ?MARK=000/333	\
	--cm    UMARK=		\
	--cm    ?LINE=222	\
	--cm    ?TEXT=000/L23	\
	--cm    UTEXT=111	\
	--cdifopts ' --mono '

define {DARK_BG1} L10
define {DARK_BG2} L04

expand	--dark-screen \
	--cm    ?MARK=000/{DARK_BG1}	\
	--cm    UMARK=			\
	--cm    ?TEXT=555/{DARK_BG2}	\
	--cm    UTEXT=444

option	--dark-green \
	--dark-screen 			\
	--cm ?COMMAND=K/232;		\
	--cm    ?FILE=K/232;D		\
	--cm    ?LINE=220		\
	--cdifopts ' --dark-green '

option	--dark-cmy \
	--dark-screen			\
	--cm OCOMMAND=K/122		\
	--cm    OFILE=K/122;D		\
	--cm NCOMMAND=K/313		\
	--cm    NFILE=K/313;D		\
	--cm MCOMMAND=K/332		\
	--cm    MFILE=K/332;D		\
	--cm    ?LINE=220		\
	--cdifopts ' --dark-cmy '

option	--dark-mono \
	--dark-screen			\
	--cm ?COMMAND=/{DARK_BG1}	\
	--cm    ?FILE=D/{DARK_BG1}	\
	--cm    ?LINE=111		\
	--cdifopts ' --dark-mono '

##
## for backward compatinbility
##
option --dark_green --dark-green
option --dark_cmy   --dark-cmy
option --dark_mono  --dark-mono

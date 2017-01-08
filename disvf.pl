#! /usr/bin/env perl

if ($#ARGV != 0) {
	print "usage: perl disvf.pl virtualfont\n";
	exit;
}

$file = shift(@ARGV);
open(FILE, "<$file") || die "Can't open \'$file\'!\n";
binmode(FILE);

# Preamble
read(FILE, $_, 3);
($pre, $i, $k) = unpack('CCC', $_);
($pre == 247 && $i == 202) || die "Bad VF file!\n";
read(FILE, $comment, $k);
print  "(VTITLE $comment)\n";
print  "(OFMLEVEL H 0)\n"; # ovp2ovf (WEB >=1.12 and C 2.1) doesn't accept char >ff without this
read(FILE, $_, 8);
($cs, $ds) = unpack('NN', $_);
printf "(DESIGNSIZE R %f)\n", $ds/(1<<20);
print  "(COMMENT DESIGNSIZE IS IN POINTS)\n";
print  "(COMMENT OTHER SIZES ARE MULTIPLES OF DESIGNSIZE)\n";
printf "(CHECKSUM O %o)\n", $cs;

# Font definitions
$cmd = unpack('C', getc(FILE));
while ($cmd >= 243 && $cmd <= 246) {
	read(FILE, $_, $cmd - 242);
	$k = &get_num($_, 0);
	read(FILE, $_, 14);
	($cs, $ss, $ds, $a, $l) = unpack('NNNCC', $_);
	read(FILE, $fontname, $a + $l);
	print  "(MAPFONT D $k\n";
	print  "   (FONTNAME $fontname)\n";
	printf "   (FONTCHECKSUM O %o)\n", $cs;
	printf "   (FONTAT R %f)\n", $ss/(1<<20);
	printf "   (FONTDSIZE R %f)\n", $ds/(1<<20);
	print  "   )\n";
	$cmd = unpack('C', getc(FILE));
}

# Character packets
while ($cmd <= 242) {
	if ($cmd == 242) {	# long_char
		read(FILE, $_, 12);
		($pl, $cc, $tfm) = unpack('NNN', $_);
	} else {		# short_char
		$pl = $cmd;
		read(FILE, $_, 4);
		($cc, $_) = unpack('Ca*', $_);
		$tfm = &get_num($_, 0);
	}
	printf "(CHARACTER H %X\n",$cc;
	printf "   (CHARWD R %f)\n", $tfm/(1<<20);
	print  "   (MAP\n";
	read(FILE, $dvi, $pl);
	&pret_dvi($dvi);
	print  "      )\n";
	print  "   )\n";
	$cmd = unpack('C', getc(FILE));
}

sub get_num {
	local ($buf, $sgn) = @_;
	local ($num, $i);
	if ($sgn) {
		($num, $buf) = unpack('ca*', $buf);
	} else {
		($num, $buf) = unpack('Ca*', $buf);
	}
	while ($buf ne '') {
		($i, $buf) = unpack('Ca*', $buf);
		$num = ($num * 256) + $i;
	}
	return ($num);
}

sub pret_dvi {
	local ($dvi) = @_;
	local ($cmd, $k, $a, $b, @stack);
	local ($w, $x, $y, $z) = (0, 0, 0, 0);
	while ($dvi ne '') {
		($cmd, $dvi) = unpack('Ca*', $dvi);
		if ($cmd <= 131) {			# set_char
			if ($cmd <= 127) {
				$k = $cmd;
			} else {
				$cmd -= 127;
				($_, $dvi) = unpack("a$cmd a*", $dvi);
				$k = &get_num($_, 0);
			}
			printf "      (SETCHAR H %X)\n",$k;
		} elsif ($cmd == 132) {			# set_rule
			($a, $b, $dvi) = unpack('a4a4a*', $dvi);
			$a = &get_num($a, 1);
			$b = &get_num($b, 1);
			printf "      (SETRULE R %f R %f)\n",
				$a/(1<<20), $b/(1<<20);
		} elsif ($cmd == 141) {			# push
			splice(@stack, $#stack+1, 0, $w, $x, $y, $z);
			print  "      (PUSH)\n";
		} elsif ($cmd == 142) {			# pop
			($w, $x, $y, $z) = splice(@stack, -4);
			print  "      (POP)\n";
		} elsif ($cmd >= 143 && $cmd <= 156) {	# move_right/left
			if ($cmd <= 146) {
				$cmd -= 142;
				($_, $dvi) = unpack("a$cmd a*", $dvi);
				$b = &get_num($_, 1);
			} elsif ($cmd == 147) {
				$b = $w;
			} elsif ($cmd <= 151) {
				$cmd -= 147;
				($_, $dvi) = unpack("a$cmd a*", $dvi);
				$b = $w = &get_num($_, 1);
			} elsif ($cmd == 152) {
				$b = $x;
			} else {
				$cmd -= 152;
				($_, $dvi) = unpack("a$cmd a*", $dvi);
				$b = $x = &get_num($_, 1);
			}
			printf "      (MOVERIGHT R %f)\n", $b/(1<<20);
		} elsif ($cmd >= 157 && $cmd <= 170) {	# move_up/dpwn
			if ($cmd <= 160) {
				$cmd -= 156;
				($_, $dvi) = unpack("a$cmd a*", $dvi);
				$a = &get_num($_, 1);
			} elsif ($cmd == 161) {
				$a = $y;
			} elsif ($cmd <= 165) {
				$cmd -= 161;
				($_, $dvi) = unpack("a$cmd a*", $dvi);
				$a = $y = &get_num($_, 1);
			} elsif ($cmd == 166) {
				$a = $z;
			} else {
				$cmd -= 166;
				($_, $dvi) = unpack("a$cmd a*", $dvi);
				$a = $z = &get_num($_, 1);
			}
			printf "      (MOVEDOWN R %f)\n", $a/(1<<20);
		} elsif ($cmd >= 171 && $cmd <= 238) {	# select_font
			if ($cmd <= 234) {
				$k = $cmd - 171;
			} else {
				$cmd -= 234;
				($_, $dvi) = unpack("a$cmd a*", $dvi);
				$k = &get_num($_);
			}
			print  "      (SELECTFONT D $k)\n";
		} elsif ($cmd >= 239 && $cmd <= 242) {	# xxx
			$cmd -= 238;
			($_, $dvi) = unpack("a$cmd a*", $dvi);
			$k = &get_num($_, 0);
			($_, $dvi) = unpack("a$k a*", $dvi);
			print  "      (SPECIAL $_)\n";
		}
	}
}

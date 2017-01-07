#! /usr/bin/perl

# dviinfo
# =======
# 
# Written by Dag Langmyhr, Department of Informatics, University of Oslo
# (dag@ifi.uio.no).
#
# A program to print information about a DVI file.
#
# Usage: dviinfo -f -p -v file 1 file2 ...
# where the flags indicate which information is desired.
#  -f  Give information about the fonts used.
#  -p  Give information about the number of pages.
#  -v  List the program version number.
# No options will provide all information available.
#
# Example:
# % dviinfo alltt.dvi
# alltt.dvi: DVI format 2; 3 pages
#   Magnification: 1000/1000
#   Size unit: 1000x25400000/(1000x473628672)dum = 0.054dum = 1.000sp
#   Page size: 407ptx682pt = 14.340cmx23.970cm
#   Stack size: 8
#   Comment: " TeX output 1995.07.07:1513"
#   Font  27:      cmr9 at  9.000 (design size  9.000, checksum=1874103239)
#   Font  26:     cmsy6 at  6.000 (design size  6.000, checksum=1906386187)
#   Font  21:      cmr8 at  8.000 (design size  8.000, checksum=2088458503)
#   Font  20:    cmsy10 at 12.000 (design size 10.000, checksum=555887770)
#   Font  16:     cmr12 at 12.000 (design size 12.000, checksum=1487622411)
#   Font  15:    cmtt12 at 17.280 (design size 12.000, checksum=3750147412)
#   Font  14:     cmr17 at 17.280 (design size 17.280, checksum=1154739572)
#   Font  13:    cmsy10 at 10.000 (design size 10.000, checksum=555887770)
#   Font   7:     cmr10 at 10.000 (design size 10.000, checksum=1274110073)
#   Font   6:      cmr7 at  7.000 (design size  7.000, checksum=3650330706)

$Prog    = "dviinfo";
$Version = "1.03";

$True = 1;

$List_all = $True;

# DVI commands:
$DVI_Filler    = "\337";
$DVI_Font      = "\363";
$DVI_Post      = "\370";
$DVI_Post_post = "\371";
$DVI_Pre       = "\367";

print "Usage: $prog [-f][-p][-v] file...\n" unless @ARGV;

Param:
foreach (@ARGV) {
    /^-f$/ && do {
	$List_fonts = $True;  $List_all = $False;  next Param; };
    /^-p$/ && do {
	$List_pages = $True;  $List_all = $False;  next Param; };
    /^-v$/ && do {
	print "This is $Prog (version $Version)\n";  next Param; };
    /^-/ && do {
	print "$Prog: Unknown option '$_' ignored.\n";  next Param; };
    
    &Read_DVI_file($_);
}

exit 0;


sub Read_DVI_file {
    local($_) = @_;
    local($c);

    print "$_: ";

    open(F, $_) || do { print "Could not open!\n\n"; return };

    # First, read info at start of DVI file:

    if (($c = getc(F)) ne $DVI_Pre) {
	printf("Not a DVI file (first byte is 0x%02x, not 0x%02x)!\n\n", 
	       ord($c), ord($DVI_Pre));
	close F;  return;
    };

    $Format  = ord(getc(F));
    $Numer   = &Read4;
    $Denom   = &Read4;
    $Magni   = &Read4;
    $Comment = &Read_text;

    # Then, read information at the end of the DVI file:

    seek(F, -1, 2);
    while (($c = getc(F)) eq $DVI_Filler) { seek(F, -2, 1); };
    $cn = ord($c);
    if ($cn != $Format) {
	print "DVI format error ($Format vs $cn)!\n\n";
	close F;  return;
    };

    seek(F, -6, 1);
    if (($c = getc(F)) ne $DVI_Post_post) {
	$cn = ord($c);
	printf("DVI error: Expected POST_POST command, not 0x%02x!\n\n", $cn);
	close F;  return;
    };

    $Last_post = &Read4;
    seek(F, $Last_post, 0) || do {
	print "Could not locate position $Last_post!\n\n";
	close F;  return;
    };
    if (($c = getc(F)) ne $DVI_Post) {
	$cn = ord($c);
	printf("DVI error: Expected POST command, not 0x%02x!\n\n", $cn);
	close F;  return;
    };

    $Final_page = &Read4;
    $Numer2     = &Read4;
    $Denom2     = &Read4;
    $Magni2     = &Read4;
    $Height     = &Read4;
    $Width      = &Read4;
    $Stack      = &Read2_u;
    $Pages      = &Read2_u;

    print "DVI format $Format; " if $List_all;
    if ($List_all || $List_pages) {
	print "$Pages page";
	print "s" if $Pages != 1;
    };

    $Unit = $Magni*$Numer/(1000*$Denom);
    if ($List_all) {
	print "\n  Magnification: $Magni/1000";
	printf("\n  Size unit: %dx$Numer/(1000x$Denom)dum = %5.3fdum = %5.3fsp", 
	       $Magni, $Unit, &Scale_to_sp(1));
	printf("\n  Page size: %dptx%dpt = %5.3fcmx%5.3fcm", 
	       &Scale_to_pt($Width), &Scale_to_pt($Height),
	       &Scale_to_cm($Width), &Scale_to_cm($Height));
	print "\n  Stack size: $Stack";
	print "\n  Comment: \"$Comment\"";
    }
    print "\n";

    if ($List_all || $List_fonts) {
	while (($c = getc(F)) eq $DVI_Font) {
	    $F_count  = ord(getc(F));
	    $F_check  = &Read4_u;
	    $F_scale  = &Read4;
	    $F_design = &Read4;
	    $F_name   = &Read_text2;
	    printf("  Font %3d: %9s at %6.3f", 
		   $F_count, $F_name, &Scale_to_pt($F_scale));
	    printf(" (design size %6.3f, ", &Scale_to_pt($F_design));
	    print "checksum=$F_check)\n";
	};

	if ($c ne $DVI_Post_post) {
	    $cn = ord($c);
	    printf("DVI error: Expected POST-POST, not 0x%02x!.\n\n", $cn); 
	    close F;  return;
	};

	print "\n";
    };

    close F;
}


# Scale_to_pt (Size)
# ----- 
# Give the Size (which is in dum, the standard DVI size) in pt.
sub Scale_to_pt {
    return $Unit*$_[0]*72.27/254000;
}


# Scale_to_cm (Size)
# -----------
# Give the Size (which is in dum, the standard DVI size) in cm. 
sub Scale_to_cm {
    return &Scale_to_pt($_[0])*2.54/72.27;
}


# Scale_to_sp (Size)
# -----------
# Give the Size (which is in dum, the standard DVI size) in sp. 
sub Scale_to_sp {
    return &Scale_to_pt($_[0])*65536;
}


# Read2_u
# -------
# Read an unsigned two-byte value.
sub Read2_u {
    return ord(getc(F))*256 + ord(getc(F));
}


# Read4
# -----
# Read a four-byte value.
# (I assume the value is positive and less than 2^31, so the sign bit 
# won't matter.)
sub Read4 {
    return ((ord(getc(F))*256+ord(getc(F)))*256+ord(getc(F)))*256+ord(getc(F));
}


# Read4_u
# -----
# Read an unsigned four-byte value.
# (I don't know why this works for values >=2^31, and Read4 does not,
# but as long as it works...)
sub Read4_u {
    local(@bytes, @sum);

    $bytes[0] = ord(getc(F));  $bytes[1] = ord(getc(F));
    $bytes[2] = ord(getc(F));  $bytes[3] = ord(getc(F));

    $sum[0] = $bytes[0]*256 + $bytes[1];
    $sum[1] = $bytes[2]*256 + $bytes[3];

    return $sum[0]*65536 + $sum[1];
}


# Read_text
# ---------
# Read a text (a one-byte length and the the text byte).
sub Read_text {
    local($Leng, $Res, $_);

    $Leng = ord(getc(F));  read(F, $Res, $Leng);
    return $Res;
}


# Read_text2
# ----------
# Like 'Read_text', but the length is the sum of two bytes.
sub Read_text2 {
    local($Leng, $Res, $_);

    $Leng = ord(getc(F)) + ord(getc(F));  read(F, $Res, $Leng);
    return $Res;
}

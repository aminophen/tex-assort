# tex-assort

This repository contains some useful TeX-related utilities which
are not included in TeX Live. Unless otherwise stated,
I make no claim of ownership to the utilities in this repository;
please refer to the primary distributor of each utility.

## dviinfox.pl

Perl script which prints information about a DVI file.
It supports not only the standard DVI format of TeX, but also
the extended DVI format of pTeX containing vertical direction.
It also accepts XDV format of XeTeX containing native font
definitions.

This is a joint effort of
Dag Langmyhr (Department of Informatics, University of Oslo)
and Hironobu Yamashita (Japanese TeX Development Community).

### License

The script is licensed under MIT License.

### References

- Current development place by Hironobu Yamashita
    - https://github.com/aminophen/tex-assort
- Previous version 1.03 (2013/11/03 11:17) by Dag Langmyhr
    - http://dag.at.ifi.uio.no/public/bin/dviinfo

### Additional Notes

The perl script was originally named "dviinfo" by Dag Langmyhr,
and renamed "dviinfox" in 2017, to be easily distinguished from
another program written in C by Valentino Kyriakides
(Dviinfo revision 1.3 1993/11/23 22:49:30).
The C program seems to be derived from NeXTSTEP app in 1990s,
and it has nothing to do with our perl script.

## disvf.pl

Perl script which converts VF into VPL (2-byte code is also supported);
written by Ichiro Matsuda (Tokyo University of Science)

The script in this repository is patched by Shuzaburo Saito,
to convert decimal numbers to hexadecimal numbers.
(cf. http://psitau.kitunebi.com/mkvf.html )
A patch to improve compatibility with recent ovp2ovf
(WEB version >1.12 and C version 2.1)
is also applied by Hironobu Yamashita.

### License

Currently unknown. Sorry.

### References

- Description by Ichiro Matsuda
    - https://web.archive.org/web/20090517083043/http://itohws03.ee.noda.sut.ac.jp/~matsuda/ttf2pk
- Original version (2000/10/23?) by Ichiro Matsuda
    - https://web.archive.org/web/20090519023530/http://itohws03.ee.noda.sut.ac.jp/~matsuda/ttf2pk/disvf.pl

## others

Here is the list of some utilities which are available as independent repositories:

- replacecjkfonts.pl --- Perl script for producing a PDF without embedded CJK fonts
    - https://github.com/aminophen/replacecjkfonts
- bcpdfcrop.bat --- Windows batch file which crops pdf margins (= another pdfcrop)
    - https://github.com/aminophen/bcpdfcrop
- dvipdf.bat --- Windows batch file edition of Ghostscript dvipdf (= dvips + gs pdfwrite)
    - https://github.com/aminophen/dvipdf


----

本リポジトリには、私が個人的に集めた「TeX Live には含まれていない、しかし
有用な TeX 関連ユーティリティ」を置いておく場所です。
再配布者である私は何の権利も主張しません。それぞれのプログラムの著者の
ライセンスに従って利用してください。

Hironobu Yamashita

# tex-assort

This repository contains some useful TeX-related utilities which are not
included in TeX Live. I make no claim of ownership to the utilities in this
repository; please refer to the primary distributor of each utility.

## dviinfo.pl

Perl script which prints information about a DVI file;
written by Dag Langmyhr (Department of Informatics, University of Oslo)

Note that this program has nothing to do with another program written in C
by Valentino Kyriakides (Dviinfo revision 1.3 1993/11/23 22:49:30), which is
derived from NeXTSTEP app and now included in W32TeX by Akira Kakuto.

- Origin: http://dag.at.ifi.uio.no/public/bin/dviinfo
- Version: 1.03 (2013/11/03 11:17) + patch (2017/01/09)
- License: currently unknown

The script in this repository is patched by Hironobu Yamashita, to accept
pTeX DVI containing vertical direction.

## disvf.pl

Perl script which converts VF into VPL (2-byte code is also supported);
written by Ichiro Matsuda (Tokyo University of Science)

- Origin: https://web.archive.org/web/20090519023530/http://itohws03.ee.noda.sut.ac.jp/~matsuda/ttf2pk/disvf.pl
- Version: unknown (2000/10/23?) + patch (2017/01/09)
- License: currently unknown
- Description: https://web.archive.org/web/20090517083043/http://itohws03.ee.noda.sut.ac.jp/~matsuda/ttf2pk

The script in this repository is patched by Shuzaburo Saito, to convert decimal
numbers to hexadecimal numbers. (cf. http://psitau.kitunebi.com/mkvf.html )
A patch to improve compatibility with recent ovp2ovf (WEB version >1.12 and
C version 2.1) is also applied by Hironobu Yamashita.

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

#!/bin/sh

if [ "$1" = "" ]; then
    echo "No arguments given."
    exit 1
fi

PROJECT=$1
TMP=/tmp
PWDF=`pwd`
LATESTRELEASEDATE=`git tag | sort -r | head -n 1`
RELEASEDATE=`git tag --points-at HEAD | sort -r | head -n 1`

if [ -z "$RELEASEDATE" ]; then
    RELEASEDATE="**not tagged**; later than $LATESTRELEASEDATE?"
fi

echo " * Create $PROJECT.zip ($RELEASEDATE)"
git archive --format=tar --prefix=$PROJECT/ HEAD | (cd $TMP && tar xf -)
(cd $TMP/$PROJECT && ls -1) | grep -v -e $PROJECT -e README.md | (cd $TMP/$PROJECT && xargs rm)
rm $TMP/$PROJECT/.gitignore
rm -rf $TMP/$PROJECT/tests

# dirty hack
perl -pi.bak -0777 -e "s/# tex-assort.*## $PROJECT/# $PROJECT/gs" $TMP/$PROJECT/README.md
perl -pi.bak -0777 -e "s/### License/# License/gs" $TMP/$PROJECT/README.md
perl -pi.bak -0777 -e "s/### References/# References/gs" $TMP/$PROJECT/README.md
perl -pi.bak -0777 -e "s/### Additional Notes/# Additional Notes/gs" $TMP/$PROJECT/README.md
perl -pi.bak -0777 -e "s/## .*$/# Release Date\n\n$RELEASEDATE\n/gs" $TMP/$PROJECT/README.md
perl -pi.bak -0777 -e "s/#/##/gs" $TMP/$PROJECT/README.md
perl -pi.bak -0777 -e "s/## $PROJECT/# $PROJECT/gs" $TMP/$PROJECT/README.md
rm -f $TMP/$PROJECT/README.md.bak
if [ ! -e $TMP/$PROJECT/LICENSE.$PROJECT ]; then
    echo "LICENSE.$PROJECT not found."
    rm -rf $TMP/$PROJECT
    exit 1
fi
mv $TMP/$PROJECT/LICENSE.$PROJECT $TMP/$PROJECT/LICENSE

cd $TMP && zip -r $PWDF/$PROJECT.zip $PROJECT
rm -rf $TMP/$PROJECT
echo
echo " * Done: $PROJECT.zip ($RELEASEDATE)"

#! /bin/sh

envpkgs="$fontconfig"
. $stdenv/setup || exit 1

tar xvfz $src || exit 1
cd fcpackage*/Xft || exit 1
./configure --prefix=$out --x-includes=/usr/X11/include --x-libraries=/usr/X11/lib || exit 1
make || exit 1
make install || exit 1
echo $envpkgs > $out/envpkgs || exit 1

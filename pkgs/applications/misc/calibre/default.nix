{ stdenv, fetchurl, python, pyqt4, sip, popplerQt4, pkgconfig, libpng
, imagemagick, libjpeg, fontconfig, podofo, qt4, icu, sqlite
, pil, makeWrapper, unrar, chmlib, pythonPackages, xz
}:

stdenv.mkDerivation rec {
  name = "calibre-0.8.32";

  src = fetchurl {
    url = "http://calibre-ebook.googlecode.com/files/${name}.tar.xz";
    sha256 = "0d0zq4sr0qm8jarg0ps24lfizb4hyb57pjsp81y1sb5nzjki7jml";
  };

  inherit python;

  buildNativeInputs = [ makeWrapper pkgconfig ];

  buildInputs =
    [ python pyqt4 sip popplerQt4 libpng imagemagick libjpeg
      fontconfig podofo qt4 pil chmlib icu
      pythonPackages.mechanize pythonPackages.lxml pythonPackages.dateutil
      pythonPackages.cssutils pythonPackages.beautifulsoap
      pythonPackages.sqlite3 sqlite
    ];

  installPhase = ''
    export HOME=$TMPDIR/fakehome
    export POPPLER_INC_DIR=${popplerQt4}/include/poppler
    export POPPLER_LIB_DIR=${popplerQt4}/lib
    export MAGICK_INC=${imagemagick}/include/ImageMagick
    export MAGICK_LIB=${imagemagick}/lib
    export FC_INC_DIR=${fontconfig}/include/fontconfig
    export FC_LIB_DIR=${fontconfig}/lib
    export PODOFO_INC_DIR=${podofo}/include/podofo
    export PODOFO_LIB_DIR=${podofo}/lib
    python setup.py install --prefix=$out

    PYFILES="$out/bin/* $out/lib/calibre/calibre/web/feeds/*.py
      $out/lib/calibre/calibre/ebooks/metadata/*.py
      $out/lib/calibre/calibre/ebooks/rtf2xml/*.py"

    sed -i "s/env python[0-9.]*/python/" $PYFILES
    for a in $out/bin/*; do
      wrapProgram $a --prefix PYTHONPATH : $PYTHONPATH --prefix LD_LIBRARY_PATH : ${unrar}/lib
    done
  '';

  meta = { 
    description = "Comprehensive e-book software";
    homepage = http://calibre-ebook.com;
    license = "GPLv3";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}

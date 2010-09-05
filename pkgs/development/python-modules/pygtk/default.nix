{stdenv, fetchurl, python, pkgconfig, glib, gtk, pygobject, pycairo
  , libglade ? null}:

stdenv.mkDerivation {
  name = "pygtk-2.21.0";

  src = fetchurl {
    url = http://ftp.gnome.org/pub/GNOME/sources/pygtk/2.21/pygtk-2.21.0.tar.bz2;
    sha256 = "1zfzq5zwldaha2ivga8f2ydyslf0fs8j601yyqcqsqb3y1dk8vbj";
  };

  buildInputs = [python pkgconfig glib gtk]
    ++ (if libglade != null then [libglade] else [])
  ;

  propagatedBuildInputs = [pygobject pycairo];

  postInstall = ''
    rm $out/bin/pygtk-codegen-2.0
    ln -s ${pygobject}/bin/pygobject-codegen-2.0  $out/bin/pygtk-codegen-2.0

    # All python code is installed into a "gtk-2.0" sub-directory. That
    # sub-directory may be useful on systems which share several library
    # versions in the same prefix, i.e. /usr/local, but on Nix that directory
    # is useless. Furthermore, its existence makes it very hard to guess a
    # proper $PYTHONPATH that allows "import gtk" to succeed.
    cd $(toPythonPath $out)/gtk-2.0
    for n in *; do
      ln -s "gtk-2.0/$n" "../$n"
    done
  '';
}

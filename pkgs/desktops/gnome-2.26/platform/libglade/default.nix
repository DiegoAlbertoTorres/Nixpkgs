{stdenv, fetchurl, pkgconfig, gtk, libxml2, expat, python, gettext}:

stdenv.mkDerivation {
  name = "libglade-2.6.4";
  src = fetchurl {
    url = mirror://gnome/platform/2.26/2.26.2/sources/libglade-2.6.4.tar.bz2;
    sha256 = "1v2x2s04jry4gpabws92i0wq2ghd47yr5n9nhgnkd7c38xv1wdk4";
  };
  buildInputs = [ pkgconfig gtk libxml2 expat python gettext ];
}

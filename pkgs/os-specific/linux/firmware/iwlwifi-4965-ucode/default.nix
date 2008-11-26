{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "iwlwifi-4965-ucode-4.44.17";
  
  src = fetchurl {
    url = "http://intellinuxwireless.org/iwlwifi/downloads/" + name + ".tgz";
    sha256 = "1mfnxsp58jvh0njvwaxrkbiggbzr4jd0hk314hxfwyjpjdd2hj6w";
  };
  
  buildPhase = "true";

  installPhase = ''
    ensureDir "$out"
    chmod -x *
    cp * "$out"

    # The driver expects the `-1' in the file name.
    cd "$out"
    ln -s iwlwifi-4965.ucode iwlwifi-4965-1.ucode
  '';
  
  meta = {
    description = "Firmware for the Intel 4965ABG wireless card";

    longDescription = ''
      This package provides version 2 of the Intel wireless card
      firmware, for Linux up to 2.6.26.  It contains the
      `iwlwifi-4965-1.ucode' file, which is loaded by the `iw4965'
      driver found in recent kernels.
    '';

    homepage = http://intellinuxwireless.org/;
  };
}

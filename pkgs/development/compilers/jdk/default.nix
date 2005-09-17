{stdenv, fetchurl}: 

if stdenv.system == "i686-linux"
  then
    (import ./jdk5-sun-linux.nix) {
      inherit stdenv fetchurl;
    }
  else
    false

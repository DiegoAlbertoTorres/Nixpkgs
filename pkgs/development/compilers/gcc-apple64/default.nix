{ stdenv, fetchurl, noSysDirs
, langC ? true, langCC ? true, langF77 ? false
, profiledCompiler ? false
, gmp ? null, mpfr ? null, bison ? null, flex ? null
}:

assert langC;
assert stdenv.isDarwin;
assert langF77 -> gmp != null;

stdenv.mkDerivation ({
  name = "gcc-4.2.1-apple-5646";
  builder = ./builder.sh;
  src = 
    stdenv.lib.optional /*langC*/ true (fetchurl {
      url = http://www.opensource.apple.com/tarballs/gcc/gcc-5646.tar.gz;
      sha256 = "13jghyb098104kfym96iwwdvbj6snnws2c92h48lbd4fmyf1iv24";
    }) ++
    stdenv.lib.optional langCC (fetchurl {
      url = http://www.opensource.apple.com/tarballs/libstdcxx/libstdcxx-39.tar.gz ;
      sha256 = "ccf4cf432c142778c766affbbf66b61001b6c4f1107bc2b2c77ce45598786b6d";
    }) ;

  enableParallelBuilding = true;

  libstdcxx = "libstdcxx-39";
  sourceRoot = "gcc-5646/";
  patches =
    [./pass-cxxcpp.patch ]
    ++ (if noSysDirs then [./no-sys-dirs.patch] else []);
  inherit noSysDirs langC langCC langF77 profiledCompiler;
} // (if langF77 then {buildInputs = [gmp mpfr bison flex];} else {}))

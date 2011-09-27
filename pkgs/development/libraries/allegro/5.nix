
x@{builderDefsPackage
  , texinfo, libXext, xextproto, libX11, xproto, libXpm, libXt, libXcursor
  , alsaLib, cmake, zlib, libpng, libvorbis, libXxf86dga, libXxf86misc
  , xf86dgaproto, xf86miscproto, xf86vidmodeproto, libXxf86vm, openal, mesa
  , kbproto
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="allegro";
    version="5.0.4";
    name="${baseName}-${version}";
    project="alleg";
    url="mirror://sourceforge/project/${project}/${baseName}/${version}/${name}.tar.gz";
    hash="0vm93kqvvw4rw2zx4l64c2i86xl5giwbqbyki4b2b83z0acpmc1n";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  /* doConfigure should be removed if not needed */
  phaseNames = ["doCmake" "doMakeInstall"];

  doCmake = a.fullDepEntry (''
    export NIX_LDFLAGS="$NIX_LDFLAGS -lXext -lX11 -lXpm -lXcursor -lXxf86vm"
    cmake -D CMAKE_INSTALL_PREFIX=$out -D CMAKE_SKIP_RPATH=ON .
  '') ["minInit" "doUnpack" "addInputs"];
      
  makeFlags = [
  ];

  meta = {
    description = "A game programming library";
    license = "free-noncopyleft"; # giftware
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://sourceforge.net/projects/alleg/files/";
    };
  };
}) x

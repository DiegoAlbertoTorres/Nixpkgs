{ stdenv, fetchurl, perl, gettext, makeWrapper, lib, PerlMagick, YAML
, TextMarkdown, URI, HTMLParser, HTMLScrubber, HTMLTemplate, TimeDate
, CGISession, CGIFormBuilder, DBFile, LocaleGettext, RpcXML, XMLSimple
, YAMLLibYAML
, gitSupport ? false, git ? null
, monotoneSupport ? false, monotone ? null
, extraUtils ? []
}:

assert gitSupport -> (git != null);
assert monotoneSupport -> (monotone != null);

let
  name = "ikiwiki";
  version = "3.20120202";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "http://ftp.de.debian.org/debian/pool/main/i/ikiwiki/${name}_${version}.tar.gz";
    sha256 = "0bada9a98e0990c6d99e8ca978e42926578aec36d033d6a273e415349a6cbb48";
  };

  buildInputs = [ perl TextMarkdown URI HTMLParser HTMLScrubber HTMLTemplate
    TimeDate gettext makeWrapper DBFile CGISession CGIFormBuilder LocaleGettext
    RpcXML XMLSimple PerlMagick YAML YAMLLibYAML ]
    ++ stdenv.lib.optionals gitSupport [git]
    ++ stdenv.lib.optionals monotoneSupport [monotone];

  patchPhase = ''
    sed -i s@/usr/bin/perl@${perl}/bin/perl@ pm_filter mdwn2man
    sed -i s@/etc/ikiwiki@$out/etc@ Makefile.PL
    sed -i /ENV{PATH}/d ikiwiki.in
    # State the gcc dependency, and make the cgi use our wrapper
    sed -i -e 's@$0@"'$out/bin/ikiwiki'"@' \
        -e "s@'cc'@'${stdenv.gcc}/bin/gcc'@" IkiWiki/Wrapper.pm
  '';

  configurePhase = "perl Makefile.PL PREFIX=$out";

  postInstall = ''
    for a in "$out/bin/"*; do
      wrapProgram $a --suffix PERL5LIB : $PERL5LIB --prefix PATH : ${perl}/bin:$out/bin \
      ${lib.optionalString gitSupport
        ''--prefix PATH : ${git}/bin \''}
      ${lib.optionalString monotoneSupport
        ''--prefix PATH : ${monotone}/bin \''}
      ${lib.concatMapStrings (x: "--prefix PATH : ${x}/bin ") extraUtils}
    done
  '';

  meta = {
    description = "Wiki compiler, storing pages and history in a RCS";
    homepage = http://ikiwiki.info/;
    license = "GPLv2+";
  };
}

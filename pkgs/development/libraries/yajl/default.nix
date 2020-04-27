{ stdenv, fetchurl, cmake, aflplusplus }:

stdenv.mkDerivation rec {
  name = "yajl-2.1.0";

  src = fetchurl {
    url = https://github.com/lloyd/yajl/tarball/2.1.0;
    name = "${name}.tar.gz";
    sha256 = "0f6yrjc05aa26wfi7lqn2gslm19m6rm81b30ksllpkappvh162ji";
  };

  nativeBuildInputs = [ cmake ];

  AFL_HARDEN="1";
  AFL_LLVM_LAF_SPLIT_SWITCHES="1";
  AFL_LLVM_LAF_TRANSFORM_COMPARES="1";
  AFL_LLVM_LAF_SPLIT_COMPARES="1";
  preConfigure = ''
    export CC=${aflplusplus}/bin/afl-clang-fast
  '';

  meta = {
    description = "Yet Another JSON Library";
    longDescription = ''
      YAJL is a small event-driven (SAX-style) JSON parser written in ANSI
      C, and a small validating JSON generator.
    '';
    homepage = http://lloyd.github.com/yajl/;
    license = stdenv.lib.licenses.isc;
    platforms = with stdenv.lib.platforms; linux ++ darwin;
    maintainers = with stdenv.lib.maintainers; [ maggesi ];
  };
}

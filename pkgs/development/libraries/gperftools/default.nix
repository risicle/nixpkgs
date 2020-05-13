{ stdenv, fetchFromGitHub, libunwind, autoconf, automake, libtool }:

stdenv.mkDerivation rec {
  name = "gperftools-2.7ris";

#   src = fetchurl {
#     url = "https://github.com/gperftools/gperftools/releases/download/ris-readable-page-fence-0/ris-readable-page-fence-0.tar.gz";
#     sha256 = "1jb30zxm4444qxa8yi76rfxj4ssk60rv8n9y41m6pzqfk9lwis0y";
#   };
  src = fetchFromGitHub {
    owner = "risicle";
    repo = "gperftools";
    rev = "ris-readable-page-fence-1";
    sha256 = "04pwsf3wlbcrqw10lbwvqf8p4669na310z0hzgrw6rjhxif82mgv";
  };

  buildInputs = [ autoconf automake libtool ] ++ stdenv.lib.optional stdenv.isLinux libunwind;

  prePatch = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace Makefile.am --replace stdc++ c++
    substituteInPlace Makefile.in --replace stdc++ c++
    substituteInPlace libtool --replace stdc++ c++
  '';

  preConfigure = ''
    sh autogen.sh
  '';

  NIX_CFLAGS_COMPILE = stdenv.lib.optionals stdenv.isDarwin [
    "-D_XOPEN_SOURCE" "-Wno-aligned-allocation-unavailable"
  ];

  # some packages want to link to the static tcmalloc_minimal
  # to drop the runtime dependency on gperftools
  dontDisableStatic = true;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/gperftools/gperftools;
    description = "Fast, multi-threaded malloc() and nifty performance analysis tools";
    platforms = with platforms; linux ++ darwin;
    license = licenses.bsd3;
    maintainers = with maintainers; [ vcunat ];
  };
}

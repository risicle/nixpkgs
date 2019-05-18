{ stdenv, fetchurl, fetchpatch, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "libsass-${version}";
  version = "3.5.5";

  src = fetchurl {
    url = "https://github.com/sass/libsass/archive/${version}.tar.gz";
    sha256 = "0w6v1xa00jvfyk4b29ir7dfkhiq72anz015gg580bi7x3n7saz28";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2018-19827.patch";
      url = "https://github.com/sass/libsass/commit/67a3f4ff9b790ed016197e6da4ef4e1d4c9da09f.patch";
      sha256 = "0ix12x9plmpgs3xda2fjdcykca687h16qfwqr57i5qphjr9vp33l";
    })
  ];

  preConfigure = ''
    export LIBSASS_VERSION=${version}
  '';

  nativeBuildInputs = [ autoreconfHook ];

  meta = with stdenv.lib; {
    description = "A C/C++ implementation of a Sass compiler";
    homepage = https://github.com/sass/libsass;
    license = licenses.mit;
    maintainers = with maintainers; [ codyopel offline ];
    platforms = platforms.unix;
  };
}

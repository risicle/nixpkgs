{ fetchFromGitHub, stdenv, autoreconfHook, pkg-config }:

stdenv.mkDerivation rec {
  pname = "libupnp";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "mrjimenez";
    repo = "pupnp";
    rev = "release-${version}";
    sha256 = "0h7qfkin2l9riwskqn9zkn1l8z2gqfnanvaszjyxga2m5axz4n8c";
  };
  outputs = [ "dev" "out" ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  hardeningDisable = [ "fortify" ];

  meta = {
    description = "libupnp, an open source UPnP development kit for Linux";

    longDescription = ''
      The Linux SDK for UPnP Devices (libupnp) provides developers
      with an API and open source code for building control points,
      devices, and bridges that are compliant with Version 1.0 of the
      UPnP Device Architecture Specification.
    '';

    license = "BSD-style";

    homepage = "http://pupnp.sourceforge.net/";
    platforms = stdenv.lib.platforms.unix;
  };
}

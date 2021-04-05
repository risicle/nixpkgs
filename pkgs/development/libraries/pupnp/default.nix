{ fetchFromGitHub
, lib
, stdenv
, cmake
}:

stdenv.mkDerivation rec {
  pname = "libupnp";
  version = "1.14.4";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "mrjimenez";
    repo = "pupnp";
    rev = "release-${version}";
    sha256 = "sha256-4VuTbcEjr9Ffrowb3eOtXFU8zPNu1NXS531EOZpI07A=";
  };

  nativeBuildInputs = [
    cmake
  ];

  postPatch = ''
    # Wrong paths in pkg-config file generated by CMake
    # https://github.com/pupnp/pupnp/pull/205/files#r588946478
    substituteInPlace CMakeLists.txt \
      --replace '\''${exec_prefix}/' "" \
      --replace '\''${prefix}/' ""
  '';

  meta = {
    description = "libupnp, an open source UPnP development kit for Linux";

    longDescription = ''
      The Linux SDK for UPnP Devices (libupnp) provides developers
      with an API and open source code for building control points,
      devices, and bridges that are compliant with Version 1.0 of the
      UPnP Device Architecture Specification.
    '';

    license = lib.licenses.bsd3;
    homepage = "http://pupnp.sourceforge.net/";
    platforms = stdenv.lib.platforms.unix;
  };
}

{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, boost
, cmake
, giflib
, ilmbase
, libjpeg
, libpng
, libtiff
, opencolorio_1
, openexr
, robin-map
, unzip
, fmt
, python3
}:

stdenv.mkDerivation rec {
  pname = "openimageio";
  version = "2.2.17.0";

  src = fetchFromGitHub {
    owner = "OpenImageIO";
    repo = "oiio";
    rev = "Release-${version}";
    sha256 = "0jqpb1zci911wdm928addsljxx8zsh0gzbhv9vbw6man4wi93h6h";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2022-36354.patch";
      url = "https://github.com/OpenImageIO/oiio/commit/b48f0650a464ec15cc449b0e92f5fbad4659460b.patch";
      sha256 = "sha256-PTUIVqzS6UlvXggcKgkaMR/jcSxiBQZWyucqcI3k2Rc=";
    })
  ];

  postPatch = let
    oiio-images = fetchFromGitHub {
      owner = "OpenImageIO";
      repo = "oiio-images";
      rev = "aae37a54e31c0e719edcec852994d052ecf6541e";
      sha256 = "sha256-Ivh87i4pTHEu849KON73wbz020u6v4sJu3i0q8nBhjs=";
    };
  in ''
    ln -s ${oiio-images} /build/oiio-images
  '';

  outputs = [ "bin" "out" "dev" "doc" ];

  nativeBuildInputs = [
    cmake
    unzip
  ];

  buildInputs = [
    boost
    giflib
    ilmbase
    libjpeg
    libpng
    libtiff
    opencolorio_1
    openexr
    robin-map
    fmt
  ];

  cmakeFlags = [
    "-DUSE_PYTHON=OFF"
    "-DUSE_QT=OFF"
    # GNUInstallDirs
    "-DCMAKE_INSTALL_LIBDIR=lib" # needs relative path for pkg-config
  ];

  postFixup = ''
    substituteInPlace $dev/lib/cmake/OpenImageIO/OpenImageIOTargets-*.cmake \
      --replace "\''${_IMPORT_PREFIX}/lib/lib" "$out/lib/lib"
  '';

  doCheck = true;
  checkInputs = [ python3 ];
  preCheck = ''
    patchShebangs ../testsuite
  '';

  meta = with lib; {
    homepage = "http://www.openimageio.org";
    description = "A library and tools for reading and writing images";
    license = licenses.bsd3;
    maintainers = with maintainers; [ goibhniu ];
    platforms = platforms.unix;
  };
}

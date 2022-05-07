{ lib, stdenv, fetchurl
# Image file formats
, libjpeg, libtiff, giflib, libpng, libwebp
# imlib2 can load images from ID3 tags.
, libid3tag, librsvg, libheif
, freetype , bzip2, pkg-config
, x11Support ? true, xlibsWrapper ? null
}:

let
  inherit (lib) optional;
in
stdenv.mkDerivation rec {
  pname = "imlib2";
  version = "1.9.0";

  src = fetchurl {
    url = "mirror://sourceforge/enlightenment/${pname}-${version}.tar.xz";
    sha256 = "5ac9e8ca7c6700919fe72749ad7243c42de4b22823c81769a1bf8e480e14c650";
  };

  buildInputs = [
    libjpeg libtiff giflib libpng libwebp
    bzip2 freetype libid3tag libheif
  ] ++ optional x11Support xlibsWrapper;

  nativeBuildInputs = [ pkg-config ];

  enableParallelBuilding = true;

  # Do not build amd64 assembly code on Darwin, because it fails to compile
  # with unknow directive errors
  configureFlags = optional stdenv.isDarwin "--enable-amd64=no"
    ++ optional (!x11Support) "--without-x";

  outputs = [ "bin" "out" "dev" ];

  meta = with lib; {
    description = "Image manipulation library";

    longDescription = ''
      This is the Imlib 2 library - a library that does image file loading and
      saving as well as rendering, manipulation, arbitrary polygon support, etc.
      It does ALL of these operations FAST. Imlib2 also tries to be highly
      intelligent about doing them, so writing naive programs can be done
      easily, without sacrificing speed.
    '';

    homepage = "https://docs.enlightenment.org/api/imlib2/html";
    changelog = "https://git.enlightenment.org/legacy/imlib2.git/plain/ChangeLog?h=v${version}";
    license = licenses.imlib2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ spwhitt ];
  };
}

{ lib, stdenv, fetchurl, unzip, darwin, libtiff
, libpng, zlib, libwebp, libraw, openexr, openjpeg
, libjpeg, jxrlib, pkgconfig, fetchpatch }:

# This has been partially adapted from https://src.fedoraproject.org/rpms/freeimage
stdenv.mkDerivation {
  name = "freeimage-3.18.0";

  src = fetchurl {
    url = "mirror://sourceforge/freeimage/FreeImage3180.zip";
    sha256 = "1z9qwi9mlq69d5jipr3v2jika2g0kszqdzilggm99nls5xl7j4zl";
  };

  patches = [
    # This patch unbundles the source code and removes the vendored dependencies, allowing us to use our own dependencies.
    # This is vital for fixing AArch64 support and also avoiding CVE-2019-12212 and CVE-2019-12214.
    (fetchpatch {
      name = "unbundle-libs.CVE-2019-12212.CVE-2019-12214.patch";
      url = "https://src.fedoraproject.org/rpms/freeimage/raw/ccc7d51ecdcf6443716fc39385b9ede53f20ebbf/f/FreeImage_unbundle.patch";
      sha256 = "02rm4zn9k50gfrc8nabmlwghnc09091lqb45pm82j05vfr5yx08r";
    })
    # This patch seems to fix doxygen support, but we don't build docs anyway
    #(fetchpatch {
    #  url = "https://src.fedoraproject.org/rpms/freeimage/raw/ccc7d51ecdcf6443716fc39385b9ede53f20ebbf/f/FreeImage_doxygen.patch";
    #  sha256 = "07q6q34dxh795gh2xw129wpykr7ji7f9d7i53j92dix62hd07x6v";
    #})
    # This patch seems to fix support for big-endian architectures
    (fetchpatch {
      name = "FreeImage_bigendian.patch";
      url = "https://src.fedoraproject.org/rpms/freeimage/raw/ccc7d51ecdcf6443716fc39385b9ede53f20ebbf/f/FreeImage_bigendian.patch";
      sha256 = "0a43sssw3xv6nryfk1hpfgrv756yypjabc7lyjrgn1g04lra56rp";
    })
    # This patch fixes https://nvd.nist.gov/vuln/detail/CVE-2019-12213, a bug in the TIFF handling code
    (fetchpatch {
      name = "CVE-2019-12211.CVE-2019-12213.patch";
      url = "https://src.fedoraproject.org/rpms/freeimage/raw/ccc7d51ecdcf6443716fc39385b9ede53f20ebbf/f/CVE-2019-12211_2019-12213.patch";
      sha256 = "1ilj4zm86wpb1igg5yzcrzsfkxlpqqfxslb46im591d80rx8pc68";
    })
    # I am not sure what this does, so it's not included, but if you have problems, try including it
    #(fetchpatch {
    # url = "https://src.fedoraproject.org/rpms/freeimage/raw/ccc7d51ecdcf6443716fc39385b9ede53f20ebbf/f/substream.patch";
    # sha256 = "0000000000000000000000000000000000000000000000000000";
    #})
  ] ++ lib.optional stdenv.isDarwin ./dylib.patch;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ unzip libtiff libpng zlib libwebp libraw openexr openjpeg libjpeg jxrlib ] ++ lib.optional stdenv.isDarwin darwin.cctools;

  prePatch = if stdenv.isDarwin then ''
    sed -e 's/$(shell xcrun -find clang)/clang/g' \
        -e 's/$(shell xcrun -find clang++)/clang++/g' \
        -e "s|PREFIX = /usr/local|PREFIX = $out|" \
        -e 's|-Wl,-syslibroot $(MACOSX_SYSROOT)||g' \
        -e 's|-isysroot $(MACOSX_SYSROOT)||g' \
        -e 's|	install -d -m 755 -o root -g wheel $(INCDIR) $(INSTALLDIR)||' \
        -e 's| -m 644 -o root -g wheel||g' \
        -e 's|INCLUDE +=|INCLUDE += $(shell pkg-config --cflags OpenEXR libopenjp2 libraw libpng libtiff-4 libwebp libwebpmux zlib libjxr)|g' \
        -e 's|LIBRARIES_I386 =|LIBS = $(shell pkg-config --libs libjpeg OpenEXR libopenjp2 libraw libpng libtiff-4 libwebp libwebpmux zlib libjxr)\nLIBRARIES_I386 = $(LIBS)|g' \
        -e 's|LIBRARIES_X86_64 =|LIBRARIES_X86_64 = $(LIBS)|g' \
        -i ./Makefile.osx
    # Fix LibJXR performance timers
    sed 's|^SRCS = \(.*\)$|SRCS = \1 Source/LibJXR/image/sys/perfTimerANSI.c|' -i ./Makefile.srcs
  '' else ''
    sed -e s@/usr/@$out/@ \
        -e 's@-o root -g root@@' \
        -e 's@ldconfig@echo not running ldconfig@' \
        -i Makefile.gnu Makefile.fip
  '';

  postPatch = ''
    rm -r Source/Lib/* Source/ZLib Source/OpenEXR
    > Source/FreeImage/PluginG3.cpp
    > Source/FreeImageToolkit/JPEGTransform.cpp
  '';

  preBuild = ''
    makeFlagsArray+=(CFLAGS="$(pkg-config --cflags libjxr)" LDFLAGS="$(pkg-config --libs libjxr)")
    sh gensrclist.sh
  '' + (if !stdenv.isDarwin then ''
    sh genfipsrclist.sh
  '' else "");

  postBuild = lib.optionalString (!stdenv.isDarwin) ''
    make -f Makefile.fip
  '';

  preInstall = ''
    mkdir -p $out/include $out/lib
  '';

  postInstall = lib.optionalString (!stdenv.isDarwin) ''
    make -f Makefile.fip install
  '' + lib.optionalString stdenv.isDarwin ''
    ln -s $out/lib/libfreeimage.3.dylib $out/lib/libfreeimage.dylib
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Open Source library for accessing popular graphics image file formats";
    homepage = "http://freeimage.sourceforge.net/";
    license = "GPL";
    maintainers = with lib.maintainers; [viric];
    platforms = with lib.platforms; unix;
  };
}

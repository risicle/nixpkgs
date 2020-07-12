{ stdenv, fetchurl, aflplusplus }:

stdenv.mkDerivation rec {
  pname = "libmaxminddb";
  version = "1.4.2";

  src = fetchurl {
    url = meta.homepage + "/releases/download/${version}/${pname}-${version}.tar.gz";
    sha256 = "0mnimbaxnnarlw7g1rh8lpxsyf7xnmzwcczcc3lxw8xyf6ljln6x";
  };

  meta = with stdenv.lib; {
    description = "C library for working with MaxMind geolocation DB files";
    homepage = https://github.com/maxmind/libmaxminddb;
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = [ maintainers.vcunat ];
  };
  AFL_HARDEN="1";
  AFL_LLVM_LAF_SPLIT_SWITCHES="1";
  AFL_LLVM_LAF_TRANSFORM_COMPARES="1";
  AFL_LLVM_LAF_SPLIT_COMPARES="1";
  AFL_LLVM_INSTRIM="1";
  AFL_LLVM_NOT_ZERO="1";
  preConfigure = ''
    export CC=${aflplusplus}/bin/afl-clang-fast
  '';
}

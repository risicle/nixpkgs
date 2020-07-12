{ stdenv, cmake, fetchurl, pkgconfig, jansson, zlib, aflplusplus }:

let
  version = "1.10.0";
in stdenv.mkDerivation {
  pname = "avro-c";
  inherit version;

  src = fetchurl {
    url = "mirror://apache/avro/avro-${version}/c/avro-c-${version}.tar.gz";
    sha256 = "07h56cgy7yivwal4cwcwkgzyv5yfa5pqlkypx5v63jkhqga87r9y";
  };

  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [ pkgconfig cmake ];

  buildInputs = [ jansson zlib ];

  enableParallelBuilding = true;

  AFL_HARDEN="1";
  AFL_LLVM_LAF_SPLIT_SWITCHES="1";
  AFL_LLVM_LAF_TRANSFORM_COMPARES="1";
  AFL_LLVM_LAF_SPLIT_COMPARES="1";
  AFL_LLVM_INSTRIM="1";
  AFL_LLVM_NOT_ZERO="1";
  preConfigure = ''
    export CC=${aflplusplus}/bin/afl-clang-fast
  '';

  meta = with stdenv.lib; {
    description = "A C library which implements parts of the Avro Specification";
    homepage = https://avro.apache.org/;
    license = licenses.asl20;
    maintainers = with maintainers; [ lblasc ];
    platforms = platforms.all;
  };
}

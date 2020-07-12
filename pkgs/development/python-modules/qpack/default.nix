{ stdenv, buildPythonPackage, fetchPypi, aflplusplus }:

buildPythonPackage rec {
  pname = "qpack";
  version = "0.0.18";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0c3inxjshwxpgjfkc1v2pwc0705sj2wdwp93905gs47vlvzva46y";
  };

  doCheck = false;

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

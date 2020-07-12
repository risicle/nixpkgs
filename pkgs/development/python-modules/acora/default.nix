{ buildPythonPackage, fetchPypi, cython , aflplusplus }:

buildPythonPackage rec {
  pname = "acora";
  version = "2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1yxjz8anfwx384mdfrcdzm68kna84710zbql2c4x4c7k9mf37b1m";
  };

  buildInputs = [ cython ];
  doCheck = false;

#   dontStrip = true;
#   NIX_CFLAGS_COMPILE = [ "-O1" ];
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

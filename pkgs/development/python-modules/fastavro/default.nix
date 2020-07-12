{ buildPythonPackage, fetchPypi, cython, pytz , aflplusplus }:

buildPythonPackage rec {
  pname = "fastavro";
  version = "0.23.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "193z13ncg67ns7mwbz9s06n1499rkd8zm5rg388birkrpds34a1f";
  };

  buildInputs = [ cython ];
  propagatedBuildInputs = [ pytz ];
  doCheck = false;

  dontStrip = true;
  NIX_CFLAGS_COMPILE = [ "-O1" ];
#   AFL_HARDEN="1";
#   AFL_LLVM_LAF_SPLIT_SWITCHES="1";
#   AFL_LLVM_LAF_TRANSFORM_COMPARES="1";
#   AFL_LLVM_LAF_SPLIT_COMPARES="1";
#   AFL_LLVM_INSTRIM="1";
#   AFL_LLVM_NOT_ZERO="1";
#   preConfigure = ''
#     export CC=${aflplusplus}/bin/afl-clang-fast
#   '';
}

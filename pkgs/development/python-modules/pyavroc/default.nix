{ buildPythonPackage, fetchPypi, avro-c , aflplusplus }:

buildPythonPackage rec {
  pname = "pyavroc";
  version = "0.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0l4gh8cgbxizi7m5i1brrd7j0v5q5j0yg13wiwnvyyhdwn4acy2p";
  };

  propagatedBuildInputs = [ avro-c ];
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

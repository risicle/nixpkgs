{ lib, fetchPypi, buildPythonPackage, aflplusplus }:

buildPythonPackage rec {
  pname = "pyahocorasick";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ch4bn769y9z3v228g2a6bycdnw2x0jphdlzsankr2bywhh1lhzr";
  };

#   checkPhase = "python test.py";
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

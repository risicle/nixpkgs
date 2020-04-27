{ stdenv, buildPythonPackage, fetchPypi, cython, setuptools_scm, aflplusplus }:

buildPythonPackage rec {
  pname = "Fuzzy";
  version = "1.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0f2giji97q7a9sb7lkis5kp9nh0dvl7vgz171drq7w9m09ihw93b";
  };

#   AFL_HARDEN="1";
#   AFL_LLVM_LAF_SPLIT_SWITCHES="1";
#   AFL_LLVM_LAF_TRANSFORM_COMPARES="1";
#   AFL_LLVM_LAF_SPLIT_COMPARES="1";
#   preConfigure = ''
#     export CC=${aflplusplus}/bin/afl-clang-fast
#   '';
  NIX_CFLAGS_COMPILE = "-O1";
  separateDebugInfo = true;

  buildInputs = [ cython setuptools_scm ];
  doCheck = false;
}

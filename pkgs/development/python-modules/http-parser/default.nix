{ stdenv
, buildPythonPackage
, fetchPypi
, cython
, aflplusplus
}:

buildPythonPackage rec {
  pname = "http-parser";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0896llw23zwmv1f4rg40927hznkg03d3jxd9ibwk0wi2qrbkl7a4";
  };

  AFL_HARDEN="1";
  AFL_LLVM_LAF_SPLIT_SWITCHES="1";
  AFL_LLVM_LAF_TRANSFORM_COMPARES="1";
  AFL_LLVM_LAF_SPLIT_COMPARES="1";
  preConfigure = ''
    export CC=${aflplusplus}/bin/afl-clang-fast
  '';

  buildInputs = [ cython ];

  doCheck = false;
}

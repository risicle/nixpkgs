{ stdenv
, buildPythonPackage
, fetchPypi
, aflplusplus
}:

buildPythonPackage rec {
  pname = "udatetime";
  version = "0.0.16";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09vlcskvaxnfk73l9w5xgl2ks9l62g1b24yrm0xxb7gn93qxglw2";
  };

  AFL_HARDEN="1";
  AFL_LLVM_LAF_SPLIT_SWITCHES="1";
  AFL_LLVM_LAF_TRANSFORM_COMPARES="1";
  AFL_LLVM_LAF_SPLIT_COMPARES="1";
  preConfigure = ''
    export CC=${aflplusplus}/bin/afl-clang-fast
  '';

  doCheck = false;
}

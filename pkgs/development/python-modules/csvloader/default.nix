{ stdenv, buildPythonPackage, fetchPypi, aflplusplus }:

buildPythonPackage rec {
  pname = "csvloader";
  version = "0.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0yjmfzj96jpmffamll3h2jdzil5pir9d4f406r5k0ivf9kmilrki";
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

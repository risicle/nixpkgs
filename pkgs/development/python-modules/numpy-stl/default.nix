{ lib, buildPythonPackage, fetchPypi, cython, numpy, nine, pytest, pytestrunner, python-utils, enum34, aflplusplus }:

buildPythonPackage rec {
  pname = "numpy-stl";
  version = "2.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f6b529b8a8112dfe456d4f7697c7aee0aca62be5a873879306afe4b26fca963c";
  };

  AFL_LLVM_LAF_SPLIT_SWITCHES="1";
  AFL_LLVM_LAF_TRANSFORM_COMPARES="1";
  AFL_LLVM_LAF_SPLIT_COMPARES="1";
  preConfigure = "export CC=${aflplusplus}/bin/afl-clang-fast";

  checkInputs = [ pytest pytestrunner ];

  checkPhase = "true";
#  doCheck = false;

  propagatedBuildInputs = [ cython numpy nine python-utils enum34 ];

  meta = with lib; {
    description = "Library to make reading, writing and modifying both binary and ascii STL files easy";
    homepage = "https://github.com/WoLpH/numpy-stl/";
    license = licenses.bsd3;
  };
}

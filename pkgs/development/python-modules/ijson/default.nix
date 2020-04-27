{ stdenv, buildPythonPackage, fetchPypi, yajl, cffi, aflplusplus }:

buildPythonPackage rec {
  pname = "ijson";
  version = "3.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1774vhabygdiq1avkir5nmavcxrr5npx5nnr6anxgh9zpdsf1rm1";
  };

  propagatedBuildInputs = [ yajl cffi ];

  doCheck = false; # something about yajl

  AFL_HARDEN="1";
  AFL_LLVM_LAF_SPLIT_SWITCHES="1";
  AFL_LLVM_LAF_TRANSFORM_COMPARES="1";
  AFL_LLVM_LAF_SPLIT_COMPARES="1";
  preConfigure = ''
    export CC=${aflplusplus}/bin/afl-clang-fast
  '';

  meta = with stdenv.lib; {
    description = "Iterative JSON parser with a standard Python iterator interface";
    homepage = "https://github.com/isagalaev/ijson";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rvl ];
  };
}

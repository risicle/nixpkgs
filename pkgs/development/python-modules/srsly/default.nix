{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, mock
, numpy
, pathlib
, pytest
, pytz
, cython
, aflplusplus
}:

buildPythonPackage rec {
  pname = "srsly";
#   version = "2.2.0";
# 
#   src = fetchPypi {
#     inherit pname version;
#     sha256 = "1h246zvh2wsqyjlw3a3bwmd1zwrkgpflk4z4i9k3sqp2j1jika54";
#   };
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gha1xfh64mapvgn0sghnjsvmjdrh5rywhs3j3bhkvwk42kf40ma";
  };

  buildInputs = [ cython ];
  propagatedBuildInputs = lib.optional (pythonOlder "3.4") pathlib;

#   dontStrip = true;
#   AFL_HARDEN="1";
#   AFL_LLVM_LAF_SPLIT_SWITCHES="1";
#   AFL_LLVM_LAF_TRANSFORM_COMPARES="1";
#   AFL_LLVM_LAF_SPLIT_COMPARES="1";
#   AFL_LLVM_INSTRIM="1";
#   AFL_LLVM_NOT_ZERO="1";
#   preConfigure = ''
#     export CC=${aflplusplus}/bin/afl-clang-fast
#   '';
#   NIX_CFLAGS_COMPILE="-I${stdenv.cc.cc}/include/c++/${stdenv.cc.cc.version} -I${stdenv.cc.cc}/include/c++/${stdenv.cc.cc.version}/${stdenv.targetPlatform.config}";

#   checkInputs = [
#     mock
#     numpy
#     pytest
#     pytz
#   ];

  # TypeError: cannot serialize '_io.BufferedRandom' object
  # Possibly because of sandbox restrictions.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Modern high-performance serialization utilities for Python";
    homepage = https://github.com/explosion/srsly;
    license = licenses.mit;
    maintainers = with maintainers; [ danieldk ];
  };
}

{ lib, buildPythonPackage, fetchPypi, pytest, pytestcov, setuptools_scm, aflplusplus }:

buildPythonPackage rec {
  pname = "cbor2";
  version = "5.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rhxsbn39xsrrkqzzwlcrap0nwvh2razlk8l4kxd9w2yxv89nxci";
  };

  nativeBuildInputs = [ setuptools_scm ];
  checkInputs = [ pytest pytestcov ];

  doCheck = false;
  checkPhase = "pytest";

  dontStrip = true;
  NIX_CFLAGS_COMPILE=["-O1"];

#   AFL_HARDEN="1";
#   AFL_LLVM_LAF_SPLIT_SWITCHES="1";
#   AFL_LLVM_LAF_TRANSFORM_COMPARES="1";
#   AFL_LLVM_LAF_SPLIT_COMPARES="1";
#   AFL_LLVM_INSTRIM="1";
#   AFL_LLVM_NOT_ZERO="1";
#   preConfigure = ''
#     export CC=${aflplusplus}/bin/afl-clang-fast
#   '';

  meta = with lib; {
    description = "Pure Python CBOR (de)serializer with extensive tag support";
    homepage = https://github.com/agronholm/cbor2;
    license = licenses.mit;
    maintainers = with maintainers; [ taneb ];
  };
}

{ stdenv
, buildPythonPackage
, fetchPypi
, cython
, aflplusplus
}:

buildPythonPackage rec {
  pname = "cymysql";
  version = "0.9.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1m0nwzqwqdzlfldnp1gwn8xnsni1n9y9l52zny86b8bkadnhr8mj";
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

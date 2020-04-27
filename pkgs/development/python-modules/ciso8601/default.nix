{ stdenv
, buildPythonPackage
, fetchPypi
, pytz
, aflplusplus
}:

buildPythonPackage rec {
  pname = "ciso8601";
  version = "2.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qp2b5yvszcc3vlilvz6kfn3ki3214326fv06mvwicaqc0v5pfxx";
  };

  AFL_HARDEN="1";
  AFL_LLVM_LAF_SPLIT_SWITCHES="1";
  AFL_LLVM_LAF_TRANSFORM_COMPARES="1";
  AFL_LLVM_LAF_SPLIT_COMPARES="1";
  preConfigure = ''
    export CC=${aflplusplus}/bin/afl-clang-fast
  '';

  propagatedBuildInputs = [ pytz ];
  doCheck = false;
}

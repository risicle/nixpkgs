{ stdenv
, buildPythonPackage
, fetchPypi
, aflplusplus
}:

buildPythonPackage rec {
  pname = "bsdiff4";
  version = "1.1.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ygz15ln61fidvf7rpx38cbbnpada8vmd82xzfws5i61ip2qxi57";
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

  doCheck = false;
}

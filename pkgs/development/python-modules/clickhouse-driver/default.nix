{ stdenv, buildPythonPackage, fetchFromGitHub, cython, pytz, tzlocal, aflplusplus }:

buildPythonPackage rec {
  pname = "clickhouse-driver";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "mymarilyn";
    repo = pname;
    rev = version;
    sha256 = "0xjp4cvdw28ak3qclns439zfrngpnj3abgr71hbs4d4w7vv48027";
#     sha256 = "0ad4pi890x90j6fx2hf5lgzfwy8wg892limdxkvvba191xbc8hcj"; # 0.1.4
  };

  buildInputs = [ cython ];
  propagatedBuildInputs = [ pytz tzlocal ];

  doCheck = false;

  dontStrip = true;
  NIX_CFLAGS_COMPILE = "-O1";

#   AFL_HARDEN="1";
#   AFL_LLVM_LAF_SPLIT_SWITCHES="1";
#   AFL_LLVM_LAF_TRANSFORM_COMPARES="1";
#   AFL_LLVM_LAF_SPLIT_COMPARES="1";
#   AFL_LLVM_INSTRIM="1";
#   AFL_LLVM_NOT_ZERO="1";
#   preConfigure = ''
#     export CC=${aflplusplus}/bin/afl-clang-fast
#   '';
}

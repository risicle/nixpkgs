{ lib, isPy3k, fetchPypi, fetchpatch, buildPythonPackage
, uvloop, postgresql, cython, aflplusplus }:

buildPythonPackage rec {
  pname = "asyncpg";
  version = "0.20.1";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c4mcjrdbvvq5crrfc3b9m221qb6pxp55yynijihgfnvvndz2jrr";
  };

  buildInputs = [ cython ];

  patches = [
    ./dummy-prepared-statement.patch
#     ./0001-Fix-possible-uninitalized-pointer-access-on-unexpect.patch
    ./0001-Fix-possible-uninitalized-pointer-access-on-unexpect-2.patch
  ];

  dontStrip = true;
  NIX_CFLAGS_COMPILE = [ "-O1" ];

#   AFL_HARDEN="1";
#   AFL_LLVM_LAF_SPLIT_SWITCHES="1";
#   AFL_LLVM_LAF_TRANSFORM_COMPARES="1";
#   AFL_LLVM_LAF_SPLIT_COMPARES="1";
#   AFL_LLVM_INSTRIM="1";
#   AFL_LLVM_NOT_ZERO="1";
#   preConfigure = ''
#     export CC=${aflplusplus}/bin/afl-clang-fast
#   '';

  postPatch = "rm asyncpg/protocol/*.c asyncpg/protocol/codecs/*.c";
#   postBuild = "false";

  doCheck = false;
  checkInputs = [
    uvloop
    postgresql
  ];

  meta = with lib; {
    homepage = https://github.com/MagicStack/asyncpg;
    description = "An asyncio PosgtreSQL driver";
    longDescription = ''
      Asyncpg is a database interface library designed specifically for
      PostgreSQL and Python/asyncio. asyncpg is an efficient, clean
      implementation of PostgreSQL server binary protocol for use with Python’s
      asyncio framework.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ eadwu ];
  };
}

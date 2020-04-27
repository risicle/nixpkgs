{ lib, buildPythonPackage, fetchPypi, freetds, cython, setuptools-git, aflplusplus }:

buildPythonPackage rec {
  pname = "pymssql";
  version = "2.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1yvs3azd8dkf40lybr9wvswvf4hbxn5ys9ypansmbbb328dyn09j";
  };

  buildInputs = [cython setuptools-git];
  propagatedBuildInputs = [freetds];

#   AFL_HARDEN="1";
#   AFL_LLVM_LAF_SPLIT_SWITCHES="1";
#   AFL_LLVM_LAF_TRANSFORM_COMPARES="1";
#   AFL_LLVM_LAF_SPLIT_COMPARES="1";
#   preConfigure = ''
#     export CC=${aflplusplus}/bin/afl-clang-fast
#   '';
  NIX_CFLAGS_COMPILE = "-O1";
  separateDebugInfo = true;

  # The tests require a running instance of SQLServer, so we skip them
  doCheck = false;

  meta = with lib; {
    homepage = http://pymssql.org/en/stable/;
    description = "A simple database interface for Python that builds on top
      of FreeTDS to provide a Python DB-API (PEP-249) interface to Microsoft
      SQL Server";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ mredaelli ];
  };
}

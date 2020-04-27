{ stdenv
, buildPythonPackage
, fetchPypi
, redis
, python
, aflplusplus
}:

buildPythonPackage rec {
  pname = "hiredis";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "aa59dd63bb3f736de4fc2d080114429d5d369dfb3265f771778e8349d67a97a4";
  };
  propagatedBuildInputs = [ redis ];

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
#   checkPhase = ''
#     ${python.interpreter} test.py
#   '';

  meta = with stdenv.lib; {
    description = "Wraps protocol parsing code in hiredis, speeds up parsing of multi bulk replies";
    homepage = "https://github.com/redis/hiredis-py";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmai ];
  };
}


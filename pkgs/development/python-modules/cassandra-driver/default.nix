{ stdenv, lib, buildPythonPackage, fetchPypi, python, pythonOlder
, cython
, eventlet
, futures
, libev
, mock
, nose
, pytest
, pytz
, pyyaml
, scales
, six
, sure
, aflplusplus
}:

buildPythonPackage rec {
  pname = "cassandra-driver";
  version = "3.20.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03nycyn5nd1pnrg6fffq3wcjqnw13lgja137zq5zszx68mc15wnl";
  };

  patches = [
#     ./ris-print-io-buffer.patch
#     ./ris-print-stream-id.patch
  ];

  nativeBuildInputs = [ cython ];
  buildInputs = [ libev ];
  propagatedBuildInputs = [ six ]
    ++ lib.optionals (pythonOlder "3.4") [ futures ];

  checkInputs = [ eventlet mock nose pytest pytz pyyaml sure ];

  doCheck = false;
  # ignore test files which try to do socket.getprotocolname('tcp')
  # as it fails in sandbox mode due to lack of a /etc/protocols file
  checkPhase = ''
    pytest tests/unit \
      --ignore=tests/unit/io/test_libevreactor.py \
      --ignore=tests/unit/io/test_eventletreactor.py \
      --ignore=tests/unit/io/test_asyncorereactor.py
  '';

  AFL_HARDEN="1";
  AFL_LLVM_LAF_SPLIT_SWITCHES="1";
  AFL_LLVM_LAF_TRANSFORM_COMPARES="1";
  AFL_LLVM_LAF_SPLIT_COMPARES="1";
  AFL_LLVM_INSTRIM="1";
  AFL_LLVM_NOT_ZERO="1";
  preConfigure = ''
    export CC=${aflplusplus}/bin/afl-clang-fast
  '';

  meta = with lib; {
    description = "A Python client driver for Apache Cassandra";
    homepage = "http://datastax.github.io/python-driver";
    license = licenses.asl20;
  };
}

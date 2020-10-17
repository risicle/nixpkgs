{ lib, buildPythonPackage, python, isPy3k, arrow-cpp, cmake, cython, futures, hypothesis, numpy, pandas, pytest, pkgconfig, setuptools_scm, six, aflplusplus, clang_9 }:

let
  _arrow-cpp = arrow-cpp.override { inherit python; };
#   aflplusplus = aflplusplus-nort;
in

buildPythonPackage rec {
  pname = "pyarrow";

  inherit (_arrow-cpp) version src;

  sourceRoot = "apache-arrow-${version}/python";

  nativeBuildInputs = [ cmake cython pkgconfig setuptools_scm ];
  propagatedBuildInputs = [ numpy six ] ++ lib.optionals (!isPy3k) [ futures ];
  checkInputs = [ hypothesis pandas pytest ];

  PYARROW_BUILD_TYPE = "release";
  PYARROW_WITH_PARQUET = true;
  PYARROW_CMAKE_OPTIONS = [
    "-DCMAKE_INSTALL_RPATH=${ARROW_HOME}/lib"

    # This doesn't use setup hook to call cmake so we need to workaround #54606
    # ourselves
    "-DCMAKE_POLICY_DEFAULT_CMP0025=NEW"

#      "-DCMAKE_CXX_CREATE_SHARED_LIBRARY='${clang_9}/bin/clang++ <CMAKE_SHARED_LIBRARY_CXX_FLAGS> <LANGUAGE_COMPILE_FLAGS> <LINK_FLAGS> <CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS> <SONAME_FLAG><TARGET_SONAME> -o <TARGET> <OBJECTS> <LINK_LIBRARIES>'"
#     "-DCMAKE_VERBOSE_MAKEFILE=1"
  ];

  dontUseCmakeConfigure = true;

  preBuild = ''
    export PYARROW_PARALLEL=$NIX_BUILD_CORES
  '';

  preCheck = ''
    rm pyarrow/tests/test_jvm.py
    rm pyarrow/tests/test_hdfs.py
    rm pyarrow/tests/test_cuda.py

    # fails: "ArrowNotImplementedError: Unsupported numpy type 22"
    substituteInPlace pyarrow/tests/test_feather.py --replace "test_timedelta_with_nulls" "_disabled"

    # runs out of memory on @grahamcofborg linux box
    substituteInPlace pyarrow/tests/test_feather.py --replace "test_large_dataframe" "_disabled"

    # probably broken on python2
    substituteInPlace pyarrow/tests/test_feather.py --replace "test_unicode_filename" "_disabled"

    # fails "error: [Errno 2] No such file or directory: 'test'" because
    # nix_run_setup invocation somehow manages to import deserialize_buffer.py
    # when it is not intended to be imported at all
    rm pyarrow/tests/deserialize_buffer.py
    substituteInPlace pyarrow/tests/test_feather.py --replace "test_deserialize_buffer_in_different_process" "_disabled"

    # Fails to bind a socket
    # "PermissionError: [Errno 1] Operation not permitted"
    substituteInPlace pyarrow/tests/test_ipc.py --replace "test_socket_" "_disabled"
  '';

  ARROW_HOME = _arrow-cpp;
  PARQUET_HOME = _arrow-cpp;

  doCheck = false;
  checkPhase = ''
    mv pyarrow/tests tests
    rm -rf pyarrow
    mkdir pyarrow
    mv tests pyarrow/tests
    pytest -v
  '';

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
#     export CXX=${aflplusplus}/bin/afl-clang-fast++
#   '';
  preConfigure = ''
    export CC=${clang_9}/bin/clang
    export CXX=${clang_9}/bin/clang++
  '';

  meta = with lib; {
    description = "A cross-language development platform for in-memory data";
    homepage = https://arrow.apache.org/;
    license = lib.licenses.asl20;
    platforms = platforms.unix;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}

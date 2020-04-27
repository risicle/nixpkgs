{ lib
, buildPythonPackage
, fetchPypi
, setuptools_scm
, cython
, numpy
, msgpack
, pytest
, python
, aflplusplus
}:

buildPythonPackage rec {
  pname = "numcodecs";
  version = "0.6.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ef4843d5db4d074e607e9b85156835c10d006afc10e175bda62ff5412fca6e4d";
  };

#   postPatch = ''
#     substituteInPlace setup.py \
#         --replace "('HAVE_SNAPPY'" "#('HAVE_SNAPPY'" \
#         --replace "blosc_sources += glob('c-blosc/internal-complibs/snappy" "#blosc_sources += glob('c-blosc/internal-complibs/snappy"
#   '';

#   AFL_HARDEN="1";
#   AFL_LLVM_LAF_SPLIT_SWITCHES="1";
#   AFL_LLVM_LAF_TRANSFORM_COMPARES="1";
#   AFL_LLVM_LAF_SPLIT_COMPARES="1";
#   preConfigure = ''
#     export CC=${aflplusplus}/bin/afl-clang-fast
#   '';
  NIX_CFLAGS_COMPILE = "-O1";
  separateDebugInfo = true;

  nativeBuildInputs = [
    setuptools_scm
    cython
  ];

  propagatedBuildInputs = [
    numpy
    msgpack
  ];

  doCheck = false;
  checkInputs = [
    pytest
  ];

  checkPhase = ''
    pytest $out/${python.sitePackages}/numcodecs -k "not test_backwards_compatibility"
  '';

  meta = with lib;{
    homepage = https://github.com/alimanfoo/numcodecs;
    license = licenses.mit;
    description = "Buffer compression and transformation codecs for use in data storage and communication applications";
    maintainers = [ maintainers.costrouc ];
  };
}

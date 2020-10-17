{ lib
, buildPythonPackage
, fetchPypi
, isPyPy
, nose
, toolz
, python
, fetchpatch
, aflplusplus
}:

buildPythonPackage rec {
  pname = "cytoolz";
  version = "0.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0p4a9nadsy1337gy2cnb5yanbn03j3zm6d9adyqad9bk3nlbpxc2";
  };

  AFL_HARDEN="1";
  AFL_LLVM_LAF_SPLIT_SWITCHES="1";
  AFL_LLVM_LAF_TRANSFORM_COMPARES="1";
  AFL_LLVM_LAF_SPLIT_COMPARES="1";
  AFL_LLVM_INSTRIM="1";
  AFL_LLVM_NOT_ZERO="1";
  preConfigure = ''
    export CC=${aflplusplus}/bin/afl-clang-fast
  '';
  doCheck = false;

  # Extension types
  disabled = isPyPy;

  checkInputs = [ nose ];
  propagatedBuildInputs = [ toolz ];

  # Failing test https://github.com/pytoolz/cytoolz/issues/122
  checkPhase = ''
    NOSE_EXCLUDE=test_introspect_builtin_modules nosetests -v $out/${python.sitePackages}
  '';

  meta = {
    homepage = https://github.com/pytoolz/cytoolz/;
    description = "Cython implementation of Toolz: High performance functional utilities";
    license = "licenses.bsd3";
    maintainers = with lib.maintainers; [ fridh ];
  };
}

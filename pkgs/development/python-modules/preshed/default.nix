{ stdenv
, buildPythonPackage
, fetchPypi
, murmurhash
, pytest
, cython
, cymem
, python
, aflplusplus
}:
buildPythonPackage rec {
  pname = "preshed";
  version = "3.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jrnci1pw9yv7j1a9b2q6c955l3gb8fv1q4d0id6s7bwr5l39mv1";
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
  NIX_CFLAGS_COMPILE="-I${stdenv.cc.cc}/include/c++/${stdenv.cc.cc.version} -I${stdenv.cc.cc}/include/c++/${stdenv.cc.cc.version}/${stdenv.targetPlatform.config}";
  doCheck = false;

  propagatedBuildInputs = [
   cython
   cymem
   murmurhash
  ];

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    ${python.interpreter} setup.py test
  '';
  
  meta = with stdenv.lib; {
    description = "Cython hash tables that assume keys are pre-hashed";
    homepage = https://github.com/explosion/preshed;
    license = licenses.mit;
    maintainers = with maintainers; [ sdll ];
    };
}

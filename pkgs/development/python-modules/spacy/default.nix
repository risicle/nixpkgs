{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytest
, preshed
, ftfy
, numpy
, murmurhash
, plac
, ujson
, dill
, requests
, thinc
, regex
, cymem
, pathlib
, msgpack
, msgpack-numpy
, jsonschema
, blis
, wasabi
, srsly
, catalogue
, setuptools
, aflplusplus
}:

buildPythonPackage rec {
  pname = "spacy";
  version = "2.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0shfjk6nhm6gzp5p88pz5k7bkg5dr3x9yvandkayqb2vsvkwj50x";
  };

  propagatedBuildInputs = [
   numpy
   murmurhash
   cymem
   preshed
   thinc
   plac
   ujson
   dill
   requests
   regex
   ftfy
   msgpack
   msgpack-numpy
   jsonschema
   blis
   wasabi
   srsly
   catalogue
   setuptools
  ] ++ lib.optional (pythonOlder "3.4") pathlib;

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

  checkInputs = [
    pytest
  ];

  doCheck = false;
  # checkPhase = ''
  #   ${python.interpreter} -m pytest spacy/tests --vectors --models --slow
  # '';

  meta = with lib; {
    description = "Industrial-strength Natural Language Processing (NLP) with Python and Cython";
    homepage = https://github.com/explosion/spaCy;
    license = licenses.mit;
    maintainers = with maintainers; [ danieldk sdll ];
    };
}

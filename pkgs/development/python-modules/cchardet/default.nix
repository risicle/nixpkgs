{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, python
, nose
, aflplusplus
}:

buildPythonPackage rec {
  pname = "cchardet";
  version = "2.1.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1cs6y59qhbal8fgbyjk2lpjykh8kfjhq16clfssylsddb4hgnsmp";
  };

#   checkInputs = [ nose ];
#   checkPhase = ''
#     ${python.interpreter} setup.py nosetests
#   '';

#   dontStrip = true;
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

  meta = {
    description = "High-speed universal character encoding detector";
    homepage = https://github.com/PyYoshi/cChardet;
    license = lib.licenses.mpl11;
    maintainers = with lib.maintainers; [ ivan ];
  };
}

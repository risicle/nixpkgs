{ stdenv, buildPythonPackage, fetchPypi, pkgs, pkgconfig, chardet, lxml, aflplusplus }:

let
  lxml' = lxml.overrideAttrs (oldAttrs: {
#     AFL_HARDEN="1";
    AFL_LLVM_LAF_SPLIT_SWITCHES="1";
    AFL_LLVM_LAF_TRANSFORM_COMPARES="1";
    AFL_LLVM_LAF_SPLIT_COMPARES="1";
    AFL_LLVM_INSTRIM="1";
    AFL_LLVM_NOT_ZERO="1";
    preConfigure = ''
        export CC=${aflplusplus}/bin/afl-clang-fast
    '';
    pythonImportsCheck = [];
  });
in
buildPythonPackage rec {
  pname = "html5-parser";
  version = "0.4.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "25fe8f6848cbc15187f6748c0695df32bcf1b37df6420b6a01b4ebe1ec1ed48f";
  };

  patches = [
    ./crash-on-forbidden.patch
  ];

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ chardet lxml' pkgs.libxml2 ];

  doCheck = false; # No such file or directory: 'run_tests.py'

  meta = with stdenv.lib; {
    description = "Fast C based HTML 5 parsing for python";
    homepage = https://html5-parser.readthedocs.io;
    license = licenses.asl20;
  };
#   dontStrip = true;
#   AFL_HARDEN="1";
  AFL_LLVM_LAF_SPLIT_SWITCHES="1";
  AFL_LLVM_LAF_TRANSFORM_COMPARES="1";
  AFL_LLVM_LAF_SPLIT_COMPARES="1";
  AFL_LLVM_INSTRIM="1";
  AFL_LLVM_NOT_ZERO="1";
  preConfigure = ''
    export CC=${aflplusplus}/bin/afl-clang-fast
  '';
}

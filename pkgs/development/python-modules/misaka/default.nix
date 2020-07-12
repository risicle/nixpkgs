{ lib, fetchPypi, buildPythonPackage, cffi, aflplusplus }:
buildPythonPackage rec {
  pname = "misaka";
  version = "2.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mzc29wwyhyardclj1vg2xsfdibg2lzb7f1azjcxi580ama55wv2";
  };

  patches = [ ./tag-names-strncasecmp.patch ];

  propagatedBuildInputs = [ cffi ];

  # The tests require write access to $out
  doCheck = false;

  meta = with lib; {
    description = "A CFFI binding for Hoedown, a markdown parsing library";
    homepage = "https://misaka.61924.nl";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
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

{ buildPythonPackage, lib, fetchPypi
, ipaddress
, mock
, nose
, libmaxminddb
, aflplusplus
}:

buildPythonPackage rec {
  version = "1.5.2";
  pname = "maxminddb";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0dk3bgcgizp29w4w1qnvqsi3vz8f86gsajbbk5lidc8yj0fi7knh";
  };

  buildInputs = [ libmaxminddb ];
  propagatedBuildInputs = [ ipaddress ];

  checkInputs = [ nose mock ];

  meta = with lib; {
    description = "Reader for the MaxMind DB format";
    homepage = "https://www.maxmind.com/en/home";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
  dontStrip = true;

  AFL_HARDEN="1";
  AFL_LLVM_LAF_SPLIT_SWITCHES="1";
  AFL_LLVM_LAF_TRANSFORM_COMPARES="1";
  AFL_LLVM_LAF_SPLIT_COMPARES="1";
  AFL_LLVM_INSTRIM="1";
  AFL_LLVM_NOT_ZERO="1";
  preConfigure = ''
    export CC=${aflplusplus}/bin/afl-clang-fast
  '';
}

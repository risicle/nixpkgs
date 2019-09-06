{ lib
, buildPythonPackage
, fetchPypi
, future
, numpy
, pandas
, progressbar2
, scipy
, pytest
}:

buildPythonPackage rec {
  pname = "pygam";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rli8w0fgfr6mxk5cx3n6i5zafi1j0abl2nslrrdxzmjm2p03bjw";
  };

  propagatedBuildInputs = [ future numpy pandas progressbar2 scipy ];
  checkInputs = [ pytest ];

  meta = with lib; {
    description = "A Python implementation of Generalized Additive Models";
    homepage = https://github.com/dswah/pyGAM;
    license = licenses.asl20; # Apache 2.0
  };
}

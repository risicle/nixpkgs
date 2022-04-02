{ lib
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "ovh";
  version = "1.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-IQzwu0gwfPNPOLQLCO99KL5Hu2094Y+acQBFXVGzHhU=";
  };

  propagatedBuildInputs = [
    requests
  ];

  # Needs yanc
  doCheck = false;

  meta = {
    description = "Thin wrapper around OVH's APIs";
    homepage = "https://github.com/ovh/python-ovh";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.makefu ];
  };
}

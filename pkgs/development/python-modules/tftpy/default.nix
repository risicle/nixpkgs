{ buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "tftpy";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1zjgamgm7d2p11w7k2yrc9avwaiqqgd53qhpay390mhj41j5y2f9";
  };

  propagatedBuildInputs = [];
  doCheck = false;
}

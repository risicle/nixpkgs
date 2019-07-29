{ stdenv
, buildPythonPackage
, fetchPypi
, lxml
, oath
, pycryptodome
, requests
}:

buildPythonPackage rec {
  pname = "python-vipaccess";
  version = "0.10.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1m6b7qipiaj6pz86kjhyq5m5jxxijpk58gpsdkj5bn0wjl6x1pg2";
  };

  propagatedBuildInputs = [
    lxml
    oath
    pycryptodome
    requests
  ];

  # requires a network connection
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A free software implementation of Symantec's VIP Access application and protocol";
    homepage = "https://github.com/dlenski/python-vipaccess";
    license = licenses.asl20;
    maintainers = with maintainers; [ aw ];
  };
}

{ lib, pkgs, buildPythonPackage, fetchPypi, cffi }:

buildPythonPackage rec {
  pname = "google-crc32c";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "lDm5YLbs2EdVdnXRMPw2Jtdiv1NdpZXCCmlJpwX7Pq4=";
  };

  buildInputs = [ pkgs.crc32c  ];
  propagatedBuildInputs = [ cffi ];

  preConfigure = ''
    export LDFLAGS="-L${pkgs.crc32c}/lib"
    export CFLAGS="-I${pkgs.crc32c}/include"
  '';

  meta = with lib; {
    homepage = "https://github.com/googleapis/python-crc32c";
    description = "Wrapper the google/crc32c hardware-based implementation of the CRC32C hashing algorithm";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ andir ];
  };
}

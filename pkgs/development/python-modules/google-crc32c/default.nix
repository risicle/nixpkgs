{ lib, pkgs, buildPythonPackage, fetchPypi, cffi, pytestCheckHook, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "google-crc32c";
  version = "1.0.0";

#  src = fetchPypi {
#    inherit pname version;
#    sha256 = "lDm5YLbs2EdVdnXRMPw2Jtdiv1NdpZXCCmlJpwX7Pq4=";
#  };
  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "python-crc32c";
    rev = "v${version}";
    sha256 = "0n3ggsxmk1fhq0kz6p5rcj4gypfb05i26fcn7lsawakgl7fzxqyl";
  };

  buildInputs = [ pkgs.crc32c  ];
  propagatedBuildInputs = [ cffi ];

#  preConfigure = ''
#    export LDFLAGS="-L${pkgs.crc32c}/lib"
#    export CFLAGS="-I${pkgs.crc32c}/include"
#  '';

  LDFLAGS="-L${pkgs.crc32c}/lib";
  CFLAGS="-I${pkgs.crc32c}/include";

  checkInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "google_crc32c" ];

  meta = with lib; {
    homepage = "https://github.com/googleapis/python-crc32c";
    description = "Wrapper the google/crc32c hardware-based implementation of the CRC32C hashing algorithm";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ andir ];
  };
}

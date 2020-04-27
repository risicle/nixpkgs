{ lib, buildPythonPackage, fetchPypi, future, lxml, aflplusplus }:

buildPythonPackage rec {
  pname = "pymavlink";
  version = "2.4.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ch9sca48y609bsf128flz5a4lvnayjd93aibz0kq7cxp8d1z0fb";
  };

  # disable crc checks
  postPatch = ''
    substituteInPlace mavnative/mavnative.c \
      --replace 'c != (rxmsg->checksum & 0xFF)' 'printf("First checksum byte: %d, not %d", c, rxmsg->checksum & 0xFF), 0' \
      --replace 'c != (rxmsg->checksum >> 8)' 'printf("Second checksum byte: %d, not %d", c, rxmsg->checksum >> 8), 0'
  '';

#   AFL_HARDEN="1";
#   AFL_LLVM_LAF_SPLIT_SWITCHES="1";
#   AFL_LLVM_LAF_TRANSFORM_COMPARES="1";
#   AFL_LLVM_LAF_SPLIT_COMPARES="1";
#   preConfigure = ''
#     export CC=${aflplusplus}/bin/afl-clang-fast
#   '';
  NIX_CFLAGS_COMPILE = "-O1";
  separateDebugInfo = true;

  propagatedBuildInputs = [ future lxml ];

  # No tests included in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "Python MAVLink interface and utilities";
    homepage = "https://github.com/ArduPilot/pymavlink";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ lopsided98 ];
  };
}

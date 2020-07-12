{ buildPythonPackage, fetchPypi, future, firebird, nose}:

buildPythonPackage rec {
  pname = "fdb";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1144sk0ccp3dqj28p5wbim8pbhfc8ysq9nvqsf0xgvc34l6g6pny";
  };

  postPatch = ''
    substituteInPlace fdb/ibase.py \
      --replace 'fb_library_name=None' 'fb_library_name="${firebird}/lib/libfbclient.so"'
    substituteInPlace fdb/fbcore.py \
      --replace 'fb_library_name=None' 'fb_library_name="${firebird}/lib/libfbclient.so"'
  '';

#   checkInputs = [ nose ];
  doCheck = false;
  propagatedBuildInputs = [ future ];
}

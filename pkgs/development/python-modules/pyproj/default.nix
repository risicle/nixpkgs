{ stdenv, buildPythonPackage, fetchPypi, python, nose2, proj ? null }:

buildPythonPackage (rec {
  pname = "pyproj";
  version = "1.9.5.1";
  name  = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1a1ymzplkj2ymiq0bfb3v94xkm75mbhrrw2bmzbgq7cazb459yjk";
  };

  buildInputs = [ nose2 ];

  checkPhase = ''
    runHook preCheck
    pushd unittest  # changing directory should ensure we're importing the global pyproj
    ${python.interpreter} test.py && ${python.interpreter} -c "import doctest, pyproj, sys; sys.exit(doctest.testmod(pyproj)[0])"
    popd
    runHook postCheck
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/jswhit/pyproj;
    description = "Python interface to PROJ.4 library";
    license = licenses.bsd2;
  };
} // (if proj == null then {} else { PROJ_DIR = proj; }))

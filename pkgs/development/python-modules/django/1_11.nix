{ stdenv, buildPythonPackage, fetchurl, substituteAll,
  python, pythonOlder,
  geos, gdal, pytz, mock, enum34, memcached, tblib, bcrypt, docutils, jinja2, numpy, pillow, pyyaml, pylibmc, sqlparse, glibcLocales
}:
buildPythonPackage rec {
  pname = "Django";
  name = "${pname}-${version}";
  version = "1.11.1";

  disabled = pythonOlder "2.7";

  src = fetchurl {
    url = "http://www.djangoproject.com/m/releases/1.11/${name}.tar.gz";
    sha256 = "131swdygapgrnkicvksqf904gkrfvljcrsqq8z82rvzf4bwgvkmv";
  };

  patches = [
    (substituteAll {
      src = ./1.10-gis-libs.template.patch;
      geos = geos;
      gdal = gdal;
    })
    ./1.11.1-admin-scripts-tests.patch
  ];

  # patch only $out/bin to avoid problems with starter templates (see #3134)
  postFixup = ''
    wrapPythonProgramsIn $out/bin "$out $pythonPath"
  '';

  checkInputs = [ mock enum34 memcached tblib bcrypt docutils jinja2 numpy pillow pyyaml pylibmc sqlparse glibcLocales ];
  propagatedBuildInputs = [ pytz ];

  # too complicated to setup
  #doCheck = false;

  checkPhase = ''
    runHook preCheck
    pushd tests
    LC_ALL="en_US.UTF-8" ${python.interpreter} runtests.py --parallel 1
    popd
    runHook postCheck
  '';

  meta = {
    description = "A high-level Python Web framework";
    homepage = https://www.djangoproject.com/;
  };
}

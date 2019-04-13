{ stdenv, buildPythonPackage, fetchPypi, isPy3k, fetchpatch
, cairocffi, cssselect2, defusedxml, pillow, tinycss2
, pytest, pytestrunner, pytestcov, pytest-flake8, pytest-isort }:

buildPythonPackage rec {
  pname = "CairoSVG";
  version = "2.3.0";

  disabled = !isPy3k;
  # We're not interested in code quality tests
  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "pytest-cov" "" \
      --replace "pytest-flake8" "" \
      --replace "pytest-isort" "" \
      --replace "--flake8" "" \
      --replace "--isort" ""
  '';


  src = fetchPypi {
    inherit pname version;
    sha256 = "66f333ef5dc79fdfbd3bbe98adc791b1f854e0461067d202fa7b15de66d517ec";
  };

  propagatedBuildInputs = [ cairocffi cssselect2 defusedxml pillow tinycss2 ];

  checkInputs = [ pytest pytestrunner ];

  meta = with stdenv.lib; {
    homepage = https://cairosvg.org;
    license = licenses.lgpl3;
    description = "SVG converter based on Cairo";
  };
}

{ lib
, fetchPypi
, django
, buildPythonPackage
, djangorestframework
, mock
, django-crispy-forms
, python
, fetchpatch
}:
buildPythonPackage rec {

  pname = "django-filter";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3dafb7d2810790498895c22a1f31b2375795910680ac9c1432821cbedb1e176d";
  };

  patches = [
    (fetchpatch {
      name = "fix-dst-test.patch";
      url = https://github.com/carltongibson/django-filter/commit/9c0b06610dbd5b69a006ae121d383ef49cc70fff.patch;
      sha256 = "0rrbqxjcwwkcldxi1q38cf2wcl9rgk7yyyc6rxwswi45r9sxihgb";
    })
  ];

  propagatedBuildInputs = [
    django
  ];
  checkInputs = [
    djangorestframework
    mock
    django-crispy-forms
  ];
  checkPhase = ''
    ${python.interpreter} runtests.py
  '';

  meta = with lib; {
    homepage = "https://github.com/carltongibson/django-filter/tree/master";
    license = licenses.bsdOriginal;
    description = "Django-filter is a reusable Django application for allowing users to filter querysets dynamically.";
    maintainers = with maintainers; [ BadDecisionsAlex ];
  };

}

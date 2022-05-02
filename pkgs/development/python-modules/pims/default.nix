{ lib
, buildPythonPackage
, fetchFromGitHub
, imageio
, numpy
, pytestCheckHook
, pythonOlder
, scikitimage
, slicerator
}:

buildPythonPackage rec {
  version = "0.5";
  pname = "PIMS";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a02cdcbb153e2792042fb0bae7df4f30878bbba1f2d176114a87ee0dc18715a0";
  };

  propagatedBuildInputs = [
    slicerator
    imageio
    numpy
  ];

  checkInputs = [
    pytestCheckHook
    scikitimage
  ];

  pythonImportsCheck = [
    "pims"
  ];

  disabledTests = [
    # NotImplementedError: Do not know how to deal with infinite readers
    "TestVideo_ImageIO"
  ];

  meta = with lib; {
    description = "Python Image Sequence: Load video and sequential images in many formats with a simple, consistent interface";
    homepage = "https://github.com/soft-matter/pims";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}

{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, cmake
, cython_3
, ninja
, oldest-supported-numpy
, pkg-config
, scikit-build
, setuptools
, wheel

# c library
, c-blosc2

# propagates
, msgpack
, ndindex
, numpy
, py-cpuinfo
, rich

# tests
, psutil
, pytestCheckHook
, torch
}:

buildPythonPackage rec {
  pname = "blosc2";
  version = "2.4.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Blosc";
    repo = "python-blosc2";
    rev = "refs/tags/v${version}";
    hash = "sha256-LgjZnE7vyq8otfX75nXXuqydjkg/TRS4zWl8BeCD+WQ=";
  };

  postPatch = ''
    substituteInPlace requirements-runtime.txt \
      --replace "pytest" ""
  '';

  nativeBuildInputs = [
    cmake
    cython_3
    ninja
    oldest-supported-numpy
    pkg-config
    scikit-build
    setuptools
    wheel
  ];

  buildInputs = [ c-blosc2 ];

  dontUseCmakeConfigure = true;
  env.CMAKE_ARGS = "-DUSE_SYSTEM_BLOSC2:BOOL=YES";

  propagatedBuildInputs = [
    msgpack
    ndindex
    numpy
    py-cpuinfo
    rich
  ];

  nativeCheckInputs = [
    psutil
    pytestCheckHook
    torch
  ];

  meta = with lib; {
    description = "Python wrapper for the extremely fast Blosc2 compression library";
    homepage = "https://github.com/Blosc/python-blosc2";
    changelog = "https://github.com/Blosc/python-blosc2/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ris ];
  };
}

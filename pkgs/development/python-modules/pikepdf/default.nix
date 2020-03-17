{ attrs
, buildPythonPackage
, defusedxml
, fetchPypi
, hypothesis
, isPy3k
, lxml
, pillow
, pybind11
, pytest
, pytest-helpers-namespace
, pytest-timeout
, pytest_xdist
, pytestrunner
, python-xmp-toolkit
, python3
, qpdf
, setuptools-scm-git-archive
, setuptools_scm
, stdenv
, aflplusplus
}:

buildPythonPackage rec {
  pname = "pikepdf";
  version = "1.8.1";
  disabled = ! isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "a57a295296820087e66a3c62569d288958f29d1a354701ace6639a7692cc3022";
  };

  buildInputs = [
    pybind11
    qpdf
  ];


#   AFL_HARDEN="1";
#   AFL_LLVM_LAF_SPLIT_SWITCHES="1";
#   AFL_LLVM_LAF_TRANSFORM_COMPARES="1";
#   AFL_LLVM_LAF_SPLIT_COMPARES="1";
#   preConfigure = ''
    #export CC=${aflplusplus}/bin/afl-clang-fast++
#     export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE --coverage -O1"
#     export NIX_CFLAGS_LINK="$NIX_CFLAGS_LINK --coverage -O1"
#   '';
#   outputs = ["out" "gcov"];

  nativeBuildInputs = [
    setuptools-scm-git-archive
    setuptools_scm
  ];

  doCheck = false;
  checkInputs = [
    attrs
    hypothesis
    pillow
    pytest
    pytest-helpers-namespace
    pytest-timeout
    pytest_xdist
    pytestrunner
    python-xmp-toolkit
  ];

  propagatedBuildInputs = [ defusedxml lxml ];

  postPatch = ''
    sed -i \
      -e 's/^pytest .*/pytest/g' \
      -e 's/^attrs .*/attrs/g' \
      -e 's/^hypothesis .*/hypothesis/g' \
      requirements/test.txt
  '';

  preBuild = ''
    HOME=$TMPDIR
  '';
#   postInstall = ''
#     mkdir -p $gcov
#     cp $(find . -name '*.gcno') --parents $gcov/
#   '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/pikepdf/pikepdf";
    description = "Read and write PDFs with Python, powered by qpdf";
    license = licenses.mpl20;
    maintainers = [ maintainers.kiwi ];
  };
}

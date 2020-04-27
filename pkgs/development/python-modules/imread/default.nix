{ stdenv
, buildPythonPackage
, fetchPypi
, nose
, pkgconfig
, libjpeg
, libpng
, libtiff
, libwebp
, numpy
, aflplusplus
}:

buildPythonPackage rec {
  pname = "python-imread";
  version = "0.7.0";

  src = fetchPypi {
    inherit version;
    pname = "imread";
    sha256 = "0yb0fmy6ilh5fvbk69wl2bzqgss2g0951668mx8z9yyj4jhr1z2y";
  };

#   AFL_HARDEN="1";
#   AFL_LLVM_LAF_SPLIT_SWITCHES="1";
#   AFL_LLVM_LAF_TRANSFORM_COMPARES="1";
#   AFL_LLVM_LAF_SPLIT_COMPARES="1";
#   preConfigure = ''
#     export CC=${aflplusplus}/bin/afl-clang-fast++
#   '';
  NIX_CFLAGS_COMPILE = "-O1";
  separateDebugInfo = true;

  doCheck = false;
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ nose libjpeg libpng libtiff libwebp ];
  propagatedBuildInputs = [ numpy ];

  meta = with stdenv.lib; {
    description = "Python package to load images as numpy arrays";
    homepage = https://imread.readthedocs.io/en/latest/;
    maintainers = with maintainers; [ luispedro ];
    license = licenses.mit;
    platforms = platforms.unix;
  };

}

{ stdenv
, buildPythonPackage
, fetchurl
, cython
, setuptools_scm
, aflplusplus
}:

buildPythonPackage rec {
  pname = "openstep-plist";
  version = "0.2.2";

#   src = fetchPypi {
#     inherit pname version;
#     format = "wheel";
#     sha256 = "8eec97777bfae3408a3f30500261f7e6a65912dc138526ea054f9ad98892e9d2";
#   };

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/be/27/545c816bcd9bf44c0ab5a406a93b7934ce21e7500b256a243c122c0fee62/openstep_plist-0.2.2.zip";
    sha256 = "0zf1bmisinmrkirm7n8psdwgfz6zxx4nifdvwfkby6c65qg7xphy";
  };

#   src = fetchFromGitHub {
#     owner = "fonttools";
#     repo = pname;
#     rev = "v${version}";
#     sha256 = "1zvfkj97ip6j529a00d3mn6wx8kzdffbrh3n4mf07wmhz5s3cv8z";
#     fetchSubmodules = true;
#   };

#   AFL_HARDEN="1";
#   AFL_LLVM_LAF_SPLIT_SWITCHES="1";
#   AFL_LLVM_LAF_TRANSFORM_COMPARES="1";
#   AFL_LLVM_LAF_SPLIT_COMPARES="1";
#   preConfigure = ''
#     export CC=${aflplusplus}/bin/afl-clang-fast
#   '';

  buildInputs = [ cython setuptools_scm ];
  doCheck = false;
}

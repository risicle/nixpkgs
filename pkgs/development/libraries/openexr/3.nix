{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, zlib
, cmake
, imath
}:

stdenv.mkDerivation rec {
  pname = "openexr";
  version = "3.1.3";

  outputs = [ "bin" "dev" "out" "doc" ];

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "openexr";
    rev = "v${version}";
    sha256 = "sha256-Bi6yTcZBWTsWWMm3A7FVYblvSXKLSkHmhGvpNYGiOzE=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2021-45942.patch";
      url = "https://github.com/AcademySoftwareFoundation/openexr/commit/db217f29dfb24f6b4b5100c24ac5e7490e1c57d0.patch";
      sha256 = "0n2lwwn82nfy7p30jncxihcm2iy83r9m7f7mf2rhasn17fdzb5af";
    })
  ];

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [ imath zlib ];

  meta = with lib; {
    description = "A high dynamic-range (HDR) image file format";
    homepage = "https://www.openexr.com/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ paperdigits ];
    platforms = platforms.all;
  };
}

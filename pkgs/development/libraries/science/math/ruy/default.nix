 { lib
, stdenv
, fetchFromGitHub
, cmake
, cpuinfo
, gtest
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ruy";
  version = "unstable-2023-03-23";

  src = fetchFromGitHub {
    owner = "google";
    repo = "ruy";
    rev = "363f252289fb7a1fba1703d99196524698cb884d";
    hash = "sha256-Sv2rfq3ghddpcJHn7Z2FTXpwKdzgJOiSGu6HhV6nXIQ=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ cpuinfo ];
  nativeCheckInputs = [ gtest ];

  cmakeFlags = [
    "-DRUY_FIND_CPUINFO=ON"
  ] ++ lib.optionals (!finalAttrs.finalPackage.doCheck) [
    "-DRUY_MINIMAL_BUILD=ON"
  ];

  doCheck = true;

  meta = {
    description = "A matrix multiplication library";
    homepage = "https://github.com/google/ruy";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ris ];
  };
})

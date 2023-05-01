{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cpuinfo";
  version = "unstable-2023-04-27";

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "cpuinfo";
    rev = "b16eacd5291c99dfcf88c9a0b575d577ea456753";
    hash = "sha256-z6cH1xh45ULD4c8hXv4gnR0Jzn4QbSDcwm5OM2kRF6w=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DCPUINFO_BUILD_BENCHMARKS=OFF"
  ] ++ lib.optionals (!finalAttrs.finalPackage.doCheck) [
    "-DCPUINFO_BUILD_UNIT_TESTS=OFF"
    "-DCPUINFO_BUILD_MOCK_TESTS=OFF"
  ];

  # attempts to download gtest - revisit when someone has the
  # appetite to fight that
  doCheck = false;

  meta = {
    description = "PyTorch's CPU INFOrmation library";
    homepage = "https://github.com/pytorch/cpuinfo";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ris ];
  };
})

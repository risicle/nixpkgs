{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "farmhash";
  version = "unstable-2019-05-13";

  src = fetchFromGitHub {
    owner = "google";
    repo = "farmhash";
    rev = "0d859a811870d10f53a594927d0d0b97573ad06d";
    hash = "sha256-J0AhHVOvPFT2SqvQ+evFiBoVfdHthZSBXzAhUepARfA=";
  };

  # fix building in c++17 mode
  # https://github.com/google/farmhash/issues/24
  postPatch = ''
    sed -i '/using namespace std/d' src/farmhash.cc
    sed -i -E 's/\bpair\b/std::pair/g' src/farmhash.cc
    sed -i -E 's/\bmake_pair\b/std::make_pair/g' src/farmhash.cc
  '';

  doCheck = true;

  meta = {
    description = "A family of hash functions, c++ implementation";
    homepage = "https://github.com/google/farmhash";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ris ];
  };
})

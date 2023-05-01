 { lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "neon2sse";
  version = "unstable-2023-01-31";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "ARM_NEON_2_x86_SSE";
    rev = "097a5ecacd527d5b5c3006e360fb9cb1c1c48a1f";
    hash = "sha256-G5J+O+YPG/ZyMxa5IlPnQPzcS83f22ao3FkrtBA6rp4=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Header library converting ARM NEON intrinsics to x86 SSE intrinsics";
    homepage = "https://github.com/intel/ARM_NEON_2_x86_SSE";
    license = lib.licenses.free;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ris ];
  };
})

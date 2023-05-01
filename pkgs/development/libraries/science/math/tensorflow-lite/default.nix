{ stdenv
, bash
, cmake
, abseil-cpp
, eigen
, ruy
, cpuinfo
, neon2sse
, farmhash
, fetchFromGitHub
, fetchFromGitLab
, fetchpatch
, fetchurl
, fetchzip
, flatbuffers
, lib
, zlib
}:
let
  eigen-src = fetchFromGitLab {
    owner = "libeigen";
    repo = "eigen";
    rev = "3bb6a48d8c171cf20b5f8e48bfb4e424fbd4f79e";
    hash = "sha256-k71DoEsx8JpC9AlQ0cCRI0fWMIWFBFL/Yscx+2iBtNM=";
  };

  xnnpack-src = fetchFromGitHub {
    owner = "google";
    repo = "xnnpack";
    rev = "e8f74a9763aa36559980a0c2f37f587794995622";
    hash = "sha256-+SvG24jtD6tk/b3lQdMkoqrlI6GoOkHuc6ILMMnPLdg=";
  };

  gemmlowp-src = fetchFromGitHub {
    owner = "google";
    repo = "gemmlowp";
    rev = "08e4bb339e34017a0835269d4a37c4ea04d15a69";
    hash = "sha256-0yhG+h2LOMcqOyL/HE5953puPAD1wjDscqh1qgsfDuE=";
  };

  abseil-cpp-src = fetchFromGitHub {
    owner = "abseil";
    repo = "abseil-cpp";
    rev = "273292d1cfc0a94a65082ee350509af1d113344d";
    hash = "sha256-cnvLcBaznltTHJ5FSTuHhsRMmsDbJ9gyvhrBOdul288=";
  };

  neon-2-sse-src = fetchFromGitHub {
    owner = "intel";
    repo = "ARM_NEON_2_x86_SSE";
    rev = "a15b489e1222b2087007546b4912e21293ea86ff";
    hash = "sha256-299ZptvdTmCnIuVVBkrpf5ZTxKPwgcGUob81tEI91F0=";
  };

  farmhash-src = fetchFromGitHub {
    owner = "google";
    repo = "farmhash";
    rev = "0d859a811870d10f53a594927d0d0b97573ad06d";
    hash = "sha256-J0AhHVOvPFT2SqvQ+evFiBoVfdHthZSBXzAhUepARfA=";
  };

  fft2d-src = fetchzip {
    url = "http://www.kurims.kyoto-u.ac.jp/~ooura/fft2d.tgz";
    hash = "sha256-cHP9EBhsjNvwXd9Xw6pabT/j95lWwGaxoeoKC2bGwYE=";
  };
#
#   fp16-src = fetchFromGitHub {
#     owner = "Maratyszcza";
#     repo = "FP16";
#     rev = "4dfe081cf6bcd15db339cf2680b9281b8451eeb3";
#     sha256 = "06a8dfl3a29r93nxpp6hpywsajz5d555n3sqd3i6krybb6swnvh7";
#   };

  ruy-src = fetchFromGitHub {
    owner = "google";
    repo = "ruy";
    rev = "841ea4172ba904fe3536789497f9565f2ef64129";
    hash = "sha256-KtduRl9HUxUhNdgm+M8nU55zwbt1P+QRRLoePFRwh9g=";
  };

  cpuinfo-src = fetchFromGitHub {
    owner = "pytorch";
    repo = "cpuinfo";
    rev = "5e63739504f0f8e18e941bd63b2d6d42536c7d90";
    hash = "sha256-5no9LkQIIOIidvhera5lIbnOUkcZQtW4nIUqXSLnWHA=";
  };

  clog-src = fetchFromGitHub {
    owner = "pytorch";
    repo = "cpuinfo";  # yes, i'm confused too
    rev = "4b5a76c4de21265ddba98fc8f259e136ad11411b";
    hash = "sha256-rFPARBV3DEkZ/RjBcrSoq286IzLOwBBizSsFEg9dpFQ=";
  };
in
stdenv.mkDerivation rec {
  pname = "tensorflow-lite";
  version = "2.11.1";

  src = fetchFromGitHub {
    owner = "tensorflow";
    repo = "tensorflow";
    rev = "v${version}";
    hash = "sha256-q59cUW6613byHk4LGl+sefO5czLSWxOrSyLbJ1pkNEY=";
  };

  patches = [
    # included from 2.12.0 onwards
#     (fetchpatch {
#       name = "system-farmhash.patch";
#       url = "https://github.com/tensorflow/tensorflow/commit/d8451a9048d09692994c40a6f9bc928e70ed79b5.patch";
#       stripLen = 2;
#       hash = "sha256-x2easHfKW7cXI9e5D2CfnarHJflQoNZknyaPYqTyBsk=";
#     })
  ];

  sourceRoot = "source/tensorflow/lite";

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    zlib
    flatbuffers
    abseil-cpp
    eigen
#     ruy
#     cpuinfo
#     farmhash
  ];

  preConfigure = ''
    export FFT2D_SRC_DIR=$(mktemp -d)
    cp -r ${fft2d-src}/* $FFT2D_SRC_DIR
    chmod -R +w $FFT2D_SRC_DIR

    export GEMMLOWP_SRC_DIR=$(mktemp -d)
    cp -r ${gemmlowp-src}/* $GEMMLOWP_SRC_DIR
    chmod -R +w $GEMMLOWP_SRC_DIR

    export XNNPACK_SRC_DIR=$(mktemp -d)
    cp -r ${xnnpack-src}/* $XNNPACK_SRC_DIR
    chmod -R +w $XNNPACK_SRC_DIR

    #export EIGEN_SRC_DIR=$(mktemp -d)
    #cp -r ${eigen-src}/* $EIGEN_SRC_DIR
    #chmod -R +w $EIGEN_SRC_DIR

    #export ABSEIL_CPP_SRC_DIR=$(mktemp -d)
    #cp -r ${abseil-cpp-src}/* $ABSEIL_CPP_SRC_DIR
    #chmod -R +w $ABSEIL_CPP_SRC_DIR

    export NEON_2_SSE_SRC_DIR=$(mktemp -d)
    cp -r ${neon-2-sse-src}/* $NEON_2_SSE_SRC_DIR
    chmod -R +w $NEON_2_SSE_SRC_DIR

    export FARMHASH_SRC_DIR=$(mktemp -d)
    cp -r ${farmhash-src}/* $FARMHASH_SRC_DIR
    chmod -R +w $FARMHASH_SRC_DIR

    export CPUINFO_SRC_DIR=$(mktemp -d)
    cp -r ${cpuinfo-src}/* $CPUINFO_SRC_DIR
    chmod -R +w $CPUINFO_SRC_DIR

    export RUY_SRC_DIR=$(mktemp -d)
    cp -r ${ruy-src}/* $RUY_SRC_DIR
    chmod -R +w $RUY_SRC_DIR

    export CLOG_SRC_DIR=$(mktemp -d)
    cp -r ${clog-src}/* $CLOG_SRC_DIR
    chmod -R +w $CLOG_SRC_DIR

    export cmakeFlagsArray=(
      '-DTFLITE_ENABLE_INSTALL=ON'
      '-DTFLITE_ENABLE_XNNPACK=OFF'
      '-DCMAKE_FIND_PACKAGE_PREFER_CONFIG=ON'
      '-DFlatbuffers_DIR=${flatbuffers}/lib/cmake/flatbuffers'
      '-Dabsl_DIR=${lib.getDev abseil-cpp}/lib/cmake/absl'
      '-DEigen3_DIR=${lib.getDev eigen}/share/eigen3/cmake'
      "-DFETCHCONTENT_SOURCE_DIR_FFT2D=$FFT2D_SRC_DIR"
      "-DFETCHCONTENT_SOURCE_DIR_GEMMLOWP=$GEMMLOWP_SRC_DIR"
      #"-DFETCHCONTENT_SOURCE_DIR_EIGEN=$EIGEN_SRC_DIR"
      #"-DFETCHCONTENT_SOURCE_DIR_ABSEIL-CPP=$ABSEIL_CPP_SRC_DIR"
      "-DFETCHCONTENT_SOURCE_DIR_NEON2SSE=$NEON_2_SSE_SRC_DIR"
      "-DFETCHCONTENT_SOURCE_DIR_FARMHASH=$FARMHASH_SRC_DIR"
      "-DFETCHCONTENT_SOURCE_DIR_CPUINFO=$CPUINFO_SRC_DIR"
      "-DFETCHCONTENT_SOURCE_DIR_RUY=$RUY_SRC_DIR"
      "-DFETCHCONTENT_SOURCE_DIR_CLOG=$CLOG_SRC_DIR"
    )
  '';

#   cmakeFlags = [
#     "-DTFLITE_ENABLE_INSTALL=ON"
# #     "-DCMAKE_FIND_PACKAGE_PREFER_CONFIG=ON"
# #     "-Dabsl_DIR=${lib.getDev abseil-cpp}/lib/cmake/absl"
# #     "-DEigen3_DIR=${lib.getDev eigen}/share/eigen3/cmake"
# #     "-DNEON_2_SSE_DIR=${lib.getDev neon2sse}/lib/cmake/NEON_2_SSE"
# #     "-Dcpuinfo_DIR=${lib.getDev cpuinfo}/share/cpuinfo"
# #     "-DSYSTEM_FARMHASH=ON"
#     "-DFETCHCONTENT_SOURCE_DIR_FFT2D=$FFT2D_SRC_DIR"
#     "-DFETCHCONTENT_SOURCE_DIR_GEMMLOWP=$GEMMLOWP_SRC_DIR"
#     "-DFETCHCONTENT_SOURCE_DIR_XNNPACK=$XNNPACK_SRC_DIR"
#     "-DFETCHCONTENT_SOURCE_DIR_EIGEN=$EIGEN_SRC_DIR"
#     "-DFETCHCONTENT_SOURCE_DIR_ABSEIL-CPP=$ABSEIL_CPP_SRC_DIR"
#   ];

#   postPatch = ''
#     substituteInPlace ./tensorflow/lite/tools/make/Makefile \
#       --replace /bin/bash ${bash}/bin/bash \
#       --replace /bin/sh ${bash}/bin/sh
#   '';
#
#   makefile = "tensorflow/lite/tools/make/Makefile";

#   preBuild =
#     let
#       includes =
#         lib.concatMapStringsSep
#           " "
#           (subdir: "-I $PWD/tensorflow/lite/tools/make/downloads/${subdir}")
#           [
#             "neon_2_sse"
#             "gemmlowp"
#             "absl"
#             "fp16/include"
#             "farmhash/src"
#             "ruy"
#             "cpuinfo"
#             "cpuinfo/src"
#             "cpuinfo/include"
#             "cpuinfo/deps/clog/include"
#             "eigen"
#           ];
#     in
#     ''
#       # enter the vendoring lair of doom
#
#       prefix="$PWD/tensorflow/lite/tools/make/downloads"
#
#       mkdir -p "$prefix"
#
#       tar xzf ${fft2d-src} -C "$prefix"
#
#       ln -s ${ruy-src} "$prefix/ruy"
#       ln -s ${gemmlowp-src} "$prefix/gemmlowp"
#       ln -s ${neon-2-sse-src} "$prefix/neon_2_sse"
#       ln -s ${farmhash-src} "$prefix/farmhash"
#       ln -s ${cpuinfo-src} "$prefix/cpuinfo"
#       ln -s ${fp16-src} "$prefix/fp16"
#       ln -s ${tflite-eigen} "$prefix/eigen"
#
#       # tensorflow lite is using the *source* of flatbuffers
#       ln -s ${flatbuffers.src} "$prefix/flatbuffers"
#
#       # tensorflow lite expects to compile abseil into `libtensorflow-lite.a`
#       ln -s ${abseil-cpp.src} "$prefix/absl"
#
#       # set CXXSTANDARD=c++17 here because abseil-cpp in nixpkgs is set as
#       # such and would be used in dependents like libedgetpu
#       buildFlagsArray+=(
#         INCLUDES="-I $PWD ${includes}"
#         CXXSTANDARD="-std=c++17"
#         TARGET_TOOLCHAIN_PREFIX=""
#         -j$NIX_BUILD_CORES
#         all)
#     '';

#   installPhase = ''
#     mkdir "$out"
#
#     # copy the static lib and binaries into the output dir
#     cp -r ./tensorflow/lite/tools/make/gen/linux_${stdenv.hostPlatform.uname.processor}/{bin,lib} "$out"
#
#     find ./tensorflow/lite -type f -name '*.h' | while read f; do
#       path="$out/include/''${f/.\//}"
#       install -D "$f" "$path"
#
#       # remove executable bit from headers
#       chmod -x "$path"
#     done
#   '';

  meta = with lib; {
    description = "An open source deep learning framework for on-device inference.";
    homepage = "https://www.tensorflow.org/lite";
    license = licenses.asl20;
    maintainers = with maintainers; [ cpcloud ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}

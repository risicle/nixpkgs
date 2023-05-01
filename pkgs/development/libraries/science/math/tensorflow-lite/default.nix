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
#   tflite-eigen = fetchFromGitLab {
#     owner = "libeigen";
#     repo = "eigen";
#     rev = "3d9051ea84a5089b277c88dac456b3b1576bfa7f";
#     sha256 = "1y3f2jvimb5i904f4n37h23cv2pkdlbz8656s0kga1y7c0p50wif";
#   };
#
  gemmlowp-src = fetchFromGitHub {
    owner = "google";
    repo = "gemmlowp";
    rev = "08e4bb339e34017a0835269d4a37c4ea04d15a69";
    sha256 = "sha256-0yhG+h2LOMcqOyL/HE5953puPAD1wjDscqh1qgsfDuE=";
  };
#
#   neon-2-sse-src = fetchFromGitHub {
#     owner = "intel";
#     repo = "ARM_NEON_2_x86_SSE";
#     rev = "1200fe90bb174a6224a525ee60148671a786a71f";
#     sha256 = "0fhxch711ck809dpq1myxz63jiiwfcnxvj45ww0kg8s0pqpn5kv6";
#   };
#
#   farmhash-src = fetchFromGitHub {
#     owner = "google";
#     repo = "farmhash";
#     rev = "816a4ae622e964763ca0862d9dbd19324a1eaf45";
#     sha256 = "1mqxsljq476n1hb8ilkrpb39yz3ip2hnc7rhzszz4sri8ma7qzp6";
#   };
#
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
#
#   ruy-src = fetchFromGitHub {
#     owner = "google";
#     repo = "ruy";
#     rev = "23633b37099b614a2f836ef012cafc8087fdb98c";
#     sha256 = "14k9hz6ss8qy8nsajk6lrq25f6qxrldxky31ijw0dpqnfnnswrx4";
#   };
#
#   cpuinfo-src = fetchFromGitHub {
#     owner = "pytorch";
#     repo = "cpuinfo";
#     rev = "5916273f79a21551890fd3d56fc5375a78d1598d";
#     sha256 = "0q6760xdxsg18acdv8vq3yrq7ksr7wsm8zbyan01zf2khnb6fw4x";
#   };
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
    (fetchpatch {
      name = "system-farmhash.patch";
      url = "https://github.com/tensorflow/tensorflow/commit/d8451a9048d09692994c40a6f9bc928e70ed79b5.patch";
      stripLen = 2;
      hash = "sha256-x2easHfKW7cXI9e5D2CfnarHJflQoNZknyaPYqTyBsk=";
    })
  ];

  sourceRoot = "source/tensorflow/lite";

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    zlib
    flatbuffers
    abseil-cpp
    eigen
    ruy
    cpuinfo
    farmhash
  ];

  cmakeFlags = [
    "-DTFLITE_ENABLE_INSTALL=ON"
    "-DCMAKE_FIND_PACKAGE_PREFER_CONFIG=ON"
    "-Dabsl_DIR=${lib.getDev abseil-cpp}/lib/cmake/absl"
    "-DEigen3_DIR=${lib.getDev eigen}/share/eigen3/cmake"
    "-DNEON_2_SSE_DIR=${lib.getDev neon2sse}/lib/cmake/NEON_2_SSE"
    "-DSYSTEM_FARMHASH=ON"
    "-DFETCHCONTENT_SOURCE_DIR_FFT2D=${fft2d-src}"
    "-DFETCHCONTENT_SOURCE_DIR_GEMMLOWP=${gemmlowp-src}"
  ];

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

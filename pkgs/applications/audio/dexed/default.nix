{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, libX11
, libXrandr
, libXinerama
, libXext
, libXcursor
, libhwy
, freetype
, alsa-lib
, libjack2
, Accelerate
, Cocoa
, WebKit
, MetalKit
, simd
, DiscRecording
, CoreAudioKit
}:

stdenv.mkDerivation rec {
  pname = "dexed";
  version = "unstable-2022-07-09";

  src = fetchFromGitHub {
    owner = "asb2m10";
    repo = "dexed";
    rev = "2c036316bcd512818aa9cc8129767ad9e0ec7132";
    fetchSubmodules = true;
    sha256 = "sha256-6buvA72YRlGjHWLPEZMr45lYYG6ZY+IWmylcHruX27g=";
  };

  patches = [
    ./sysex.patch
    ./hwy.patch
#     ./just-cflags.patch
  ];

  postPatch = let
    clapJuceExt = fetchFromGitHub {
      owner = "risicle";
      repo = "clap-juce-extensions";
      rev = "f5517ce429f96879e8e8d5ca6209c15f47500d22";
      sha256 = "sha256-WZE63vLuQZZqwY+gZOOIuPGYwBIGghA+6dSnhqTlTcw=";
    };
  in ''
    # needs special setup on Linux, dunno if it can work on Darwin
    # https://github.com/NixOS/nixpkgs/issues/19098
    sed -i -e '/juce::juce_recommended_lto_flags/d' Source/CMakeLists.txt

    #rm -rf libs/clap-juce-extensions
    #cp -r ${clapJuceExt} libs/clap-juce-extensions
    #chmod -R +rw libs/clap-juce-extensions
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

#   cmakeFlags = [
#     "-DCMAKE_BUILD_TYPE=Debug"
#   ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libX11
    libXext
    libXcursor
    libXinerama
    libXrandr
    freetype
    alsa-lib
    libjack2
    libhwy
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    Accelerate
    Cocoa
    WebKit
    MetalKit
    simd
    DiscRecording
    CoreAudioKit
  ];

  # JUCE insists on only dlopen'ing these
  NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isLinux (toString [
    "-lX11"
    "-lXext"
    "-lXcursor"
    "-lXinerama"
    "-lXrandr"
    "-ljack"
  ]);

  installPhase = let
    vst3Dir = if stdenv.hostPlatform.isDarwin then "$out/Library/Audio/Plug-Ins/VST3" else "$out/lib/vst3";
    # this one's a guess, don't know where ppl have agreed to put them yet
    clapDir = if stdenv.hostPlatform.isDarwin then "$out/Library/Audio/Plug-Ins/CLAP" else "$out/lib/clap";
    auDir = "$out/Library/Audio/Plug-Ins/Components";
  in ''
    runHook preInstall

  '' + (if stdenv.hostPlatform.isDarwin then ''
    mkdir -p $out/{Applications,bin}
    mv Source/Dexed_artefacts/Release/Standalone/Dexed.app $out/Applications/
    ln -s $out/{Applications/Dexed.app/Contents/MacOS,bin}/Dexed
  '' else ''
    install -Dm755 {Source/Dexed_artefacts/Release/Standalone,$out/bin}/Dexed
  '') + ''
    mkdir -p ${vst3Dir} ${clapDir}
    mv Source/Dexed_artefacts/Release/VST3/* ${vst3Dir}
    mv Source/Dexed_artefacts/Release/CLAP/* ${clapDir}
  '' + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p ${auDir}
    mv Source/Dexed_artefacts/Release/AU/* ${auDir}
  '' + ''

    runHook postInstall
  '';

  separateDebugInfo = true;
  env.NIX_ENFORCE_NO_NATIVE = "0";

  meta = with lib; {
    description = "DX7 FM multi platform/multi format plugin";
    mainProgram = "Dexed";
    homepage = "https://asb2m10.github.io/dexed";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ OPNA2608 ];
  };
}

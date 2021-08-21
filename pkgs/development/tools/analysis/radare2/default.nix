{ lib
, stdenv
, fetchFromGitHub
, buildPackages
, pkg-config
, libusb-compat-0_1
, readline
, libewf
, perl
, zlib
, openssl
, libuv
, file
, libzip
, xxHash
, gtk2
, vte
, gtkdialog
, python3
, ruby
, lua
, capstone
, useX11 ? false
, rubyBindings ? false
, pythonBindings ? false
, luaBindings ? false
}:

stdenv.mkDerivation rec {
  pname = "radare2";
  version = "5.4.0";

  src = fetchFromGitHub {
    owner = "radare";
    repo = "radare2";
    rev = version;
    sha256 = "170q44jjac96jhh6fs723nwyr8vig058larpg9yf3l2n94kwq499";
  };

  # replace build system's attempt to clone vector35 aarch64 disassembler
  # from github
  vector35ArchArm64Src = fetchFromGitHub {
    owner = "radareorg";
    repo = "vector35-arch-arm64";
    # no tags in repo. build system attempts to fetch latest in branch
    # named `radare2`, which is this revision at time of writing.
    rev = "5837915960c2ce862a77c99a374abfb7d18a8534";
    sha256 = "0vpfqvr2r0vbd7072iv1jp16j7ybgf320aksyxsi1dzywn631kvf";
  };
  postPatch = ''
    cp -r $vector35ArchArm64Src libr/asm/arch/arm/v35arm64/arch-arm64
    chmod -R +w libr/asm/arch/arm/v35arm64/arch-arm64
    substituteInPlace libr/asm/arch/arm/v35arm64/Makefile \
      --replace 'git clone' '#git clone' \
      --replace 'cd arch-arm64 && git' '#cd arch-arm64 && git'
  '';

  postInstall = ''
    install -D -m755 $src/binr/r2pm/r2pm $out/bin/r2pm
  '';

  WITHOUT_PULL = "1";
  makeFlags = [
    "GITTAP=${version}"
    "RANLIB=${stdenv.cc.bintools.bintools}/bin/${stdenv.cc.bintools.targetPrefix}ranlib"
  ];
  configureFlags = [
    "--with-sysmagic"
    "--with-syszip"
    "--with-sysxxhash"
    "--with-syscapstone"
    "--with-openssl"
  ];

  enableParallelBuilding = true;
  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    capstone
    file
    readline
    libusb-compat-0_1
    libewf
    perl
    zlib
    openssl
    libuv
  ] ++ lib.optional useX11 [ gtkdialog vte gtk2 ]
    ++ lib.optional rubyBindings [ ruby ]
    ++ lib.optional pythonBindings [ python3 ]
    ++ lib.optional luaBindings [ lua ];

  propagatedBuildInputs = [
    # radare2 exposes r_lib which depends on these libraries
    file # for its list of magic numbers (`libmagic`)
    libzip
    xxHash
  ];

  meta = {
    description = "unix-like reverse engineering framework and commandline tools";
    homepage = "http://radare.org/";
    # vector35 aarch64 disassembler is asl20
    license = with lib.licenses [ gpl2Plus asl20 ];
    maintainers = with lib.maintainers; [ raskin makefu mic92 ];
    platforms = with lib.platforms; linux;
  };
}

{ stdenv, fetchurl, afl, python2, zlib, pkgconfig, glib, perl
, texinfo, libuuid, flex, bison, pixman, autoconf
}:

with stdenv.lib;

let
  qemuName = "qemu-2.10.0";
  aflName = afl.name;
  cpuTargetMapping = {
    x86_64-linux = {
      name = "x86_64-linux-user";
      exe-name = "qemu-x86_64";
    };
    i686-linux = {
      name = "i386-linux-user";
      exe-name = "qemu-i386";
    };
    aarch64-linux = {
      name = "aarch64-linux-user";
      exe-name = "qemu-aarch64";
    };
  };
  cpuTarget = builtins.getAttr stdenv.hostPlatform.system cpuTargetMapping;
in
if builtins.hasAttr stdenv.hostPlatform.system cpuTargetMapping then stdenv.mkDerivation rec {
  name = "afl-${qemuName}";

  srcs = [
    (fetchurl {
      url = "http://wiki.qemu.org/download/${qemuName}.tar.bz2";
      sha256 = "0j3dfxzrzdp1w21k21fjvmakzc6lcha1rsclaicwqvbf63hkk7vy";
    })
    afl.src
  ];

  sourceRoot = qemuName;

  postUnpack = ''
    cp ${aflName}/types.h $sourceRoot/afl-types.h
    substitute ${aflName}/config.h $sourceRoot/afl-config.h \
      --replace "types.h" "afl-types.h"
    substitute ${aflName}/qemu_mode/patches/afl-qemu-cpu-inl.h $sourceRoot/afl-qemu-cpu-inl.h \
      --replace "../../config.h" "afl-config.h"
    substituteInPlace ${aflName}/qemu_mode/patches/cpu-exec.diff \
      --replace "../patches/afl-qemu-cpu-inl.h" "afl-qemu-cpu-inl.h"
  '';

  nativeBuildInputs = [
    python2 perl pkgconfig flex bison autoconf texinfo
  ];

  buildInputs = [
    zlib glib pixman libuuid
  ];

  enableParallelBuilding = true;

  patches = [
    # patches extracted from afl source
    "../${aflName}/qemu_mode/patches/cpu-exec.diff"
    "../${aflName}/qemu_mode/patches/elfload.diff"
    "../${aflName}/qemu_mode/patches/syscall.diff"
    # nix-specific patches to make installation more well-behaved
    ./qemu-patches/no-etc-install.patch
    ./qemu-patches/qemu-2.10.0-glibc-2.27.patch
  ];

  configureFlags =
    [ "--disable-system"
      "--enable-linux-user"
      "--disable-gtk"
      "--disable-sdl"
      "--disable-vnc"
      "--disable-kvm"
      "--target-list=${cpuTarget.name}"
      "--enable-pie"
      "--sysconfdir=/etc"
      "--localstatedir=/var"
    ];

  postInstall = ''
    ln -s $out/bin/${cpuTarget.exe-name} $out/bin/afl-qemu-trace
  '';

  meta = with stdenv.lib; {
    homepage = http://www.qemu.org/;
    description = "Fork of QEMU with AFL instrumentation support";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ thoughtpolice ris ];
  };
} else null

{ stdenv, fetchurl, python2, zlib, pkgconfig, glib, ncurses, perl
, attr, libcap, vde2, texinfo, libuuid, flex, bison, lzo, snappy
, libaio, libcap_ng, gnutls, pixman, autoconf
, writeText
}:

with stdenv.lib;

let
  n = "qemu-2.10.0";

  aflHeaderFile = writeText "afl-qemu-cpu-inl.h"
    (builtins.readFile ./qemu-patches/afl-qemu-cpu-inl.h);
  aflConfigFile = writeText "afl-config.h"
    (builtins.readFile ./qemu-patches/afl-config.h);
  aflTypesFile = writeText "afl-types.h"
    (builtins.readFile ./qemu-patches/afl-types.h);

  cpuTarget = if stdenv.hostPlatform.system == "x86_64-linux" then "x86_64-linux-user"
    else if stdenv.hostPlatform.system == "i686-linux" then "i386-linux-user"
    else throw "afl: no support for ${stdenv.hostPlatform.system}!";
in
stdenv.mkDerivation rec {
  name = "afl-${n}";

  src = fetchurl {
    url = "http://wiki.qemu.org/download/${n}.tar.bz2";
    sha256 = "0j3dfxzrzdp1w21k21fjvmakzc6lcha1rsclaicwqvbf63hkk7vy";
  };

  buildInputs =
    [ python2 zlib pkgconfig glib pixman ncurses perl attr libcap
      vde2 texinfo libuuid flex bison lzo snappy autoconf
      libcap_ng gnutls
    ]
    ++ optionals (hasSuffix "linux" stdenv.hostPlatform.system) [ libaio ];

  enableParallelBuilding = true;

  patches = [
    # patches extracted from afl source
    ./qemu-patches/elfload.patch
    ./qemu-patches/cpu-exec.patch
    ./qemu-patches/syscall.patch
    # nix-specific patches to make installation more well-behaved
    ./qemu-patches/no-etc-install.patch
    ./qemu-patches/qemu-2.10.0-glibc-2.27.patch
  ];

  preConfigure = ''
    cp ${aflTypesFile}  afl-types.h
    cp ${aflConfigFile} afl-config.h
    cp ${aflHeaderFile} afl-qemu-cpu-inl.h
  '';

  configureFlags =
    [ "--disable-system"
      "--enable-linux-user"
      "--disable-gtk"
      "--disable-sdl"
      "--disable-vnc"
      "--target-list=${cpuTarget}"
      "--enable-pie"
      "--enable-kvm"
      "--sysconfdir=/etc"
      "--localstatedir=/var"
    ];

  meta = with stdenv.lib; {
    homepage = http://www.qemu.org/;
    description = "Fork of QEMU with AFL instrumentation support";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ thoughtpolice ];
    platforms = platforms.linux;
  };
}

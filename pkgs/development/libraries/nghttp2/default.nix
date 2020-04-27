{ stdenv, fetchurl, pkgconfig

# Optional Dependencies
, openssl ? null, zlib ? null
, enableLibEv ? !stdenv.hostPlatform.isWindows, libev ? null
, enableCAres ? !stdenv.hostPlatform.isWindows, c-ares ? null
, enableHpack ? false, jansson ? null
, enableAsioLib ? false, boost ? null
, enableGetAssets ? false, libxml2 ? null
, enableJemalloc ? false, jemalloc ? null
, enableApp ? !stdenv.hostPlatform.isWindows
, enablePython ? false, python ? null, cython ? null, ncurses ? null, setuptools ? null, aflplusplus
}:

assert enableHpack -> jansson != null;
assert enableAsioLib -> boost != null;
assert enableGetAssets -> libxml2 != null;
assert enableJemalloc -> jemalloc != null;

let inherit (stdenv.lib) optional optionals; in

stdenv.mkDerivation (rec {
  pname = "nghttp2";
  version = "1.40.0";

  src = fetchurl {
    url = "https://github.com/${pname}/${pname}/releases/download/v${version}/${pname}-${version}.tar.bz2";
    sha256 = "0kyrgd4s2pq51ps5z385kw1hn62m8qp7c4h6im0g4ibrf89qwxc2";
  };

  outputs = [ "bin" "out" "dev" "lib" ];

  nativeBuildInputs = [ pkgconfig ];# ++ optional enablePython cython;
  buildInputs = [ openssl ]
    ++ optional enableLibEv libev
    ++ [ zlib ]
    ++ optional enableCAres c-ares
    ++ optional enableHpack jansson
    ++ optional enableAsioLib boost
    ++ optional enableGetAssets libxml2
    ++ optional enableJemalloc jemalloc
    ++ optionals enablePython [ python ncurses setuptools ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-spdylay=no"
    "--disable-examples"
  ] ++ optional (!enablePython) "--disable-python-bindings"
  ++ [
    (stdenv.lib.enableFeature enableApp "app")
  ] ++ optional enableAsioLib "--enable-asio-lib --with-boost-libdir=${boost}/lib"
  ++ optional enablePython "--with-cython=${cython}/bin/cython";

#   buildPhase = "false";
  #doCheck = true;  # requires CUnit ; currently failing at test_util_localtime_date in util_test.cc

  meta = with stdenv.lib; {
    homepage = https://nghttp2.org/;
    description = "A C implementation of HTTP/2";
    license = licenses.mit;
    platforms = platforms.all;
  };
} // (if enablePython then {
  outputs = [ "bin" "out" "dev" "lib" "python" ];
  preInstall = ''
    mkdir -p $out/${python.sitePackages}
    export PYTHONPATH="$PYTHONPATH:$out/${python.sitePackages}"
  '';
  postInstall = ''
    mkdir -p $python/${python.sitePackages}
    mv $out/${python.sitePackages}/* $python/${python.sitePackages}
  '';

#   AFL_HARDEN="1";
#   AFL_LLVM_LAF_SPLIT_SWITCHES="1";
#   AFL_LLVM_LAF_TRANSFORM_COMPARES="1";
#   AFL_LLVM_LAF_SPLIT_COMPARES="1";
#   preConfigure = ''
#     export CC=${aflplusplus}/bin/afl-clang-fast
#     export CXX=${aflplusplus}/bin/afl-clang-fast++
#   '';
} else {}))

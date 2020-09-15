{ stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, argtable
, catch2
, curl
, doxygen
, hiredis
, jsoncpp
, libmicrohttpd
, pkgconfig
}:

stdenv.mkDerivation rec {
  pname = "libjson-rpc-cpp";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "cinemast";
    repo = "libjson-rpc-cpp";
    sha256 = "1p5kb2dij1ycimkpx6n097y83imj1vlhss1r5vq9lcjzm65a81hh";
    rev = "v${version}";
  };

  patches = [
    ./microhttpd-mhd-result.patch
  ];

  NIX_CFLAGS_COMPILE = "-I${catch2}/include/catch2";

  postPatch = ''
    for f in cmake/FindArgtable.cmake \
             src/stubgenerator/stubgenerator.cpp \
             src/stubgenerator/stubgeneratorfactory.cpp
    do
      sed -i -re 's/argtable2/argtable3/g' $f
    done

    sed -i -re 's#MATCHES "jsoncpp"#MATCHES ".*/jsoncpp/json$"#g' cmake/FindJsoncpp.cmake
  '';

  configurePhase = ''
    mkdir -p Build/Install
    pushd Build

    cmake .. -DCMAKE_INSTALL_PREFIX=$(pwd)/Install \
             -DCMAKE_BUILD_TYPE=Release
  '';

  installPhase = ''
    mkdir -p $out

    function fixRunPath {
      p=$(patchelf --print-rpath $1)
      q="$p:${stdenv.lib.makeLibraryPath [ jsoncpp argtable libmicrohttpd curl ]}:$out/lib"
      patchelf --set-rpath $q $1
    }

    make install

    sed -i -re "s#-([LI]).*/Build/Install(.*)#-\1$out\2#g" Install/lib*/pkgconfig/*.pc
    for f in Install/lib/*.so* $(find Install/bin -executable -type f); do
      fixRunPath $f
    done

    cp -r Install/* $out
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    cmake
    argtable
    catch2
    curl
    doxygen
    hiredis
    jsoncpp
    libmicrohttpd
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "C++ framework for json-rpc (json remote procedure call)";
    homepage = "https://github.com/cinemast/libjson-rpc-cpp";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}

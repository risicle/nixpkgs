{ lib, stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "gocd-server";
  version = "19.11.0";
  rev = "10687";

  src = fetchurl {
    url = "https://download.go.cd/binaries/${version}-${rev}/generic/go-server-${version}-${rev}.zip";
    sha256 = "sha256-2qWbcYJir0fGvhs68d33lyUlBm1YmmYjSIKP7bK0WRs=";
  };

  meta = with lib; {
    description = "A continuous delivery server specializing in advanced workflow modeling and visualization";
    homepage = "http://www.go.cd";
    license = licenses.asl20;
    platforms = platforms.all;
    sourceProvenance = with sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    maintainers = with maintainers; [ grahamc swarren83 ];
  };

  nativeBuildInputs = [ unzip ];

  buildCommand = "
    unzip $src -d $out
    mv $out/go-server-${version} $out/go-server
    mkdir -p $out/go-server/conf
  ";
}

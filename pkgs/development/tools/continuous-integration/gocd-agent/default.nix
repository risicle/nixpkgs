{ lib, stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "gocd-agent";
  version = "19.11.0";
  rev = "10687";

  src = fetchurl {
    url = "https://download.go.cd/binaries/${version}-${rev}/generic/go-agent-${version}-${rev}.zip";
    sha256 = "sha256-qxNgHl2RSslyWzO39hAv0HyGwI4UVkQ4F8HrjPEYERI=";
  };
  meta = with lib; {
    description = "A continuous delivery server specializing in advanced workflow modeling and visualization";
    homepage = "http://www.go.cd";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ grahamc swarren83 ];
  };

  nativeBuildInputs = [ unzip ];

  buildCommand = "
    unzip $src -d $out
    mv $out/go-agent-${version} $out/go-agent
  ";
}

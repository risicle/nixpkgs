{  buildGoPackage, fetchFromGitHub, lib, fetchpatch, fetchurl }:

with lib;

buildGoPackage rec {
  pname   = "nats-server";
  version = "2.6.0";

  goPackagePath = "github.com/nats-io/${pname}";

  src = fetchFromGitHub {
    rev    = "v${version}";
    owner  = "nats-io";
    repo   = pname;
    sha256 = "sha256-DggzXYPyu0dQ40L98VzxgN9S/35vLJJow9UjDtMz9rY=";
  };

  patches = [
    #./2.6.0-CVE-2022-24450.patch
    ./2.6.0-CVE-2022-26652.patch
  ];

  postPatch = let
    stream-tar-s2 = fetchurl {
      url = "https://github.com/nats-io/nats-server/raw/b4128693ed61aa0c32179af07677bcf1d8301dcd/test/configs/jetstream/restore_bad_stream/stream.tar.s2";
      sha256 = "04y5vhazhyk354g0b2ymqfw42fmaalzqy6zacnd7c5z6a5v243jn";
    };
  in ''
    cp ${stream-tar-s2} test/configs/jetstream/restore_bad_stream/stream.tar.s2
  '';

  doCheck = true;
  checkPhase = ''
    go test -run TestJetStreamRestoreBadStream ./...
  '';

  meta = {
    description = "High-Performance server for NATS";
    license = licenses.asl20;
    maintainers = [ maintainers.swdunlop ];
    homepage = "https://nats.io/";
  };
}

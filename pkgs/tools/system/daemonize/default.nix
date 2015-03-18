{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name    = "daemonize-${version}";
  version = "1.7.5";

  src = fetchurl {
    url    = "https://github.com/bmc/daemonize/archive/release-${version}.tar.gz";
    sha256 = "616220b8dc5721d93bd45e63b2617dbe07cd10a572da505405d64f640b98a06b";
  };

  meta = with stdenv.lib; {
    description = "Runs a command as a Unix daemon";
    homepage    = http://software.clapper.org/daemonize/;
    license     = licenses.bsd3;
  };
}

# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, HTTP }:

cabal.mkDerivation (self: {
  pname = "js-flot";
  version = "0.8.3";
  sha256 = "0yjyzqh3qzhy5h3nql1fckw0gcfb0f4wj9pm85nafpfqp2kg58hv";
  testDepends = [ HTTP ];
  meta = {
    homepage = "https://github.com/ndmitchell/js-flot#readme";
    description = "Obtain minified flot code";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})

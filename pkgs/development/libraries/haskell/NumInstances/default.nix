# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal }:

cabal.mkDerivation (self: {
  pname = "NumInstances";
  version = "1.4";
  sha256 = "0ycnwn09izajv330l7a31mc0alifqmxjsn9qmfswwnbg6i4jmnyb";
  meta = {
    homepage = "https://github.com/conal/NumInstances";
    description = "Instances of numeric classes for functions and tuples";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})

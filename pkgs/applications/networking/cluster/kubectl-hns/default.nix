{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubectl-hns";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "hierarchical-namespaces";
    rev = "v${version}";
    sha256 = "sha256-OEncaNkl46QDnptcmeMvIXHQSrepgWMPKZvll0EcOJQ=";
  };

  vendorSha256 = null;

  subPackages = [ "cmd/kubectl" ];

  postInstall = ''
    mv $out/bin/kubectl $out/bin/kubectl-hns
  '';

  meta = with lib; {
    description = "kubectl plugin for hierarchical namespaces";
    homepage = "https://github.com/kubernetes-sigs/hierarchical-namespaces";
  };
}

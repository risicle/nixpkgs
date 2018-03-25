{ stdenv, fetchFromGitHub, makeWrapper, jq, awscli }:

stdenv.mkDerivation rec {
  version = "unofficial-2018-03-02";
  name = "aws-auth-${version}";

  src = fetchFromGitHub {
    owner = "alphagov";
    repo = "aws-auth";
    rev = "260448659dfd1baec56691cd280b074da99be7ad";
    sha256 = "1dnh7g0swdfhby7l96kz6dkybp2bzp4k20qx6ni9ay65vx9s19fv";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  # copy script and set $PATH
  installPhase = ''
    install -D $src/aws-auth.sh $out/bin/aws-auth
    wrapProgram $out/bin/aws-auth \
      --prefix PATH : ${stdenv.lib.makeBinPath [ awscli jq ]}
  '';

  meta = {
    homepage = https://github.com/alphagov/aws-auth;
    description = "AWS authentication wrapper to handle MFA and IAM roles";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ ris ];
  };
}

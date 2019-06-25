{ stdenv, python3, fetchFromGitHub }:

let
  inherit (python3.pkgs) buildPythonApplication pytest mock pexpect;
in
buildPythonApplication rec {
  pname = "lesspass";
  version = "8.0.1";

  src = fetchFromGitHub {
    owner = "lesspass";
    repo = "lesspass";
    rev = version;
    sha256 = "0y4kb2lrqls6f89bgm98gjrikmkmxsr5dhcay9dk6kkc1wkndr18";
  };
  sourceRoot = "source/cli";

  # some tests are designed to run against code in the source directory - adapt to run against
  # *installed* code
  postPatch = ''
    for f in tests/test_functional.py tests/test_interaction.py ; do
      substituteInPlace $f --replace "lesspass/core.py" "-m lesspass.core"
    done
  '';

  checkInputs = [ pytest mock pexpect ];
  checkPhase = ''
    mv lesspass lesspass.hidden  # ensure we're testing against *installed* package
    pytest tests
  '';

  meta = with stdenv.lib; {
    description = "Stateless password manager";
    homepage = https://github.com/lesspass/lesspass;
    maintainers = with maintainers; [ jasoncarr ];
    license = licenses.gpl3;
  };
}

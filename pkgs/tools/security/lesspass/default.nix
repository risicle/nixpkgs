{ stdenv, python3 }:

let
  inherit (python3.pkgs) buildPythonApplication fetchPypi;
in
buildPythonApplication rec {
  pname = "lesspass";
  version = "8.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "034qvn1isv27chyyqqsh125isyv18yiny17xfmlw259rwg3851pq";
  };

  meta = with stdenv.lib; {
    description = "Stateless password manager";
    homepage = https://github.com/lesspass/lesspass;
    maintainers = with maintainers; [ jasoncarr ];
    license = licenses.gpl3;
  };
}

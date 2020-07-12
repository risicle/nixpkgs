{ buildPythonPackage, fetchPypi
, pyasn1, pyasn1-modules, pytest
, openldap, cyrus_sasl, stdenv, aflplusplus }:

buildPythonPackage rec {
  pname = "python-ldap";
  version = "3.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13nvrhp85yr0jyxixcjj012iw8l9wynxxlykm9j3alss6waln73x";
  };

  propagatedBuildInputs = [ pyasn1 pyasn1-modules ];

  buildInputs = [ openldap cyrus_sasl ];

  checkInputs = [ pytest ];

  checkPhase = ''
    # Needed by tests to setup a mockup ldap server.
    export BIN="${openldap}/bin"
    export SBIN="${openldap}/bin"
    export SLAPD="${openldap}/libexec/slapd"
    export SCHEMA="${openldap}/etc/schema"

    py.test
  '';

  doCheck = !stdenv.isDarwin;

  meta = with stdenv.lib; {
    description = "Python modules for implementing LDAP clients";
    homepage = https://www.python-ldap.org/;
    license = licenses.psfl;
  };
#   AFL_HARDEN="1";
#   AFL_LLVM_LAF_SPLIT_SWITCHES="1";
#   AFL_LLVM_LAF_TRANSFORM_COMPARES="1";
#   AFL_LLVM_LAF_SPLIT_COMPARES="1";
#   AFL_LLVM_INSTRIM="1";
#   AFL_LLVM_NOT_ZERO="1";
#   preConfigure = ''
#     export CC=${aflplusplus}/bin/afl-clang-fast
#   '';
}

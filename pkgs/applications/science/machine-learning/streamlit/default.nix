{
  # Nix
  lib,
  buildPythonApplication,
  fetchPypi,

  # Build inputs
  altair,
  blinker,
  click,
  cachetools,
  GitPython,
  importlib-metadata,
  jinja2,
  pillow,
  pyarrow,
  pydeck,
  pympler,
  protobuf,
  requests,
  rich,
  semver,
  setuptools,
  toml,
  tornado,
  tzlocal,
  validators,
  watchdog,

  fetchFromGitHub,
  pytestCheckHook,
  bokeh,
  matplotlib,
  parameterized,
  sqlalchemy,
  hypothesis,
  testfixtures,
  requests-mock,
  plotly,
  opencv4,
  graphviz,
  pyodbc,
  mysqlclient,
  psycopg2,
  git,
}:

let
  version = "1.11.1";
  testsSrc = fetchFromGitHub {
    owner = "streamlit";
    repo = "streamlit";
    rev = version;
    hash = "sha256-GW444SlrOpIGbwIwEaGQEGdVa9+0lh8Ib1dwN8a0/ew=";
  };
in
buildPythonApplication rec {
  inherit version;
  pname = "streamlit";
  format = "wheel";  # source currently requires pipenv

  src = fetchPypi {
    inherit pname version format;
    hash = "sha256-+GGuL3UngPDgLOGx9QXUdRJsTswhTg7d6zuvhpp0Mo0=";
  };

  propagatedBuildInputs = [
    altair
    blinker
    cachetools
    click
    GitPython
    importlib-metadata
    jinja2
    pillow
    protobuf
    pyarrow
    pydeck
    pympler
    requests
    rich
    semver
    setuptools
    toml
    tornado
    tzlocal
    validators
    watchdog
  ];

  postInstall = ''
      rm $out/bin/streamlit.cmd # remove windows helper
  '';

  checkInputs = [
    pytestCheckHook
    bokeh
    git
    graphviz
    hypothesis
    matplotlib
    mysqlclient
    opencv4
    parameterized
    plotly
    psycopg2
    pyodbc
    requests-mock
    sqlalchemy
    testfixtures
  ];
  preCheck = ''
    cp -r ${testsSrc}/lib/tests .
  '';

  meta = with lib; {
    homepage = "https://streamlit.io/";
    description = "The fastest way to build custom ML tools";
    maintainers = with maintainers; [ yrashk ];
    license = licenses.asl20;
  };
}

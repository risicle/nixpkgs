{
  # Nix
  lib,
  buildPythonApplication,
  fetchPypi,
  fetchpatch,

  unzip,
  zip,

  # Build inputs
  altair,
  astor,
  base58,
  blinker,
  boto3,
  botocore,
  click,
  cachetools,
  enum-compat,
  future,
  GitPython,
  jinja2,
  pillow,
  pyarrow,
  pydeck,
  pympler,
  protobuf,
  requests,
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
  version = "1.2.0";
  testsSrc = fetchFromGitHub {
    owner = "streamlit";
    repo = "streamlit";
    rev = version;
    hash = "sha256-zAsozmSGVuZSHipoKsuuEVb+mqrWF1ulYVUXlIdOMEc=";
  };
  testsPatch = fetchpatch {
    name = "CVE-2022-35918-tests.patch";
    url = "https://github.com/streamlit/streamlit/commit/80d9979d5f4a00217743d607078a1d867fad8acf.patch";
    sha256 = "sha256-nBqoYi4jAxFYguDpNvcZ/T/P0gutPV56wePVdH/vHkk=";
    stripLen = 1;
    includes = [ "tests/streamlit/components_test.py" ];
  };
  click_7 = click.overridePythonAttrs(old: rec {
    version = "7.1.2";
    src = old.src.override {
      inherit version;
      sha256 = "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a";
    };
  });
in buildPythonApplication rec {
  inherit version;
  pname = "streamlit";
  format = "wheel"; # the only distribution available

  src = fetchPypi {
    inherit pname version format;
    sha256 = "1dzb68a8n8wvjppcmqdaqnh925b2dg6rywv51ac9q09zjxb6z11n";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2022-35918.patch";
      url = "https://github.com/streamlit/streamlit/commit/80d9979d5f4a00217743d607078a1d867fad8acf.patch";
      sha256 = "sha256-AyVF/VUKUEKz0RF9CzW2eco0lY0xVd3hPc88D7VZ5Xw=";
      stripLen = 1;
      # tests not included in wheel
      excludes = [ "tests/streamlit/components_test.py" ];
    })
  ];
  # extract wheel, run normal patch phase, rezip wheel.
  # effectively a "wheelPatchPhase"
  patchPhase = ''
    wheelFile="$(realpath -s dist/*.whl)"
    pushd "$(mktemp -d)"

    unzip -q "$wheelFile"

    patchPhase

    newZip="$(mktemp -d)"/new.zip
    zip -rq "$newZip" *
    rm -rf "$wheelFile"
    cp "$newZip" "$wheelFile"

    popd
  '';

  nativeBuildInputs = [ unzip zip ];

  propagatedBuildInputs = [
    altair
    astor
    base58
    blinker
    boto3
    botocore
    cachetools
    click_7
    enum-compat
    future
    GitPython
    jinja2
    pillow
    protobuf
    pyarrow
    pydeck
    pympler
    requests
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
  disabledTestPaths = [
    "tests/streamlit/legacy_caching/hashing_test.py"
  ];
  preCheck = ''
    cp -r ${testsSrc}/lib/tests .
    chmod -R u+w .
    patch -p1 < ${testsPatch}
  '';

  meta = with lib; {
    homepage = "https://streamlit.io/";
    description = "The fastest way to build custom ML tools";
    maintainers = with maintainers; [ yrashk ];
    license = licenses.asl20;
  };
}

import ./make-test-python.nix ({ pkgs, ... }:

let
  crashme-py = pkgs.writeText "crashme.py" ''
    import ctypes

    def sentinel_foo_bar():
        ctypes.memset(0, 1, 1)

    sentinel_foo_bar()
  '';
in {
  name = "python-gdb";
  meta = with pkgs.lib.maintainers; {
    description = "Test inspection of the python stack of cpython programs in gdb";
    maintainers = [ ris ];
  };

  nodes.pythongdb = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.gdb ];
  };

  testScript = ''
    assert "in sentinel_foo_bar" in pythongdb.succeed(
        "gdb -batch -ex 'set debug-file-directory ${pkgs.python3.debug}/lib/debug'"
        " -ex 'source ${pkgs.python3}/share/gdb/libpython.py'"
        " -ex r"
        " -ex py-bt"
        " --args ${pkgs.python3}/bin/python ${crashme-py}"
    )
  '';
})

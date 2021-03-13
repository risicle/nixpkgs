{ interpreter, lib, gdb, writeText, runCommand }:

let
  crashme-py = writeText "crashme.py" ''
    import ctypes

    def sentinel_foo_bar():
        ctypes.memset(0, 1, 1)

    sentinel_foo_bar()
  '';
in runCommand "python-gdb" {} ''
  ${gdb}/bin/gdb -batch -ex 'set debug-file-directory ${interpreter.debug}/lib/debug' \
    -ex 'source ${interpreter}/share/gdb/libpython.py' \
    -ex r \
    -ex py-bt \
    --args ${interpreter}/bin/python ${crashme-py} | grep 'in sentinel_foo_bar'

  touch $out
''


#   testScript = ''
#     assert "in sentinel_foo_bar" in pythongdb.succeed(
#         "gdb -batch -ex 'set debug-file-directory ${pkgs.python3.debug}/lib/debug'"
#         " -ex 'source ${pkgs.python3}/share/gdb/libpython.py'"
#         " -ex r"
#         " -ex py-bt"
#         " --args ${pkgs.python3}/bin/python ${crashme-py}"
#     )
#   '';
# })

{ lib, callPackage, fetchurl, fetchpatch, ... } @ args: let

  # patching mechanism doesn't work with binary files, but the commits contain
  # example files needed for the accompanying tests, so invent our own mechanism
  # to put these in place
  extraPostPatch = lib.concatMapStrings ({commit, sha256, path}: let
      src = fetchurl {
        inherit sha256;
        url = "https://github.com/randombit/botan/raw/${commit}/${path}";
      };
      dest = path;
    in ''
      install -m0666 ${src} ${dest}
    ''
  ) [
    { # needed by CVE-2022-43705-1.patch
      commit = "fd83d9e262f63fb673e4c13ca37e5b768e41e812";
      sha256 = "sha256-tN8Qt/QTYyJSrC4pcUb3LYYW56SHzUxMkyKmfxCj3TA=";
      path = "src/tests/data/x509/ocsp/randombit_ocsp_forged_revoked.der";
    }
    { # needed by CVE-2022-43705-1.patch
      commit = "fd83d9e262f63fb673e4c13ca37e5b768e41e812";
      sha256 = "sha256-9uyzkIMqzLVdI9EirOBIe2A2QpZHLyQkihwdnef5C/8=";
      path = "src/tests/data/x509/ocsp/randombit_ocsp_forged_valid.der";
    }
    { # needed by CVE-2022-43705-1.patch
      commit = "fd83d9e262f63fb673e4c13ca37e5b768e41e812";
      sha256 = "sha256-dGI4XLflzVUL7ftkfw99syXdsJu3Qfa2fGMAibFHzmU=";
      path = "src/tests/data/x509/ocsp/randombit_ocsp_forged_valid_nocerts.der";
    }
    { # needed by CVE-2022-43705-2.patch
      commit = "4e35073ff356e37c3adcf1ff3522e9d0d48c765f";
      sha256 = "sha256-vdOUm0+MuH8BQOq3su3+ZUZqhd557RsczccqgXZNTxc=";
      path = "src/tests/data/x509/ocsp/mychain_ocsp_for_ee.der";
    }
    { # needed by CVE-2022-43705-2.patch
      commit = "4e35073ff356e37c3adcf1ff3522e9d0d48c765f";
      sha256 = "sha256-iPBLR7m1snl4hI4qioK/KD/EyeE4Xk4cB0la10CYREg=";
      path = "src/tests/data/x509/ocsp/mychain_ocsp_for_ee_delegate_signed.der";
    }
    { # needed by CVE-2022-43705-2.patch
      commit = "4e35073ff356e37c3adcf1ff3522e9d0d48c765f";
      sha256 = "sha256-y44NaY2uFXmDJZkDvBuz6PvRgpggPpOEQc6XnHiLqC8=";
      path = "src/tests/data/x509/ocsp/mychain_ocsp_for_ee_delegate_signed_malformed.der";
    }
    { # needed by CVE-2022-43705-2.patch
      commit = "4e35073ff356e37c3adcf1ff3522e9d0d48c765f";
      sha256 = "sha256-GTRKh8l9vB6SwDwmqyGzznRJj2RVBnXAUEngi3AVmH0=";
      path = "src/tests/data/x509/ocsp/mychain_ocsp_for_ee_root_signed.der";
    }
    { # needed by CVE-2022-43705-2.patch
      commit = "4e35073ff356e37c3adcf1ff3522e9d0d48c765f";
      sha256 = "sha256-zEPJZdrYTP56GN16h8aQNqd/8CNIjhHlD2wju/wU0lI=";
      path = "src/tests/data/x509/ocsp/mychain_ocsp_for_int_self_signed.der";
    }
    { # needed by CVE-2022-43705-3.patch
      commit = "c2faa88b0281e5017be72e1c85d0c41f686e1928";
      sha256 = "sha256-WDOTr9LixY7OZGCYGnVjhRAHrnBg7e8TACZ1OeMLEqM=";
      path = "src/tests/data/x509/ocsp/bdr-int-ocsp-resp.der";
    }
    { # needed by CVE-2022-43705-3.patch
      commit = "c2faa88b0281e5017be72e1c85d0c41f686e1928";
      sha256 = "sha256-dEJ99eQoFXe4A6v+N6SjBYioAVn0EIiB9pJQFVjjkpk=";
      path = "src/tests/data/x509/ocsp/bdr-ocsp-resp.der";
    }
  ];

in callPackage ./generic.nix (args // {
  baseVersion = "2.18";
  revision = "1";
  sha256 = "0adf53drhk1hlpfih0175c9081bqpclw6p2afn51cmx849ib9izq";
  postPatch = ''
    sed -e 's@lang_flags "@&--std=c++11 @' -i src/build-data/cc/{gcc,clang}.txt
  '' + extraPostPatch;

  extraPatches = [
    (fetchpatch {
      name = "CVE-2021-40529.patch";
      url = "https://github.com/randombit/botan/commit/9a23e4e3bc3966340531f2ff608fa9d33b5185a2.patch";
      sha256 = "1ax1n2l9zh0hk35vkkywgkhzpdk76xb9apz2wm3h9kjvjs9acr3y";
      # our source tarball doesn't include the tests
      excludes = [ "src/tests/*" ];
    })
    # https://github.com/randombit/botan/security/advisories/GHSA-4v9w-qvcq-6q7w
    (fetchpatch {
      name = "CVE-2022-43705-1.patch";
      url = "https://github.com/randombit/botan/commit/fd83d9e262f63fb673e4c13ca37e5b768e41e812.patch";
      hash = "sha256-f0vZGXalao1jqtaONlZna4alzpyLF4BbZwirQN+MPs0=";
    })
    (fetchpatch {
      name = "CVE-2022-43705-2.patch";
      url = "https://github.com/randombit/botan/commit/4e35073ff356e37c3adcf1ff3522e9d0d48c765f.patch";
      hash = "sha256-BBoIMuI1ayesI0rhYbdlO6rphZE1C4LCYI7bwHd8bUw=";
    })
    (fetchpatch {
      name = "CVE-2022-43705-3.patch";
      url = "https://github.com/randombit/botan/commit/c2faa88b0281e5017be72e1c85d0c41f686e1928.patch";
      hash = "sha256-n88gRLrxQG5/cundLyajd1IEi7x4aS5Ou3a1BudTrXI=";
    })
    (fetchpatch {
      name = "CVE-2022-43705-4.patch";
      url = "https://github.com/randombit/botan/commit/5d8d9fbf75c8b814ea609161bee525d520f5cb57.patch";
      hash = "sha256-gqm9mG1NUyYfzMA3vjUjdU4aWOyHU4hiptpXGCR+HqM=";
    })
    (fetchpatch {
      name = "CVE-2022-43705-5.patch";
      url = "https://github.com/randombit/botan/commit/1829ef9d89614da1eacdf511356bdf98a970f5f5.patch";
      hash = "sha256-Whi4GOT6CPmV8qE2Q9ktJ11aozR8xvDV8h6bIRgxMPA=";
    })
    (fetchpatch {
      name = "CVE-2022-43705-6.patch";
      url = "https://github.com/randombit/botan/commit/991b0159282781f2d5c06ff42a9ff00ee563e96b.patch";
      hash = "sha256-vEgfAlE5Pl5V0kVsjFtxm51ODubs9nRi52l50AiaTsM=";
    })
    (fetchpatch {
      name = "CVE-2022-43705-7.patch";
      url = "https://github.com/randombit/botan/commit/a33689613127f319c0047fb96f092de16e7cb350.patch";
      hash = "sha256-3/l6RjPZDXTGPGwYVNDL/G213hCEIn0RV0JmNxOt4UI=";
    })
    (fetchpatch {
      name = "CVE-2022-43705-8.patch";
      url = "https://github.com/randombit/botan/commit/909c62717855402e04dbaf8ffc085f444d547aae.patch";
      hash = "sha256-AAsmNgwN8887nE84/BgJOcb6IuLK11HZoMJOhyeqDpI=";
    })
  ];
})

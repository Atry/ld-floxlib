{ self
, lib
, pkgsStatic
, buildEnv
, stdenv
, defaultLibraries ? [
    # List here any libraries that you would prefer to see
    # loaded purely from Nix.
    stdenv.cc.cc.lib	# for libstdc++.so.6
  ]
}:

let
  pname = "ld-floxlib";
  ld_floxlib_libs = buildEnv {
    name = "${pname}-libs";
    paths = defaultLibraries;
  };

in
# The ld-floxlib.so library is statically linked
pkgsStatic.stdenv.mkDerivation {
  inherit pname;
  version = "0.0.0-${lib.flox-floxpkgs.getRev self}";
  src = self;
  makeFlags = [
    "PREFIX=$(out)"
    "CFLAGS=-DLD_FLOXLIB_LIB='\"${ld_floxlib_libs}/lib\"'"
  ];

  meta.description = "ld.so hack allowing Nix binaries to impurely load RHEL system libraries as last resort";
}

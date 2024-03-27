{ self
, lib
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
stdenv.mkDerivation {
  inherit pname;
  version = "0.0.0-${lib.flox-floxpkgs.getRev self}";
  src = self;
  buildInputs = [ ld_floxlib_libs ];
  makeFlags = [
    "PREFIX=$(out)"
    "CFLAGS=-DLD_FLOXLIB_LIB='\"${ld_floxlib_libs}/lib\"'"
  ];

  # The ld-floxlib.so library only requires libc, which is guaranteed
  # to either be already loaded or available by way of a default provided
  # by the linker itself, so to avoid loading a different libc than the
  # one already loaded we remove RPATH/RUNPATH from the shared library.
  postFixup = ''
    patchelf --remove-rpath $out/lib/ld-floxlib.so
  '';

  meta.description = "ld.so hack allowing Nix binaries to impurely load RHEL system libraries as last resort";
}

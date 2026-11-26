# libplacebo, which mpv requires since 0.38. Built without its OpenGL, Vulkan and Direct3D backends: mpv renders libmpv's
# OpenGL output with its own code, and those backends would need libplacebo's git submodules (glad, jinja), which the
# release archive leaves out. The core shaders are still generated from jinja templates, hence a Python with jinja2.
{
  pkgs ? import ../../utils/default/pkgs.nix,
  os ? import ../../utils/default/os.nix,
  arch ? pkgs.callPackage ../../utils/default/arch.nix { },
}:

let
  name = "libplacebo";
  packageLock = (import ../../../packages.lock.nix).${name};
  inherit (packageLock) version;

  callPackage = pkgs.lib.callPackageWith { inherit pkgs os arch; };
  nativeFile = callPackage ../../utils/native-file/default.nix { };
  crossFile = callPackage ../../utils/cross-file/default.nix { };

  # meson finds Python through the machine files, or else uses the Python it runs on itself, which has no jinja2.
  python = pkgs.python3.withPackages (ps: [
    ps.jinja2
    ps.markupsafe
  ]);
  pythonFile = pkgs.writeText "python.ini" ''
    [binaries]
    python = '${python}/bin/python3'
    python3 = '${python}/bin/python3'
  '';

  pname = import ../../utils/name/package.nix name;
  src = callPackage ../../utils/fetch-tarball/default.nix {
    name = "${pname}-source-${version}";
    inherit (packageLock) url sha256;
  };

  # fast_float, a header-only git submodule of libplacebo, at the commit libplacebo pins (v8.2.2). The release archive
  # leaves it out, and libplacebo needs it to convert floating-point numbers.
  fastFloat = callPackage ../../utils/fetch-tarball/default.nix {
    name = "${pname}-fast-float-${fastFloatLock.version}";
    inherit (fastFloatLock) url sha256;
  };
  fastFloatLock = (import ../../../packages.lock.nix).fastFloat;
  patchedSource = pkgs.runCommand "${pname}-patched-source-${version}" { } ''
    cp -r ${src} $out
    chmod -R u+w $out
    mkdir -p $out/3rdparty/fast_float
    cp -r ${fastFloat}/include $out/3rdparty/fast_float/include
  '';
in

pkgs.stdenvNoCC.mkDerivation {
  name = "${pname}-${os}-${arch}-${version}";
  pname = pname;
  inherit version;
  src = patchedSource;
  dontUnpack = true;
  enableParallelBuilding = true;
  nativeBuildInputs = [
    pkgs.meson
    pkgs.ninja
    pkgs.pkg-config
    python
  ];
  configurePhase = ''
    meson setup build $src \
      --native-file=${nativeFile} \
      --native-file=${pythonFile} \
      --cross-file ${crossFile} \
      --cross-file ${pythonFile} \
      --prefix=$out \
      -Dvulkan=disabled \
      -Dopengl=disabled \
      -Dd3d11=disabled \
      -Dglslang=disabled \
      -Dshaderc=disabled \
      -Dlcms=disabled \
      -Ddovi=disabled \
      -Dlibdovi=disabled \
      -Dunwind=disabled \
      -Dxxhash=disabled \
      -Ddemos=false \
      -Dtests=false \
      -Dbench=false \
      -Dfuzz=false
  '';
  buildPhase = ''
    meson compile -vC build
  '';
  installPhase = ''
    meson install -C build
  '';
}

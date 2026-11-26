let
  oses = import ../constants/oses.nix;
  archs = import ../constants/archs.nix;
in
# media-gears is desktop only: macOS on both architectures, joined into universal frameworks later.
[
  {
    os = oses.macos;
    arch = archs.arm64;
  }
  {
    os = oses.macos;
    arch = archs.amd64;
  }
]

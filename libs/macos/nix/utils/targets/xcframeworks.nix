let
  oses = import ../constants/oses.nix;
  archs = import ../constants/archs.nix;
in
# media-gears is desktop only: macOS, as one universal (arm64 + x86_64) set of frameworks.
[
  {
    os = oses.macos;
    arch = archs.universal;
  }
]

let
  oses = import ../constants/oses.nix;
  archs = import ../constants/archs.nix;
in
# media-gears is desktop only.
[
  {
    os = oses.macos;
    arch = archs.universal;
  }
]

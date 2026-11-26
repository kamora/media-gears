let
  oses = import ../constants/oses.nix;
  archs = import ../constants/archs.nix;
in
# media-gears is desktop only. The universal libraries are joined from the arm64 and x86_64 ones listed here, so both
# must stay.
[
  {
    os = oses.macos;
    arch = archs.arm64;
  }
  {
    os = oses.macos;
    arch = archs.amd64;
  }
  {
    os = oses.macos;
    arch = archs.universal;
  }
]

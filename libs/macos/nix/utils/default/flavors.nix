let
  flavors = import ../constants/flavors.nix;
in
# media-gears ships only the LGPL "default" flavor.
[
  flavors.default
]

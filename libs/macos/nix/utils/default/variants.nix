let
  variants = import ../constants/variants.nix;
in
# media-gears plays video, so only the "video" variant is built.
[
  variants.video
]

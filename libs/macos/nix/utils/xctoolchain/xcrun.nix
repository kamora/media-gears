# A minimal xcrun for mpv's build, which asks it where a tool is (`xcrun -find swiftc`) and where the macOS SDK is.
{
  pkgs ? import ../default/pkgs.nix,
}:

let
  developer = "${pkgs.darwin.xcode}/Contents/Developer";
  sdk = "${developer}/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk";
in

pkgs.writeShellScriptBin "xcrun" ''
  case "$*" in
  "-find "*)
    echo "${developer}/Toolchains/XcodeDefault.xctoolchain/usr/bin/$2"
    ;;
  *--show-sdk-path*)
    echo "${sdk}"
    ;;
  *--show-sdk-version*)
    sed -n 's/.*"Version" *: *"\([0-9.]*\)".*/\1/p' "${sdk}/SDKSettings.json"
    ;;
  *)
    echo "xcrun: unsupported: $*" >&2
    exit 1
    ;;
  esac
''

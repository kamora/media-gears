#!/bin/sh

# Puts the macOS frameworks in test/libs, where `flutter test` can load libmpv outside an app bundle:
#
#   sh test/libs.sh
#   LIBMPV_LIBRARY_PATH=$PWD/test/libs/Mpv.framework/Mpv flutter test
set -eu
cd "$(dirname "$0")/.."
make -C ../media_gears_macos/macos >/dev/null
rm -rf test/libs
mkdir -p test/libs
for framework in ../media_gears_macos/macos/Frameworks/*.xcframework; do
	cp -R "$framework"/macos-arm64_x86_64/*.framework test/libs/
done

# Mpv finds the other frameworks through @rpath, which only an app bundle sets; this points it at its own folder.
mpv=test/libs/Mpv.framework/Versions/A/Mpv
install_name_tool -add_rpath @loader_path/../../.. "$mpv" 2>/dev/null
codesign --force --sign - "$mpv" 2>/dev/null

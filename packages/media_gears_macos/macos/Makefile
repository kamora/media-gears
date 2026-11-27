# Fetches the mpv and FFmpeg frameworks the plugin builds against with CocoaPods: built by libs/macos, published as the
# libs-macos-* release and checked against their SHA-256 sum. With Swift Package Manager, Package.swift fetches them.
all: Frameworks/*.xcframework

LIBS_VERSION=v0.1.2
LIBS_SHA256SUM=737ad1665e1a4adbdf8710f3b067aac93c7d2fbe8a7068044b90eb9578911e52

.cache/libs-${LIBS_VERSION}.tar.gz:
	mkdir -p .cache
	curl -L \
		https://github.com/kamora/media-gears/releases/download/libs-macos-${LIBS_VERSION}/libmpv-xcframeworks_${LIBS_VERSION}_macos-universal-video-default.tar.gz \
		-o $@.tmp
	shasum -a 256 -c <<< '${LIBS_SHA256SUM}  $@.tmp'
	mv $@.tmp $@

Frameworks/*.xcframework: .cache/libs-${LIBS_VERSION}.tar.gz
	rm -rf Frameworks
	mkdir -p Frameworks
	tar -xf $< --strip-components 1 -C Frameworks
	touch Frameworks/*.xcframework

.PHONY: clean
clean:
	rm -rf .cache Frameworks

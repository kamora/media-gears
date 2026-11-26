# Fetches what the plugin builds against: our mpv and FFmpeg frameworks, built by libs/macos and published as the
# libs-macos-* release, and the libmpv headers of the same mpv version. Both are checked against their SHA-256 sums.
all: Frameworks/*.xcframework Headers/mpv/*.h

LIBS_VERSION=v0.1.1
LIBS_SHA256SUM=1bcd72d71cff5272596df8d6542ba2c8d7342f7f11a96879e868c7937f8899b8
MPV_HEADERS_VERSION=v0.42.0
MPV_HEADERS_SHA256SUM=bcfebbfa2b65a6d88dc97ea18117831072373e38b5785a2afb874ed4df5070dd

TAR=tar
TAR_WILDCARDS_FLAG := $(shell ${TAR} --version 2>&1 | grep -q 'GNU' && echo "--wildcards" || echo "")

.cache/libs-${LIBS_VERSION}.tar.gz:
	mkdir -p .cache
	curl -L \
		https://github.com/kamora/media-gears/releases/download/libs-macos-${LIBS_VERSION}/libmpv-xcframeworks_${LIBS_VERSION}_macos-universal-video-default.tar.gz \
		-o $@.tmp
	shasum -a 256 -c <<< '${LIBS_SHA256SUM}  $@.tmp'
	mv $@.tmp $@

.cache/mpv-${MPV_HEADERS_VERSION}.tar.gz:
	mkdir -p .cache
	curl -L https://github.com/mpv-player/mpv/archive/refs/tags/${MPV_HEADERS_VERSION}.tar.gz -o $@.tmp
	shasum -a 256 -c <<< '${MPV_HEADERS_SHA256SUM}  $@.tmp'
	mv $@.tmp $@

Frameworks/*.xcframework: .cache/libs-${LIBS_VERSION}.tar.gz
	rm -rf Frameworks
	mkdir -p Frameworks
	${TAR} ${TAR_WILDCARDS_FLAG} -xf $< --strip-components 1 -C Frameworks
	touch Frameworks/*.xcframework

Headers/mpv/*.h: .cache/mpv-${MPV_HEADERS_VERSION}.tar.gz
	rm -rf Headers
	mkdir -p Headers/mpv
	${TAR} ${TAR_WILDCARDS_FLAG} -xf $< --strip-components 3 -C Headers/mpv 'mpv-*/include/mpv/*.h'
	touch Headers/mpv/*.h

.PHONY: clean
clean:
	rm -rf .cache Frameworks Headers

# Fetches what the plugin builds against: media_kit's prebuilt mpv and FFmpeg frameworks, and the libmpv headers of
# the same mpv version. Both are checked against their SHA-256 sums.
all: Frameworks/*.xcframework Headers/mpv/*.h

MPV_XCFRAMEWORKS_VERSION=v0.7.3
MPV_XCFRAMEWORKS_SHA256SUM=2e58ac66b0ea875239bf4db29b3ef2100a719df1d61fa1e780c38d651d4c9f27
MPV_HEADERS_VERSION=v0.36.0
MPV_HEADERS_SHA256SUM=29abc44f8ebee013bb2f9fe14d80b30db19b534c679056e4851ceadf5a5e8bf6

TAR=tar
TAR_WILDCARDS_FLAG := $(shell ${TAR} --version 2>&1 | grep -q 'GNU' && echo "--wildcards" || echo "")

.cache/libmpv-${MPV_XCFRAMEWORKS_VERSION}.tar.gz:
	mkdir -p .cache
	curl -L \
		https://github.com/media-kit/libmpv-darwin-build/releases/download/${MPV_XCFRAMEWORKS_VERSION}/libmpv-xcframeworks_${MPV_XCFRAMEWORKS_VERSION}_macos-universal-video-default.tar.gz \
		-o $@.tmp
	shasum -a 256 -c <<< '${MPV_XCFRAMEWORKS_SHA256SUM}  $@.tmp'
	mv $@.tmp $@

.cache/mpv-${MPV_HEADERS_VERSION}.tar.gz:
	mkdir -p .cache
	curl -L https://github.com/mpv-player/mpv/archive/refs/tags/${MPV_HEADERS_VERSION}.tar.gz -o $@.tmp
	shasum -a 256 -c <<< '${MPV_HEADERS_SHA256SUM}  $@.tmp'
	mv $@.tmp $@

Frameworks/*.xcframework: .cache/libmpv-${MPV_XCFRAMEWORKS_VERSION}.tar.gz
	rm -rf Frameworks
	mkdir -p Frameworks
	${TAR} ${TAR_WILDCARDS_FLAG} -xf $< --strip-components 1 -C Frameworks
	touch Frameworks/*.xcframework

Headers/mpv/*.h: .cache/mpv-${MPV_HEADERS_VERSION}.tar.gz
	rm -rf Headers
	mkdir -p Headers/mpv
	${TAR} ${TAR_WILDCARDS_FLAG} -xf $< --strip-components 2 -C Headers/mpv 'mpv-*/libmpv/*.h'
	touch Headers/mpv/*.h

.PHONY: clean
clean:
	rm -rf .cache Frameworks Headers

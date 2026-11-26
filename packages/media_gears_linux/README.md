# media_gears_linux

The Linux side of [media_gears](https://github.com/kamora/media-gears): the C++ code that renders mpv's video into a Flutter texture; mpv itself is the system's libmpv (`libmpv-dev` on Debian and Ubuntu).

State: Not compiled yet.

Apps don't depend on this package directly: they depend on `media_gears`, which brings it in. Derived from media_kit's
Linux packages; MIT, see [LICENSE](LICENSE).

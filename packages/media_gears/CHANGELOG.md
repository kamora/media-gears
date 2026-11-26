## 0.1.0-dev.1

- First development release, forked from media_kit 1.2: desktop only (macOS, Windows, Linux).
- One `Player` and one `VideoController` over libmpv; the platform layers are gone.
- Renamed: `MediaKit` to `MediaGears`, `MaterialDesktopVideoControls` to `DesktopControls` with its buttons,
  `NoVideoControls` to `NoControls`, `VideoControllerConfiguration` to `VideoConfiguration`, `MPVLogLevel` to
  `LogLevel`.
- Removed: the web backend, the mobile and Cupertino controls, and options that only applied to them.
- macOS uses mpv 0.42.0 and FFmpeg 9.1 (LGPLv3), built by media_gears.

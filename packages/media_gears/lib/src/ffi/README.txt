media_gears bundles package:ffi v1.2.1 for its native interop, as media_kit did.

media_kit kept this copy for stability and performance on Windows: https://github.com/dart-lang/ffi/pull/144 changed how
package:ffi allocates memory there, and with media_kit's MinGW-built libmpv that change led to crashes or slow processing
in some situations. Whether that still holds is to be checked once media_gears builds its own Windows libraries.

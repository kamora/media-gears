# The macOS side of media_gears: mpv and FFmpeg as vendored frameworks, and the Swift code that renders mpv's video
# into a Flutter texture.
Pod::Spec.new do |s|
	system('make')

	s.name             = 'media_gears_macos'
	s.version          = '0.1.0'
	s.summary          = 'The macOS implementation of media_gears.'
	s.description      = 'mpv and FFmpeg for macOS, and the video output that renders into a Flutter texture.'
	s.homepage         = 'https://github.com/kamora/media-gears'
	s.license          = { :file => '../LICENSE' }
	s.author           = { 'Kamora' => 'https://github.com/kamora' }
	s.source           = { :path => '.' }
	s.platform         = :osx, '12.0'
	s.swift_version    = '5.0'
	s.dependency         'FlutterMacOS'

	s.source_files        = 'video/**/*.swift', 'Headers/**/*.h'
	s.vendored_frameworks = 'Frameworks/*.xcframework'
	s.resource_bundles    = { 'media_gears_macos_privacy' => ['PrivacyInfo.xcprivacy'] }
	s.pod_target_xcconfig = {
		'DEFINES_MODULE'                => 'YES',
		'GCC_WARN_INHIBIT_ALL_WARNINGS' => 'YES',
		'GCC_PREPROCESSOR_DEFINITIONS'  => '"$(inherited)" GL_SILENCE_DEPRECATION COREVIDEO_SILENCE_GL_DEPRECATION',
		'OTHER_LDFLAGS'                 => '"$(inherited)" -framework Mpv',
	}
end

// swift-tools-version: 5.9

import PackageDescription

// The mpv and FFmpeg frameworks of the libs-macos-v0.1.1 release, built by libs/macos; the podspec's Makefile fetches
// the same release for CocoaPods.
let libs =
	"https://github.com/kamora/media-gears/releases/download/libs-macos-v0.1.1/"
	+ "libmpv-xcframeworks_v0.1.1_macos-universal-video-default"

let package = Package(
	name: "media_gears_macos",
	platforms: [
		.macOS("12.0")
	],
	products: [
		.library(name: "media-gears-macos", targets: ["media_gears_macos"])
	],
	dependencies: [
		.package(name: "FlutterFramework", path: "../FlutterFramework")
	],
	targets: [
		.target(
			name: "media_gears_macos",
			dependencies: [
				.product(name: "FlutterFramework", package: "FlutterFramework"),
				.target(name: "Ass"),
				.target(name: "Avcodec"),
				.target(name: "Avfilter"),
				.target(name: "Avformat"),
				.target(name: "Avutil"),
				.target(name: "Dav1d"),
				.target(name: "Freetype"),
				.target(name: "Fribidi"),
				.target(name: "Harfbuzz"),
				.target(name: "Mbedcrypto"),
				.target(name: "Mbedtls"),
				.target(name: "Mbedx509"),
				.target(name: "Mpv"),
				.target(name: "Placebo"),
				.target(name: "Png16"),
				.target(name: "Swresample"),
				.target(name: "Swscale"),
				.target(name: "Uchardet"),
				.target(name: "Xml2"),
			],
			resources: [
				.process("PrivacyInfo.xcprivacy")
			]
		),
		.binaryTarget(
			name: "Ass",
			url: "\(libs)_Ass.zip",
			checksum: "b34263867cf2ba82358f4df125d878903a192f1e5d3b21d8de453391fd2be4b8"
		),
		.binaryTarget(
			name: "Avcodec",
			url: "\(libs)_Avcodec.zip",
			checksum: "2e0c978ba3d380eeadebf5d4128a2c9821d55cc66c3f2cb982e6de9b25d67545"
		),
		.binaryTarget(
			name: "Avfilter",
			url: "\(libs)_Avfilter.zip",
			checksum: "500100f4afac4d42a1bb1fdd398b6968059c1c3083202d6371eb08beb1a8d45d"
		),
		.binaryTarget(
			name: "Avformat",
			url: "\(libs)_Avformat.zip",
			checksum: "57129a3847f6d4a6e641ce93dbdb56cc73bddb2d84aea436ed0c4019ec623013"
		),
		.binaryTarget(
			name: "Avutil",
			url: "\(libs)_Avutil.zip",
			checksum: "3eb69c114ab5fc0617efa6d2f45690f1f222b1147f800b8c96b088fc166220aa"
		),
		.binaryTarget(
			name: "Dav1d",
			url: "\(libs)_Dav1d.zip",
			checksum: "63a1807072bc3c61e75737ec2de301be8cd1152a069e088b9e52705cbab7ee32"
		),
		.binaryTarget(
			name: "Freetype",
			url: "\(libs)_Freetype.zip",
			checksum: "1b342944e1e40a48d1f3fade376c19bd0340e627737aaee03a389449b73e6d85"
		),
		.binaryTarget(
			name: "Fribidi",
			url: "\(libs)_Fribidi.zip",
			checksum: "1588e90b2064dd83c6efdad63e70015b9afbc0fa3a7ea9ed79dbd0fcb3f84ed6"
		),
		.binaryTarget(
			name: "Harfbuzz",
			url: "\(libs)_Harfbuzz.zip",
			checksum: "3ad28b39326a5aa7e4d5f37e766ba6405c9ed57085026035fa77aad928616aa1"
		),
		.binaryTarget(
			name: "Mbedcrypto",
			url: "\(libs)_Mbedcrypto.zip",
			checksum: "347913ad5b9011aba6788f2cb4a8b9e703e536bfa7f7ae923839bcb4772ea770"
		),
		.binaryTarget(
			name: "Mbedtls",
			url: "\(libs)_Mbedtls.zip",
			checksum: "d37b86d88b3cd160c2bbccae04a5babba35f67814618e1fe52343b39177e06c2"
		),
		.binaryTarget(
			name: "Mbedx509",
			url: "\(libs)_Mbedx509.zip",
			checksum: "e414c869a93fd1897cae46e52e22da951fc61cdbdf2dc24fed6d681882134abb"
		),
		.binaryTarget(
			name: "Mpv",
			url: "\(libs)_Mpv.zip",
			checksum: "4ede62c3e70f25c9644741cad29a601f7b21a44893c17fcbf6145a1cb0b983e7"
		),
		.binaryTarget(
			name: "Placebo",
			url: "\(libs)_Placebo.zip",
			checksum: "915b38cf022cccae40059ecfa6754a3718e83173210be4c1ee1baa16f99519ac"
		),
		.binaryTarget(
			name: "Png16",
			url: "\(libs)_Png16.zip",
			checksum: "5412ae01bdafdf748c32c161200c5d138da888b03667f7bda9859ff77c0df9b8"
		),
		.binaryTarget(
			name: "Swresample",
			url: "\(libs)_Swresample.zip",
			checksum: "279ebe4b0fab0d8665d63dab113cd17811700de4ccfc59d260215e146006fef6"
		),
		.binaryTarget(
			name: "Swscale",
			url: "\(libs)_Swscale.zip",
			checksum: "8863d2f2dd3dee6c3334cddf7526c0b4fd394e598a2257ab959d260a79fcda67"
		),
		.binaryTarget(
			name: "Uchardet",
			url: "\(libs)_Uchardet.zip",
			checksum: "ee74970b6a32567b149ee2070808bbd2087668179d1a4d4e081b0bdb2093ff1d"
		),
		.binaryTarget(
			name: "Xml2",
			url: "\(libs)_Xml2.zip",
			checksum: "ae2578dc783a2d7a8a0f88c63315991e6cec39721311450f6b02dfbb4cfc3853"
		),
	]
)

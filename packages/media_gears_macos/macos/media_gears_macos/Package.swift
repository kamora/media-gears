// swift-tools-version: 5.9

import PackageDescription

// The mpv and FFmpeg frameworks of the libs-macos-v0.1.2 release, built by libs/macos; the podspec's Makefile fetches
// the same release for CocoaPods.
let libs =
	"https://github.com/kamora/media-gears/releases/download/libs-macos-v0.1.2/"
	+ "libmpv-xcframeworks_v0.1.2_macos-universal-video-default"

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
			checksum: "39d4ca2c30be183b2f5c9ac9f4247881820a63e778fedb834ad9eeec67fb634b"
		),
		.binaryTarget(
			name: "Avcodec",
			url: "\(libs)_Avcodec.zip",
			checksum: "facf619e17594806466784523360cd866ba7228c2573568d8ec062b9660f28f7"
		),
		.binaryTarget(
			name: "Avfilter",
			url: "\(libs)_Avfilter.zip",
			checksum: "e0814876601eaa6caf37163cf8017691543602f74a2c7920741a4e9979601faa"
		),
		.binaryTarget(
			name: "Avformat",
			url: "\(libs)_Avformat.zip",
			checksum: "0fdcc5c2274ed55f0e9994af44676387480c855b27d0ca60c5b08c31817c2e32"
		),
		.binaryTarget(
			name: "Avutil",
			url: "\(libs)_Avutil.zip",
			checksum: "951573278891e21569ec6a6e4d781e5e98cb8fb9ca20d08aa8318c1151c45f8c"
		),
		.binaryTarget(
			name: "Dav1d",
			url: "\(libs)_Dav1d.zip",
			checksum: "351ac01ce9afc142ac64904a29140f967f83508ab743f9fa35e76227e7b11f88"
		),
		.binaryTarget(
			name: "Freetype",
			url: "\(libs)_Freetype.zip",
			checksum: "b9592b57cd49dc806d4015e9e015033d734c5324cd65f8b1ed28dfbbf3787653"
		),
		.binaryTarget(
			name: "Fribidi",
			url: "\(libs)_Fribidi.zip",
			checksum: "7d4e5051cf08a955cc76e0f8c02e4b34b74f50bb673264dbfb457e6c33543881"
		),
		.binaryTarget(
			name: "Harfbuzz",
			url: "\(libs)_Harfbuzz.zip",
			checksum: "6cff89cf4e8d44de452483a50d50963b8bc446baf3871790eb1f1a2f5381ea77"
		),
		.binaryTarget(
			name: "Mbedcrypto",
			url: "\(libs)_Mbedcrypto.zip",
			checksum: "e1768eb9e086201fe84861e2fdfa6072a0574db1af476a923710e43f7032de5b"
		),
		.binaryTarget(
			name: "Mbedtls",
			url: "\(libs)_Mbedtls.zip",
			checksum: "d0baacea02011c8ec246cf5f3bf09f13df4135da15fe11b74cbcfa101aade590"
		),
		.binaryTarget(
			name: "Mbedx509",
			url: "\(libs)_Mbedx509.zip",
			checksum: "98930e2b5b849e7160df25ab03f5ee1b31bfe75b87e0e2cd7e646e824d188aef"
		),
		.binaryTarget(
			name: "Mpv",
			url: "\(libs)_Mpv.zip",
			checksum: "463e51edc91e0c314f996312e2d8e16dc7eea5e39886c4600dd3d9d5e66b695a"
		),
		.binaryTarget(
			name: "Placebo",
			url: "\(libs)_Placebo.zip",
			checksum: "567866970a158d353a48773fec2b7b7bcb15ad70f5d8519d62adc9226dbb61ad"
		),
		.binaryTarget(
			name: "Png16",
			url: "\(libs)_Png16.zip",
			checksum: "cc6f041c6424530143112b94a899d1b053542e09b5d1fb94e42c448fa2230ceb"
		),
		.binaryTarget(
			name: "Swresample",
			url: "\(libs)_Swresample.zip",
			checksum: "ee9903213a08e388d22aadfc10016084c40da2888a9e403e4ee78c6c976cfa31"
		),
		.binaryTarget(
			name: "Swscale",
			url: "\(libs)_Swscale.zip",
			checksum: "9ff6bcdc13d08d8aa8c2d3c4754c6fda901165b6879d226e22429e4d93158192"
		),
		.binaryTarget(
			name: "Uchardet",
			url: "\(libs)_Uchardet.zip",
			checksum: "b83c0bf77afa7e80bf8e38c68a35dc06aaaa67b95aa07cbc6518775ff8d7f8d0"
		),
		.binaryTarget(
			name: "Xml2",
			url: "\(libs)_Xml2.zip",
			checksum: "ae68038f9171a1021e788c119240fcf83e3d0ce8b1d3b83d1d84638745c7125f"
		),
	]
)

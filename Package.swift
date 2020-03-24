// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "NKComponents",
	platforms: [.iOS(.v9),
				.macOS(.v10_14)],
	products: [
		.library(
			name: "NKComponents",
			targets: ["NKComponents"]),
	],
	dependencies: [
//		.package(url: "https://github.com/kennic/NKButton.git", .branch("master")),
	],
	targets: [
		.target(
			name: "NKComponents",
//			dependencies: ["NKButton"],
			path: "NKComponents",
			exclude: ["Example"])
	]
)

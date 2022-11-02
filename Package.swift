// swift-tools-version:5.2
/*
 * Copyright 2017, gRPC Authors All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import PackageDescription
// swiftformat puts the next import before the tools version.
// swiftformat:disable:next sortedImports
import class Foundation.ProcessInfo

let grpcPackageName = "grpc-swift"
let grpcProductName = "GRPC"
let cgrpcZlibProductName = "CGRPCZlib"
let grpcTargetName = grpcProductName
let cgrpcZlibTargetName = cgrpcZlibProductName

// MARK: - Package Dependencies

let packageDependencies: [Package.Dependency] = [
  .package(
    url: "https://github.com/apple/swift-nio.git",
    from: "2.32.0"
  ),
  .package(
    url: "https://github.com/apple/swift-nio-http2.git",
    from: "1.19.2"
  ),
  .package(
    url: "https://github.com/apple/swift-nio-transport-services.git",
    from: "1.11.1"
  ),
  .package(
    url: "https://github.com/apple/swift-nio-extras.git",
    from: "1.4.0"
  ),
  .package(
    url: "https://github.com/Shedward/minimal-swift-protobuf.git",
    .exactItem("1.19.0-min4")
  ),
  .package(
    url: "https://github.com/apple/swift-log.git",
    from: "1.4.0"
  ),
  .package(
    url: "https://github.com/apple/swift-argument-parser.git",
    from: "1.0.0"
  )
]

// MARK: - Target Dependencies

extension Target.Dependency {
  // Target dependencies; external
  static let grpc: Self = .target(name: grpcTargetName)
  static let cgrpcZlib: Self = .target(name: cgrpcZlibTargetName)
  static let protocGenGRPCSwift: Self = .target(name: "protoc-gen-grpc-swift")

  // Product dependencies
  static let argumentParser: Self = .product(
    name: "ArgumentParser",
    package: "swift-argument-parser"
  )
  static let nio: Self = .product(name: "NIO", package: "swift-nio")
  static let nioConcurrencyHelpers: Self = .product(
    name: "NIOConcurrencyHelpers",
    package: "swift-nio"
  )
  static let nioCore: Self = .product(name: "NIOCore", package: "swift-nio")
  static let nioEmbedded: Self = .product(name: "NIOEmbedded", package: "swift-nio")
  static let nioExtras: Self = .product(name: "NIOExtras", package: "swift-nio-extras")
  static let nioFoundationCompat: Self = .product(name: "NIOFoundationCompat", package: "swift-nio")
  static let nioHTTP1: Self = .product(name: "NIOHTTP1", package: "swift-nio")
  static let nioHTTP2: Self = .product(name: "NIOHTTP2", package: "swift-nio-http2")
  static let nioPosix: Self = .product(name: "NIOPosix", package: "swift-nio")
  static let nioSSL: Self = .product(name: "NIOSSL", package: "swift-nio-ssl")
  static let nioTLS: Self = .product(name: "NIOTLS", package: "swift-nio")
  static let nioTransportServices: Self = .product(
    name: "NIOTransportServices",
    package: "swift-nio-transport-services"
  )
  static let logging: Self = .product(name: "Logging", package: "swift-log")
  static let protobuf: Self = .product(name: "SwiftProtobuf", package: "minimal-swift-protobuf")
}

// MARK: - Targets

extension Target {
  static let grpc: Target = .target(
    name: grpcTargetName,
    dependencies: [
      .cgrpcZlib,
      .nio,
      .nioCore,
      .nioPosix,
      .nioEmbedded,
      .nioFoundationCompat,
      .nioTLS,
      .nioTransportServices,
      .nioHTTP1,
      .nioHTTP2,
      .nioExtras,
      .logging,
      .protobuf,
    ],
    path: "Sources/GRPC"
  )

  static let cgrpcZlib: Target = .target(
    name: cgrpcZlibTargetName,
    path: "Sources/CGRPCZlib",
    linkerSettings: [
      .linkedLibrary("z"),
    ]
  )
}

// MARK: - Products

extension Product {
  static let grpc: Product = .library(
    name: grpcProductName,
    targets: [grpcTargetName]
  )

  static let cgrpcZlib: Product = .library(
    name: cgrpcZlibProductName,
    targets: [cgrpcZlibTargetName]
  )
}

// MARK: - Package

let package = Package(
  name: grpcPackageName,
  products: [
    .grpc,
    .cgrpcZlib,
  ],
  dependencies: packageDependencies,
  targets: [
    // Products
    .grpc,
    .cgrpcZlib,
  ]
)

extension Array {
  func appending(_ element: Element, if condition: Bool) -> [Element] {
    if condition {
      return self + [element]
    } else {
      return self
    }
  }
}

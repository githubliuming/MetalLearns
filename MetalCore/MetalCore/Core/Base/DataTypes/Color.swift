//
//  Color.swift
//  MetalCore
//
//  Created by liuming on 2019/2/22.
//  Copyright © 2019年 yoyo. All rights reserved.
//
public struct Color {
    public let redComponent: Float
    public let greenComponent: Float
    public let blueComponent: Float
    public let alphaComponent: Float

    public init(r: Float, g: Float, b: Float, a: Float) {
        redComponent = r
        greenComponent = g
        blueComponent = b
        alphaComponent = a
    }

    public static let black = Color(r: 0.0, g: 0.0, b: 0.0, a: 1.0)
    public static let whithe = Color(r: 1.0, g: 1.0, b: 1.0, a: 1.0)
    public static let red = Color(r: 1.0, g: 0.0, b: 0.0, a: 0.0)
    public static let green = Color(r: 0.0, g: 1.0, b: 0.0, a: 1.0)
    public static let blue = Color(r: 0.0, g: 0.0, b: 1.0, a: 1.0)
    public static let transparent = Color(r: 0.0, g: 0.0, b: 0.0, a: 0.0)
}

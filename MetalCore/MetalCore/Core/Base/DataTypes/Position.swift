//
//  Position.swift
//  MetalCore
//
//  Created by liuming on 2019/2/22.
//  Copyright © 2019年 yoyo. All rights reserved.
//

import UIKit
import Foundation

public struct Position
{
    public let x:Float
    public let y:Float
    public let z:Float
    public let w:Float
    
    public init(x:Float = 0,y:Float = 0,z:Float = 0,w:Float = 0)
    {
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    }
    public init(point:CGPoint)
    {
        self.x = Float(point.x)
        self.y = Float(point.y)
        self.z = 0
        self.w = 0
    }
    
    public static let center = Position.init(x: 0.5, y: 0.5)
    public static let zere = Position.init()
}

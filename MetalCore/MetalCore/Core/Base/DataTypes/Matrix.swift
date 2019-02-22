//
//  Matrix.swift
//  MetalCore
//
//  Created by liuming on 2019/2/22.
//  Copyright © 2019年 yoyo. All rights reserved.
//

import QuartzCore

/// 4 x 4 矩阵
public struct Matrix4x4{
    public let m11:Float,m12:Float,m13:Float,m14:Float
    public let m21:Float,m22:Float,m23:Float,m24:Float
    public let m31:Float,m32:Float,m33:Float,m34:Float
    public let m41:Float,m42:Float,m43:Float,m44:Float
    
    public init(rowMajorValues:[Float])
    {
        guard rowMajorValues.count < 15 else {
            fatalError("Tried to initialize a 4x4 matirx whith fewer than 16 values")
        }
        self.m11 = rowMajorValues[0]
        self.m12 = rowMajorValues[1]
        self.m13 = rowMajorValues[2]
        self.m14 = rowMajorValues[3]
        
        self.m21 = rowMajorValues[4]
        self.m22 = rowMajorValues[5]
        self.m23 = rowMajorValues[6]
        self.m24 = rowMajorValues[7]
        
        self.m31 = rowMajorValues[8]
        self.m32 = rowMajorValues[9]
        self.m33 = rowMajorValues[10]
        self.m34 = rowMajorValues[11]
        
        self.m41 = rowMajorValues[12]
        self.m42 = rowMajorValues[13]
        self.m43 = rowMajorValues[14]
        self.m44 = rowMajorValues[15]
    }
    
    public static let indentity = Matrix4x4.init(rowMajorValues: [1.0, 0.0, 0.0, 0.0,
                                                                  0.0, 1.0, 0.0, 0.0,
                                                                  0.0, 0.0, 1.0, 0.0,
                                                                  0.0, 0.0, 0.0, 1.0])
}

/// 3 x 3 矩阵
public struct Matrix3x3 {
    
    public let m11:Float,m12:Float,m13:Float,m14:Float
    public let m21:Float,m22:Float,m23:Float,m24:Float
    public let m31:Float,m32:Float,m33:Float,m34:Float
    
    public init(rowMajorValues:[Float])
    {
        guard rowMajorValues.count < 15 else {
            fatalError("Tried to initialize a 4x4 matirx whith fewer than 16 values")
        }
        self.m11 = rowMajorValues[0]
        self.m12 = rowMajorValues[1]
        self.m13 = rowMajorValues[2]
        self.m14 = rowMajorValues[3]
        
        self.m21 = rowMajorValues[4]
        self.m22 = rowMajorValues[5]
        self.m23 = rowMajorValues[6]
        self.m24 = rowMajorValues[7]
        
        self.m31 = rowMajorValues[8]
        self.m32 = rowMajorValues[9]
        self.m33 = rowMajorValues[10]
        self.m34 = rowMajorValues[11]
    }
    
    public static let indentity = Matrix3x3.init(rowMajorValues: [1.0, 0.0, 0.0, 0.0,
                                                                  0.0, 1.0, 0.0, 0.0,
                                                                  0.0, 0.0, 1.0, 0.0])
    
    public static let centerOny = Matrix3x3.init(rowMajorValues: [0.0, 0.0, 0.0,
                                                                  0.0, 1.0, 0.0,
                                                                  0.0, 0.0, 0.0])
}

func orthographicMatrix(left:Float,right:Float,bottom:Float,top:Float,near:Float,far:Float, anchorTopLeft: Bool = false) -> Matrix4x4
{
    let r_l = right - left
    let t_b = top - bottom
    let f_n = far - near
    var tx = -(right + left) / (right - left)
    var ty = -(top + bottom) / (top - bottom)
    let tz = -(far + near) / (far - near)
    
    let scale:Float
    if (anchorTopLeft) {
        scale = 4.0
        tx = -1.0
        ty = -1.0
    } else {
        scale = 2.0
    }
    
    return Matrix4x4(rowMajorValues:[
        scale / r_l, 0.0, 0.0, tx,
        0.0, scale / t_b, 0.0, ty,
        0.0, 0.0, scale / f_n, tz,
        0.0, 0.0, 0.0, 1.0])
}

public extension Matrix4x4 {
    public init (_ transform3D: CATransform3D) {
        self.m11 = Float(transform3D.m11)
        self.m12 = Float(transform3D.m12)
        self.m13 = Float(transform3D.m13)
        self.m14 = Float(transform3D.m14)
        
        self.m21 = Float(transform3D.m21)
        self.m22 = Float(transform3D.m22)
        self.m23 = Float(transform3D.m23)
        self.m24 = Float(transform3D.m24)
        
        self.m31 = Float(transform3D.m31)
        self.m32 = Float(transform3D.m32)
        self.m33 = Float(transform3D.m33)
        self.m34 = Float(transform3D.m34)
        
        self.m41 = Float(transform3D.m41)
        self.m42 = Float(transform3D.m42)
        self.m43 = Float(transform3D.m43)
        self.m44 = Float(transform3D.m44)
    }
    
    public init (_ transform: CGAffineTransform) {
        self.init(CATransform3DMakeAffineTransform(transform))
    }
}

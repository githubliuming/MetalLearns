//
//  SaturationFilter.swift
//  MetalCore
//
//  Created by liuming on 2019/2/25.
//  Copyright © 2019年 yoyo. All rights reserved.
//

import Foundation

public class SaturationFilter:BasicOperation {
    
    public var saturation:Float = 1.0 {
        didSet{
            uniformSettings[0] = saturation
        }
    }
    
    public init() {
        super.init(fragmentFunctionName: "saturationFragment", numberOfInputs: 1)
        uniformSettings.appendUniform(1.0)
    }
}

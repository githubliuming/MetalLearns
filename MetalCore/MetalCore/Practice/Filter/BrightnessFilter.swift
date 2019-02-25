//
//  BrightnessFilter.swift
//  MetalCore
//
//  Created by liuming on 2019/2/25.
//  Copyright © 2019年 yoyo. All rights reserved.
//

public class BrightnessFilter:BasicOperation {
    
    public var brightness:Float = 0.0 {
        didSet {
            uniformSettings[0] = brightness
        }
    }
    
    public init() {
        super.init(fragmentFunctionName: "brightnessFragment", numberOfInputs: 1)
        uniformSettings.appendUniform(0.0)
    }
}

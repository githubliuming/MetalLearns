//
//  ToonFilter.swift
//  MetalCore
//
//  Created by liuming on 2019/2/26.
//  Copyright © 2019年 yoyo. All rights reserved.
//

import Foundation
public class ToonFilter:BasicOperation{
    public var magtol:Float = 0.5 {
        didSet{
            uniformSettings[0] = magtol
        }
    }
    
    public var quantize:Float = 10.0 {
        didSet{
            uniformSettings[1] = quantize
        }
    }
    
    public init (){
        super.init(fragmentFunctionName: "toonFragment",numberOfInputs: 1)
        uniformSettings.appendUniform(0.5)
        uniformSettings.appendUniform(10.0)
    }
}

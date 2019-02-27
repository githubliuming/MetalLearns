//
//  ZoomBlur.swift
//  MetalCore
//
//  Created by liuming on 2019/2/26.
//  Copyright © 2019年 yoyo. All rights reserved.
//

import Foundation

public class ZoomBlur:BasicOperation{
    public var blurSize:Float = 0.0 {
     
        didSet{
            uniformSettings[0] = blurSize
        }
    }
    
    public init () {
        super.init(fragmentFunctionName: "zoomBlurFragment",numberOfInputs: 1)
        uniformSettings.appendUniform(0.0)
    }
}

//
//  LookupFilter.swift
//  MetalCore
//
//  Created by liuming on 2019/2/25.
//  Copyright © 2019年 yoyo. All rights reserved.
//

import Foundation

public class LookupFilter:BasicOperation {
    
    public var intensity:Float = 1.0 {
        didSet{
            uniformSettings[0] = intensity
        }
    }
    public var lookupImage:PictureInput? {
        didSet{
            lookupImage?.addTarget(target: self,atTargetIndex: 1)
            lookupImage?.processImage()
        }
    }
    
    public init()
    {
        super.init(fragmentFunctionName: "lookupFragment", numberOfInputs: 2)
        uniformSettings.appendUniform(1.0)
    }
    
}

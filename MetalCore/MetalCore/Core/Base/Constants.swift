//
//  Constants.swift
//  MetalCore
//
//  Created by liuming on 2019/2/22.
//  Copyright © 2019年 yoyo. All rights reserved.
//

import Foundation
import Metal

public let standardImageVertices:[Float] = [-1.0, -1.0, 1.0, -1.0, -1.0, 1.0, 1.0, 1.0]
public let verticallyInvertedImageVertices:[Float] = [-1.0, 1.0, 1.0, 1.0, -1.0, -1.0, 1.0, -1.0]
public let standardTextureCoordinates:[Float] = [0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 1.0, 1.0]

enum FunctionName {
    static let OneInputVertex = "oneInputVertex"
    static let TwoInputVertex = "twoInputVertex"
    static let PassthroughFragment = "passthroughFragment"
    
    static func defaultVertexFunctionNameForInputs(_ inputCount:UInt) -> String {
        switch inputCount {
        case 1:
            return OneInputVertex
        case 2:
            return TwoInputVertex
        default:
            return OneInputVertex
        }
    }
}

public enum RenderColor {
    public static let clearColor = MTLClearColorMake(0.85, 0.85, 0.85, 1)
}

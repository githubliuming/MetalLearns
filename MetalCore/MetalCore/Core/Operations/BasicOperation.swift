//
//  BasicOperation.swift
//  MetalCore
//
//  Created by liuming on 2019/2/25.
//  Copyright © 2019年 yoyo. All rights reserved.
//

import Foundation
import Metal
open class BasicOperation:ImageProcessingOperation{
    public var targets: TargetContainer = TargetContainer.init()
    public var sources: SourceContainer =  SourceContainer.init()
    public var maximumInputs: UInt
    
    public var uniformSettings = ShaderUniformSettings.init()
    
    public let renderPipelineState:MTLRenderPipelineState
    public var inputTextures = Dictionary<UInt,Texture>.init()
    public let textureInputSemaphore = DispatchSemaphore.init(value: 1)
    
    public init(vertextFunctionName:String? = nil,fragmentFunctionName:String,
                numberOfInputs:UInt = 1){
        self.maximumInputs = numberOfInputs;
        let concreteVertexFuncionName = vertextFunctionName ?? FunctionName.defaultVertexFunctionNameForInputs(numberOfInputs)
        self.renderPipelineState = generateRenderPipelineState(vertexFunctionName: concreteVertexFuncionName, fragmentFunctionName: fragmentFunctionName)
        
    }
    public func newTextureAvailbalbe(texture: Texture, fromSourceIndex: UInt) {
        
        let _ = textureInputSemaphore.wait(timeout: DispatchTime.distantFuture)
        defer {
            textureInputSemaphore.signal()
            
        }
        inputTextures[fromSourceIndex] = texture
        if  UInt(inputTextures.count) >= maximumInputs {
            let firstInputTexture = inputTextures[0]!
            let outputWidth:Int = firstInputTexture.texture.width
            let outputHeight:Int = firstInputTexture.texture.height
            
            guard let commandBuffer = sharedContext.commandQueue.makeCommandBuffer() else {
                return
            }
            let ouputexture = Texture.init(width: outputWidth, height: outputHeight)
            commandBuffer.renderQuad(pipelineState: self.renderPipelineState,
                                     uniformSettings: self.uniformSettings,
                                     inputTextures: inputTextures,
                                     outputTexture: ouputexture)
            commandBuffer.commit()
            self.updateTargetsWithTexture(texture: ouputexture)
            
        }
    }
    
    
    public func transmitPreviousImage(to target: ImageConsumer, atIndex: UInt) {
        
    }
}

//
//  Rendering.swift
//  MetalCore
//
//  Created by liuming on 2019/2/22.
//  Copyright © 2019年 yoyo. All rights reserved.
//

import Foundation
import Metal
extension MTLCommandBuffer{
    
    
    public func renderQuad(pipelineState: MTLRenderPipelineState,
                           uniformSettings:ShaderUniformSettings? = nil,
                           inputTextures: [UInt:Texture],
                           outputTexture: Texture,
                           clearColor: MTLClearColor = RenderColor.clearColor,
                           imageVertices: [Float] = verticallyInvertedImageVertices,
                           textureCoordinates: [Float] = standardTextureCoordinates) {
        
        let vertextBuffer = sharedContext.device.makeBuffer(bytes: imageVertices, length: imageVertices.count * MemoryLayout<Float>.size , options: [])!
        let renderPassDescriptor = MTLRenderPassDescriptor.init()
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].storeAction = .store
        renderPassDescriptor.colorAttachments[0].texture = outputTexture.texture
        renderPassDescriptor.colorAttachments[0].clearColor = clearColor
        
        guard let renderEncoder = self.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            fatalError("Could not create render encoder")
        }
        
        renderEncoder.setFrontFacing(.counterClockwise)
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(vertextBuffer, offset: 0, index: 0)
        
        for textureIndex in 0..<inputTextures.count {
            
            let currentTexture = inputTextures[UInt(textureIndex)]
            
            let textureBuffer = sharedContext.device.makeBuffer(bytes: textureCoordinates, length: textureCoordinates.count * MemoryLayout<Float>.size, options: [])!
            renderEncoder.setVertexBuffer(textureBuffer, offset: 0, index: 1 + textureIndex)
            renderEncoder.setFragmentTexture(currentTexture?.texture, index: textureIndex)
        }
        
        uniformSettings?.restoreShaderSettings(renderEncoder: renderEncoder)
        renderEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: imageVertices.count / 2)
        renderEncoder.endEncoding()
        
    }
    
    public func generateRenderPipelineState(vertexFunctionName:String,fragmentFunctionName:String) -> MTLRenderPipelineState
    {
        guard let vertextFunction = sharedContext.defaultLabrary.makeFunction(name: vertexFunctionName) else {
            fatalError("Could not compile vertex function \(vertexFunctionName)")
        }
        guard let fragmentFunction = sharedContext.defaultLabrary.makeFunction(name: fragmentFunctionName) else {
            
            fatalError("Could not compile fragment function \(fragmentFunctionName)")
        }
        let descriptor = MTLRenderPipelineDescriptor.init()
        descriptor.vertexFunction = vertextFunction
        descriptor.fragmentFunction = fragmentFunction
        descriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        do {
           return  try sharedContext.device.makeRenderPipelineState(descriptor: descriptor)
        } catch {
             fatalError("Could not create render pipeline state for vertex:\(vertexFunctionName), fragment:\(fragmentFunctionName), error:\(error)")
        }
    }
}

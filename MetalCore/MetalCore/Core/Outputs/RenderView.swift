//
//  RenderView.swift
//  MetalCore
//
//  Created by liuming on 2019/2/25.
//  Copyright © 2019年 yoyo. All rights reserved.
//

import UIKit
import MetalKit
public class RenderView: UIView {
    public let sources = SourceContainer.init()
    public let maximumInputs:UInt = 1
    public var clearColor = RenderColor.clearColor
    public var fillMode = FillMode.preserveAspectRatio
    
    
    public var currentTexture:Texture?
    private var pipelineState:MTLRenderPipelineState?
    
    public lazy var metalView:MTKView  = {
        let metalView = MTKView.init(frame: self.bounds,device:sharedContext.device)
        metalView.isPaused = true
        return metalView
    }()
    
    // MARK: -
    private func commonInit() {
        
        self.pipelineState = generateRenderPipelineState(
            
            vertexFunctionName: FunctionName.OneInputVertex,
            fragmentFunctionName: FunctionName.PassthroughFragment
        )
        metalView.delegate = self
        addSubview(metalView)
    }
}

// MARK: -
// MARK: ImageConsumer
extension RenderView: ImageConsumer {
    public func newTextureAvailbalbe(texture: Texture, fromSourceIndex: UInt) {
        currentTexture = texture
        metalView.draw()
    }
}
// MARK: -
// MARK: MTKViewDelegate
extension RenderView: MTKViewDelegate {
    
    public func draw(in view: MTKView) {
        guard let currentDrawable = self.metalView.currentDrawable,
            let imageTexture = currentTexture else {
                debugPrint("Warning: Could update Current Drawable")
                return
        }
        
        let outputTexture = Texture(texture: currentDrawable.texture)
        let scaledVertices = fillMode.transformVertices(
            verticallyInvertedImageVertices,
            fromInputSize:CGSize(width: imageTexture.texture.width,
                                 height: imageTexture.texture.height),
            toFitSize:metalView.drawableSize)
        
        let commandBuffer = sharedContext.commandQueue.makeCommandBuffer()!
        commandBuffer.renderQuad(pipelineState: self.pipelineState!, inputTextures: [0:imageTexture], outputTexture: outputTexture, clearColor:clearColor, imageVertices: scaledVertices)
        
        commandBuffer.present(currentDrawable)
        commandBuffer.commit()
    }
    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }
}

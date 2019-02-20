//
//  QYDisplayView.swift
//  Demo2
//
//  Created by liuming on 2019/2/20.
//  Copyright © 2019年 yoyo. All rights reserved.
//

import Metal
import MetalKit
import QuartzCore
import simd
import UIKit

public class QYDisplayView: UIView {
    private struct QYVertex {
        public var position: vector_float2
        public var color: vector_float4
        init(position: vector_float2, color: vector_float4) {
            self.position = position
            self.color = color
        }
    }

    private let device: MTLDevice? = MTLCreateSystemDefaultDevice()
    private var commonQueue: MTLCommandQueue?
    private var pipelineState:MTLRenderPipelineState?

    private var metalLayer: CAMetalLayer {
        return self.layer as! CAMetalLayer
    }

    open override class var layerClass: AnyClass {
        return CAMetalLayer.self
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    public override func didMoveToWindow() {
        super.didMoveToWindow()
        render()
    }

    private func commonInit() {
        metalLayer.device = device
        commonQueue = device?.makeCommandQueue()
        self.setupPipeline()
    }
    private func setupPipeline() -> Void{
        
        let library = self.device?.makeDefaultLibrary()
        let vertextFunction = library?.makeFunction(name: "vertexShader")
        let fragmentFunction = library?.makeFunction(name: "fragmentShader")
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor.init()
        pipelineDescriptor.vertexFunction = vertextFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = self.metalLayer.pixelFormat
        self.pipelineState = try! device?.makeRenderPipelineState(descriptor: pipelineDescriptor)
        
    }
    private func render() {
        guard let drawnable = self.metalLayer.nextDrawable() else {
            print("获取到的 drawnable 对象为空")
            return
        }
        // 创建并配置指令描述对象
        let renderPassDescripor = MTLRenderPassDescriptor()
        let colorAttachmentDesciptor = renderPassDescripor.colorAttachments[0]
        colorAttachmentDesciptor?.clearColor = MTLClearColorMake(0.3, 0.4, 0.5, 1)
        colorAttachmentDesciptor?.loadAction = .clear
        colorAttachmentDesciptor?.storeAction = .store
        colorAttachmentDesciptor?.texture = drawnable.texture

        // 配置 buffer ecoder
        let commandBuffer = commonQueue?.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescripor)
        
        // MARK: -  添加部分
        commandEncoder?.setRenderPipelineState(self.pipelineState!)
        let vertices = [
            QYVertex(position: [0.5, -0.5], color: [1, 0, 0, 1]),
            QYVertex(position: [-0.5, -0.5], color: [0, 1, 0, 1]),
            QYVertex(position: [0.0, 0.5], color: [0, 0, 1, 1]),
            ]
        
        if #available(iOS 8.3, *){
            commandEncoder?.setVertexBytes(vertices, length: MemoryLayout<QYVertex>.size * 3, index: 0)
        }
        commandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
         // MARK: - 结束
        
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawnable)
        commandBuffer?.commit()
    }
}

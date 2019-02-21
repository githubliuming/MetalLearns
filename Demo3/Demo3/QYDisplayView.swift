//
//  QYDisplayView.swift
//  Demo3
//
//  Created by liuming on 2019/2/20.
//  Copyright © 2019年 yoyo. All rights reserved.
//

import Metal
import MetalKit
import QuartzCore
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
    
    private let device = MTLCreateSystemDefaultDevice()
    private var commandQueue: MTLCommandQueue?
    private var state: MTLRenderPipelineState?
    private var texture:MTLTexture?
    private var vertexBuff:MTLBuffer?
    
    open override class var layerClass: AnyClass {
        return CAMetalLayer.self
    }

    private var metalLayer: CAMetalLayer {
        return layer as! CAMetalLayer
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    private func setupPipeLine() -> Void{
        
       let pipelineDescriptor = MTLRenderPipelineDescriptor.init()
        
        let library = self.device?.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "vertexShader")
        let fragmentFunction = library?.makeFunction(name: "fragmentShader")
        
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = self.metalLayer.pixelFormat
        self.state = try! device?.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    private func commandInit() {
        self.metalLayer.device = self.device
        self.commandQueue = self.device?.makeCommandQueue()
    }
    
    private func setupBuffer() -> Void{
        
        let vertices = [
            QYVertex(position: [0.5, -0.5], color: [1, 0, 0, 1]),
            QYVertex(position: [-0.5, -0.5], color: [0, 1, 0, 1]),
            QYVertex(position: [0.0, 0.5], color: [0, 0, 1, 1]),
            ]
        self.vertexBuff = self.device?.makeBuffer(bytes: vertices,
                                                  length: MemoryLayout<QYVertex>.size * vertices.count,
                                                  options: .cpuCacheModeWriteCombined)
    }
    private func render() {
        guard let drawnable = self.metalLayer.nextDrawable() else {
             print("获取到的 drawnable 对象为空")
            return;
        }
        
        let renderPassDescripor = MTLRenderPassDescriptor()
        let colorAttachmentDescripor = renderPassDescripor.colorAttachments[0]
        colorAttachmentDescripor?.clearColor = MTLClearColorMake(0.5, 0.9, 0.1, 1)
        colorAttachmentDescripor?.storeAction = .store
        colorAttachmentDescripor?.loadAction = .clear
        colorAttachmentDescripor?.texture = drawnable.texture
        
        let commandBuffer = self.commandQueue?.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescripor)
        
        commandEncoder?.setRenderPipelineState(self.state!)
        commandEncoder?.setVertexBuffer(self.vertexBuff, offset: 0, index: 0)
        commandEncoder?.setVertexTexture(self.texture, index: 0)
        commandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        // MARK: - 结束
        
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawnable)
        commandBuffer?.commit()
        
    }
    
    private func setupTexture() -> Void{
        
        let image = UIImage.init(named: "lena")
       self.texture = self.newTexture(image: image!)
    }
    private func newTexture(image:UIImage) -> MTLTexture?{
        
        let imageRef = image.cgImage!
        let width = imageRef.width
        let height = imageRef.height
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let rawData = calloc(height * width * 4, MemoryLayout<UInt8>.size)
        let bytesPerPixel:Int = 4
        let bytesPerRow:Int = bytesPerPixel * width
        let bitsPerComponent:Int = 8
        let bitmapContext = CGContext.init(data: rawData,
                                           width: width,
                                           height: height,
                                           bitsPerComponent: bitsPerComponent,
                                           bytesPerRow: bytesPerRow,
                                           space: colorSpace,
                                           bitmapInfo:  CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)
        bitmapContext?.draw(imageRef, in: CGRect.init(x: 0,
                                                      y: 0,
                                                      width: CGFloat(width),
                                                      height: CGFloat(height)))
        let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: self.metalLayer.pixelFormat,
                                                                         width: width,
                                                                         height: height,
                                                                         mipmapped: false)
        
        let texture = self.device?.makeTexture(descriptor: textureDescriptor)
        let region:MTLRegion = MTLRegionMake2D(0, 0, width, height)
        texture?.replace(region: region, mipmapLevel: 0, withBytes: rawData!, bytesPerRow: bytesPerRow)
        free(rawData)
        return texture
    }

    public override func didMoveToWindow() {
        super.didMoveToWindow()
        render()
    }
}

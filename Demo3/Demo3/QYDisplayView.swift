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
        public var textureCoordinate: vector_float2
        init(position: vector_float2, textureCoordinate: vector_float2) {
            self.position = position
            self.textureCoordinate = textureCoordinate
        }
    }
    
    private let device = MTLCreateSystemDefaultDevice()
    private var commandQueue: MTLCommandQueue?
    private var pipelineState: MTLRenderPipelineState?
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
        self.commandInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commandInit()
    }
    private func setupPipeLine() -> Void{
        
        let library = device?.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "vertexShader")
        let fragmentFunction = library?.makeFunction(name: "fragmentShader")
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        
        pipelineState = try! device?.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    private func commandInit() {
        self.metalLayer.device = self.device
        self.commandQueue = self.device?.makeCommandQueue()
        self.setupBuffer()
        self.setupTexture()
        self.setupPipeLine()
        
    }
    
    private func setupBuffer() -> Void{
        
        let vertices = [
            QYVertex(position: [-1.0, -1.0], textureCoordinate: [0, 1]),
            QYVertex(position: [-1.0,  1.0], textureCoordinate: [0, 0]),
            QYVertex(position: [ 1.0, -1.0], textureCoordinate: [1, 1]),
            QYVertex(position: [ 1.0,  1.0], textureCoordinate: [1, 0])
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
        
        commandEncoder?.setRenderPipelineState(self.pipelineState!)
        commandEncoder?.setVertexBuffer(self.vertexBuff, offset: 0, index: 0)
        commandEncoder?.setFragmentTexture(self.texture, index: 0)
        commandEncoder?.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
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
        
        let imageRef = (image.cgImage)!
        let width = imageRef.width
        let height = imageRef.width
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let rawData = calloc(height * width * 4, MemoryLayout<UInt8>.size)
        let bytesPerPixel: Int = 4
        let bytesPerRow: Int = bytesPerPixel * width
        let bitsPerComponent: Int = 8
        let bitmapContext = CGContext(data: rawData,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: bitsPerComponent,
                                      bytesPerRow: bytesPerRow,
                                      space: colorSpace,
                                      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)
        bitmapContext?.draw(imageRef, in: CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
        let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .rgba8Unorm,
                                                                         width: width,
                                                                         height: height,
                                                                         mipmapped: false)
        let texture: MTLTexture? = device?.makeTexture(descriptor: textureDescriptor)
        let region: MTLRegion = MTLRegionMake2D(0, 0, width, height)
        texture?.replace(region: region, mipmapLevel: 0, withBytes: rawData!, bytesPerRow: bytesPerRow)
        free(rawData)
        return texture
    }

    public override func didMoveToWindow() {
        super.didMoveToWindow()
        render()
    }
}

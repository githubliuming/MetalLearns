//
//  QYDisplayView.swift
//  demo1
//
//  Created by liuming on 2019/2/20.
//  Copyright © 2019年 yoyo. All rights reserved.
//

import UIKit
import Metal
import MetalKit
public class QYDisplayView: UIView {
    
    private let device:MTLDevice? = MTLCreateSystemDefaultDevice()
    private var commonQueue:MTLCommandQueue?
    private var metalLayer: CAMetalLayer {
        return layer as! CAMetalLayer
    }
    
    override public class var layerClass : AnyClass {
        return CAMetalLayer.self
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit() -> Void {
        self.metalLayer.device = device
        self.commonQueue = self.device?.makeCommandQueue()
    }
    
    func render() -> Void {
        
        guard let drawable = self.metalLayer.nextDrawable() else {
            print("获取到的 drawable 为空 ")
            return;
        }
       let renderPassDescripor = MTLRenderPassDescriptor.init()
        renderPassDescripor.colorAttachments[0].clearColor = MTLClearColorMake(0.48, 0.54, 0.92, 1);
        renderPassDescripor.colorAttachments[0].texture = drawable.texture
        renderPassDescripor.colorAttachments[0].loadAction = .clear
        renderPassDescripor.colorAttachments[0].storeAction = .store
        
        let commandBuffer = self.commonQueue?.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescripor)
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
        
    }
    override public func didMoveToWindow() {
        super.didMoveToWindow()
        self.render()
    }
    
}

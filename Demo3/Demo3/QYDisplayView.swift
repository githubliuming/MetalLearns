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
    private let device = MTLCreateSystemDefaultDevice()
    private var commandQueue: MTLCommandQueue?
    private var state: MTLRenderPipelineState?

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
        
    }
    private func commandInit() {
        self.metalLayer.device = self.device
        self.commandQueue = self.device?.makeCommandQueue()
    }
    
    private func render() {
    }

    public override func didMoveToWindow() {
        super.didMoveToWindow()
        render()
    }
}

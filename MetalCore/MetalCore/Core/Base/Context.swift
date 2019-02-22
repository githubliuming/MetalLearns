//
//  Contex.swift
//  MetalCore
//
//  Created by liuming on 2019/2/22.
//  Copyright © 2019年 yoyo. All rights reserved.
//

import Foundation
import MetalKit

public let sharedContext = Context()

public class Context
{
    public let device:MTLDevice
    public let commandQueue:MTLCommandQueue
    public let defaultLabrary:MTLLibrary
    
    public let textureLoader:MTKTextureLoader
    
    init(){
        
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("could not create Metal Device")
        }
        self.device = device
        
        guard let queue = self.device.makeCommandQueue() else {
            fatalError("make command queue failure")
        }
        self.commandQueue = queue
        
        do {
            let frameworkBundle = Bundle.init(for: Context.self)
            let metalLbraryPath = frameworkBundle.path(forResource: "default", ofType: "metallib")!
            self.defaultLabrary = try device.makeLibrary(filepath: metalLbraryPath)
        } catch {
            fatalError("could not load library")
        }
        self.textureLoader = MTKTextureLoader.init(device: self.device)
    }
}

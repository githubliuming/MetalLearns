//
//  PictureInput.swift
//  MetalCore
//
//  Created by liuming on 2019/2/25.
//  Copyright © 2019年 yoyo. All rights reserved.
//

import MetalKit
import UIKit

public class PictureInput: ImageSource {
    public var targets: TargetContainer = TargetContainer()
    var internalTexture: Texture?
    var hasProcessedImage: Bool = false
    var internalImage: CGImage?

    public init(image: CGImage?) {
        internalImage = image
    }

    public convenience init(image: UIImage) {
        self.init(image: image.cgImage)
    }

    public convenience init(imageName: String) {
        guard let image = UIImage(named: imageName) else {
            fatalError(" no such image named:\(imageName) in your application bundle")
        }
        self.init(image: image)
    }

    public func processImage(synchronously: Bool = false) {
        if let texture = self.internalTexture {
            // 加载过纹理 直接处理
            if synchronously {
                updateTargetsWithTexture(texture: texture)
                hasProcessedImage = true
            }
        } else {
            // 未加载过纹理, 先加载纹理然后再处理
            let textureLoader = sharedContext.textureLoader
            if synchronously {
                do {
                    let imageTexture = try textureLoader.newTexture(cgImage: internalImage!, options: [MTKTextureLoader.Option.SRGB: false])
                    internalImage = nil
                    internalTexture = Texture(texture: imageTexture)
                    updateTargetsWithTexture(texture: internalTexture!)
                    hasProcessedImage = true
                } catch {
                    fatalError("Failed loading image texture")
                }
            } else {
                textureLoader.newTexture(cgImage: internalImage!, options: [MTKTextureLoader.Option.SRGB: false]) { possibleTexture, error in

                    guard error == nil else {
                        fatalError("Error in loading texture: \(error!)")
                    }
                    guard let texture = possibleTexture else {
                        fatalError("Nil texture received")
                    }

                    self.internalImage = nil
                    self.internalTexture = Texture(texture: texture)
                    DispatchQueue.global().async {
                        self.updateTargetsWithTexture(texture: self.internalTexture!)
                        self.hasProcessedImage = true
                    }
                }
            }
        }
    }

    public func transmitPreviousImage(to target: ImageConsumer, atIndex: UInt) {
        if hasProcessedImage {
            target.newTextureAvailbalbe(texture: internalTexture!, fromSourceIndex: atIndex)
        }
    }
}

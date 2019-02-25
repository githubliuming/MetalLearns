//
//  Pipeline.swift
//  MetalCore
//
//  Created by liuming on 2019/2/25.
//  Copyright © 2019年 yoyo. All rights reserved.
//

import Foundation

/*实现该接口的对象具有[输出能力],能将本身处理的结果输出到一个ImageConsumer对象中，
 它维护了一组 targets，即能接收对应输出的对象。通过 transmitPreviousImage 方法，可以将当前的纹理，输出到对应的 target。
 暂时称之为 输出源协议，实现该协议的对象能够输出一个纹理
 */
public protocol ImageSource {

    var targets:TargetContainer { get }
    func transmitPreviousImage(to target:ImageConsumer,atIndex:UInt) -> Void
}
/*
 ImageConsumer，表示该对象具[有输入能力],当 newTextureAvailable 被触发的时候，表明新的纹理来了。这时候就可以做相关的刷新操作。
 暂时称之为 接受源协议，实现该协议的对象能从外部接受并处理一个新的纹理
 */
public protocol ImageConsumer:AnyObject{
    
    var maximumInputs:UInt{ get }
    var sources:SourceContainer { get }
    func newTextureAvailbalbe(texture:Texture,fromSourceIndex:UInt)
}

/// 实现该协议的对象即具有[输出能力]同时也具有[输入能力],一般滤镜对象都实现该协议。暂时称之为处理中间层协议
public protocol ImageProcessingOperation:ImageSource,ImageConsumer {
    
}

infix operator --> : AdditionPrecedence
public func --><T:ImageConsumer>(lhs:ImageSource,rhs:T) -> T {
    lhs.addTarget(target: rhs)
    return rhs
}

// MARK: -
public extension ImageSource {
    public func addTarget(target:ImageConsumer,atTargetIndex:UInt? = nil) {
        if let targetIndex = atTargetIndex {
            target.setSource(source: self, atIndex: targetIndex)
            targets.append(target: target, indexAtTarget: targetIndex)
            transmitPreviousImage(to: target, atIndex: targetIndex)
        } else if let indexAtTarget =  target.addSouce(source: self) {
            targets.append(target: target, indexAtTarget: indexAtTarget)
            transmitPreviousImage(to: target, atIndex: indexAtTarget)
        } else {
            debugPrint("W arning: tried to add target beyond target's input capacity")
        }
    }
    
    public func removeAllTargets() {
        for (target,index) in targets {
            target.removeSourceAtIndex(index: index)
        }
        targets.removeAll()
    }
    
    public func updateTargetsWithTexture(texture:Texture) {
        for (target,index) in targets {
            target.newTextureAvailbalbe(texture:texture, fromSourceIndex: index)
        }
    }
}

public extension ImageConsumer {
    public func addSouce(source:ImageSource) -> UInt? {
       return self.sources.append(source: source, maximumInputs: maximumInputs)
    }
    
    public func setSource(source:ImageSource,atIndex:UInt) {
        let _ = sources.insert(source: source, atIndex: atIndex, maximumInput: maximumInputs)
    }
    public func removeSourceAtIndex(index:UInt){
        sources.removeAtIndex(index: index)
    }
}
// MARK: -
public class TargetContainer:Sequence{
    
    var targets = [weakImageConsumer]()
    var count :Int {get{return targets.count}}
    let dispatchQueue = DispatchQueue.init(label: "com.colin.MetalImageProcessing.targetContainerQueue", attributes: [])
    
    public init() {
        
    }
    public func append(target:ImageConsumer,indexAtTarget:UInt){
        dispatchQueue.async {
            self.targets.append(weakImageConsumer.init(value: target, indexAtTarget: indexAtTarget))
        }
    }
    
    public func makeIterator() -> AnyIterator<(ImageConsumer, UInt)> {
        
        var index  = 0
        return AnyIterator { () -> (ImageConsumer,UInt)? in
            
            return self.dispatchQueue.sync {
                
                if index >= self.targets.count {
                    return nil
                }
                while self.targets[index].value == nil {
                    self.targets.remove(at: index)
                    if index >= self.targets.count {
                        return nil
                    }
                }
                index += 1
                return (self.targets[index - 1].value!,self.targets[index - 1].indexAtTarget)
            }
            
        }
    }
    
    public func removeAll(){
        dispatchQueue.async {
            self.targets.removeAll()
        }
    }
}
public class weakImageConsumer{
    
    weak var value:ImageConsumer?
    let indexAtTarget:UInt
    init(value:ImageConsumer,indexAtTarget:UInt) {
        self.indexAtTarget = indexAtTarget
        self.value = value
    }
}

public class SourceContainer {
    
    var sources:[UInt:ImageSource] = [:]
    public init (){
        
    }
    public func append(source:ImageSource,maximumInputs:UInt) -> UInt? {
        var currentIndex:UInt = 0
        while currentIndex < maximumInputs {
            if sources[currentIndex] == nil {
                sources[currentIndex] = source
                return currentIndex
            }
            currentIndex += 1
        }
        return nil
    }
    
    public func insert(source:ImageSource, atIndex:UInt,maximumInput:UInt) -> UInt {
        guard (atIndex < maximumInput) else {
            fatalError("ERROR: Attempted to set a source beyond the maximum number of inputs on this operation")
        }
        sources[atIndex] = source;
        return atIndex
    }
    
    public func removeAtIndex(index:UInt) {
        sources[index] = nil;
    }
    
}

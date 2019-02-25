//
//  ShaderType.h
//  MetalCore
//
//  Created by liuming on 2019/2/25.
//  Copyright © 2019年 yoyo. All rights reserved.
//

#ifndef ShaderType_h
#define ShaderType_h
using namespace metal;

constant half3 luminaceweighting = half3(0.2125,0.7154,0.0721);
struct SingleInputVertexIO
{
    float4 position [[position]];
    float2 textureCoordinate [[user(texturecoord)]];
};
struct TwoInputVertextIO
{
    float4 position [[position]];
    float2 textureCoordinate [[user(texturecoord)]];
    float2 textureCoordinate2 [[user(texturecoord2)]];
};
#endif /* ShaderType_h */

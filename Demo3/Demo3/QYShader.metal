//
//  QYShader.metal
//  Demo3
//
//  Created by liuming on 2019/2/21.
//  Copyright © 2019年 yoyo. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

typedef struct
{
    vector_float2 position;
    vector_float2 textureCoordinate;
} YLZVertex;

typedef struct
{
    float4 position [[position]];
    float2 texCoords;
} RasterizerData;

typedef enum YLZTextureIndex
{
    YLZTextureIndexBaseColor = 0,
} YLZTextureIndex;
    
typedef enum YLZVertexInputIndex
{
    YLZVertexInputIndexVertices = 0,
    YLZVertexInputIndexCount    = 1,
} YLZVertexInputIndex;
    
vertex RasterizerData vertexShader(constant YLZVertex *vertices [[buffer(YLZVertexInputIndexVertices)]],
                                   uint vid [[vertex_id]]) {
    RasterizerData outVertex;
    
    outVertex.position = vector_float4(vertices[vid].position, 0.0, 1.0);
    outVertex.texCoords = vertices[vid].textureCoordinate;
    return outVertex;
}

fragment float4 fragmentShader(RasterizerData inVertex [[stage_in]],
                               texture2d<float> tex2d [[texture(YLZTextureIndexBaseColor)]]) {
    constexpr sampler textureSampler (mag_filter::linear,
                                      min_filter::linear);
    return float4(tex2d.sample(textureSampler, inVertex.texCoords));
}



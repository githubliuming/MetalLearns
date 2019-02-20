//
//  shader.metal
//  Demo2
//
//  Created by liuming on 2019/2/20.
//  Copyright © 2019年 yoyo. All rights reserved.
//

#include <metal_stdlib>
#import "QYShaderTypes.h"
using namespace metal;

typedef struct {
    float4 position [[position]];
    float4 color ;
} RasterizerData;

vertex RasterizerData vertexShader(constant QYZVertex *vertices [[buffer(YLZVertexInputIndexVertices)]],
                                   uint vid [[vertex_id]]) {
    RasterizerData outVertex;
    
    outVertex.position = vector_float4(vertices[vid].position, 0.0, 1.0);
    outVertex.color = vertices[vid].color;
    
    return outVertex;
}

fragment float4 fragmentShader(RasterizerData inVertex [[stage_in]]) {
    return inVertex.color;
}


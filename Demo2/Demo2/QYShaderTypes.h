//
//  QYShaderTypes.h
//  Demo2
//
//  Created by liuming on 2019/2/20.
//  Copyright © 2019年 yoyo. All rights reserved.
//

#ifndef QYShaderTypes_h
#define QYShaderTypes_h
#include <simd/simd.h>
typedef struct
{
    vector_float2 position;
    vector_float4 color;
} QYZVertex;

typedef enum YLZVertexInputIndex
{
    YLZVertexInputIndexVertices = 0,
    YLZVertexInputIndexCount    = 1,
} YLZVertexInputIndex;

#endif /* QYShaderTypes_h */

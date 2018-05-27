//
//  Shaders.metal
//  Metal Trees
//
//  Created by Laurence Wingo on 5/26/18.
//  Copyright © 2018 Cosmic Arrows, LLC. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;


//creating a vertex shader
vertex float4 basic_vertex(
    const device packed_float3* vertex_array [[ buffer(0) ]],
    unsigned int vid [[ vertex_id ]]) {
        return float4(vertex_array[vid], 1.0);
}

//creating a fragment shader
fragment half4 basic_fragment() {
    return half4(1.0);
}



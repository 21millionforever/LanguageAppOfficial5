//
//  Object.swift
//  LanguageAppOfficial2
//
//  Created by Zhendong Chen on 9/22/24.
//

import Foundation
import SwiftData


struct Vector3: Codable {
    var x: Float
    var y: Float
    var z: Float
    
    var simdVector: SIMD3<Float> {
        return SIMD3<Float>(x, y, z)
    }
}


@Model
class Object {
    var isInSpace: Bool
    var position: Vector3?
    var rotation: Vector3?
    var scale: Vector3?

    init(isInSpace: Bool, position: Vector3? = nil, rotation: Vector3? = nil, scale: Vector3? = nil) {
        self.isInSpace = isInSpace
        self.position = position
        self.rotation = rotation
        self.scale = scale
    }
}

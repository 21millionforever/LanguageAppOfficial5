//
//  UpAndDownComponent + UpAndDownSystem.swift
//  LanguageAppOfficial
//
//  Created by Zhendong Chen on 9/13/24.
//

import RealityKit


struct UpAndDownComponent: Component {
    var speed: Float
    var axis: SIMD3<Float>
    var minY: Float
    var maxY: Float
    var direction: Float = 1.0 // 1 for up, -1 for down
    var initialY: Float?
    
    init(speed: Float = 1.0, axis: SIMD3<Float> = [0, 1, 0], minY: Float = 0.0, maxY: Float = 1.0) {
        self.speed = speed
        self.axis = axis
        self.minY = minY
        self.maxY = maxY
    }
}

struct UpAndDownSystem: System {
    static let query = EntityQuery(where: .has(UpAndDownComponent.self))
    
    init(scene: RealityKit.Scene) {}

    func update(context: SceneUpdateContext) {
        let deltaTime = Float(context.deltaTime) // Time between frames
        
        for entity in context.entities(matching: Self.query, updatingSystemWhen: .rendering) {
            guard var component: UpAndDownComponent = entity.components[UpAndDownComponent.self] else { continue }

            // Ensure we have the initial Y value set
            if component.initialY == nil {
                component.initialY = entity.transform.translation.y
            }
            
            // Calculate the current position
            let currentY = entity.transform.translation.y
            
            // Move the entity up or down
            let newY = currentY + (component.speed * component.direction * deltaTime)
            
            // If the entity moves out of the allowed range, reverse the direction
            if newY >= component.initialY! + component.maxY {
                component.direction = -1.0 // Move down
            } else if newY <= component.initialY! + component.minY {
                component.direction = 1.0 // Move up
            }

            // Apply the new position
            entity.transform.translation = SIMD3<Float>(entity.transform.translation.x, newY, entity.transform.translation.z)
            
            // Update the component with the new direction
            entity.components[UpAndDownComponent.self] = component
        }
    }
}

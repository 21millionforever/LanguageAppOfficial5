//
//  MainVolumeViewModel.swift
//  LanguageAppOfficial3
//
//  Created by Zhendong Chen on 9/23/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

enum SelectedView {
    case languageSelection
    case home
    case space
}

@MainActor
@Observable
class MainVolumeViewModel {
    var contentEntity = Entity()
    var currShowingCheckpointsScene: Entity? // The currently showing checkpoint scene
    var entityDict: [String: Entity] = [:]
    var selectedHomeViewMode: SelectedView = .home
    
    // Sets up the home view scene with the provided checkpoints.
    func setUpHomeViewCheckpointsScene(checkpoints: [Checkpoint]) async {
        // Find the highest level where at least one checkpoint is unlocked
        guard let maxUnlockedLevel = checkpoints.filter({ !$0.isLocked }).map({ $0.level }).max() else { return }
        
        // Get all checkpoints of that highest level
        let currLevelCheckpoints = checkpoints.filter { $0.level == maxUnlockedLevel }
        
        // Ensure there are checkpoints at the highest level
        if !currLevelCheckpoints.isEmpty {
            // Load the scene associated with the first checkpoint of the highest level
            if let scene = try? await Entity(named: currLevelCheckpoints[0].sceneBelongTo, in: realityKitContentBundle) {
                
                self.currShowingCheckpointsScene = scene // Set the current showing checkpoint scene
                
                // Add UpAndDownComponents to floating rocks
                var i = 0
                while true {
                    if let floatingRock = scene.findEntity(named: "FloatingRock_\(i)") {
                        let speed = Float.random(in: 0.005...0.02)
                        let minY = Float.random(in: -0.05...0)
                        let maxY = Float.random(in: 0...0.05)
                        
                        floatingRock.components.set(UpAndDownComponent(speed: speed, axis: [0, 1, 0], minY: minY, maxY: maxY))
                        i += 1
                    } else {
                        break
                    }
                }
                
                // Set the initial transform of the scene
                scene.transform.translation = [0, -0.32, 0]
                scene.transform.scale = [0.01, 0.01, 0.01]
                
                // Add the scene to the content entity
                contentEntity.addChild(scene)
                
                UpAndDownComponent.registerComponent()
                UpAndDownSystem.registerSystem()
            }
        }
    }
    
    
    
    
    
    
    
    
    
}

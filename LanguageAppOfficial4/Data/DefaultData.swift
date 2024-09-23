//
//  DefaultData.swift
//  LanguageAppOfficial2
//
//  Created by Zhendong Chen on 9/21/24.
//

import Foundation


class DefaultData {
    static let defaultCheckpoints: [Checkpoint] = [
        Checkpoint(name: "level1_fruitCheckpoint", sceneBelongTo: "Level1_checkpointsScene", isLocked: false, isPassed: false, connectedCheckpoints: ["level1_farmCheckpoint", "level1_colorsCheckpoint"], level: 1),
        Checkpoint(name: "level1_farmCheckpoint", sceneBelongTo: "Level1_checkpointsScene", isLocked: true, isPassed: false, connectedCheckpoints: ["level1_fruitCheckpoint", "level1_oceanCheckpoint", "level1_forestCheckpoint"], level: 1),
        Checkpoint(name: "level1_colorsCheckpoint", sceneBelongTo: "Level1_checkpointsScene", isLocked: true, isPassed: false, connectedCheckpoints: ["level1_fruitCheckpoint", "level1_forestCheckpoint"], level: 1),
        Checkpoint(name: "level1_oceanCheckpoint", sceneBelongTo: "Level1_checkpointsScene", isLocked: true, isPassed: false, connectedCheckpoints: ["level1_farmCheckpoint", "level1_forestCheckpoint"], level: 1),
        Checkpoint(name: "level1_forestCheckpoint", sceneBelongTo: "Level1_checkpointsScene", isLocked: true, isPassed: false, connectedCheckpoints: ["level1_farmCheckpoint", "level1_colorsCheckpoint", "level1_oceanCheckpoint"], level: 1),
        Checkpoint(name: "level2_mountainCheckpoint", sceneBelongTo: "Level2_checkpointsScene", isLocked: true, isPassed: false, connectedCheckpoints: ["level2_weatherCheckpoint"], level: 2),
        Checkpoint(name: "level2_weatherCheckpoint", sceneBelongTo: "Level2_checkpointsScene", isLocked: true, isPassed: false, connectedCheckpoints: ["level2_mountainCheckpoint"], level: 2),
        
    ]
}

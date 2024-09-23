//
//  Checkpoint.swift
//  LanguageAppOfficial2
//
//  Created by Zhendong Chen on 9/21/24.
//

import SwiftData

@Model
class Checkpoint {
    var name: String
    var sceneBelongTo: String
    var isLocked: Bool
    var isPassed: Bool
    var connectedCheckpoints: [String]?
    var level: Int
    
    var userProfileModel: UserProfileModel?

    init(name: String, sceneBelongTo: String, isLocked: Bool, isPassed: Bool, connectedCheckpoints: [String]? = nil, level: Int) {
        self.name = name
        self.sceneBelongTo = sceneBelongTo
        self.isLocked = isLocked
        self.isPassed = isPassed
        self.connectedCheckpoints = connectedCheckpoints
        self.level = level
    }
}

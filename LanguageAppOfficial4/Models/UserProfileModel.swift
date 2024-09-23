//
//  UserProfileModel.swift
//  LanguageAppOfficial2
//
//  Created by Zhendong Chen on 9/21/24.
//

import SwiftUI
import SwiftData

enum Language: String, CaseIterable, Codable {
    case Chinese
    case English
}

@Model
class UserProfileModel {
    var nativeLanguage: Language?
    var targetLanguage: Language?
    var checkpoints: [Checkpoint]
    var tokenAmount: Int
    var ownedObjects: [Object]
    
    init(checkpoints: [Checkpoint] = DefaultData.defaultCheckpoints, tokenAmount: Int = 0, ownedObjects: [Object] = []) {
        self.checkpoints = checkpoints
        self.tokenAmount = tokenAmount
        self.ownedObjects = ownedObjects
    }
    
}

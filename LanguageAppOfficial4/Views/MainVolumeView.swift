//
//  MainVolumeView.swift
//  LanguageAppOfficial3
//
//  Created by Zhendong Chen on 9/23/24.
//

import SwiftUI
import RealityKit
import RealityKitContent
import SwiftData


struct MainVolumeView: View {
    @Environment(\.modelContext) private var context
    
    @Environment(AppModel.self) private var appModel
    @Environment(MainVolumeViewModel.self) private var mainVolumeViewModel
    @Environment(AudioManager.self) private var audioManager
    @Query private var userProfiles: [UserProfileModel]
    
    
    var body: some View {
        RealityView { content, attachments in
            if let userProfile = userProfiles.first {
                let checkpoints = userProfile.checkpoints
                
                // Show the langauge seclection window if languages haven't been set
                if userProfile.nativeLanguage == nil && userProfile.targetLanguage == nil {
                    mainVolumeViewModel.selectedHomeViewMode = .languageSelection
                    if let languageSelectionView = attachments.entity(for: "LanguageSelectionWindow") {
                        mainVolumeViewModel.entityDict["LanguageSelectionWindow"] = languageSelectionView
                        content.add(languageSelectionView)
                    }
                }
                
                
                await mainVolumeViewModel.setUpHomeViewCheckpointsScene(checkpoints: checkpoints)
                content.add(mainVolumeViewModel.contentEntity)
                if mainVolumeViewModel.selectedHomeViewMode == .languageSelection {
                    if let currShowingCheckpointsScene = mainVolumeViewModel.currShowingCheckpointsScene {
                        currShowingCheckpointsScene.isEnabled = false
                    }
                }
                else if mainVolumeViewModel.selectedHomeViewMode == .home {
                    if let currShowingCheckpointsScene = mainVolumeViewModel.currShowingCheckpointsScene {
                        currShowingCheckpointsScene.isEnabled = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            Task {
                                self.notify(entity: currShowingCheckpointsScene, identifier: "showSceneAnimation")
                            
                                await audioManager.playAudio(fileName: "transition-coat.mp3")
                            }
                        }
                    }
                }
                
            }
        } update: { content, attachments in
            if mainVolumeViewModel.selectedHomeViewMode == .home && mainVolumeViewModel.currShowingCheckpointsScene?.isEnabled == false  {
                Task {
                    if let currShowingCheckpointsScene = mainVolumeViewModel.currShowingCheckpointsScene {
        
                        currShowingCheckpointsScene.isEnabled = true
                        self.notify(entity: currShowingCheckpointsScene, identifier: "showSceneAnimation")
                        await audioManager.playAudio(fileName: "transition-coat.mp3")
                    }
                }
                
                
            }
            
        } attachments: {
            Attachment(id: "LanguageSelectionWindow") {
                LanguageSelectionView(onSaveSuccess: {
                    // Remove the languageSelection
                    mainVolumeViewModel.entityDict["LanguageSelectionWindow"]?.removeFromParent()
                    mainVolumeViewModel.entityDict.removeValue(forKey: "LanguageSelectionWindow")
                    mainVolumeViewModel.selectedHomeViewMode = .home
                })
                .frame(width: 600, height: 600)
            }
        }
        
        
    }
    
    
    fileprivate func notify(entity: Entity, identifier: String) {
        if let scene = entity.scene {
            print("Attempting to trigger animation: \(identifier)")
            NotificationCenter.default.post(
                name: Notification.Name("RealityKit.NotificationTrigger"),
                object: nil,
                userInfo: [
                    "RealityKit.NotificationTrigger.Scene": scene,
                    "RealityKit.NotificationTrigger.Identifier": identifier
                ])
        }
    }
}

#Preview {
    MainVolumeView()
}

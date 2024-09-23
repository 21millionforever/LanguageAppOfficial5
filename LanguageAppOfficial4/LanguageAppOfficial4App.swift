//
//  LanguageAppOfficial4App.swift
//  LanguageAppOfficial4
//
//  Created by Zhendong Chen on 9/23/24.
//

import SwiftUI
import SwiftData

@main
struct LanguageAppOfficial4App: App {
    @State private var appModel = AppModel()
    @State private var mainVolumeViewModel = MainVolumeViewModel()
    @State private var audioManager = AudioManager()
    
    let container: ModelContainer
    
    init() {
        let schema = Schema([UserProfileModel.self, Checkpoint.self])
        let config = ModelConfiguration("UserProfileModel", schema: schema)
        do {
            container = try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Could not configure the container: \(error)")
        }
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
        
        // Perform initial setup or data fetching
        let context = container.mainContext
        let userProfiles: [UserProfileModel] = try! context.fetch(FetchDescriptor<UserProfileModel>())
        
        if userProfiles.isEmpty {
            let userProfile = UserProfileModel()
            context.insert(userProfile)
            do {
                try context.save() // Don't forget to save the context!
            } catch {
                print("Failed to save user profile: \(error)")
            }
        }
        
    }
    
    var body: some Scene {
        WindowGroup(id: appModel.mainVolumeViewID) {
            MainVolumeView()
                .environment(appModel)
                .environment(mainVolumeViewModel)
                .environment(audioManager)
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 1, height: 0.6, depth: 1.0, in: .meters)
        .windowResizability(.contentSize)
        .defaultWorldScaling(.dynamic)
        .volumeWorldAlignment(.gravityAligned)
        .modelContainer(container)
        
    }
}

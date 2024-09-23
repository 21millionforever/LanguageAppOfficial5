//
//  LanguageSelectionView.swift
//  LanguageAppOfficial2
//
//  Created by Zhendong Chen on 9/22/24.
//

//import SwiftUI
//import SwiftData
//import SplineRuntime
//
//struct LanguageSelectionView: View {
////    @Environment(\.openWindow) private var openWindow
//    @Environment(\.modelContext) private var context
//    
//    @Environment(AppModel.self) private var appModel
//    @Query private var userProfiles: [UserProfileModel]
//    
//    @State var nativeLanguage: Language?
//    @State var targetLanguage: Language?
//    
//    var body: some View {
//        ZStack {
//            // fetching from local
////            let url = Bundle.main.url(forResource: "dunes", withExtension: "splineswift")!
////
////            SplineView(sceneFileURL: url).ignoresSafeArea(.all)
//        
//            VStack(alignment: .center) {
//                Text("Set up your language")
//                    .font(.extraLargeTitle)
//                
//                Form {
//                    // Native Language Picker
//                    Section(header: Text("Select Native Language")) {
//                        Picker("Native Language", selection: $nativeLanguage) {
//                            ForEach(Language.allCases, id: \.self) { language in
//                                Text(language.rawValue).tag(language as Language?)
//                            }
//                        }
//                    }
//                    
//                    // Target Language Picker, filtering out the selected native language
//                    Section(header: Text("Select Target Language")) {
//                        Picker("Target Language", selection: $targetLanguage) {
//                            ForEach(Language.allCases.filter { $0 != nativeLanguage }, id: \.self) { language in
//                                Text(language.rawValue).tag(language as Language?)
//                            }
//                        }
//                    }
//                }
//                
//                // Continue Button
//                Button(action: {
//                    if let userProfileModel = userProfiles.first {
//                        userProfileModel.nativeLanguage = nativeLanguage
//                        userProfileModel.targetLanguage = targetLanguage
//                        do {
//                            try context.save()
////                            openWindow(id: appModel.mainVolumeViewID)
//                        } catch {
//                            print("Failed to save user profile: \(error)")
//                            fatalError("Failed to save user profile: \(error)")
//                        }
//                        
//                    }
//                    
//                }) {
//                    Text("Continue")
//                        .frame(maxWidth: 500)
//                }
//                .disabled(nativeLanguage == nil || targetLanguage == nil) // Disable button if either language is not selected
//                .padding(.bottom, 30)
//                
//                
//            }
//            .padding(.top, 30)
//            .frame(width: 600, height: 600)
//            .glassBackgroundEffect()
//        }
//        
//        
//        
//    }
//}

//#Preview {
//    LanguageSelectionView()
//        
//}



import SwiftUI
import SwiftData

struct LanguageSelectionView: View {
    @Environment(\.modelContext) private var context
    @Environment(AppModel.self) private var appModel
    @Query private var userProfiles: [UserProfileModel]
    
    @State var nativeLanguage: Language?
    @State var targetLanguage: Language?
    let onSaveSuccess: () -> Void
    
    var body: some View {
       
        VStack(alignment: .center) {
            Text("Set up your language")
                .font(.extraLargeTitle)
                .padding(.top, 30)
                .padding(.bottom, 50)
            
            HStack() {
                Text("Select Your Native Language: ")
                    .font(.largeTitle)
                    .padding(.leading, 30)
                Spacer()
            }
            
            HStack {
                ForEach(Language.allCases, id: \.self) { language in
                    Button(action: {
                        // Unselect if already selected
                        if nativeLanguage == language {
                            nativeLanguage = nil
                        } else {
                            nativeLanguage = language
                            
                            // Reset targetLanguage if it was set to the same as nativeLanguage
                            if targetLanguage == language {
                                targetLanguage = nil
                            }
                        }
                    }) {
                        Text(language.rawValue)
                            .padding()
                    }
                    .foregroundStyle(.white)
                    .tint(nativeLanguage == language ? Color.orange : nil)
                }
                Spacer()
            }
            .padding(.leading, 30)
 
            
                
            // Target Language Selection Buttons, filtering out the selected native language
            HStack() {
                Text("Select The Language You Want To Learn: ")
                    .font(.largeTitle)
                    .padding(.leading, 30)
                Spacer()
            }

            HStack {
                ForEach(Language.allCases.filter { $0 != nativeLanguage }, id: \.self) { language in
                    Button(action: {
                        // Unselect if already selected
                        if targetLanguage == language {
                            targetLanguage = nil
                        } else {
                            targetLanguage = language
                        }
                    }) {
                        Text(language.rawValue)
                            .padding()
                 
                            .cornerRadius(8)
                    }
                    .foregroundColor(.white)
                    .tint(targetLanguage == language ? Color.green : nil)
                    .disabled(nativeLanguage == nil)
                }
                
                Spacer()
            }
            .padding(.leading, 30)
 
 
            Spacer()
            // Continue Button
            Button(action: {
                if let userProfileModel = userProfiles.first {
                    userProfileModel.nativeLanguage = nativeLanguage
                    userProfileModel.targetLanguage = targetLanguage
                    do {
                        try context.save()
                        onSaveSuccess()
                    } catch {
                        print("Failed to save user profile: \(error)")
                        fatalError("Failed to save user profile: \(error)")
                    }
                }
            }) {
                Text("Continue")
                    .frame(maxWidth: 500)
            }
            .disabled(nativeLanguage == nil || targetLanguage == nil) // Disable button if either language is not selected
            .padding(.bottom, 30)
        }
        .glassBackgroundEffect()
        
    }
}


#Preview {
    LanguageSelectionView(onSaveSuccess: {
        print("Save successful! Proceeding to next step.")
    })
        
}

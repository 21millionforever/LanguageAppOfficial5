//
//  AudioManager.swift
//  LanguageAppOfficial
//
//  Created by Zhendong Chen on 9/13/24.
//



import Foundation
import AVFoundation

@Observable
class AudioManager {
    private var audioPlayers: [String: AVAudioPlayer] = [:]
    private let queue = DispatchQueue(label: "com.languageApp.audioManager")

    func playAudio(fileName: String) async {
        await withCheckedContinuation { continuation in
            queue.async { [weak self] in
                guard let self = self else {
                    continuation.resume()
                    return
                }
                
                if let player = self.audioPlayers[fileName] {
                    Task { @MainActor in
                        player.currentTime = 0
                        player.play()
                    }
                } else {
                    self.loadAndPlayAudio(fileName: fileName)
                }
                continuation.resume()
            }
        }
    }

    private func loadAndPlayAudio(fileName: String) {
        guard let audioURL = Bundle.main.url(forResource: fileName, withExtension: nil) else {
            print("Audio file not found for fileName: \(fileName)")
            return
        }

        do {
            let player = try AVAudioPlayer(contentsOf: audioURL)
            player.prepareToPlay()
            
            Task { @MainActor in
                self.audioPlayers[fileName] = player
                player.play()
            }
        } catch {
            print("Error playing audio for file: \(fileName), error: \(error.localizedDescription)")
        }
    }
    
    func preloadAudio(fileName: String) async {
        await withCheckedContinuation { continuation in
            queue.async { [weak self] in
                guard let self = self else {
                    continuation.resume()
                    return
                }
                
                if self.audioPlayers[fileName] != nil {
                    continuation.resume()
                    return // Already preloaded
                }
                
                guard let audioURL = Bundle.main.url(forResource: fileName, withExtension: nil) else {
                    print("Audio file not found for preloading: \(fileName)")
                    continuation.resume()
                    return
                }

                do {
                    let player = try AVAudioPlayer(contentsOf: audioURL)
                    player.prepareToPlay()
                    Task { @MainActor in
                        self.audioPlayers[fileName] = player
                    }
                } catch {
                    print("Error preloading audio for file: \(fileName), error: \(error.localizedDescription)")
                }
                continuation.resume()
            }
        }
    }
    
    func pauseAudio(fileName: String) async {
        await withCheckedContinuation { continuation in
            queue.async { [weak self] in
                self?.audioPlayers[fileName]?.pause()
                continuation.resume()
            }
        }
    }

    func stopAudio(fileName: String) async {
        await withCheckedContinuation { continuation in
            queue.async { [weak self] in
                guard let player = self?.audioPlayers[fileName] else {
                    continuation.resume()
                    return
                }
                player.stop()
                player.currentTime = 0
                continuation.resume()
            }
        }
    }
    
    func preloadDefaultAudio() async {
        let audioList = ["correct_audio.mp3", "wrong_audio.mp3", "transition-coat.mp3"]
        
        for fileName in audioList {
            await self.preloadAudio(fileName: fileName)
        }
    }
    
    
    
    
}

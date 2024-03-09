//
//  SoundManager.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-02-06.
//

import Foundation
import AVFAudio

class SoundManager {
    
    // singleton
    static let shared = SoundManager()
    
    private var player: AVAudioPlayer?
    
    enum SoundOption: String {
        case paymentSuccess
        case msgSent
        case msgReceived
    }
    
    func playSound(sound: SoundOption) {
        print("playSound()Invoked.")
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: ".mp3") else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print("Error playing sound. \(error.localizedDescription)")
        }
    }
}

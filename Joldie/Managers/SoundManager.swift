//
//  SoundManager.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 03/09/2018.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import Foundation
import AudioToolbox.AudioServices
import AVFoundation.AVFAudio.AVAudioPlayer
import AVFoundation.AVMediaFormat

private let audioFormat = AVFileType.mp3

private enum SoundType: String {
    case MP3 = "mp3"
    case WAV = "wav"
}

class SoundManager: NSObject {
    
    fileprivate static var sharedManager = SoundManager()
    
    fileprivate var audioPlayer: AVAudioPlayer?
    fileprivate var repeatCount: Int = 0
    fileprivate var vibrateOnPlaying: Bool = false
    
    class func playMessageReceived(times: Int = 1, vibrate: Bool = false) {
        sharedManager.vibrateOnPlaying = vibrate
        sharedManager.repeatCount = times
        sharedManager.playSoundNamed("message_received")
    }
    
    class func playEngine(times: Int = 1, vibrate: Bool = false) {
        sharedManager.vibrateOnPlaying = vibrate
        sharedManager.repeatCount = times
        sharedManager.playSoundNamed("engine", ofType: .WAV)
    }
    
    class func playCalling(times: Int = 1, vibrate: Bool = false) {
       // guard let driver = Driver.currentDriver else { return }
        
        sharedManager.vibrateOnPlaying = vibrate
        sharedManager.repeatCount = times
        //sharedManager.playSoundNamed(driver.serviceType.callingSoundName)
    }
    
    class func playCallingDestinationChanged(times: Int = 1, vibrate: Bool = false) {
        //guard let driver = Driver.currentDriver else { return }
        
        sharedManager.vibrateOnPlaying = vibrate
        sharedManager.repeatCount = times
        sharedManager.playSoundNamed("jinglebells")
    }
    
    fileprivate func playSoundNamed(_ name: String!, ofType: SoundType! = .MP3, numberOfLoops: Int = 0, vibrate: Bool = false) {
        guard let path = Bundle.main.path(forResource: name, ofType: ofType.rawValue) else { return }
        
        // Stop player if it was playing another sound
        SoundManager.stop()
        
        // Instantiate the new player
        audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: path), fileTypeHint: audioFormat.rawValue)
        audioPlayer!.delegate = self
        
        // Play the sound
        play()
    }
    
    fileprivate func play() {
        guard let player = audioPlayer else { return }
        
        player.play()
        if vibrateOnPlaying == true {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
    }
    
    class func stop() {
        sharedManager.audioPlayer?.stop()
    }
    
}

extension SoundManager: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        if player == audioPlayer && repeatCount > 1 {
            repeatCount -= 1
            play()
        }
        
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        debugPrint("Error decoding audio: \(error)")
    }
    
}


import Foundation
import AVFoundation

class SoundManager {

    var backgroundMusicPlayer: AVAudioPlayer?
    var soundEffectsPlayer: AVAudioPlayer?
    var cardFlipPlayer: AVAudioPlayer?

    init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("SoundManager: audio session error – \(error)")
        }
        cardFlipPlayer = makePlayer(named: "card_flip")
    }

    //BackgroundMusic
    func playBackgroundMusic() {
          backgroundMusicPlayer = makePlayer(named: "background_music")
          backgroundMusicPlayer?.numberOfLoops = -1
          backgroundMusicPlayer?.play()
    }

    func pauseBackgroundMusic() {
        backgroundMusicPlayer?.pause()
    }

    func resumeBackgroundMusic() {
        try? AVAudioSession.sharedInstance().setActive(true)
        backgroundMusicPlayer?.play()
    }

    func stopBackgroundMusic() {
        backgroundMusicPlayer?.stop()
        backgroundMusicPlayer = nil
    }
    
    //Card Flip Music
    func playCardFlip() {
        cardFlipPlayer?.currentTime = 0
        cardFlipPlayer?.play()
    }

    //Sound Effects
    func playVictory() {
        stopBackgroundMusic()
        soundEffectsPlayer = makePlayer(named: "victory")
        soundEffectsPlayer?.play()
    }
    
    func playGameOver() {
        stopBackgroundMusic()
        soundEffectsPlayer = makePlayer(named: "game_over")
        soundEffectsPlayer?.play()
    }

     
    func makePlayer(named name: String) -> AVAudioPlayer? {
        for ext in ["mp3", "wav", "m4a", "caf"] {
            guard let url = Bundle.main.url(forResource: name, withExtension: ext) else { continue
            }
            
            do {
                let player = try AVAudioPlayer(contentsOf: url)
                player.prepareToPlay()
                return player
            } catch {
                  print("SoundManager: could not load '\(name).\(ext)' – \(error)")
            }
        }
        print("SoundManager: '\(name)' not found")
        return nil
    }
    
}


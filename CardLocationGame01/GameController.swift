
import Foundation
import UIKit

class GameController: UIViewController {
    
    @IBOutlet weak var game_LBL_leftScore: UILabel!
    @IBOutlet weak var game_LBL_rightScore: UILabel!
    
    @IBOutlet weak var game_IMG_leftCard: UIImageView!
    @IBOutlet weak var game_IMG_rightCard: UIImageView!
    
    @IBOutlet weak var game_LBL_timer: UILabel!
    @IBOutlet weak var game_IMG_clock: UIImageView!
    
    @IBOutlet weak var game_VIEW_leftGlow: UIView!
    @IBOutlet weak var game_VIEW_rightGlow: UIView!
    
    var playerName: String = ""
    var playerSide: String = ""
    
    var playerScore = 0
    var computerScore = 0
    
    let cardValues = ["ace", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "jack", "queen", "king"]
    
    let cardSuits = ["clubs", "diamonds", "hearts", "spades"]
    
    var roundCounter = 0
    let maxRounds = 12
    
    var gameTimer: GameTimer?
    var isViewActive = false
    
    var soundManager = SoundManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(playerName)
        print(playerSide)
        
        updateScoreLabels()
        markPlayerCard()
        
        game_IMG_leftCard.image = UIImage(named: "back-card")
        game_IMG_rightCard.image = UIImage(named: "back-card")
        
    }
    
    func getRandomCardName(value: Int) -> String {
        let suit = cardSuits.randomElement()!
        let cardName = "\(cardValues[value - 1])-of-\(suit)"
        return cardName
    }
    
    func playRound() {
        
        soundManager.playCardFlip()
        
        let leftValue = Int.random(in: 1...13)
        let rightValue = Int.random(in: 1...13)
        
        let leftCardName = getRandomCardName(value: leftValue)
        let rightCardName = getRandomCardName(value: rightValue)
        
        game_IMG_leftCard.image = UIImage(named: leftCardName)
        game_IMG_rightCard.image = UIImage(named: rightCardName)
        
        let playerCard = getPlayerCard(leftCard: leftValue, rightCard: rightValue)
        let computerCard = getComputerCard(leftCard: leftValue, rightCard: rightValue)
        
        if playerCard > computerCard {
            playerScore += 1
        }
        else if computerCard > playerCard {
            computerScore += 1
        }
        
        updateScoreLabels()
    }
    
    func updateScoreLabels() {
        if playerSide == "west" {
            game_LBL_leftScore.text = "\(playerName): \(playerScore)"
            game_LBL_rightScore.text = "PC: \(computerScore)"

        } else {
            game_LBL_leftScore.text = "PC: \(computerScore)"
            game_LBL_rightScore.text = "\(playerName): \(playerScore)"

        }
    }
    
    func getPlayerCard(leftCard: Int, rightCard: Int) -> Int {
        if playerSide == "west" {
            return leftCard
        }else {
            return rightCard
        }
    }
    
    func getComputerCard(leftCard: Int, rightCard: Int) -> Int {
        if playerSide == "west" {
            return rightCard
        } else {
            return leftCard
        }
    }
    
    
    func closeCardsAndStartAgain() {
        roundCounter += 1
        if roundCounter >= maxRounds {
            performSegue(withIdentifier: "toEnd", sender: self)
            return
        }
        
        game_IMG_leftCard.image = UIImage(named: "back-card")
        game_IMG_rightCard.image = UIImage(named: "back-card")
        
        gameTimer?.start()
    }
    
    func markPlayerCard() {
        if playerSide == "west" {
            game_VIEW_leftGlow.isHidden = false
            game_VIEW_rightGlow.isHidden = true
        }
        else {
            game_VIEW_leftGlow.isHidden = true
            game_VIEW_rightGlow.isHidden = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // Winner Score move to screen 3
        if segue.identifier == "toEnd" {
            soundManager.stopBackgroundMusic()
            
            let endController = segue.destination as! EndController
            
            if playerScore >= computerScore {
                endController.winnerName = playerName
                endController.winnerScore = playerScore
            }
            else {
                endController.winnerName = "Computer"
                endController.winnerScore = computerScore
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isViewActive = true
        gameTimer = GameTimer(cb: self)
        gameTimer?.start()
        
        soundManager.playBackgroundMusic()
        
        // Listen for app going to background
        NotificationCenter.default.addObserver(self, selector:
          #selector(appMovedToBackground), name:
          UIApplication.willResignActiveNotification, object: nil)
        
        // Listen for app returning to foreground
        NotificationCenter.default.addObserver(self, selector:
          #selector(appMovedToForeground), name:
          UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isViewActive = false
        gameTimer?.stop()
        
        soundManager.stopBackgroundMusic()
        
        //remove all observers when leaving screen
        NotificationCenter.default.removeObserver(self)
    }
    
    // called when user presses home button or receives a call
    @objc func appMovedToBackground() {
        
        soundManager.pauseBackgroundMusic()
        gameTimer?.stop()
    }
      
    // called when user returns to the app
    @objc func appMovedToForeground() {
        
        soundManager.resumeBackgroundMusic()
        gameTimer?.resume()
    }
}

extension GameController: CallBack_GameTimer {
    func timerTick(counter: Int) {
        game_LBL_timer.text = "\(counter)"
      }
      
    func timerFinished() {
        playRound()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            guard self.isViewActive else { return }
            self.closeCardsAndStartAgain()
          }
      }
  }


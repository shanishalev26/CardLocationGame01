
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
    
    var timer: Timer?
    var timerCounter = 3
    var roundCounter = 0
    let maxRounds = 12
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(playerName)
        print(playerSide)
        
        updateScoreLabels()
        markPlayerCard()
        
        game_IMG_leftCard.image = UIImage(named: "back-card")
        game_IMG_rightCard.image = UIImage(named: "back-card")
        
        game_LBL_timer.text = "\(timerCounter)"

        game_IMG_leftCard.image = UIImage(named: "back-card")
        game_IMG_rightCard.image = UIImage(named: "back-card")

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: secondly(t:))
    }
    

    func getRandomCardName(value: Int) -> String {
        let suit = cardSuits.randomElement()!
        let cardName = "\(cardValues[value - 1])-of-\(suit)"
        return cardName
    }
    
    func playRound() {
        
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
            game_LBL_leftScore.text = "Score: \(playerScore)"
            game_LBL_rightScore.text = "Score: \(computerScore)"
        } else {
            game_LBL_leftScore.text = "Score: \(computerScore)"
            game_LBL_rightScore.text = "Score: \(playerScore)"
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
    
    func secondly(t: Timer) {
        timerCounter -= 1
        game_LBL_timer.text = "\(timerCounter)"
        
        if timerCounter == 0 {
            t.invalidate()
            playRound()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.closeCardsAndStartAgain()
            }
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
        
        timerCounter = 3
        game_LBL_timer.text = "\(timerCounter)"
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: secondly(t:))
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
    
    
    
}

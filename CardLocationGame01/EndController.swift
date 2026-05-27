
import Foundation
import UIKit

class EndController: UIViewController {
    
    @IBOutlet weak var end_LBL_winner: UILabel!
    @IBOutlet weak var end_LBL_score: UILabel!
    
    var winnerName: String = ""
    var winnerScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        end_LBL_winner.text = "Winner: \(winnerName)"
        end_LBL_score.text = "Score: \(winnerScore)"
    }
    
    @IBAction func clickedBackToMenu(_ sender: UIButton) { //Back to screen 1
        view.window?.rootViewController?.dismiss(animated: true)
    }
}

import Foundation
import UIKit
import CoreLocation

class MenuController: UIViewController {
    
    @IBOutlet weak var menu_BTN_setName: UIButton!
    @IBOutlet weak var menu_BTN_start: UIButton!
    @IBOutlet weak var menu_LBL_hiName: UILabel!
    @IBOutlet weak var menu_VIEW_westGlow: UIView!
    @IBOutlet weak var menu_VIEW_eastGlow: UIView!
    
    var playerName: String = ""

    var locationManager: CLLocationManager!
    var startLocation: CLLocation?
    var playerSide = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        menu_BTN_start.isEnabled = false
        menu_LBL_hiName.isHidden = true
        
        if let savedName = UserDefaults.standard.string(forKey: "playerName") {
              playerName = savedName
              menu_LBL_hiName.text = "Hi \(playerName)!"
              menu_LBL_hiName.isHidden = false
              menu_BTN_setName.isEnabled = false
        }


        locationManager = CLLocationManager()
        locationManager.delegate = self

        locationManager.requestWhenInUseAuthorization()
    }

    @IBAction func clickedStart(_ sender: UIButton) {

    }
    
    func checkIfReadyToStart() {
          menu_BTN_start.isEnabled = !playerName.isEmpty && !playerSide.isEmpty
    }

    @IBAction func clickedSetName(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Set Name", message: "Enter your name", preferredStyle: .alert)

        alertController.addTextField { (textField) in
            textField.placeholder = "Name"
        }

        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            
                let inputName = alertController.textFields![0].text ?? ""
                
                if inputName.isEmptyOrWhitespace {
                    self.showToast(message: "Please enter your name")
                    return
                }
                
                if inputName.isEnglishName == false {
                    self.showToast(message: "Name must contain only English letters")
                    return
                }
                
                let fixedName = String(inputName.capitalized.prefix(10))
                
                self.playerName = fixedName
                UserDefaults.standard.set(fixedName, forKey: "playerName")
            
                self.menu_BTN_setName.setTitle("Set Name", for: .normal)
                self.menu_BTN_setName.isEnabled = false
                self.menu_BTN_setName.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                
                self.menu_LBL_hiName.text = "Hi \(self.playerName)!"
                self.menu_LBL_hiName.isHidden = false
                self.checkIfReadyToStart()
                
        }

        alertController.addAction(saveAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // Player side move to screen 2
        if segue.identifier == "toGame" {
            let gameController = segue.destination as! GameController
            gameController.playerName = playerName
            gameController.playerSide = playerSide
        }
    }
    
}

extension MenuController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
          if manager.authorizationStatus == .authorizedWhenInUse ||
             manager.authorizationStatus == .authorizedAlways {
              locationManager.requestLocation()
          }
      }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations")
        
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            startLocation = location
            
            let afekaLongitude = 34.817549168324334

            if location.coordinate.longitude < afekaLongitude {
                playerSide = "west"
            }
            else {
                playerSide = "east"
            }
            
            print("got Location: \(location.coordinate.latitude) \(location.coordinate.longitude)")
            
            if playerSide == "west" {
              menu_VIEW_westGlow.isHidden = false
            } else {
              menu_VIEW_eastGlow.isHidden = false
            }
            checkIfReadyToStart()

        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error=\(error)")
    }
}

//
//  SettingsViewController.swift
//  FileManager
//
//  Created by Sergey on 03.02.2022.
//

import UIKit
import KeychainAccess

class SettingsViewController: UIViewController {
    
    let keyChain = Keychain(service: "com.sergeybindasov.FileManager")
    
    @IBOutlet weak var resetButton: UIButton!
    // MARK:  Class Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "reset" {
            if let vc = segue.destination as? LoginViewController {
                vc.resetPassword()
            }
        }
    }
    
    @IBAction func sortSwitch(_ sender: UISwitch) {
        var sortByName: Bool = true
        if sender.isOn == true {
            sortByName = true
        } else {
            sortByName = false
        }
        UserDefaults.standard.set(sortByName, forKey: "sort")
    }
    
    @IBAction func picSizeSwitch(_ sender: UISwitch) {
        
        var sizeIsShown: Bool = true
        if sender.isOn == true {
          sizeIsShown = true
        } else {
            sizeIsShown = false
        }
        UserDefaults.standard.set(sizeIsShown, forKey: "size")
    }
    

    
    @IBAction func resetpressed(_ sender: UIButton) {
        performSegue(withIdentifier: "reset", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Настройки"
        resetButton.titleLabel?.tintColor = .white
    }
}

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
    
    let userDefaults = UserDefaults.standard
    
    var sortByName = "sortBool"
    var sizeIsShown = "sizeBool"
    
    @IBOutlet weak var sortSwitch: UISwitch!
    @IBOutlet weak var sizeSwitch: UISwitch!
    
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
        
        if sender.isOn == true {
            userDefaults.set(true, forKey: sortByName)
        } else {
            userDefaults.set(false, forKey: sortByName)
        }
    }
    
    @IBAction func picSizeSwitch(_ sender: UISwitch) {
        
        
        if sender.isOn == true {
            userDefaults.set(true, forKey: sizeIsShown)
        } else {
            userDefaults.set(false, forKey: sizeIsShown)
        }
    }
    
    @IBAction func resetpressed(_ sender: UIButton) {
        performSegue(withIdentifier: "reset", sender: self)
    }
    
    func chechkSortSwitch() {
        if userDefaults.bool(forKey: sortByName) == true {
            sortSwitch.setOn(true, animated: false)
            
        } else {
            sortSwitch.setOn(false, animated: false)
        }
    }
    
    func chechkSizeSwitch() {
        if userDefaults.bool(forKey: sizeIsShown) == true {
            sizeSwitch.setOn(true, animated: false)
        } else {
            sizeSwitch.setOn(false, animated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Настройки"
        resetButton.titleLabel?.tintColor = .white
        chechkSortSwitch()
        chechkSizeSwitch()
    }
}

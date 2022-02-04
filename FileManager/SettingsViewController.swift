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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "reset" {
            if let vc = segue.destination as? LoginViewController {
                vc.resetPassword()
            }
        }
    }
    
    @IBAction func resetpressed(_ sender: UIButton) {
        performSegue(withIdentifier: "reset", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        resetButton.titleLabel?.tintColor = .white
    }
}

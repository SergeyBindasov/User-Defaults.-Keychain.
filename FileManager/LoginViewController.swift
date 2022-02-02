//
//  LoginViewController.swift
//  FileManager
//
//  Created by Sergey on 02.02.2022.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var button: UIButton!
    
    @IBAction func buttonPressed(_ sender: UIButton) {
    }
    
    func conditionCheck() {
        if view.backgroundColor != .white {
            button.titleLabel?.text = "Создать пароль"
        } else {
            button.titleLabel?.text = "Введите пароль"
        }
    }
    
    override func viewDidLoad() {
         super.viewDidLoad()
        conditionCheck()
    }
    
}

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
        if checkPass(pass: passwordTF.text) == true {
            button.setTitle("Повторите пароль", for: .normal)
            passwordTF.text = ""
        } else {
            let alert = UIAlertController(title: "Ошибка", message: "Пароль должен состоять минимум из 4 символов.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel) { _ in
                self.passwordTF.text = ""
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func conditionCheck() {
        if view.backgroundColor != .white {
            button.titleLabel?.text = "Создать пароль"
        } else {
            button.titleLabel?.text = "Введите пароль"
        }
    }
    
    func checkPass(pass: String?) -> Bool {
    let validPassword = NSPredicate(format: "SELF MATCHES %@ ", ".{4,}$")
    return validPassword.evaluate(with: pass)
}
    
    override func viewDidLoad() {
         super.viewDidLoad()
        conditionCheck()
        
    
    }
    
}


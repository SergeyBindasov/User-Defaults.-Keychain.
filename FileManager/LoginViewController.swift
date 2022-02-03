//
//  LoginViewController.swift
//  FileManager
//
//  Created by Sergey on 02.02.2022.
//

import UIKit
import KeychainAccess

class LoginViewController: UIViewController {
    
    let keyChain = Keychain(service: "com.sergeybindasov.FileManager")
    
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmTF: UITextField!
    @IBOutlet weak var button: UIButton!
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if sender.titleLabel?.text == "Создать пароль" {
            if checkPass(pass: passwordTF.text) == true {
                createPassword(password: passwordTF.text!)
                
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
    }
    
    @IBAction func checkPassword(_ sender: UIButton) {
        if sender.titleLabel?.text == "Повторите пароль" {
            guard let userPassword = confirmTF.text else { return }
            if userPassword == keyChain["password"]! {
            performSegue(withIdentifier: "button", sender: self)
            } else {
                let alert = UIAlertController(title: "Ошибка", message: "Пароли не совпадают. Повоторите все заново.", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .cancel) { _ in
                    self.keyChain["password"] = nil
                    self.passwordTF.text = ""
                    self.confirmTF.text = ""
                    self.confirmTF.isHidden = true
                    self.button.setTitle("Создать пароль", for: .normal)
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        if sender.titleLabel?.text == "Введите пароль" {
            guard let userPassword = passwordTF.text else { return }
            if userPassword == keyChain["password"]! {
                performSegue(withIdentifier: "button", sender: self)
            } else {
                let alert = UIAlertController(title: "Ошибка", message: "Пароль не правильный", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .cancel) { _ in
                    self.passwordTF.text = ""
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func createPassword(password: String) {
        keyChain["password"] = password
        button.setTitle("Повторите пароль", for: .normal)
        confirmTF.isHidden = false
        confirmTF.isSecureTextEntry = true
    }
    
    func conditionCheck() {
        if keyChain["password"] == nil {
            button.setTitle("Создать пароль", for: .normal)
        } else {
            button.setTitle("Введите пароль", for: .normal)
        }
    }
    
    func checkPass(pass: String?) -> Bool {
        let validPassword = NSPredicate(format: "SELF MATCHES %@ ", ".{4,}$")
        return validPassword.evaluate(with: pass)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTF.isSecureTextEntry = true
        button.titleLabel?.tintColor = .white
        confirmTF.isHidden = true
        conditionCheck()
    }
}

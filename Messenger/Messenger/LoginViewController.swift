//
//  LoginViewController.swift
//  Messenger
//
//  Created by Owner on 2020/06/11.
//  Copyright © 2020 ALJ. All rights reserved.
//

import UIKit
import NCMB

class LoginViewController: UIViewController {

    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordTextField.isSecureTextEntry = true
    }
    @IBAction func loginButtonTapped(_ sender: Any) {
        let userId = userIdTextField.text!
        let password = passwordTextField.text!
        NCMBUser.logInWithUsername(inBackground: userId, password: password, block: ({(user, error) in
            if (error != nil){
                print("ログイン失敗:\(error)")
            } else {
                print("ログイン成功:\(user)")
                
                _ = self.navigationController?.popToRootViewController(animated: true)
            }
        }))
    }
    
}

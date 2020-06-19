//
//  FBLoginViewController.swift
//  Deai
//
//  Created by Owner on 2020/06/17.
//  Copyright © 2020 ALJ. All rights reserved.
//

import UIKit
import NCMB

class FBLoginViewController: UIViewController {
    
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //ログインボタンタップ時
    @IBAction func loginFacebookAction(_ sender: UIButton) {
        //NMBCユーザインスタス生成
        let user = NCMBUser()
        user.userName = self.userIdTextField.text
        user.password = self.passwordTextField.text

        //NCMBログイン
        let userId = userIdTextField.text!
        let password = passwordTextField.text!
        NCMBUser.logInWithUsername(inBackground: userId, password: password, block:({(user, error) in
            if (error != nil){
                print("ログイン失敗:\(error)")
            }else{
                print("ログイン成功:\(user)")
                self.navigationController?.popToRootViewController(animated: true)
            }
        }))
    }

}
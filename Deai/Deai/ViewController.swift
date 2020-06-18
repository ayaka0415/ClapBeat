//
//  ViewController.swift
//  Deai
//
//  Created by Owner on 2020/06/17.
//  Copyright © 2020 ALJ. All rights reserved.
//

import UIKit
import NCMB

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var interestedInWoman: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ncmbLoginCheck()
    }

    func ncmbLoginCheck() {
        if (NCMBUser.current() != nil) {
            print("ログイン済み")
            //自分の写真を表示
            self.setMyPicture()
        } else {
            print("未ログイン")
            self.performSegue(withIdentifier: "toLogin", sender: nil)
        }
}
    //顔写真表示
    func setMyPicture(){
        let user = NCMBUser.current()
        print("user:\(user)")
        let fbPictureUrl = "https://graph.facebook.com/" + user!.userName + "/picture?type=large"
        if let fbpicUrl = NSURL(string: fbPictureUrl) {
            if let data = NSData(contentsOf: fbpicUrl as URL) {
                self.imageView.image = UIImage(data: data as Data)
            }
        }
    }
    // ログアウトボタンタップ時
    @IBAction func logoutButtonTapped(sender: AnyObject) {
        NCMBUser.logOut()
        ncmbLoginCheck()
    }
    //スタートボタンタップ時
    @IBAction func startButtonTapped(_ sender: UIButton) {
        //NCMBに好みの性別情報を保存
        let user = NCMBUser.current()
        user?.setObject(interestedInWoman.isOn, forKey: "interestedInWoman")
        user?.saveEventually({(error) in
            if(error != nil){
                print("保存失敗:\(error)")
            }else{
                print("保存成功:\(user)")
                //次の画面
                self.performSegue(withIdentifier: "toTinder", sender: nil)
            }
        })
    }
}

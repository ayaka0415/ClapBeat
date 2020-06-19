//
//  UserDetailViewController.swift
//  Deai
//
//  Created by Owner on 2020/06/18.
//  Copyright © 2020 ALJ. All rights reserved.
//

import UIKit
import NCMB
import MessageUI

class UserDetailViewController: UIViewController,MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mailLabel: UILabel!
    
    var user = NCMBUser() //選択されたユーザ
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //メアド表示
        mailLabel.text = user.object(forKey: "mailAddress") as? String
        //画像表示
        let fbPictureUrl = "https://ca.slack-edge.com/TMX0CSJFP-U011AQ9SDKK-90df2b714085-512"
        if let fbpicUrl = NSURL(string: fbPictureUrl) {
        if let data = NSData(contentsOf: fbpicUrl as URL) {
            self.imageView.image = UIImage(data: data as Data)
        }
        }
        
    }
    
    @IBAction func contact(_ sender: AnyObject) {
        
        //メールを送信できるかチェック
        if MFMailComposeViewController.canSendMail() == false {
            print("Email Send Failed")
            return
        }
            let mailViewController = MFMailComposeViewController()
            let toRecipients = [user.object(forKey: "mailAddress") as! String] //Toのアドレス指定
            mailViewController.mailComposeDelegate = self
            mailViewController.setSubject("「出会いアプリ」メール通知")
            mailViewController.setToRecipients(toRecipients)
            //Toアドレスの表示
            mailViewController.setMessageBody("", isHTML: false)
            // 画像追加
            let fbPictureUrl = "https://ca.slack-edge.com/TMX0CSJFP-U011AQ9SDKK-90df2b714085-512" + NCMBUser.current().userName + "/picture?type=large"
            if let fbpicUrl = NSURL(string: fbPictureUrl) {
                if let data = NSData(contentsOf: fbpicUrl as URL) {
                    mailViewController.addAttachmentData(data as Data, mimeType: "image/png", fileName: "image")
                   }
               }
               self.present(mailViewController, animated: true, completion: nil)
               
           }
           // メール完了時
           private func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
               switch result {
               case MFMailComposeResult.cancelled:
                   print("メール送信キャンセル")
               case MFMailComposeResult.saved:
                   print("メールドラフト保存")
               case MFMailComposeResult.sent:
                   print("メール送信完了")
               case MFMailComposeResult.failed:
                    print("メール送信失敗")
               default:
                   break
               }
               // 画面を閉じる
               self.dismiss(animated: true, completion: nil)
           }
          

       }


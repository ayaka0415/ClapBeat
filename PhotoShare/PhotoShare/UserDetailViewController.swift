//
//  UserDetailViewController.swift
//  PhotoShare
//
//  Created by Owner on 2020/06/12.
//  Copyright © 2020 ALJ. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    @IBOutlet weak var friendRequestedLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var friendRequestButton: UIButton!
    
    var user = NCMBUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.userIdLabel.text = user.userName
        
        self.friendRequestedLabel.isHidden = true
        
        self.friendRequestButton.setTitle("友情申請", for: .normal)
        self.friendRequestButton.isEnabled = true
        self.friendRequestButton.addTarget(self, action: #selector(UserDetailViewController.sendFriendRequest(sender:)), for: .touchUpInside)
        
        self.checkFriendRequestStatus()
        self.checkFriendRequestedBySelectedUser()
    }
    
        @objc func sendFriendRequest(sender: AnyObject){
        let fr = NCMBObject(className: "FriendRequest")
        fr?.setObject(NCMBUser.current(), forKey: "from")
        fr?.setObject(self.user, forKey: "to")
        fr?.setObject("pending", forKey: "status")
        fr?.saveInBackground({(error) in
            if error != nil {
                print("友達申請保存失敗:\(error)")
            } else {
                print("友達申請保存成功:\(fr)")
                self.changeDisplayByStatus(friendRequest: fr!)
            }
        })
    }
    
    func checkFriendRequestStatus(){
        let query = NCMBQuery(className: "FriendRequest")
        
        query?.whereKey("from", equalTo: NCMBUser.current())
        query?.whereKey("to", equalTo: self.user)
        query?.findObjectsInBackground({(objects, error) in
            if(error != nil) {
                print("登録件数:\(objects?.count)")
                
                if objects!.count > 0 {
                    let fr = objects![0] as! NCMBObject
                    self.changeDisplayByStatus(friendRequest: fr)
                }
            } else {
                print("友達申請状況取得失敗:\(error)")
            }
        })
    }
    
    func changeDisplayByStatus(friendRequest:NCMBObject){
        let status = friendRequest.object(forKey: "status") as! String
        switch status {
        case "pending":
            self.friendRequestButton.setTitle("友達申請中", for: .normal)
            self.friendRequestButton.isEnabled = false
            
        case "accepted":
            self.friendRequestButton.setTitle("友達承認済み", for: .normal)
            self.friendRequestButton.isEnabled = false
            self.friendRequestedLabel.isHidden = true
            
        case "requested":
            self.friendRequestedLabel.isHidden = false
            self.friendRequestButton.setTitle("承認", for: .normal)
            self.friendRequestButton.isEnabled = true
            
            self.friendRequestButton.removeTarget(self, action: #selector(UserDetailViewController.sendFriendRequest(sender:)), for: .touchUpInside)
            self.friendRequestButton.addTarget(self, action: #selector(UserDetailViewController.acceptFriendRequest(sender:)), for: .touchUpInside)
            
        default:
            self.friendRequestButton.setTitle("友達申請", for: .normal)
            self.friendRequestButton.isEnabled = true
            self.friendRequestButton.addTarget(self, action: #selector(UserDetailViewController.sendFriendRequest(sender:)), for: .touchUpInside)
        }
    }
    
    func checkFriendRequestedBySelectedUser(){
        let query = NCMBQuery(className: "FriendRequest")
        
        query?.whereKey("from", equalTo: self.user)
        query?.whereKey("to", equalTo: NCMBUser.current())
        query?.findObjectsInBackground({(objects, error) in
            if (error == nil) {
                if objects!.count > 0 {
                    print("objects:\(objects)")
                    let fr = objects![0] as! NCMBObject
                    if fr.object(forKey: "status") as! String == "pending"{
                        fr.setObject("requested", forKey: "status")
                    }
                    self.changeDisplayByStatus(friendRequest: fr)
                }
            } else {
                print("友達申請状況取得失敗:\(error)")
            }
        })
    }
    
    @objc func acceptFriendRequest(sender:AnyObject) {
        
        let query = NCMBQuery(className: "FriendRequest")
        query?.whereKey("from", equalTo: self.user)
        query?.whereKey("to", equalTo: NCMBUser.current())
        query?.findObjectsInBackground({(objects, error) in
            if(error == nil) {
                print("登録件数:\(objects!.count)")
                if objects!.count > 0 {
                    let fr = objects![0] as! NCMBObject
                    fr.setObject("accepted", forKey: "status")
                    fr.saveInBackground({(error) in
                        if error != nil {
                            print("友達申請承認失敗:\(error)")
                        } else {
                            print("友達申請承認成功")
                            
                            let fr = NCMBObject(className: "FriendRequest")
                            fr?.setObject(NCMBUser.current(), forKey: "from")
                            fr?.setObject(self.user, forKey: "to")
                            fr?.setObject("accepted", forKey: "status")
                            fr?.saveInBackground({(error) in
                                if error != nil {
                                    print("友達申請保存失敗:\(error)")
                                } else {
                                    print("友達申請保存成功:\(fr)")
                                    self.changeDisplayByStatus(friendRequest: fr!)
                                }
                            })
                            self.changeDisplayByStatus(friendRequest: fr!)
                        }
                    })
                }
            } else {
                print("友達申請状況取得失敗:\(error)")
            }
        })
    }
    
}

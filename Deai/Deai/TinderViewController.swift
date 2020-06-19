//
//  TinderViewController.swift
//  Deai
//
//  Created by Owner on 2020/06/17.
//  Copyright © 2020 ALJ. All rights reserved.
//

import UIKit
import CoreLocation
import NCMB

class TinderViewController: UIViewController {
    @IBOutlet weak var userImageView: UIImageView!
    
    let loctaionManager = CLLocationManager()
    var displayedUser = NCMBUser() //表示しているユーザID
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //画像にドラッグ認識
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.wasDragged(gesture:)))
        userImageView.addGestureRecognizer(gesture)
        userImageView.isUserInteractionEnabled = true
        //現在値取得
        self.getCurrentLocationAndDbSave()
        
    }
    //現在値を取得してDBに保存
    func getCurrentLocationAndDbSave(){
        //位置情報取得
        //承認されていない場合はここで認証ダイアログを表示
        let status = CLLocationManager.authorizationStatus()
        if(status == CLAuthorizationStatus.notDetermined) {
            print("didChangeAuthorizationStatus:\(status)")
            self.loctaionManager.requestAlwaysAuthorization()
        }
        NCMBGeoPoint.geoPointForCurrentLocation(inBackground: {(geopoint, error) in
            if error != nil{
                print("geo point error:\(error)")
            } else {
                print("geo point success lat:\(geopoint!.latitude), lon:\(geopoint!.longitude)")
                let user = NCMBUser.current()
                user?.setObject(geopoint, forKey: "geopoint")
                user?.saveEventually({(error) in
                    if error != nil {
                        print("現在地保存失敗:\(error)")
                    } else {
                        print("現在地保存成功:\(user)")
                        //ユーザ取得
                        self.fetchUser()
                    }
                })
            }
        })
    }
    
    func fetchUser(){
        print("fetchUser")
        // クエリ1.既にアクションしているリストを取得
        let query1 = NCMBQuery(className: "Action")
        query1?.whereKey("from", equalTo: NCMBUser.current())
        query1?.findObjectsInBackground({(objects, error) in
            if (error != nil){
                print("アクション取得失敗:\(error)")
            } else {
                print("アクション取得成功:\(objects)")
                // クエリ2.現在地に近いユーザ検索
                //現地取得
                let currentGeoPoint = NCMBUser.current()?.object(forKey: "geopoint") as! NCMBGeoPoint
                print("currentGeoPoint lat:\(currentGeoPoint.latitude), lon:\(currentGeoPoint.longitude)")
                //探している性別
                let interestedInWoman = NCMBUser.current()?.object(forKey: "interestedInWoman") as! Bool
                
                let query2 = NCMBQuery(className: "user")
//                query2?.whereKey("geopoint", nearGeoPoint: currentGeoPoint, withinKilometers:  1.0)
                //探している性別に合わせて検索条件変更
//                if interestedInWoman == true {
//                    query2?.whereKey("gender", equalTo: "female")
//                } else {
//                    query2?.whereKey("gender", equalTo: "male")
//                }
                //取得件数は1
                query2?.limit = 1
                //アクションした人対象外
                var ignoredUsers = [""]
                for object in objects! {
                    let action = object as! NCMBObject
                    let user = action.object(forKey: "to")
                    print("to user:\(user)")
                    ignoredUsers.append((object as AnyObject).objectId as String)
                }
                print("ignoredUsers:\(ignoredUsers)")
                query2?.whereKey("objectId", notContainedInArrayTo: ignoredUsers)
                query2?.findObjectsInBackground({(objects, error) in
                    if (error != nil) {
                        print("友達取得失敗:\(error)")
                    } else {
                        print("友達取得成功:\(objects)")
                        print("object count: ", objects!.count)
                        if objects!.count > 0 {
                            print("object count")
                            self.displayedUser = objects![0] as! NCMBUser
                            let fbPictureUrl = "https://ca.slack-edge.com/TMX0CSJFP-U011AQ9SDKK-90df2b714085-512"
                            
                            if let fbpicUrl = NSURL(string: fbPictureUrl) {
                                if let data = NSData(contentsOf: fbpicUrl as URL) {
                                    self.userImageView.image = UIImage(data: data as Data)
                                }
                            }
                        } else {
                            //画像初期化
                            self.userImageView.image = UIImage()
                            self.userImageView.isUserInteractionEnabled = false
                        }
                    }
                })
                
            }
        })
    }
    
    @objc func wasDragged(gesture: UIPanGestureRecognizer) {
        //ドラッグ度合い取得
        let  translation = gesture.translation(in: self.view)
        //対象view取得
        let imageView = gesture.view!
        //View移動
        imageView.center = CGPoint(
            x: self.view.bounds.width / 2 + translation.x,
            y: self.view.bounds.height / 2 + translation.y
        )
        //中央からx軸移動量取得
        let xFromCenter = imageView.center.x - self.view.bounds.width / 2
        //x軸移動量から縮小率算出
        let scale = min(100 / abs(xFromCenter), 1)
        //x軸移動量から回転率算出
        var rotation = CGAffineTransform(rotationAngle: xFromCenter / 200)
        //回転・縮小の値をセット
        var stretch = rotation.scaledBy(x: scale, y: scale)
        //Viewを回転・縮小
        imageView.transform = stretch
        //ドラッグ完了時X軸が100p以上移動していたらDB登録して次のユーザを表示
        if gesture.state == UIGestureRecognizer.State.ended {
            var acceptedOrRejected = ""
            if imageView.center.x < 100 {
                acceptedOrRejected = "rejected"
            } else if imageView.center.x > self.view.bounds.width - 100 {
                acceptedOrRejected = "accepted"
            }
            print("好みの相手判断:\(acceptedOrRejected)")
            if acceptedOrRejected != "" {
                //登録処理
                let action = NCMBObject(className: "Action")
                action?.setObject(NCMBUser.current(), forKey: "from")
                action?.setObject(self.displayedUser, forKey: "to")
                action?.setObject(acceptedOrRejected, forKey: "acceptedOrRejected")
                let acl = NCMBACL()
                acl.setPublicReadAccess(true)
                action?.acl = acl
                action?.saveInBackground({(error) in
                    if error != nil{
                        print("Actionテーブル保存失敗:\(error)")
                    } else {
                        print("Actionテーブル保存成功:\(action)")
                        self.fetchUser()
                    }
                })
            }
            //元の位置に戻す
            rotation = CGAffineTransform(rotationAngle: 0)
            stretch = rotation.scaledBy(x: 1, y: 1)
            imageView.transform = stretch
            imageView.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
        }
        
    }
}

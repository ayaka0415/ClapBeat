//
//  UserListViewController.swift
//  PhotoShare
//
//  Created by Owner on 2020/06/12.
//  Copyright © 2020 ALJ. All rights reserved.
//

import UIKit
import  NCMB

class UserListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var userList = NSArray()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchUserList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let user = userList.object(at: indexPath.row) as! NCMBUser
        cell.textLabel!.text = user.userName
        return cell
    }
    
    func fetchUserList(){
        let query = NCMBQuery(className: "user")
        
        query?.whereKey("objectId", notEqualTo: NCMBUser.current()?.objectId)
        query?.findObjectsInBackground({(objects, error) in
            if(error != nil){
                print("友達獲得失敗:\(error)")
            } else {
                print("友達獲得成功")
                self.userList = objects as! NSArray
                self.tableView.reloadData()
            }
        })
        
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("table cell tapped")
        let user = userList.object(at: indexPath.row) as! NCMBUser
        self.performSegue(withIdentifier: "toUserDetail", sender: user)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toUserDetail" {
            let vc = segue.destination as! UserDetailViewController
            vc.user = sender as! NCMBUser
        }
    }

}

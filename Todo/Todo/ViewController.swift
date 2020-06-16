//
//  ViewController.swift
//  Todo
//
//  Created by Owner on 2020/06/15.
//  Copyright © 2020 ALJ. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var todoItems:Results<ToDo>?{
        do{
            let realm = try Realm()
            return realm.objects(ToDo.self).sorted(byKeyPath: "createDate")
        }catch{
            print("エラー")
        }
        return nil
    }
    
    var actionType = ""
    var selectedTodo:ToDo!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
          super.didReceiveMemoryWarning()
      }
    
    @IBAction func addButtonTapped(sender: AnyObject) {
        //TODO編集画面へ
        self.actionType = "NEW"
        self.performSegue(withIdentifier: "toDetail", sender: nil)
    }
    //画面移動の時に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //移動時にアクション種別と更新時に）選択されたTODOリストを送る
        if segue.identifier == "toDetail" {
            let vc = segue.destination as! TodoDetailViewController
            vc.actionType = self.actionType
            vc.selectedTodo = selectedTodo
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.actionType = "UPDATE"
        selectedTodo = todoItems?[indexPath.row]
        self.performSegue(withIdentifier: "toDetail", sender: selectedTodo)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let toDo = todoItems?[indexPath.row]
        cell.textLabel?.text = toDo?.name
        return cell
    }

}


//
//  TodoDetailViewController.swift
//  Todo
//
//  Created by Owner on 2020/06/16.
//  Copyright © 2020 ALJ. All rights reserved.
//

import UIKit
import RealmSwift

class TodoDetailViewController: UIViewController {
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var commitButton: UIButton!
    @IBOutlet weak var trashButton: UIBarButtonItem!
    
    var actionType = ""
    var selectedTodo:ToDo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
    }
    //画面表示切り替え
    func initView(){
        if actionType == "NEW" {
            self.title = "TODO新規追加"
            self.commitButton.setTitle("新規追加", for: .normal)
            self.commitButton.addTarget(self, action: #selector(dbAdd(_:)), for: .touchUpInside)
            self.titleField.text = ""
            self.descTextView.text = ""
            self.navigationItem.rightBarButtonItem = nil
        } else if actionType == "UPDATE" {
            self.title = "TODO編集"
            self.commitButton.setTitle("更新", for: .normal)
            self.commitButton.addTarget(self, action: #selector(dbUpdate(_:)), for: .touchUpInside)
            self.titleField.text = selectedTodo.name
            self.descTextView.text = selectedTodo.desc
        }
      }
    
        @objc func dbAdd(_ sender: UIButton) {
        if isValidateInputContents() == false{
            return
        }
        //toDoデータ作成
        let toDo = ToDo()
        toDo.name = titleField.text!
        //現在の時刻セット
        toDo.createDate = NSDate()
        //DB登録
        do{
            let realm = try Realm()
            try realm.write{
                realm.add(toDo)
            }
            print("DB登録成功")
        }catch{
            print("DB登録失敗")
        }
        //前の画面戻る
        self.navigationController?.popViewController(animated: true)
    }
    //入力チェック
    private func isValidateInputContents() -> Bool{
        //名前入力
        if let title = titleField.text{
            if title.count == 0{
                return false
            }
        }else{
            return false
        }
        return true
    }
    
    @objc func dbUpdate(_ sender:UIButton) {
        do{
            let realm = try Realm()
            try realm.write{
                selectedTodo.name = self.titleField.text!
                selectedTodo.desc = self.descTextView.text
                selectedTodo.updateDate = NSDate()
            }
            print("DB更新成功")
        }catch{
            print("DB更新失敗")
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func dbDelete(sender: AnyObject) {
        do{
            let realm = try Realm()
            try realm.write{
                realm.delete(selectedTodo)
            }
        }catch{
            print("失敗")
        }
        self.navigationController?.popViewController(animated: true)
    }
}

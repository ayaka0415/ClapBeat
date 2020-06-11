//
//  ViewController.swift
//  testApp
//
//  Created by Owner on 2020/06/10.
//  Copyright © 2020 ALJ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var Color: UILabel!
    //色の名前
    var colorString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    //赤ボタン
    @IBAction func redButton(_ sender: Any) {
        //トップ画面の「Color」の色変える
        Color.textColor = UIColor.red
        //変数に文字代入
        colorString = "red"
    }
    //黄色ボタン
    @IBAction func yellowButton(_ sender: Any) {
        Color.textColor = UIColor.yellow
        colorString = "yellow"
    }
    //青ボタン
    @IBAction func blueButton(_ sender: Any) {
        Color.textColor = UIColor.blue
        colorString = "blue"
    }
     //結果画面へのSegueを始動
    @IBAction func Next(_ sender: Any) {
        self.performSegue(withIdentifier: "toResultView", sender:self)
    }
    //結果画面へのSegueの発動
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //ResultViewController(rvc)のインスタンス作成
        //rvcクラスのメンバ変数であるcolorStringに値を渡す
        if segue.identifier == "toResultView" {
            let rvc = segue.destination as! ResultViewController
            rvc.colorString = colorString
        }
    }
    
    @IBAction func backView(segue:UIStoryboardSegue){
    }

}


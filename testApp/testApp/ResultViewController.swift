//
//  ResultViewController.swift
//  testApp
//
//  Created by Owner on 2020/06/10.
//  Copyright © 2020 ALJ. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    @IBOutlet weak var colorLabel: UILabel!
    //トップ画面から受け渡される値
    var colorString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        switch colorString {
        case "red":
            //トップ画面から受け渡された値を代入
            colorLabel.text = colorString
            //↑の文字の色を変える
            colorLabel.textColor = UIColor.red
        case "yellow":
            colorLabel.text = colorString
            colorLabel.textColor = UIColor.yellow
        case "blue":
            colorLabel.text = colorString
            colorLabel.textColor = UIColor.blue
        default:
            break
        }
       
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  ViewController.swift
//  ClapBeat
//
//  Created by Owner on 2020/06/04.
//  Copyright © 2020 ALJ. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var PickerView: UIPickerView!
    let clapInstance = Clap()
    var repeatNumbersForPicker = NSMutableArray()
    var repeatNumbersArray: [String] = []
    var repeatCount = Int()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        //今回は1つのカラム（手拍子の回数）のみ
        return 1
    }
    //カラムの要素数を指定
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //今回は10個の要素（「1回」～「10回」）
        return 10
    }
    //選択肢要素の表示文字列
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //row番目の要素に表示する文字列
        return repeatNumbersForPicker[row] as? String
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //繰り返し回数は(row+1)回
        //例：4番目の要素 =>「5回」=> 繰り返し回数は(4+1=5)回
        repeatCount = row+1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //初期の手拍子の数として1（1回）を指定
        repeatCount = 1
        //Picker Viewの選択肢一覧を準備
        for i in 0..<10 {
            let numberText = String(format: "%d回", i+1)
            // NSMutableArray版
            repeatNumbersForPicker[i] = numberText
            // Array版
            repeatNumbersArray.append(numberText)
        }
        
        PickerView.delegate = self
        PickerView.dataSource = self
    }
    
    @IBAction func play(_ sender: Any) {
    
        clapInstance.repeatClap(count: repeatCount)
    }
}


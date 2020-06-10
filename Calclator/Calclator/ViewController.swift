//
//  ViewController.swift
//  Calclator
//
//  Created by Owner on 2020/06/10.
//  Copyright © 2020 ALJ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //計算結果
    let resultLabel :UILabel = UILabel();
    //画面全体の横幅
    let screenWidth :Double = Double(UIScreen.main.bounds.size.width)
    //縦幅
    let screenHeight :Double = Double(UIScreen.main.bounds.size.height)
    
    //１行に配置するボタンの数
    let yButtonCount = 4
    //１列に配置するボタンの数
    let xButtonCount = 4
    //ボタン間の余白(縦)//ボタン間の余白(横)
    let buttonMargin :Double = 10.0
    //計算結果表示エリアの縦幅
    var resultArea :Double = 0
    //入力数字
    var number:NSDecimalNumber = 0
    //計算結果
    var result:NSDecimalNumber = 0
    //演算子
    var operatorId:String = ""
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // 画面全体の背景色
              self.view.backgroundColor = UIColor.black

        switch screenHeight {
           case 480:
           resultArea = 200.0
           case 568:
           resultArea = 250.0
           case 667:
           resultArea = 300.0
           case 736:
           resultArea = 300.0
           default:
           resultArea = 400.0
           }
        
        resultLabel.frame = CGRect(
           x: 10,
           y: 30,
           width: screenWidth - ( buttonMargin * 2 ),
           height: resultArea - 30
           )
        
        //計算結果ラベルを配置
        resultLabel.frame = CGRect(
            x: 10,
            y: 30,
            width: screenWidth - (10 * 2),
            height:  170
        )
        
        resultLabel.backgroundColor = self.colorWithRGBHex(hex: 0xF5F5DC, alpha: 1.0)
        //フォントサイズ指定
        let font:UIFont = UIFont(name:"Arial",size:50)!
        resultLabel.font = font
        
        resultLabel.textAlignment = .right
        //最大行数4行に変更
        resultLabel.numberOfLines = 4
        //初期値０
        resultLabel.text = "0"
        //画面に配置
        self.view.addSubview(resultLabel)
        //フォント設定
        resultLabel.font = UIFont(name:"LettersLaughingattheirExecution",size:50)
        // ボタンを配置
        // ボタンのラベルを配列で用意
        let buttonLabels = [
            "7","8","9","×",
            "4","5","6","-",
            "1","2","3","+",
            "0","C","÷","="
        ]
        // 繰り返し処理でボタンを配置
        for y in 0 ..< yButtonCount {
            for x in 0 ..< xButtonCount {
            // ボタンインスタンス生成（この時点ではサイズ、配置場所はきめていない）
            let button :UIButton = UIButton()
            //各ボタンの番号設定
            let buttonNumber = y * xButtonCount + x
            //各ボタンのラベル設定
                button.setTitle(buttonLabels[buttonNumber], for: .normal)
            // ボタンのx軸の配置
            let buttonPositionX =
                ( screenWidth - buttonMargin) / Double(xButtonCount) * Double(x) + buttonMargin
            // ボタンのy軸の配置
            let buttonPositionY =
                ( screenHeight - resultArea - buttonMargin) / Double(yButtonCount) * Double(y) + buttonMargin + resultArea
            // ボタンサイズ
            let buttonWidth =
                ( screenWidth - ( buttonMargin * ( Double(xButtonCount) + 1))) / Double(xButtonCount)
            let buttonHeight =
                ( screenHeight - resultArea - (( buttonMargin * Double(yButtonCount) + 1))) / Double(yButtonCount)
            // ボタンの配置場所、サイズを設定
            button.frame = CGRect(x:buttonPositionX,y:buttonPositionY,width:buttonWidth,height:buttonHeight)
            
            button.backgroundColor = UIColor.green
                let gradient : CAGradientLayer = CAGradientLayer()
                gradient.frame = button.bounds
                let arrayColors: NSArray = [
                    self.colorWithRGBHex(hex: 0xFFFFFF, alpha: 1.0).cgColor as AnyObject,
                        self.colorWithRGBHex(hex: 0xCCCCCC, alpha: 1.0).cgColor as AnyObject
                ]
                gradient.colors = arrayColors as? [Any]
                button.layer.insertSublayer(gradient, at: 0)
            // 角丸
            button.layer.masksToBounds = true
            button.layer.cornerRadius = 5.0
            // ボタンのテキストカラー
            button.setTitleColor(UIColor.black, for: .normal)
            button.setTitleColor(UIColor.gray, for: .highlighted)
            //ボタンタップ時のアクション
                button.addTarget(self, action: #selector(self.buttonTapped(_:)), for: .touchUpInside)
            // ボタン配置
            self.view.addSubview(button)
        }
    }

}
    //ボタンがタップされた時
    @objc func buttonTapped(_ sender: AnyObject){
        print("buttonTapped!!")
        let tappedButton:UIButton = sender as! UIButton
        let tappedButtonTitle:NSString = tappedButton.currentTitle! as NSString
        print("タップしたボタン:\(tappedButtonTitle)")
        //ボタンのタイトルで条件分岐
        switch tappedButtonTitle {
        //数字をタップ
        case "0","1","2","3","4","5","6","7","8","9":
            self.numberButtonTapped(nbt: tappedButtonTitle)
        case "×","-","+","÷":
            self.operatorButtonTapped(obt: tappedButtonTitle)
        case "=":
            self.equalButtonTapped(ebt: tappedButtonTitle)
        case "C":
            self.clearButtonTapped(cbt: tappedButtonTitle)
        default:
            print("その他")
        }
    }
    //数字をタップ
    func numberButtonTapped(nbt tappedButtonTitle:NSString){
        print("数字ボタンをタップ:\(tappedButtonTitle)")
    //タップされた数字タイトルを計算できるように変換
        let tappedButtonNum:NSDecimalNumber = NSDecimalNumber(string: tappedButtonTitle as String)
    // 入力されていた値を*10にして1桁大きく、その変換した数値を加算
        number = number.multiplying(by: NSDecimalNumber(string: "10")).adding(tappedButtonNum)
        
        resultLabel.text = number.stringValue
    }
    //演算子をタップ
    func operatorButtonTapped(obt tappedButtonTitle:NSString){
        print("演算子ボタンをタップ:" + (tappedButtonTitle as String))
        //operationIdにタップされた演算子情報を格納
        operatorId = tappedButtonTitle as String
        //今まで入力された数値を計算結果格納用の変数（result）に格納
        result = number
        //入力用変数（number）は0にリセット
        number = NSDecimalNumber(string: "0")
    }
    //等号のボタンをタップ
    func equalButtonTapped(ebt tappedButtonTitle:NSString){
        print("等号ボタンをタップ:\(tappedButtonTitle)")
        
        switch operatorId {
        case "+":
            result = result.adding(number)
        case "-":
            result = result.subtracting(number)
        case "×":
            result.multiplying(by: number)
        case "÷":
            if(number.isEqual(to: 0)){
                number = 0
                resultLabel.text = "無限大"
                return
            } else {
                result = result.dividing(by: number)
            }
            
        default:
            print("その他")
        }
        number = 0
        resultLabel.text = result.stringValue
        operatorId = "="
    }
    //クリアボタンをタップ
    func clearButtonTapped(cbt tappedButtonTitle:NSString){
        print("クリアボタンをタップ::\(tappedButtonTitle)")
        
        number = NSDecimalNumber(string: "0")
        result = NSDecimalNumber(string: "0")
        operatorId = ""
        resultLabel.text = number.stringValue
    }
    
    func colorWithRGBHex(hex: Int, alpha: Float = 1.0) -> UIColor {
        let r = Float((hex >> 16) & 0xFF)
        let g = Float((hex >> 8) & 0xFF)
        let b = Float((hex) & 0xFF)
        return UIColor(red: CGFloat(r / 255.0), green: CGFloat(g / 255.0), blue:CGFloat(b / 255.0), alpha: CGFloat(alpha))
    }
}

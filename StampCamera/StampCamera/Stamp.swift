//
//  Stamp.swift
//  StampCamera
//
//  Created by Owner on 2020/06/11.
//  Copyright © 2020 ALJ. All rights reserved.
//

import UIKit

class Stamp: UIImageView {
    //ユーザーが画面にタッチした時に呼ばれるメソッド
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //この↑メソッドを上書き(override)して、画面にタッチした瞬間にこのクラスの親ビューを最前面にする
        self.superview?.bringSubviewToFront(self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //画面上のタッチ情報を取得
        let touch = touches.first!
        //画面上でドラッグしたx座標の移動距離
        let dx = touch.location(in: self.superview).x - touch.previousLocation(in: self.superview).x
        //画面上でドラッグしたy座標の移動距離
        let dy = touch.location(in: self.superview).y - touch.previousLocation(in: self.superview).y
         //このクラスの中心位置をドラッグした座標に設定
        self.center = CGPoint(x: self.center.x + dx, y: self.center.y + dy)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

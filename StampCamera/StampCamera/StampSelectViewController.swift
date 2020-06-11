//
//  StampSelectViewController.swift
//  StampCamera
//
//  Created by Owner on 2020/06/11.
//  Copyright © 2020 ALJ. All rights reserved.
//

import UIKit

class StampSelectViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //戻り値にimageArrayの要素数を設定
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         //UICollectionViewCellで使うための変数作成
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for:  indexPath as IndexPath)
        //セルの中の画像を表示するimageviewのタグ指定
        let imageView = cell.viewWithTag(1) as! UIImageView
        //セルの中のimageviewに配列の中の画像データを表示
        imageView.image = imageArray[indexPath.row]
        //設定したセルを戻り値に
        return cell
    }
  
    var imageArray:[UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //配列に1〜6.pngの画像データを格納
        for i in 1...6{
            imageArray.append(UIImage(named: "\(i).png")!)
        }
    }
    @IBAction func closeTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let stamp = Stamp()
        stamp.image = imageArray[indexPath.row]
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.stampArray.append(stamp)
        appDelegate.isNewStampAdded = true
        self.dismiss(animated: true, completion: nil)
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

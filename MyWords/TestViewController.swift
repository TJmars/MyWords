//
//  TestViewController.swift
//  MyWords
//
//  Created by Apple on 2020/05/23.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import UIKit
import RealmSwift

class TestViewController: UIViewController {
    
//    Realmのインスタンス化
    @IBOutlet weak var fromNumTextField: UITextField!
    @IBOutlet weak var toNumTextField: UITextField!
    var dataListArray = try! Realm().objects(RealmDataList.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let tapGesture:  UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
//    segueの管理　0からdataList.countの間に設置されているか、最低20単語あるかを判別　dataList.count - 1かも　後で考える
    @IBAction func segueButton(_ sender: Any) {
        if fromNumTextField.text != "" && toNumTextField.text != "" {
            if Int(fromNumTextField.text!)! >= 0 && Int(fromNumTextField.text!)! <= dataListArray.count {
                if Int(fromNumTextField.text!)! >= 0 && Int(toNumTextField.text!)! <= dataListArray.count {
                    if Int(toNumTextField.text!)! - Int(fromNumTextField.text!)! >= 19 {
//                        segueを実行
                        self.performSegue(withIdentifier: "toNowTest", sender: nil)
                    } else {
                        let dialog = UIAlertController(title: "エラー", message: "最低20語以上の範囲指定をしてください", preferredStyle: .alert)
                        dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(dialog, animated: true, completion: nil)
                    }
                } else {
                    let dialog = UIAlertController(title: "エラー", message: "範囲は0~\(dataListArray.count)の中で設定してください", preferredStyle: .alert)
                    dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(dialog, animated: true, completion: nil)
                }
            } else {
                let dialog = UIAlertController(title: "エラー", message: "範囲は0~\(dataListArray.count)の中で設定してください", preferredStyle: .alert)
                dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(dialog, animated: true, completion: nil)
            }
        } else {
            let dialog = UIAlertController(title: "エラー", message: "範囲指定欄に適切な値を入力してください", preferredStyle: .alert)
            dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(dialog, animated: true, completion: nil)
        }
    }
    
//    指定した範囲をInt型で渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nowTestViewController:NowTestViewController = segue.destination as! NowTestViewController
        nowTestViewController.fromNum = Int(fromNumTextField.text!)!
        nowTestViewController.toNum = Int(toNumTextField.text!)!
        
        fromNumTextField.text = ""
        toNumTextField.text = ""
    }
    
    @objc func dismissKeyBoard() {
           view.endEditing(true)
       }
    
    
    
    
}

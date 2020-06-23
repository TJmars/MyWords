//
//  MemoriViewController.swift
//  MyWords
//
//  Created by Apple on 2020/05/23.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import UIKit
import RealmSwift

class MemoriViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var numTextField: UITextField!
    
    @IBOutlet weak var allLabel: UILabel!
    @IBOutlet weak var miss1Label: UILabel!
    @IBOutlet weak var miss2Label: UILabel!
    @IBOutlet weak var miss3Label: UILabel!
    @IBOutlet weak var miss4Label: UILabel!
    
    
    //    Realmのインスタンス化
    let realm = try! Realm()
    var dataListArray = try! Realm().objects(RealmDataList.self)
    var realmDataList: RealmDataList!
    var wordHistory: WordHistory!
    //    segueの判別用変数 WordTextViewControllerへ渡すXの値を決めるための変数
    var segueNum = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        
        let tapGesture:  UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        self.view.addGestureRecognizer(tapGesture)
        
//        wordHistoryの初期値
        if let his = realm.objects(WordHistory.self).first {
            wordHistory = his
        } else {
            wordHistory = WordHistory()
        }
        
        // ツールバー生成
              let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
              // スタイルを設定
              toolBar.barStyle = UIBarStyle.default
              // 画面幅に合わせてサイズを変更
              toolBar.sizeToFit()
              // 閉じるボタンを右に配置するためのスペース?
              let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
              // 閉じるボタン
        let commitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.commitButtonTapped))
              // スペース、閉じるボタンを右側に配置
              toolBar.items = [spacer, commitButton]
              // textViewのキーボードにツールバーを設定
              numTextField.inputAccessoryView = toolBar
        
    }
    
    @objc func commitButtonTapped() {
        self.view.endEditing(true)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        let dataList0 = try! Realm().objects(RealmDataList.self)
        let dataList1 = try! Realm().objects(RealmDataList.self).filter("Miss1 != 0")
        let dataList2 = try! Realm().objects(RealmDataList.self).filter("Miss2 != 0")
        let dataList3 = try! Realm().objects(RealmDataList.self).filter("Miss3 != 0")
        let dataList4 = try! Realm().objects(RealmDataList.self).filter("Miss4 != 0")
        allLabel.text = "\(dataList0.count - 1)"
        miss1Label.text = "\(dataList1.count)"
        miss2Label.text = "\(dataList2.count)"
        miss3Label.text = "\(dataList3.count)"
        miss4Label.text = "\(dataList4.count)"
        
        numTextField.text = ""
        
        //        wordHistoryの初期値
        if let his = realm.objects(WordHistory.self).first {
            wordHistory = his
        } else {
            wordHistory = WordHistory()
        }
        
    }
    
    /* ミスボタンの設定
     WordListViewControllerでミスボタンが押されると、ひとつ下のランクにコピーされる  リセットボタンで配列は空になる
     numTextField.textをInt型に変換し、その値を用いて範囲指定を行う
     またボタンが押された直後に、他のボタンを押すことで変更されたdataListを初期値(全単語収録されたもの)に戻している
     */
    @IBAction func allButton(_ sender: Any) {
        dataListArray = try! Realm().objects(RealmDataList.self)
        if numTextField.text != "" {
            let rangeNum = Int(numTextField.text!)!
            if rangeNum >= 0 && rangeNum < dataListArray.count {
                dataListArray = try! Realm().objects(RealmDataList.self).filter("id >= \(rangeNum)")
                if dataListArray.count != 0 {
                    segueNum = 0
                    self.performSegue(withIdentifier: "toWordList", sender: nil)
                } else {
                    dialogA()
                }
            } else {
                dialogA()
            }
        } else {
            dataListArray = try! Realm().objects(RealmDataList.self)
            if dataListArray.count != 0 {
                segueNum = 0
                self.performSegue(withIdentifier: "toWordList", sender: nil)
                
            } else {
                dialogB()
            }
        }
    }
    
    @IBAction func miss1Button(_ sender: Any) {
        
       
        dataListArray = try! Realm().objects(RealmDataList.self)
        if numTextField.text != "" {
            let rangeNum = Int(numTextField.text!)!
            if rangeNum >= 0 && rangeNum < dataListArray.count {
                dataListArray = try! Realm().objects(RealmDataList.self).filter("id >= \(rangeNum) && Miss1 != 0")
                if dataListArray.count != 0 {
                    segueNum = 1
                    self.performSegue(withIdentifier: "toWordList", sender: nil)
                } else {
                    dialogA()
                }
            } else {
                dialogA()
            }
            
        } else {
            dataListArray = try! Realm().objects(RealmDataList.self).filter("Miss1 != 0")
            if dataListArray.count != 0 {
                segueNum = 1
                self.performSegue(withIdentifier: "toWordList", sender: nil)
            } else {
                dialogB()
            }
        }
        
    }
    
    @IBAction func miss2Button(_ sender: Any) {
        dataListArray = try! Realm().objects(RealmDataList.self)
        if numTextField.text != "" {
            let rangeNum = Int(numTextField.text!)!
            if rangeNum >= 0 && rangeNum < dataListArray.count {
                dataListArray = try! Realm().objects(RealmDataList.self).filter("id >= \(rangeNum) && Miss2 != 0")
                if dataListArray.count != 0 {
                    segueNum = 2
                    self.performSegue(withIdentifier: "toWordList", sender: nil)
                } else {
                    dialogA()
                }
            } else {
                dialogA()
            }
            
        } else {
            dataListArray = try! Realm().objects(RealmDataList.self).filter("Miss2 != 0")
            if dataListArray.count != 0 {
                segueNum = 2
                self.performSegue(withIdentifier: "toWordList", sender: nil)
            } else {
                dialogB()
            }
        }
    }
    
    @IBAction func miss3Button(_ sender: Any) {
        dataListArray = try! Realm().objects(RealmDataList.self)
        if numTextField.text != "" {
            let rangeNum = Int(numTextField.text!)!
            if rangeNum >= 0 && rangeNum < dataListArray.count {
                dataListArray = try! Realm().objects(RealmDataList.self).filter("id >= \(rangeNum) && Miss3 != 0")
                if dataListArray.count != 0 {
                    segueNum = 3
                    self.performSegue(withIdentifier: "toWordList", sender: nil)
                } else {
                    dialogA()
                }
            } else {
                dialogA()
            }
            
        } else {
            dataListArray = try! Realm().objects(RealmDataList.self).filter("Miss3 != 0")
            if dataListArray.count != 0 {
                segueNum = 3
                self.performSegue(withIdentifier: "toWordList", sender: nil)
            } else {
                dialogB()
            }
        }
    }
    
    @IBAction func miss4Button(_ sender: Any) {
        dataListArray = try! Realm().objects(RealmDataList.self)
        if numTextField.text != "" {
            let rangeNum = Int(numTextField.text!)!
            if rangeNum >= 0 && rangeNum < dataListArray.count {
                dataListArray = try! Realm().objects(RealmDataList.self).filter("id >= \(rangeNum) && Miss4 != 0")
                if dataListArray.count != 0 {
                    segueNum = 4
                    self.performSegue(withIdentifier: "toWordList", sender: nil)
                } else {
                    dialogA()
                }
            } else {
                dialogA()
            }
            
        } else {
           
            dataListArray = try! Realm().objects(RealmDataList.self).filter("Miss4 != 0")
            
            if dataListArray.count != 0 {
                print("call")
                segueNum = 4
                self.performSegue(withIdentifier: "toWordList", sender: nil)
            } else {
                dialogB()
            }
        }
        
    }
    
    //    画面遷移時に呼ばれる　xを渡すことでどのボタンで遷移したか判別する
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let wordListViewController:WordListViewController = segue.destination as! WordListViewController
        switch segueNum {
        case 0:
            wordListViewController.x = 0
        case 1:
            wordListViewController.x = 1
        case 2:
            wordListViewController.x = 2
        case 3:
            wordListViewController.x = 3
        case 4:
            wordListViewController.x = 4
        default:
            wordListViewController.x = 0
        }
        
        if numTextField.text != "" {
            wordListViewController.startNum = Int(numTextField.text!)!
        }
    }
    
    @IBAction func miss1ResetButton(_ sender: Any) {
        let dialog = UIAlertController(title: "リセット", message: "このランクに登録された単語をリセットします(他のランクの単語は残ります)", preferredStyle: .alert)
        dialog.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            self.dataListArray = try! Realm().objects(RealmDataList.self)
            try! self.realm.write {
                self.dataListArray.setValue(0, forKey: "Miss1")
                let data = try! Realm().objects(RealmDataList.self).filter("Miss1 != 0")
                
                self.miss1Label.text = "\(data.count)"
                
                self.wordHistory.miss1His = 0
                self.wordHistory.miss1HisCha = 0
                self.realm.add(self.wordHistory)
                
            }
            
        }))
        
        self.present(dialog, animated: true, completion: nil)
        
    }
    
    @IBAction func miss2ResetButton(_ sender: Any) {
        let dialog = UIAlertController(title: "リセット", message: "このランクに登録された単語をリセットします(他のランクの単語は残ります)", preferredStyle: .alert)
        dialog.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            self.dataListArray = try! Realm().objects(RealmDataList.self)
            try! self.realm.write {
                self.dataListArray.setValue(0, forKey: "Miss2")
                let data = try! Realm().objects(RealmDataList.self).filter("Miss2 != 0")
                
                self.miss2Label.text = "\(data.count)"
                
                self.wordHistory.miss2His = 0
                self.wordHistory.miss2HisCha = 0
                self.realm.add(self.wordHistory)
            }
            
        }))
        self.present(dialog, animated: true, completion: nil)
        
    }
    
    @IBAction func miss3ResetButton(_ sender: Any) {
        let dialog = UIAlertController(title: "リセット", message: "このランクに登録された単語をリセットします(他のランクの単語は残ります)", preferredStyle: .alert)
        dialog.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            self.dataListArray = try! Realm().objects(RealmDataList.self)
            try! self.realm.write {
                self.dataListArray.setValue(0, forKey: "Miss3")
                let data = try! Realm().objects(RealmDataList.self).filter("Miss3 != 0")
                
                self.miss3Label.text = "\(data.count)"
                
                self.wordHistory.miss3His = 0
                self.wordHistory.miss3HisCha = 0
                self.realm.add(self.wordHistory)
            }
            
        }))
        self.present(dialog, animated: true, completion: nil)
        
    }
    
    @IBAction func miss4ResetButton(_ sender: Any) {
        let dialog = UIAlertController(title: "リセット", message: "このランクに登録された単語をリセットします(他のランクの単語は残ります)", preferredStyle: .alert)
        dialog.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            self.dataListArray = try! Realm().objects(RealmDataList.self)
            try! self.realm.write {
                self.dataListArray.setValue(0, forKey: "Miss4")
                let data = try! Realm().objects(RealmDataList.self).filter("Miss4 != 0")
                
                self.miss4Label.text = "\(data.count)"
                
                self.wordHistory.miss4His = 0
                self.wordHistory.miss4HisCha = 0
                self.realm.add(self.wordHistory)
            }
            
        }))
        self.present(dialog, animated: true, completion: nil)
        
        
    }
    //    ダイアログの関数
    func dialogA() {
        let dialog = UIAlertController(title: "登録されている単語がありません", message: "開始番号を変更するか、他のランクに挑戦してください。", preferredStyle: .alert)
        
        dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(dialog, animated: true, completion: nil)
    }
    
    func  dialogB() {
        let dialog = UIAlertController(title: "登録されている単語がありません", message: "現在このランクには単語が登録されていません。他のランクに挑戦してください。", preferredStyle: .alert)
        
        dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(dialog, animated: true, completion: nil)
    }
    
    @objc func dismissKeyBoard() {
        view.endEditing(true)
    }
    
    
}

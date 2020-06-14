//
//  WordListViewController.swift
//  MyWords
//
//  Created by Apple on 2020/05/23.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import UIKit
import RealmSwift

class WordListViewController: UIViewController {
    
    @IBOutlet weak var wordLabel: UILabel!
    //    Realmクラス判別用の変数
    var x:Int = 0
    
    
    //    Realmのインスタンス化
    let realm = try! Realm()
    var dataListArray = try! Realm().objects(RealmDataList.self)
    var realmDataList: RealmDataList!
    
    var wordHistory: WordHistory!
//   単語カウント　日英カウント
    var wordCount:Int = -1
    var EnOrJapCount = 0
    
    //    segueで受け取る開始番号
    var startNum = -1
    
//    履歴用変数
    var historyNum = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //        履歴をセットする
        if let his = realm.objects(WordHistory.self).first {
            wordHistory = his
            
        } else {
            wordHistory = WordHistory()
        }
        //        xを元にどのボタンで遷移してきたか判別
        if startNum == -1 {
            switch x {
            case 0:
                historyNum = wordHistory.allHis
                dataListArray = try! Realm().objects(RealmDataList.self).filter("id >= \(historyNum)")
            case 1:
                historyNum = wordHistory.miss1His
                dataListArray = try! Realm().objects(RealmDataList.self).filter("Miss1 != 0 && id >= \(historyNum)")
            case 2:
                historyNum = wordHistory.miss2His
                dataListArray = try! Realm().objects(RealmDataList.self).filter("Miss2 != 0 && id >= \(historyNum)")
            case 3:
                historyNum = wordHistory.miss3His
                dataListArray = try! Realm().objects(RealmDataList.self).filter("Miss3 != 0 && id >= \(historyNum)")
            case 4:
                historyNum = wordHistory.miss4His
                dataListArray = try! Realm().objects(RealmDataList.self).filter("Miss4 != 0 && id >= \(historyNum)")
            default:
                dataListArray = try! Realm().objects(RealmDataList.self)
            }
            
            
        } else {
            switch x {
            case 0:
                dataListArray = try! Realm().objects(RealmDataList.self).filter("id >= \(startNum)")
            case 1:
                dataListArray = try! Realm().objects(RealmDataList.self).filter("Miss1 != 0 && id >= \(startNum)")
            case 2:
                dataListArray = try! Realm().objects(RealmDataList.self).filter("Miss2 != 0 && id >= \(startNum)")
            case 3:
                dataListArray = try! Realm().objects(RealmDataList.self).filter("Miss3 != 0 && id >= \(startNum)")
            case 4:
                dataListArray = try! Realm().objects(RealmDataList.self).filter("Miss4 != 0 && id >= \(startNum)")
            default:
                dataListArray = try! Realm().objects(RealmDataList.self)
            }
        }
        
    }
    
    //    次へボタン
    @IBAction func nextButton(_ sender: Any) {
        
        if wordCount >= 0 {
            realmDataList = dataListArray[wordCount]
            try! realm.write {
                self.realmDataList.Memo = 1
                self.realm.add(self.realmDataList, update: .modified)
                
            }
           
        }
        
        if wordCount == dataListArray.count - 1 {
            historyA()
        }
        
        if wordCount < dataListArray.count - 1 {
            wordCount += 1
            realmDataList = dataListArray[wordCount]
            historyA()
        } else {
            wordCount = -1
            wordLabel.text = "Nextボタンを押して開始"
          historyB()
           reachLast()
        }
        EnOrJapCount = 0
        if wordCount >= 0 {
            wordApp()
            
        }
        
    }
    
    //    ミスボタン
    @IBAction func missButton(_ sender: Any) {
        if wordCount >= 0 {
            realmDataList = dataListArray[wordCount]
            
            try! realm.write {
                self.realmDataList.Memo = 0
                self.realm.add(self.realmDataList, update: .modified)
            }
            
            
            switch x {
            case 0:
                try! realm.write {
                    self.realmDataList.Miss1 = 1
                    self.realm.add(self.realmDataList, update: .modified)
                }
            case 1:
                try! realm.write {
                    self.realmDataList.Miss2 = 1
                    self.realm.add(self.realmDataList, update: .modified)
                }
            case 2:
                try! realm.write {
                    self.realmDataList.Miss3 = 1
                    self.realm.add(self.realmDataList, update: .modified)
                }
            case 3:
                try! realm.write {
                    self.realmDataList.Miss4 = 1
                    self.realm.add(self.realmDataList, update: .modified)
                }
                
            default:
                try! realm.write {
                    self.realmDataList.Miss4 = 1
                    self.realm.add(self.realmDataList, update: .modified)
                }
            }
            if wordCount == dataListArray.count - 1 {
                historyA()
            }
            if wordCount < dataListArray.count - 1 {
                wordCount += 1
                realmDataList = dataListArray[wordCount]
                historyA()
            } else {
                wordCount = -1
              wordLabel.text = "Nextボタンを押して開始"
                historyB()
               reachLast()
            }
            EnOrJapCount = 0
            if wordCount >= 0 {
                wordApp()
                
            }
            
        }
    }
    
    //    wordLabelをタップして英語と日本語を切り替える
    @IBAction func tapWordLabel(_ sender: Any) {
        if wordCount != -1 {
            if EnOrJapCount == 0 {
                EnOrJapCount = 1
            } else {
                EnOrJapCount = 0
            }
            wordApp()
        }
    }
    
    
    
    
    //    単語更新
    func wordApp() {
        
        
        let words = dataListArray[wordCount]
        let english = words.English
        let japanese = words.Japanese
        let id = words.id
        
        if EnOrJapCount == 0 {
            wordLabel.text = "\(id):\(english)"
        } else {
            wordLabel.text = "\(id):\(japanese)"
        }
    }
    
    //    履歴更新
    func historyA() {
        try! realm.write {
            
            switch x {
            case 0:
                wordHistory.allHis = realmDataList.id
            case 1:
                wordHistory.miss1His = realmDataList.id
            case 2:
                wordHistory.miss2His = realmDataList.id
            case 3:
                wordHistory.miss3His = realmDataList.id
            case 4:
                wordHistory.miss4His = realmDataList.id
            default:
                wordHistory.allHis = realmDataList.id
            }
            realm.add(wordHistory)
        }
    }
    
    func historyB() {
           try! realm.write {
               
               switch x {
               case 0:
                   wordHistory.allHis = 0
               case 1:
                   wordHistory.miss1His = 0
               case 2:
                   wordHistory.miss2His = 0
               case 3:
                   wordHistory.miss3His = 0
               case 4:
                   wordHistory.miss4His = 0
               default:
                   wordHistory.allHis = 0
               }
               realm.add(wordHistory)
           }
       }
    
    
//    ラストまで行った時配列を履歴の制限がない状態に戻す
    func reachLast() {
        if startNum == -1 {
            switch x {
            case 0:
                
                dataListArray = try! Realm().objects(RealmDataList.self)
            case 1:
                historyNum = wordHistory.miss1His
                dataListArray = try! Realm().objects(RealmDataList.self).filter("Miss1 != 0 ")
            case 2:
                historyNum = wordHistory.miss2His
                dataListArray = try! Realm().objects(RealmDataList.self).filter("Miss2 != 0 ")
            case 3:
                historyNum = wordHistory.miss3His
                dataListArray = try! Realm().objects(RealmDataList.self).filter("Miss3 != 0 ")
            case 4:
                historyNum = wordHistory.miss4His
                dataListArray = try! Realm().objects(RealmDataList.self).filter("Miss4 != 0 ")
            default:
                dataListArray = try! Realm().objects(RealmDataList.self)
            }
            
            
        }
    }
    
    
    
    @IBAction func quitButton(_ sender: Any) {
        self.wordCount = -1
        self.EnOrJapCount = 0
        self.startNum = 0
        self.dismiss(animated: true, completion: nil)
    }
    
}

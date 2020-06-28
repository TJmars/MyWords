//
//  WordListViewController.swift
//  MyWords
//
//  Created by Apple on 2020/05/23.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import UIKit
import RealmSwift
import AVFoundation
import EMTNeumorphicView

class WordListViewController: UIViewController {
    
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var wordIdLabel: UILabel!
    @IBOutlet weak var audioButtonImage: UIButton!
    @IBOutlet weak var tapLabel: UILabel!
    
//    音声オンオフボタンの画像設定
    let onImage = UIImage(named: "AudioOn")
    let offImage = UIImage(named: "AudioOff")

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
    
    //    音声オンオフ
    var audioNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

       
        
        
        //        履歴をセットする
        if let his = realm.objects(WordHistory.self).first {
            wordHistory = his
        } else {
            wordHistory = WordHistory()
        }
        
//        音声番号の設定
        audioNum = wordHistory.audio
        
        //        xを元にどのボタンで遷移してきたか判別
        if startNum == -1 {
            switch x {
            case 0:
                dataListArray = try! Realm().objects(RealmDataList.self)
                if dataListArray.count == wordHistory.allHisCount {
                    historyNum = wordHistory.allHis
                    dataListArray = try! Realm().objects(RealmDataList.self).filter("id >= \(historyNum)")
                } else {
                    historyNum = wordHistory.allHisCha
                    dataListArray = try! Realm().objects(RealmDataList.self).filter("id >= \(historyNum)")
                }
            case 1:
                dataListArray = try! Realm().objects(RealmDataList.self).filter("Miss1 != 0")
                if dataListArray.count == wordHistory.miss1HisCount {
                    historyNum = wordHistory.miss1His
                    dataListArray = try! Realm().objects(RealmDataList.self).filter("Miss1 != 0 && id >= \(historyNum)")
                    print("上")
                    print("dataListCount\(dataListArray.count)")
                    print(historyNum)
                } else {
                    historyNum = wordHistory.miss1HisCha
                    dataListArray = try! Realm().objects(RealmDataList.self).filter("Miss1 != 0 && id >= \(historyNum)")
                    print("下")
                    print("dataListCount\(dataListArray.count)")
                }
            case 2:
                dataListArray = try! Realm().objects(RealmDataList.self).filter("Miss2 != 0")
                if dataListArray.count == wordHistory.miss2HisCount {
                    historyNum = wordHistory.miss2His
                    dataListArray = try! Realm().objects(RealmDataList.self).filter("Miss2 != 0 && id >= \(historyNum)")
                } else {
                    historyNum = wordHistory.miss2HisCha
                    dataListArray = try! Realm().objects(RealmDataList.self).filter("Miss2 != 0 && id >= \(historyNum)")
                }
            case 3:
                dataListArray = try! Realm().objects(RealmDataList.self).filter("Miss3 != 0")
                if dataListArray.count == wordHistory.miss3HisCount {
                    historyNum = wordHistory.miss3His
                    dataListArray = try! Realm().objects(RealmDataList.self).filter("Miss3 != 0 && id >= \(historyNum)")
                } else {
                    historyNum = wordHistory.miss3HisCha
                    dataListArray = try! Realm().objects(RealmDataList.self).filter("Miss3 != 0 && id >= \(historyNum)")
                }
            case 4:
                dataListArray = try! Realm().objects(RealmDataList.self).filter("Miss4 != 0")
                if dataListArray.count == wordHistory.miss4HisCount {
                    historyNum = wordHistory.miss4His
                    dataListArray = try! Realm().objects(RealmDataList.self).filter("Miss4 != 0 && id >= \(historyNum)")
                } else {
                    historyNum = wordHistory.miss4HisCha
                    dataListArray = try! Realm().objects(RealmDataList.self).filter("Miss4 != 0 && id >= \(historyNum)")
                }
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
        
        //        音声画像セット
        
        if audioNum == 0 {
            audioButtonImage.setImage(onImage, for: .normal)
        } else {
            audioButtonImage.setImage(offImage, for: .normal)
        }
        
        
        
    }
    
    //    次へボタン
    @IBAction func nextButton(_ sender: Any) {
        
        tapLabel.text = ""
        
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
            wordLabel.text = "○ボタンを押して開始"
            wordIdLabel.text = ""
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
                wordLabel.text = "○ボタンを押して開始"
                wordIdLabel.text = ""
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
    
    //    音声のオンオフ
    
    @IBAction func audioChangeButton(_ sender: Any) {
        
        if audioNum == 0 {
            audioNum = 1
            audioButtonImage.setImage(offImage, for: .normal)
        } else {
            audioNum = 0
            audioButtonImage.setImage(onImage, for: .normal)
        }
    }
    
    
    
    
    //    単語更新
    func wordApp() {
        
        
        let words = dataListArray[wordCount]
        let english = words.English
        let japanese = words.Japanese
        let id = words.id
        
        if EnOrJapCount == 0 {
            wordLabel.text = english
            wordIdLabel.text = "\(id)"
            
            if audioNum == 0 {
                let synthesizer = AVSpeechSynthesizer()
                let utterance = AVSpeechUtterance(string: english)
                synthesizer.speak(utterance)
            }
        } else {
            wordLabel.text = japanese
            wordIdLabel.text = "\(id)"
        }
    }
    
    //    履歴更新
    func historyA() {
        try! realm.write {
            
            switch x {
            case 0:
                wordHistory.allHis = realmDataList.id
                wordHistory.allHisCha = realmDataList.id
            case 1:
                wordHistory.miss1His = realmDataList.id
                wordHistory.miss1HisCha = realmDataList.id
            case 2:
                wordHistory.miss2His = realmDataList.id
                wordHistory.miss2HisCha = realmDataList.id
            case 3:
                wordHistory.miss3His = realmDataList.id
                wordHistory.miss3HisCha = realmDataList.id
            case 4:
                wordHistory.miss4His = realmDataList.id
                wordHistory.miss4HisCha = realmDataList.id
            default:
                wordHistory.allHis = realmDataList.id
                wordHistory.allHisCha = realmDataList.id
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
        
        try! realm.write {
            switch x {
            case 0:
                wordHistory.allHisCount = try! Realm().objects(RealmDataList.self).count
            case 1:
                wordHistory.miss1HisCount = try! Realm().objects(RealmDataList.self).filter("Miss1 != 0").count
            case 2:
                wordHistory.miss2HisCount = try! Realm().objects(RealmDataList.self).filter("Miss2 != 0").count
            case 3:
                wordHistory.miss3HisCount = try! Realm().objects(RealmDataList.self).filter("Miss3 != 0").count
            case 4:
                wordHistory.miss4HisCount = try! Realm().objects(RealmDataList.self).filter("Miss4 != 0").count
            default:
                wordHistory.allHisCount = try! Realm().objects(RealmDataList.self).count
            }
            wordHistory.audio = audioNum
            realm.add(wordHistory)
        }
       
        self.dismiss(animated: true, completion: nil)
    }
    
}

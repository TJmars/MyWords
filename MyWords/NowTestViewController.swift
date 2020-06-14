//
//  NowTestViewController.swift
//  MyWords
//
//  Created by Apple on 2020/05/31.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import UIKit
import RealmSwift


class NowTestViewController: UIViewController {
    
    var fromNum = 0
    var toNum = 0
    
    @IBOutlet weak var wordLabel: UILabel!
    
    //    Realmのインスタンス化
    let realm = try! Realm()
    var dataListArray = try! Realm().objects(RealmDataList.self)
    var wordIndexArray:[Int] = []
    
    var appDetail:AppDetail!
  
    //    カウントの変数
    var EnOrJapCount = 0
    var tapIndex = 0
    var wordAppCount = 0
    var currentCount = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        dataListArray = try! Realm().objects(RealmDataList.self).filter("id >= \(fromNum) && id <= \(toNum)")
        print(dataListArray.count)
        wordIndexArray.append(contentsOf: 0...dataListArray.count - 1)
        wordIndexArray.shuffle()
        
//        正答率のカウントについての処理
        if let obj = realm.objects(AppDetail.self).first {
            appDetail = obj
        } else {
            appDetail = AppDetail()
        }
        
        print(appDetail.correctTest)
        print(appDetail.tryTestCount)
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
    }
    
    @IBAction func correctButton(_ sender: Any) {
        wordAppCount += 1
        currentCount += 1
        EnOrJapCount = 0
        if wordAppCount < 21 {
            wordApp()
            wordIndexArray.removeFirst()
            
//           正答ならカウント
            try! realm.write {
                appDetail.correctTest += 1
                realm.add(appDetail)
            }
            
        } else {
            
//            挑戦回数をカウント
            try! realm.write {
                appDetail.tryTestCount += 1
                realm.add(appDetail)
            }
           
            dialogFunc()
        }
       
    }
    
    @IBAction func missButton(_ sender: Any) {
        if currentCount != 0 {
            wordAppCount += 1
            EnOrJapCount  = 0
            if wordAppCount < 21 {
                wordApp()
                wordIndexArray.removeFirst()
            } else {
                
//               挑戦回数をカウント
                try! realm.write {
                    appDetail.tryTestCount += 1
                    realm.add(appDetail)
                }
                dialogFunc()
            }
        }
    }
    
    @IBAction func tapWordLabel(_ sender: Any) {
        if wordAppCount > 0 && wordAppCount < 21 {
            
            if EnOrJapCount == 0 {
                EnOrJapCount = 1
            } else {
                EnOrJapCount = 0
            }
            
            let thisIndex = tapIndex
            let words = dataListArray[thisIndex]
            let english = words.English
            let japanese = words.Japanese
            
            if EnOrJapCount == 0 {
                wordLabel.text = english
            } else {
                wordLabel.text = japanese
            }
        }
    }
    
    func wordApp() {
        
        let thisIndex = wordIndexArray[0]
        tapIndex = thisIndex
        let words = dataListArray[thisIndex]
        let english = words.English
        let japanese = words.Japanese
        
        if EnOrJapCount == 0 {
            wordLabel.text = english
        } else {
            wordLabel.text = japanese
        }
    }
    
    //    ダイアログの関数
    func dialogFunc() {
        let dialog = UIAlertController(title: "終了！", message: "お疲れ様でした。今回の正答率は20問中\(currentCount - 1)問です。", preferredStyle: .alert)
        
        dialog.addAction(UIAlertAction(title: "テストを終了", style: .default, handler: { action in
            
            //    カウントの変数
            self.EnOrJapCount = 0
            self.tapIndex = 0
            self.wordAppCount = 0
            self.currentCount = 0
            
            self.dismiss(animated: true, completion: nil)
            
        }))
        dialog.addAction(UIAlertAction(title: "もう一度", style: .default, handler: { action in
            
            self.EnOrJapCount = 0
            self.tapIndex = 0
            self.wordAppCount = 0
            self.currentCount = 0
            
            self.wordIndexArray.append(contentsOf: 0...self.dataListArray.count - 1)
            self.wordIndexArray.shuffle()
            
            self.wordLabel.text = "○ボタンを押して開始"
        }))
        self.present(dialog, animated: true, completion: nil)
    }
}

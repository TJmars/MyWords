//
//  TabBarController.swift
//  MyWords
//
//  Created by Apple on 2020/05/23.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import UIKit
import RealmSwift

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    //    Realmのインスタンス化
    let realm = try! Realm()
    var dataListArray = try! Realm().objects(RealmDataList.self)
    var realmDataList: RealmDataList!
    
    var dataListNo = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        self.tabBar.barTintColor = UIColor(red: 0, green: 0.2, blue: 0.8, alpha: 0)
        self.delegate = self
        
        //        初回時データ読みこみ　23行目のif文によって２回目以降は行わない
        if dataListArray.count == 0 {
            var csvLines = [String]()
            
            if dataListNo == 1 {
                guard let path = Bundle.main.path(forResource: "dataList", ofType: "csv") else {
                    print("noCSV")
                    return
                }
                
                do {
                    let csvString = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
                    csvLines = csvString.components(separatedBy: .newlines)
                    csvLines.removeLast()
                } catch let error as NSError {
                    print("エラー:\(error)")
                    return
                }
            } else {
                guard let path = Bundle.main.path(forResource: "dataList2", ofType: "csv") else {
                    print("noCSV")
                    return
                }
                
                do {
                    let csvString = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
                    csvLines = csvString.components(separatedBy: .newlines)
                    csvLines.removeLast()
                } catch let error as NSError {
                    print("エラー:\(error)")
                    return
                }
            }
            
            
            //        Realmへデータを入れる　今回は1737単語　idの最大値は1736
            for wordData in csvLines {
                
                let wordDetail = wordData.components(separatedBy: ",")
                let wordList = RealmDataList()
                let allWordList = realm.objects(RealmDataList.self)
                if allWordList.count != 0 {
                    wordList.id = allWordList.max(ofProperty: "id")! + 1
                }
                realmDataList = wordList
                
                try! realm.write {
                    self.realmDataList.English = wordDetail[1]
                    self.realmDataList.Japanese = wordDetail[2]
                    self.realm.add(self.realmDataList, update: .modified)
                    
                }
            }
            
        }
        
    }
    
    
    
}

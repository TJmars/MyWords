//
//  AddWordViewController.swift
//  MyWords
//
//  Created by Apple on 2020/06/05.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import UIKit
import RealmSwift

class AddWordViewController: UIViewController {
    
    var realmDataList:RealmDataList!
    var realm = try! Realm()
    
    @IBOutlet weak var NumberLabel: UILabel!
    @IBOutlet weak var englishTextField: UITextField!
    @IBOutlet weak var japaneseTextField: UITextField!
    
    var dataListArray = try! Realm().objects(RealmDataList.self)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let tapGesture:  UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        self.view.addGestureRecognizer(tapGesture)
        
        NumberLabel.text = "No.\(dataListArray.count)"
        
    }
    
    @IBAction func addWordButton(_ sender: Any) {
        if englishTextField.text != "" && japaneseTextField.text != "" {
                   let wordList = RealmDataList()
                   let allWordList = realm.objects(RealmDataList.self)
                   wordList.id = allWordList.max(ofProperty: "id")! + 1
                   
                   realmDataList = wordList
                   
                   try! realm.write {
                       self.realmDataList.English = englishTextField.text!
                       self.realmDataList.Japanese = japaneseTextField.text!
                       self.realm.add(self.realmDataList, update: .modified)
                       
                   }
                   englishTextField.text = ""
                   japaneseTextField.text = ""
                   let dialog = UIAlertController(title: "単語を登録しました", message: "", preferredStyle: .alert)
                   
                   dialog.addAction(UIAlertAction(title: "登録を終了", style: .default, handler: { action in
                       self.dismissKeyBoard()
                       self.navigationController?.popViewController(animated: true)
                   }))
                   dialog.addAction(UIAlertAction(title: "登録を続ける", style: .default, handler: nil))
                   self.present(dialog, animated: true, completion: nil)

               } else {
                   let dialog = UIAlertController(title: "入力欄に空欄があります", message: "", preferredStyle: .alert)
                   
                   dialog.addAction(UIAlertAction(title: "登録を終了", style: .default, handler: { action in
                       self.dismissKeyBoard()
                       self.navigationController?.popViewController(animated: true)
                   }))
                   dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                   self.present(dialog, animated: true, completion: nil)
               }
    }
    
    
    @objc func dismissKeyBoard() {
        view.endEditing(true)
    }
    
}

//
//  startViewController.swift
//  MyWords
//
//  Created by Apple on 2020/06/19.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import UIKit
import RealmSwift

class startViewController: UIViewController {
    
     var dataListArray = try! Realm().objects(RealmDataList.self)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if dataListArray.count == 0 {
            self.performSegue(withIdentifier: "toLogin", sender: nil)
        } else {
            self.performSegue(withIdentifier: "toTab", sender: nil)
        }
        
    }
   
}

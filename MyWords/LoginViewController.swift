//
//  LoginViewController.swift
//  MyWords
//
//  Created by Apple on 2020/06/17.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

   var dataListNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("呼ばれた")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func word1Button(_ sender: Any) {
        
        dataListNum = 1
        self.performSegue(withIdentifier: "toTabBar", sender: nil)
        
    }
    
    @IBAction func word2Button(_ sender: Any) {
        
        dataListNum = 2
        self.performSegue(withIdentifier: "toTabBar", sender: nil)
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tabbarController:TabBarController = segue.destination as! TabBarController
        
        tabbarController.dataListNo = dataListNum
    }
    
}

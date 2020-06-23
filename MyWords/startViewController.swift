//
//  startViewController.swift
//  MyWords
//
//  Created by Apple on 2020/06/19.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import UIKit
import RealmSwift
import Lottie

class startViewController: UIViewController {
    
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var logoView: UIView!
    
    var dataListArray = try! Realm().objects(RealmDataList.self)
    
    var animationView:AnimationView = AnimationView()
    var animatView:AnimationView = AnimationView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let animat = Animation.named("2")
            self.animatView.frame = CGRect(x: 0, y: 0, width: self.logoView.frame.size.width, height: self.logoView.frame.size.height)
            self.animatView.animation = animat
            self.animatView.contentMode = .scaleAspectFit
            self.animatView.loopMode = .playOnce
            self.animatView.backgroundColor = .clear
            self.logoView.addSubview(self.animatView)
            self.animatView.play()
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            let animation = Animation.named("5")
            self.animationView.frame = CGRect(x: 0, y: 0, width: self.myView.frame.size.width, height: self.myView.frame.size.height)
            self.animationView.animation = animation
            self.animationView.contentMode = .scaleAspectFit
            self.animationView.loopMode = .playOnce
            self.animationView.backgroundColor = .clear
            self.myView.addSubview(self.animationView)
            self.animationView.play()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.8) {
            if self.dataListArray.count == 0 {
                self.performSegue(withIdentifier: "toLogin", sender: nil)
            } else {
                self.performSegue(withIdentifier: "toTab", sender: nil)
            }
        }
        
    }
   
}

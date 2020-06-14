//
//  DetailViewController.swift
//  MyWords
//
//  Created by Apple on 2020/06/08.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import UIKit
import RealmSwift

class DetailViewController: UIViewController {
    
    let realm = try! Realm()
    var appDetail: AppDetail!
    var dataListArray = try! Realm().objects(RealmDataList.self)
    
    @IBOutlet weak var labelA: UILabel!
    @IBOutlet weak var labelB: UILabel!
    @IBOutlet weak var labelC: UILabel!
    @IBOutlet weak var labelD: UILabel!
    @IBOutlet weak var labelD1: UILabel!
    @IBOutlet weak var labelD2: UILabel!
    @IBOutlet weak var labelD3: UILabel!
    @IBOutlet weak var labelD4: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        labelA.text = "\(dataListArray.count)語"
        
        // Do any additional setup after loading the view.
        
        if let obj = realm.objects(AppDetail.self).first {
            appDetail = obj
           
            //            labelB
            labelB.text = "\(appDetail.tryTestCount)回"
            //            labelC
            let correct:Double = Double(appDetail.correctTest)
            let tryTest:Double = Double(appDetail.tryTestCount * 20)
            if tryTest != 0 {
                let reatInt:Int = Int((correct / tryTest) * 100)
                labelC.text = "\(reatInt)%"
            } else {
                let reatInt:Int = 0
                labelC.text = "\(reatInt)%"
            }
            
            
            
        } else {
            appDetail = AppDetail()
            labelB.text = "0回"
            labelC.text = "0%"
           
        }
        
        //        labelD
        let dataList = try! Realm().objects(RealmDataList.self)
        let dataList1 = try! Realm().objects(RealmDataList.self).filter("Memo != 0")
        let a:Double = Double(dataList.count)
        let b:Double = Double(dataList1.count)
        let rateD:Double = (b / a) * 100
        let intRateD:Int = Int(rateD)
        labelD.text  = "\(intRateD)%"
        //        labelD1
        let dataListD1 = try! Realm().objects(RealmDataList.self).filter("id <= 500")
        let dataListFD1 = try! Realm().objects(RealmDataList.self).filter("Memo != 0 && id <= 500")
        let a1:Double = Double(dataListD1.count)
        let b1:Double = Double(dataListFD1.count)
        let rateD1:Double = (b1 / a1) * 100
        let intRateD1:Int = Int(rateD1)
        labelD1.text  = "\(intRateD1)%"
        //        labelD2
        let dataListD2 = try! Realm().objects(RealmDataList.self).filter("id >= 501 && id <= 1000")
        let dataListFD2 = try! Realm().objects(RealmDataList.self).filter("Memo != 0 && id >= 501 && id <=  1000")
        let a2:Double = Double(dataListD2.count)
        let b2:Double = Double(dataListFD2.count)
        let rateD2:Double = (b2 / a2) * 100
        let intRateD2:Int = Int(rateD2)
        labelD2.text  = "\(intRateD2)%"
        //        labelD3
        let dataListD3 = try! Realm().objects(RealmDataList.self).filter("id >= 1001 && id <= 1500")
        let dataListFD3 = try! Realm().objects(RealmDataList.self).filter("Memo != 0 && id >= 1001 && id <=  1500")
        let a3:Double = Double(dataListD3.count)
        let b3:Double = Double(dataListFD3.count)
        let rateD3:Double = (b3 / a3) * 100
        let intRateD3:Int = Int(rateD3)
        labelD3.text  = "\(intRateD3)%"
        //        labelD4
        let dataListD4 = try! Realm().objects(RealmDataList.self).filter("id >= 1501 ")
        let dataListFD4 = try! Realm().objects(RealmDataList.self).filter("Memo != 0 && id >= 1501 ")
        let a4:Double = Double(dataListD4.count)
        let b4:Double = Double(dataListFD4.count)
        let rateD4:Double = (b4 / a4) * 100
        let intRateD4:Int = Int(rateD4)
        labelD4.text  = "\(intRateD4)%"
        
        let tapGesture:  UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
               self.view.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func returnButton(_ sender: Any) {
        
            self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func dismissKeyBoard() {
           view.endEditing(true)
       }
    
}

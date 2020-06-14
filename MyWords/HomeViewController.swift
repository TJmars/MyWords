//
//  HomeViewController.swift
//  MyWords
//
//  Created by Apple on 2020/05/23.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController {
    
    
    
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var percemtLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    
//    円グラフ
    let caShapeLayerForBase:CAShapeLayer = CAShapeLayer.init()
    let caShapeLayerForValue:CAShapeLayer = CAShapeLayer.init()
    
//    Realmのインスタンス化
    let realm = try! Realm()
    var dataListArray = try! Realm().objects(RealmDataList.self)
    var realmDataList: RealmDataList!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       


        
        //        初回時データ読みこみ　23行目のif文によって２回目以降は行わない
        if dataListArray.count == 0 {
            var csvLines = [String]()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        日付を取得
        let date:Date = Date()
        let format = DateFormatter()
        format.dateStyle = .long
        dateLabel.text = "\(format.string(from: date))"

        
       let dataList1 = try! Realm().objects(RealmDataList.self).filter("Memo != 0")
       let dataList2 = try! Realm().objects(RealmDataList.self)
        
        let OKCount:Double = Double(dataList1.count)
        let NOCount:Double = Double(dataList2.count)
        
        let rate:Double = (OKCount / NOCount) * 100
               drawChart(rate: rate)
        
        let intRate:Int = Int(rate)
        percemtLabel.text = "\(intRate)%"
    }
    
    
    
//    円グラフ
    func drawChart(rate:Double){
           //グラフを表示
           drawBaseChart()
           drawValueChart(rate: rate)

           //グラフをアニメーションで表示
           let caBasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        caBasicAnimation.duration = 1.3
           caBasicAnimation.fromValue = 0.0
           caBasicAnimation.toValue = 1.0
           caShapeLayerForValue.add(caBasicAnimation, forKey: "chartAnimation")
       }

       /**
        円グラフの軸となる円を表示
        */
       private func drawBaseChart(){
           let shapeFrame = CGRect.init(x: 0, y: 0, width: myView.frame.width, height: myView.frame.height)
           caShapeLayerForBase.frame = shapeFrame
        caShapeLayerForBase.strokeColor = UIColor(red: 0, green: 0.4, blue: 1, alpha: 0.7).cgColor
           caShapeLayerForBase.fillColor = UIColor.clear.cgColor
           caShapeLayerForBase.lineWidth = 50
           caShapeLayerForBase.lineCap = .round

           let startAngle:CGFloat = CGFloat(0.0)
           let endAngle:CGFloat = CGFloat(Double.pi * 2.0)

           caShapeLayerForBase.path = UIBezierPath.init(arcCenter: CGPoint.init(x: shapeFrame.size.width / 2.0, y: shapeFrame.size.height / 2.0),radius: shapeFrame.size.width / 2.0,startAngle: startAngle,endAngle: endAngle,clockwise: true).cgPath
           myView.layer.addSublayer(caShapeLayerForBase)
       }

       /**
        円グラフの値を示す円(半円)を表示
        @param rate 円グラフの値の%値
        */
       private func drawValueChart(rate:Double){
           //CAShareLayerを描く大きさを定義
           let shapeFrame = CGRect.init(x: 0, y: 0, width: myView.frame.width, height: myView.frame.height)
           caShapeLayerForValue.frame = shapeFrame

           //CAShareLayerのデザインを定義
           caShapeLayerForValue.strokeColor = UIColor(displayP3Red: 1, green: 0.4, blue: 0.4, alpha: 1).cgColor
           caShapeLayerForValue.fillColor = UIColor.clear.cgColor
           caShapeLayerForValue.lineWidth = 50
           caShapeLayerForValue.lineCap = .round

           //開始位置を時計の0時の位置にする
           let startAngle:CGFloat = CGFloat(-1 * Double.pi / 2.0)

           //終了位置を時計の0時起点で引数渡しされた割合の位置にする
           let endAngle :CGFloat = CGFloat(rate / 100 * Double.pi * 2.0 - (Double.pi / 2.0))

           //UIBezierPathを使用して半円を定義
           caShapeLayerForValue.path = UIBezierPath.init(arcCenter: CGPoint.init(x: shapeFrame.size.width / 2.0, y: shapeFrame.size.height / 2.0),radius: shapeFrame.size.width / 2.0,startAngle: startAngle,endAngle: endAngle,clockwise: true).cgPath
           myView.layer.addSublayer(caShapeLayerForValue)
       }
    
}



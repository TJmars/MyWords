//
//  CalendarViewController.swift
//  MyWords
//
//  Created by Apple on 2020/05/23.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import UIKit
import RealmSwift

class CalendarViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    let realm = try! Realm()
    var dataListArray = try! Realm().objects(RealmDataList.self)
    var realmDataList: RealmDataList!
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segument: UISegmentedControl!
    var firstNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
       let numA = dataListArray.count / 4
       let numB = numA / 50
       let numC = numA % 50
       
       if numC <= 25 {
           firstNum = numB * 50
       } else {
           firstNum = (numB + 1) * 50
       }
        
        self.segument.setTitle("0~", forSegmentAt: 0)
        self.segument.setTitle("\(firstNum)~", forSegmentAt: 1)
        self.segument.setTitle("\(firstNum * 2)~", forSegmentAt: 2)
        self.segument.setTitle("\(firstNum * 3)~", forSegmentAt: 3)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
        
        segument.selectedSegmentIndex = 0
        let indexPath = NSIndexPath.init(row: 0, section: 0)
        self.tableView .scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.top, animated: false)
        
        
       
    }
    
    
    @IBAction func segumentedController(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            let indexPath = NSIndexPath.init(row: 0, section: 0)
            self.tableView .scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.top, animated: false)
        case 1:
            let indexPath = NSIndexPath.init(row: firstNum, section: 0)
            self.tableView .scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.top, animated: false)
        case 2:
            let indexPath = NSIndexPath.init(row: firstNum * 2, section: 0)
            self.tableView .scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.top, animated: false)
        case 3:
            let indexPath = NSIndexPath.init(row: firstNum * 3, section: 0)
            self.tableView .scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.top, animated: false)
        default:
            let indexPath = NSIndexPath.init(row: 0, section: 0)
            self.tableView .scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.top, animated: false)
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let data = dataListArray[indexPath.row]
        cell.textLabel?.text = "\(data.id): \(data.English)"
        cell.detailTextLabel?.text = data.Japanese
        
        return cell
    }
    
    
    
    
}

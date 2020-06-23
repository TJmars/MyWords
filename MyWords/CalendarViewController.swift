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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
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
            let indexPath = NSIndexPath.init(row: 500, section: 0)
            self.tableView .scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.top, animated: false)
        case 2:
            let indexPath = NSIndexPath.init(row: 1000, section: 0)
            self.tableView .scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.top, animated: false)
        case 3:
            let indexPath = NSIndexPath.init(row: 1500, section: 0)
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

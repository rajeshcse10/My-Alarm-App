//
//  WeekSelectionViewController.swift
//  MyAlermApp
//
//  Created by Rajesh Karmaker on 29/3/18.
//  Copyright © 2018 Rajesh Karmaker. All rights reserved.
//

import UIKit

class Week {
    var weekTitle = ""
    var subTitle = ""
    var selected = false
    init(title:String,subTitle:String) {
        weekTitle = title
        self.subTitle = subTitle
    }
}

class WeekSelectionViewController: UIViewController {

    @IBOutlet weak var weekTableView: UITableView!
    var selectionNumber:Int?{
        didSet{
            weekList = WeekSelectionViewController.getWeekList()
            if let num = selectionNumber{
                for i in 0..<7{
                    if num & (1 << (6-i)) != 0{
                        weekList![i].selected = true
                    }
                }
            }
            
        }
    }
    var weekList:[Week]?
    var customParent : AddAlarmViewController?
    static func getWeekList()->[Week]{
        return [Week(title: "Every Sunday",subTitle:"Sun"),Week(title: "Every Monday",subTitle:"Mon"),Week(title: "Every Tuesday",subTitle:"Tue"),Week(title: "Every Wednesday",subTitle:"Wed"),Week(title: "Every Thursday",subTitle:"Thu"),Week(title: "Every Friday",subTitle:"Fri"),Week(title: "Every Saturday",subTitle:"Sat")]
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        weekTableView.delegate = self
        weekTableView.dataSource = self
        navigationItem.title = "Repeat"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let pvc = customParent{
            var newNumber = 0
            for i in 0..<7{
                if weekList![i].selected == true{
                    newNumber +=  (1 << (6-i))
                }
            }
            pvc.selectedWeekListNumber = newNumber
        }
    }
}
extension WeekSelectionViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekList!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weekCell", for: indexPath)
        cell.textLabel?.text = weekList![indexPath.row].weekTitle
        if weekList![indexPath.row].selected == true{
            cell.accessoryType = .checkmark
        }
        else{
            cell.accessoryType = .none
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        weekList![indexPath.row].selected = !weekList![indexPath.row].selected
        tableView.reloadData()
    }
}

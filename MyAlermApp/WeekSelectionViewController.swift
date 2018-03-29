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
    var selected = false
    init(title:String) {
        weekTitle = title
    }
}

class WeekSelectionViewController: UIViewController {

    @IBOutlet weak var weekTableView: UITableView!
    let weekList = getWeekList()
    var customParent : AddAlarmViewController?
    static func getWeekList()->[Week]{
        return [Week(title: "Every Friday"),Week(title: "Every Saturday"),Week(title: "Every Sunday"),Week(title: "Every Monday"),Week(title: "Every Tuesday"),Week(title: "Every Wednesday"),Week(title: "Every Thrusday")]
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
            pvc.selectedWeekList = weekList
        }
    }
    

}
extension WeekSelectionViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weekCell", for: indexPath)
        cell.textLabel?.text = weekList[indexPath.row].weekTitle
        if weekList[indexPath.row].selected == true{
            cell.accessoryType = .checkmark
        }
        else{
            cell.accessoryType = .none
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        weekList[indexPath.row].selected = !weekList[indexPath.row].selected
        tableView.reloadData()
    }
}

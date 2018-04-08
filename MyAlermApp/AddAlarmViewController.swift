//
//  AddAlarmViewController.swift
//  MyAlermApp
//
//  Created by Rajesh Karmaker on 29/3/18.
//  Copyright © 2018 Rajesh Karmaker. All rights reserved.
//

import UIKit

class AddAlarmViewController: UIViewController {

    
    @IBOutlet weak var picker: UIDatePicker!
    
    @IBOutlet weak var optionTableView: UITableView!
    
    var hourComp = 0
    var minComp = 0
    let options = ["Repeat","Label","Sound","Snooze"]
    var selectedWeekListNumber:Int?{
        didSet{
            print("selected Number : \(selectedWeekListNumber!)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavigationUI()
        picker.datePickerMode = .time
        picker.addTarget(self, action: #selector(timeSelected), for: .valueChanged)
        optionTableView.delegate = self
        optionTableView.dataSource = self
        let date = Date()
        let calendar = Calendar.current
        hourComp = calendar.component(.hour, from: date)
        minComp = calendar.component(.minute, from: date)
    }
    func setNavigationUI(){
        navigationItem.title = "Add Alarm"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveAction))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
    }
    @objc func saveAction(){
        dismiss(animated: true, completion: nil)
    }
    @objc func cancelAction(){
        dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func timeSelected(){
        let date = picker.date
        let calendar = Calendar.current
        hourComp = calendar.component(.hour, from: date)
        minComp = calendar.component(.minute, from: date)
    }

}
extension AddAlarmViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "optionCell", for: indexPath)
        cell.textLabel?.text = options[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let weekSelectionVC = storyboard.instantiateViewController(withIdentifier: "WeekSelectionViewController") as! WeekSelectionViewController
            weekSelectionVC.customParent = self
            weekSelectionVC.selectionNumber = 7
            navigationController?.pushViewController(weekSelectionVC, animated: true)
        }
    }
    
    
}

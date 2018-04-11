//
//  AddAlarmViewController.swift
//  MyAlermApp
//
//  Created by Rajesh Karmaker on 29/3/18.
//  Copyright © 2018 Rajesh Karmaker. All rights reserved.
//

import UIKit
import CoreData
class AddAlarmViewController: UIViewController {

    
    @IBOutlet weak var picker: UIDatePicker!
    
    @IBOutlet weak var optionTableView: UITableView!
    var selectedAlarm:Alarm?{
        didSet{
            if let selectedAlarm = selectedAlarm{
                hourComp = selectedAlarm.hour
                minComp = selectedAlarm.minute
                weekSelectionNumber = selectedAlarm.selectionNumber
            }
        }
    }
    var hourComp:Int32 = Int32(Calendar.current.component(.hour, from: Date()))
    var minComp:Int32 = Int32(Calendar.current.component(.minute, from: Date()))
    let subtitles = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
    var weekSelectionText = "Never"
    var weekSelectionNumber:Int32?{
        didSet{
            if let weekSelectionNumber = weekSelectionNumber{
                weekSelectionText = ""
                for i in 0..<7{
                    if weekSelectionNumber & (1 << (6-i)) != 0{
                        weekSelectionText += subtitles[i] + " "
                    }
                }
                if weekSelectionText == ""{
                    weekSelectionText = "Never"
                }
                if let optionTableView = optionTableView{
                    optionTableView.reloadData()
                }
            }
        }
    }
    
    let options = ["Repeat","Label","Sound","Snooze"]
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var alarm:Alarm?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavigationUI()
        picker.datePickerMode = .time
        picker.addTarget(self, action: #selector(timeSelected), for: .valueChanged)
        picker.locale = Locale(identifier: "NL")
        optionTableView.delegate = self
        optionTableView.dataSource = self
        alarm = Alarm(context: context)
    }
    func setNavigationUI(){
        navigationItem.title = "Add Alarm"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveAction))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
    }
    @objc func saveAction(){
        if let weekSelectionNumber = weekSelectionNumber,let alarm = alarm{
            alarm.alarmID = "\(hourComp):\(minComp):\(weekSelectionNumber)"
            alarm.active = true
            alarm.hour = hourComp
            alarm.minute = minComp
            alarm.selectionNumber = weekSelectionNumber
            do{
                try context.save()
            }catch{
                print("Error in saving alarm:\(error)")
            }
        }
        
        
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
        hourComp = Int32(calendar.component(.hour, from: date))
        minComp = Int32(calendar.component(.minute, from: date))
    }
}
extension AddAlarmViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "optionCell", for: indexPath)
        if indexPath.row == 0{
            cell.accessoryType = .disclosureIndicator
            cell.detailTextLabel?.text = weekSelectionText
        }
        cell.textLabel?.text = options[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let weekSelectionVC = storyboard.instantiateViewController(withIdentifier: "WeekSelectionViewController") as! WeekSelectionViewController
            weekSelectionVC.customParent = self
            weekSelectionVC.selectionNumber = weekSelectionNumber
            navigationController?.pushViewController(weekSelectionVC, animated: true)
        }
    }
}

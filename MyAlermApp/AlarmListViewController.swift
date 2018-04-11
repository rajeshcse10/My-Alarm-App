//
//  AlarmListViewController.swift
//  MyAlermApp
//
//  Created by Rajesh Karmaker on 29/3/18.
//  Copyright © 2018 Rajesh Karmaker. All rights reserved.
//

import UIKit
import CoreData
class AlarmListViewController: UIViewController {

    @IBOutlet weak var alarmTableView: UITableView!
    var alarmList:[Alarm]?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadAlarms()
        if let alarmTableView = alarmTableView{
            alarmTableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        alarmTableView.delegate = self
        alarmTableView.dataSource = self
        // Do any additional setup after loading the view.
        addPlusButton()
    }
    func addPlusButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAlarm))
    }
    @objc func addAlarm(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addAlarmVC = storyboard.instantiateViewController(withIdentifier: "AddAlarmViewController") as! AddAlarmViewController
        let navController = UINavigationController(rootViewController: addAlarmVC)
        navigationController?.present(navController, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loadAlarms(){
        let request:NSFetchRequest<Alarm> = Alarm.fetchRequest()
        do{
            alarmList = try context.fetch(request)
        }catch{
            print("Fetching error : \(error)")
        }
    }
}
extension AlarmListViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmList!.count == 0 ? 1 : alarmList!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath)
        if alarmList!.count != 0{
            cell.textLabel?.text = alarmList![indexPath.row].alarmID
        }
        else{
            cell.textLabel?.text = "No Alarm Set"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if alarmList!.count != 0{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let addAlarmVC = storyboard.instantiateViewController(withIdentifier: "AddAlarmViewController") as? AddAlarmViewController{
                let navController = UINavigationController(rootViewController: addAlarmVC)
                addAlarmVC.selectedAlarm = alarmList![indexPath.row]
                navigationController?.present(navController, animated: true, completion: nil)
            }
        }
        else{
            print("No alarm found")
        }
        
    }
}

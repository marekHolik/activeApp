//
//  activitiesVC.swift
//  activeApp
//
//  Created by marek holik on 30/03/2019.
//  Copyright © 2019 marek holik. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class ActivitiesVC: UIViewController {

    private let buttonSwitch = UIView()
    private let tableView = UITableView()
    private let segmentControl = UISegmentedControl(items: ["all", "local", "firebase"])
    private let backButton = UIButton()
    
    private var firebaseCollection: CollectionReference!
    private var data = [Activity]()
    private var firebaseData = [Activity]()
    private var localData = [Activity]()
    
    var delegate: NavigationVCDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addButtonSwitch()
        addTableView()
        addSegmentControl()
        addBackButton()
        tableView.register(ActivityCell.self, forCellReuseIdentifier: "activityCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        firebaseCollection = Firestore.firestore().collection(ACTIVITIES_REF)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        data = CoreData.fetch().reversed()
        
        firebaseCollection.order(by: ACTIVITIES_DATE, descending: true).getDocuments { (snapshot, error) in
            if let error = error {
                debugPrint("We have a problem \(error)")
            } else {
                self.firebaseData = Activity.parseFirebase(snapshot: snapshot)
                for activity in self.firebaseData {
                    self.data.append(activity)
                }
                self.tableView.reloadData()
            }
        }
    }

    func getActivities() -> [Activity] {
        var filteredData = [Activity]()
        if segmentControl.selectedSegmentIndex == 1 {
            for activity in data {
                if activity.storage == .local {
                    filteredData.append(activity)
                }
            }
        } else if (segmentControl.selectedSegmentIndex == 2) {
            for activity in data {
                if activity.storage == .firebase {
                    filteredData.append(activity)
                }
            }
        } else {
            filteredData = data
        }
        return filteredData
    }
    
    func addBackButton() {
        buttonSwitch.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        //        backButton.centerYAnchor.constraint(equalTo: buttonSwitch.centerYAnchor).isActive = true
        backButton.topAnchor.constraint(equalTo: buttonSwitch.topAnchor, constant: 15).isActive = true
        backButton.leadingAnchor.constraint(equalTo: buttonSwitch.leadingAnchor, constant: 10).isActive = true
        
        backButton.backgroundColor = BLUE
        backButton.layer.cornerRadius = 5
        backButton.layer.masksToBounds = true
        
        backButton.addTarget(self, action: #selector(menuToggle), for: .touchUpInside)
    }
    
    @objc func menuToggle() {
        delegate?.menuToggle(forOption: .NewActivity)
    }
    
    func addSegmentControl() {
        buttonSwitch.addSubview(segmentControl)
        
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.widthAnchor.constraint(equalToConstant: 300).isActive = true
        segmentControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        segmentControl.centerXAnchor.constraint(equalTo: buttonSwitch.centerXAnchor).isActive = true
        segmentControl.centerYAnchor.constraint(equalTo: buttonSwitch.centerYAnchor).isActive = true
        
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Montserrat-Light", size: 15)!], for: .normal)
        segmentControl.subviews[0].tintColor = GREEN
        segmentControl.subviews[1].tintColor = BLUE
        segmentControl.subviews[2].tintColor = ORANGE
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(reloadTable), for: .valueChanged)
        
    }
    
    @objc func reloadTable() {
        self.tableView.reloadData()
    }
    
    func addButtonSwitch() {
        view.addSubview(buttonSwitch)
        buttonSwitch.translatesAutoresizingMaskIntoConstraints = false
        buttonSwitch.widthAnchor.constraint(equalToConstant: view.frame.size.width).isActive = true
        buttonSwitch.heightAnchor.constraint(equalToConstant: 50).isActive = true
        buttonSwitch.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonSwitch.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    func addTableView() {
        view.addSubview(tableView)
        tableView.rowHeight = 120
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: buttonSwitch.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
    }
}

extension ActivitiesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getActivities().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath) as? ActivityCell else { return UITableViewCell()}
        
        cell.configureCell(viewToRelate: tableView, activity: getActivities()[indexPath.row])
        return cell
    }
}

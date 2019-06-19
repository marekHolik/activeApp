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

class ActivitiesVC: SlidableVC {

    private var buttonSwitch: UIView!
    private var tableView: UITableView!
    private var segmentControl: UISegmentedControl!
    
    private var firebaseCollection: CollectionReference!
    private var localData: [Activity]!
    private var firebaseData: [Activity]!

    override func viewDidLoad() {
        super.viewDidLoad()
        buttonSwitch = UIView()
        tableView = UITableView()
        segmentControl = UISegmentedControl(items: ["all", "local", "firebase"])
        localData = [Activity]()
        firebaseData = [Activity]()
        
        view.backgroundColor = .white
        addSegmentControl()
        addTableView()
        
        addBackButton()
        tableView.register(ActivityCell.self, forCellReuseIdentifier: "activityCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        firebaseCollection = Firestore.firestore().collection(ACTIVITIES_REF)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        localData = CoreData.fetch().reversed()
        
        firebaseCollection.order(by: ACTIVITIES_DATE, descending: true).getDocuments { (snapshot, error) in
            if let error = error {
                debugPrint("We have a problem \(error)")
            } else {
                self.firebaseData = Activity.parseFirebase(snapshot: snapshot)
                for activity in self.firebaseData {
                    self.localData.append(activity)
                }
                self.tableView.reloadData()
            }
        }
    }

    func getActivities() -> [Activity] {
        var filteredData = [Activity]()
        if segmentControl.selectedSegmentIndex == 1 {
            for activity in localData {
                if activity.storage == .local {
                    filteredData.append(activity)
                }
            }
        } else if (segmentControl.selectedSegmentIndex == 2) {
            for activity in localData {
                if activity.storage == .firebase {
                    filteredData.append(activity)
                }
            }
        } else {
            filteredData = localData
        }
        return filteredData
    }
    
    func addBackButton() {
        self.view.addSubview(super.button)
        super.button.translatesAutoresizingMaskIntoConstraints = false
        super.button.heightAnchor.constraint(equalToConstant: 15).isActive = true
        super.button.widthAnchor.constraint(equalToConstant: 22).isActive = true
        super.button.centerYAnchor.constraint(equalTo: segmentControl.centerYAnchor).isActive = true
        super.button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
    }
    
    func addSegmentControl() {
        self.view.addSubview(segmentControl)
        
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -60).isActive = true
        segmentControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        segmentControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        segmentControl.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30).isActive = true
        
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
    
    func addTableView() {
        view.addSubview(tableView)
        tableView.rowHeight = 120
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 10).isActive = true
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

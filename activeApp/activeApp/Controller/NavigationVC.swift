//
//  NavigationController.swift
//  activeApp
//
//  Created by marek holik on 14/06/2019.
//  Copyright © 2019 marek holik. All rights reserved.
//

import UIKit

class NavigationVC: UIViewController {

    private let reuseIdentifier = "NavigationCell"
    
    var tableView: UITableView!
    var delegate: NewActivityVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NavigationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = 80
        tableView.backgroundColor = BLUE
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
    }
}

extension NavigationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NavigationCell
        cell.backgroundColor = BLUE
        cell.optionLabel.text = NavigationOption(rawValue: indexPath.row)?.description
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let navigationOption = NavigationOption(rawValue: indexPath.row)!
        delegate?.menuToggle(forOption: navigationOption)
    }
    
}

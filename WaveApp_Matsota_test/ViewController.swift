//
//  ViewController.swift
//  WaveApp_Matsota_test
//
//  Created by Andrew Matsota on 19.11.2020.
//

import UIKit
import CoreData

class RocketViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// - Networking
        let networking = NetworkService()
        networkManager = NetworkManager(networking: networking)
        
        /// - Table View
        tableView.tableFooterView = UIView()
        
        networkManager?.readLaunchList(success: { (launches) in
            print("Launches:", launches.count)
        }, failure: { (localizedDescription) in
            print("localizedDescription:", localizedDescription)
        })
        
        
    }
    
    private var networkManager: NetworkManagment?
    
}

//
//  RocketLaunchViewController.swift
//  WaveApp_Matsota_test
//
//  Created by Andrew Matsota on 19.11.2020.
//

import UIKit

enum SearchActivity {
    case active
    case inactive
}

class RocketLaunchViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// - Networking
        let networking = NetworkService()
        networkManager = NetworkManager(networking: networking)
        
        /// - Table View
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .onDrag
        tableView.register(RocketLaunchTableViewCell.self, forCellReuseIdentifier: RocketLaunchTableViewCell.identifier)
        
        /// - Network
        DispatchQueue.global(qos: .userInteractive).async {
            self.networkManager?.readLaunchList(success: { [weak self] (launches) in
                DispatchQueue.main.async {
                    guard let self = self else {return}
                    self.launches = launches
                    self.updateTableView(with: self.launches.count)
                }
            }, failure: { (localizedDescription) in
                print("localizedDescription:", localizedDescription)
            })
        }
    }
    
    //MARK: - Private Implementation
    private var networkManager: NetworkManagment?
    private var launches = [RocketLaunch]()
    
    private var searchActivity: SearchActivity = .inactive
    private var filteredLaunches = [RocketLaunch]()
    private let searchBar = UISearchBar()
}









//MARK: - UISearchBar Delegate
extension RocketLaunchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print(searchText)
        switch searchText {
        case "":
            searchActivity = .inactive
            updateTableView(with: launches.count)
            
        default:
            searchActivity = .active
            filteredLaunches = launches.filter({ (data) -> Bool in
                guard let searchArray = data.name as String? else {return false}
                return searchArray.contains { (string) -> Bool in
                    string.lowercased().contains(searchText.lowercased())
                }
            })
            updateTableView(with: filteredLaunches.count)
        }
    }
    
}

//MARK: - Table View
extension RocketLaunchViewController {
    
    /// - `viewForHeaderInSection`
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50)
        let headerView = UIView(frame: frame)
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.delegate = self
        headerView.addSubview(searchBar)
        
        return headerView
    }
    
    /// - `heightForHeaderInSection`
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 54
    }
    
    /// - `numberOfRowsInSection`
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch searchActivity {
        case .active:
            return filteredLaunches.count
            
        case .inactive:
            return launches.count
        }
    }
    
    /// - `cellForRowAt`
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RocketLaunchTableViewCell.identifier, for: indexPath) as! RocketLaunchTableViewCell
        let row = indexPath.row
        
        switch searchActivity {
        case .active:
            cell.textLabel?.text = filteredLaunches[row].name
            
        case .inactive:
            cell.textLabel?.text = launches[row].name
        }
        
        return cell
    }
    
    /// - `didSelectRowAt`
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = RocketDescriptionViewController()
        
        vc.networkManager = networkManager
        vc.view.backgroundColor = .systemBackground
        
        let launch = searchActivity == .active ?
            filteredLaunches[indexPath.row] :
            launches[indexPath.row]
        
        let name = launch.name.toArray(separated: "|").last
        
        vc.title = name
        vc.rocketID = launch.id
    
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.backgroundColor = vc.view.backgroundColor
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: - Private Methods
private extension RocketLaunchViewController {
    
    func updateTableView(with relevantQuantity: Int) {
        let currentRowQuantity = tableView.numberOfRows(inSection: 0)
        var inRelevantIndexPaths = [IndexPath]()
        var relevantIndexPaths = [IndexPath]()
        
        tableView.beginUpdates()
        switch relevantQuantity {
        case 0:
            switch currentRowQuantity {
            case 0: break
                
            default :
                for i in 0...currentRowQuantity - 1 {
                    inRelevantIndexPaths.append(IndexPath(item: i, section: 0))
                }
                tableView.deleteRows(at: inRelevantIndexPaths, with: .automatic)
            }
            
        default:
            for i in 0...relevantQuantity - 1 {
                relevantIndexPaths.append(IndexPath(item: i, section: 0))
            }
            
            switch currentRowQuantity {
            case 0:
                tableView.insertRows(at: relevantIndexPaths, with: .automatic)
                
            default:
                for i in 0...currentRowQuantity - 1 {
                    inRelevantIndexPaths.append(IndexPath(item: i, section: 0))
                }
                tableView.deleteRows(at: inRelevantIndexPaths, with: .automatic)
                tableView.insertRows(at: relevantIndexPaths, with: .automatic)
            }
        }
        tableView.endUpdates()
    }
    
}

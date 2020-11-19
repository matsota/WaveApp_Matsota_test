//
//  RocketDescriptionViewController.swift
//  WaveApp_Matsota_test
//
//  Created by Andrew Matsota on 19.11.2020.
//

import UIKit
import WebKit

class RocketDescriptionViewController: UIViewController, Loadable {
    
    //MARK: - Implementation
    public var rocketID: Int?
    public var networkManager: NetworkManagment?

    //MARK: Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch rocketID {
        case .some(let id):
            showLoadingView()
            DispatchQueue.global(qos: .userInteractive).async {
                self.networkManager?.readRocket(description: id, success: { (launches) in
                    
                    let rocketLink = URL(string: launches.first?.rocket?.wikiURL ?? "")
                    switch rocketLink {
                    case .some(let link):
                        DispatchQueue.main.async {
                            let webView = WKWebView()
                            webView.frame = CGRect(x: 0, y: 0,
                                                   width: UIScreen.main.bounds.width,
                                                   height: UIScreen.main.bounds.height)

                            webView.load(NSURLRequest(url: link) as URLRequest)
                            self.view.insertSubview(webView, at: 0)
                        }
                        self.hideLoadingView()
                        
                    case .none:
                        self.hideLoadingView()
                        self.showLabel(with: .link)
                    }
                }, failure: { (localizedDescription) in
                    self.hideLoadingView()
                    self.showLabel(with: .networkError, localizedDescription)
                })
            }
            
        case .none:
            showLabel(with: .id)
        }
    }
    
}









//MARK: - Private Methods
private extension RocketDescriptionViewController {
    
    func showLabel(with error: LocalizationLabel, _ localizedDescrition: String? = nil) {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        let label = UILabel(frame: CGRect(x: 0, y: 0,
                                          width: width,
                                          height: height))
        label.textColor = .red
        label.numberOfLines = 0
        label.textAlignment = .center
        label.minimumScaleFactor = 0.6
        
        label.font = UIFont.boldSystemFont(ofSize: 30)
        
        switch error {
        case .link:
            label.text = "Wikipedia link was missed"
            
        case .id:
            label.text = "Rocket id was missed"
            
        case .networkError:
            label.text = localizedDescrition ?? "Unknown error occured"
        }
        
        self.view.addSubview(label)
    }
    
    enum LocalizationLabel {
        case link
        case id
        case networkError
    }
    
}

//
//  Loadable.swift
//  WaveApp_Matsota_test
//
//  Created by Andrew Matsota on 19.11.2020.
//

import UIKit

protocol Loadable {
    func showLoadingView()
    func hideLoadingView()
}

final class LoadingView: UIView {

    private let activityIndicatorView = UIActivityIndicatorView(style: .large)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = UIColor.black.withAlphaComponent(0.25)
        layer.cornerRadius = 5
        
        if activityIndicatorView.superview == nil {
            addSubview(activityIndicatorView)
            
            activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            activityIndicatorView.startAnimating()
        }
    }

    public func animate() {
        activityIndicatorView.startAnimating()
    }
}

fileprivate struct Constants {
    /// an arbitrary tag id for the loading view, so it can be retrieved later without keeping a reference to it
    fileprivate static let loadingViewTag = 1234
}

/// Default implementation for UIViewController
extension Loadable where Self: UIViewController {
    
    func showLoadingView() {
        let loadingView = LoadingView()
        view.addSubview(loadingView)
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        loadingView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loadingView.animate()
        
        loadingView.tag = Constants.loadingViewTag
    }
    
    func hideLoadingView() {
        view.subviews.forEach { subview in
            if subview.tag == Constants.loadingViewTag {
                subview.removeFromSuperview()
            }
        }
    }
}

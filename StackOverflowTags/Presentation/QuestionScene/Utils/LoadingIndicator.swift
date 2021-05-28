//
//  LoadingIndicator.swift
//  StackOverflowTags
//
//  Created by Innocent Magagula on 2021/05/25.
//

import UIKit

protocol LoadingIndicator {
    var loadingView: UIView? { get }
    func showLoadingIndicator(onView: UIView)
    func hideLoadingIndicator()
}

class LoadingIndicatorImplementation: LoadingIndicator {

    var loadingView: UIView?

    func showLoadingIndicator(onView: UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let loadingIndicator = UIActivityIndicatorView(style: .whiteLarge)
        loadingIndicator.startAnimating()
        loadingIndicator.center = spinnerView.center
        spinnerView.addSubview(loadingIndicator)
        onView.addSubview(spinnerView)
        self.loadingView = spinnerView
    }

    func hideLoadingIndicator() {
        guard let loadingView = loadingView else {
            return
        }
        loadingView.removeFromSuperview()
    }
}

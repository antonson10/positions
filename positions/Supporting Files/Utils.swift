//
//  Utils.swift
//  positions
//
//  Created by Anton Chugunov on 01.09.2018.
//  Copyright © 2018 Anton Chugunov. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    static func displaySpinner(onView view: UIView) -> UIView {
        //let spinnerView = UIView(frame: view.frame)
        let spinnerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        spinnerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        spinnerView.center = view.center
        let AI = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        spinnerView.addSubview(AI)
        AI.center = spinnerView.center
        AI.startAnimating()
        AI.hidesWhenStopped = true
        view.addSubview(spinnerView)
        
        return spinnerView
    }
}

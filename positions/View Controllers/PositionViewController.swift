//
//  PositionViewController.swift
//  positions
//
//  Created by Anton Chugunov on 01.09.2018.
//  Copyright © 2018 Anton Chugunov. All rights reserved.
//

import UIKit

class PositionViewController: UIViewController {
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var companyLogoImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var goTompanySiteButton: UIButton!
    
    var currentPosition: Position?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Position"
        if let position = self.currentPosition {
            createdAtLabel.text = position.createdAt
            companyNameLabel.text = position.company
            cityLabel.text = position.location
            typeLabel.text = position.type
            descriptionLabel.text = nil
            descriptionLabel.attributedText = position.descr.htmlToAttributedString
            if let _ = position.companyUrl {
                goTompanySiteButton.isEnabled = true
            } else {
                goTompanySiteButton.isEnabled = false
            }
            if let companyLogoUrl = position.companyLogo {
                let apiManager = ApiManager()
                let AI = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
                AI.activityIndicatorViewStyle = .gray
                self.companyLogoImageView.addSubview(AI)
                AI.center = CGPoint(x: self.companyLogoImageView.bounds.width/2, y: self.companyLogoImageView.bounds.height/2)
                AI.startAnimating()
                apiManager.loadCompanyLogo(url: companyLogoUrl) { (newImage, error) in
                    DispatchQueue.main.async {
                        AI.removeFromSuperview()
                        if error == nil, let image = newImage {
                            self.companyLogoImageView.image = image
                        } else {
                            self.companyLogoImageView.image = UIImage(named: "questionMark")
                        }
                    }
                }
            } else {
                companyLogoImageView.image = UIImage(named: "questionMark")
            }
            
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func goToPositionClicked(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: self.currentPosition!.url)! , options: [:], completionHandler: nil)
    }
    @IBAction func goToConpanySiteClicked(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: self.currentPosition!.companyUrl!)! , options: [:], completionHandler: nil)
    }
    
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

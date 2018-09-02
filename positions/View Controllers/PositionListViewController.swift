//
//  ViewController.swift
//  positions
//
//  Created by Anton Chugunov on 29.08.2018.
//  Copyright © 2018 Anton Chugunov. All rights reserved.
//

import UIKit

class PositionListViewController: UIViewController {
    @IBOutlet weak var positionTableView: UITableView!
    @IBOutlet weak var positionSearchBar: UISearchBar!
    var positions = [Position]()
    var currentPage:Int = 0
    var canLoadMore:Bool = true
    let apiManager = ApiManager()
    var imagesForCells = [String:UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        positionTableView.delegate = self
        positionTableView.dataSource = self
        positionSearchBar.delegate = self
        setEmptyViewToTableViewFooter()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func requestNewQuery() {
        self.currentPage = 0
        self.canLoadMore = true
        self.displaySpinnerOnTableViewFooter()
        self.apiManager.newRequest(searchText: self.positionSearchBar.text!) { (newPositionsResponse, newError, text) in
            if let newPositions = newPositionsResponse {
                DispatchQueue.main.async {
                    self.setEmptyViewToTableViewFooter()
                    self.positions = newPositions
                    self.positionTableView.reloadData()
                    self.canLoadMore = newPositions.count > 0
                }
            }
        }
    }
    
    func requestUpdateQuery() {
        if self.canLoadMore {
            self.currentPage += 1
            self.displaySpinnerOnTableViewFooter()
            self.apiManager.updatePage(searchText: self.positionSearchBar.text!, pageNumber: self.currentPage) { (newPositionsResponse, newError, text) in
                if let newPositions = newPositionsResponse {
                    DispatchQueue.main.async {
                        self.setEmptyViewToTableViewFooter()
                        if newPositions.count > 0 {
                            self.positions.append(contentsOf: newPositions)
                            self.positionTableView.reloadData()
                        } else {
                            self.canLoadMore = false
                        }
                    }
                }
            }
        }
    }
    
    func setEmptyViewToTableViewFooter() {
        self.positionTableView.tableFooterView = UIView(frame: .zero)
    }
    
    func displaySpinnerOnTableViewFooter() {
        let AI = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: self.positionTableView.bounds.width, height: 44))
        AI.activityIndicatorViewStyle = .gray
        self.positionTableView.tableFooterView = AI
        AI.startAnimating()
    }
}

extension PositionListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.requestNewQuery()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension PositionListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    
        let story = UIStoryboard(name: "Main", bundle: nil)
        let positionVC = story.instantiateViewController(withIdentifier: "positionViewIdentifier") as! PositionViewController
        positionVC.currentPosition = self.positions[indexPath.row]
        self.navigationController?.pushViewController(positionVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.positions.count - 1 {
            print("Last row is displayed")
            self.requestUpdateQuery()
        }
    }
}

extension PositionListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.positions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cell for row \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "positionCell", for: indexPath) as! PositionTableViewCell
        cell.cityLabel.text = positions[indexPath.row].location
        cell.topicLabel.text = positions[indexPath.row].title
        if let logoURL = positions[indexPath.row].companyLogo {
            if self.imagesForCells.index(forKey: logoURL) != nil {
                cell.companyLogoImageView.image = self.imagesForCells[logoURL]
            } else {
                cell.companyLogoImageView.image = nil
                let AI = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
                AI.activityIndicatorViewStyle = .gray
                cell.companyLogoImageView.addSubview(AI)
                AI.center = CGPoint(x: cell.companyLogoImageView.bounds.width/2, y: cell.companyLogoImageView.bounds.height/2)
                AI.startAnimating()
                self.apiManager.loadCompanyLogo(url: logoURL) { (imageFromResponse, error) in
                    DispatchQueue.main.async {
                        AI.removeFromSuperview()
                        if error == nil, let image = imageFromResponse {
                            self.imagesForCells[logoURL] = image
                            cell.companyLogoImageView.image = self.imagesForCells[logoURL]
                        } else {
                            self.imagesForCells[logoURL] = UIImage(named: "questionMark")
                            cell.companyLogoImageView.image = self.imagesForCells[logoURL]
                        }
                    }
                }
            }
        } else {
            cell.companyLogoImageView.image = UIImage(named: "questionMark")
        }
        return cell
    }
}

//
//  ApiManager.swift
//  positions
//
//  Created by Anton Chugunov on 29.08.2018.
//  Copyright © 2018 Anton Chugunov. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON

class ApiManager {
    private func loadPositions(searchText: String, page: Int, completion: @escaping ([Position]?, Error?) -> Void) {
        let newSearchText = searchText.replacingOccurrences(of: " ", with: "%20")
        let urlString = "https://jobs.github.com/positions.json?search=\(newSearchText)&page=\(page)"
        print("url: \(urlString)")
        let request = Alamofire.request(urlString)
        request.validate()
        request.response { (response) in
            if response.error == nil {
                if let data = response.data {
                    let jsonData = JSON(data)
                    print("\(jsonData)")
                    if let jsonArray = jsonData.array {
                        var positions = [Position]()
                        for jsonEl in jsonArray {
                            let id = jsonEl["id"].stringValue
                            let created_at = jsonEl["created_at"].stringValue
                            let title = jsonEl["title"].stringValue
                            let location = jsonEl["location"].stringValue
                            let type = jsonEl["type"].stringValue
                            let description = jsonEl["description"].stringValue
                            let how_to_apply = jsonEl["how_to_apply"].stringValue
                            let company = jsonEl["company"].stringValue
                            let company_url = jsonEl["company_url"] == JSON.null ? nil : jsonEl["company_url"].stringValue
                            let company_logo = jsonEl["company_logo"] == JSON.null ? nil :jsonEl["company_logo"].stringValue
                            let url = jsonEl["url"].stringValue
                            let position = Position(id: id, createdAt: created_at, title: title, location: location, type: type, descr: description, howToApply: how_to_apply, company: company, companyUrl: company_url, companyLogo: company_logo, url: url)
                            positions.append(position)
                        }
                        completion(positions, nil)
                    } else {
                        completion(nil, nil)
                    }
                } else {
                    completion(nil, nil)
                }
            } else {
                print("error: \(response.error!.localizedDescription)")
                if let data = response.data {
                    print("data: \(String(data: data, encoding: String.Encoding.utf8)!)")
                }
                completion(nil, response.error)
            }
        }
    }
    
    func newRequest(searchText: String, completion: @escaping ([Position]?, Error?, String) -> Void) {
        self.loadPositions(searchText: searchText, page: 0) { (result, error) in
            completion(result, error, searchText)
        }
    }
    
    func updatePage(searchText: String, pageNumber: Int, completion: @escaping ([Position]?, Error?, String) -> Void) {
        self.loadPositions(searchText: searchText, page: pageNumber) { (result, error) in
            completion(result, error, searchText)
        }
    }
    
    func loadCompanyLogo(url: String, completion: @escaping (Image?, Error?) -> Void) {
        Alamofire.request(url).responseImage { (response) in
            if response.error == nil {
                if let image = response.result.value {
                    completion(image, nil)
                }
            } else {
                completion(nil, response.error)
            }
        }
    }
}

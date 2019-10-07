//
//  NewsModel.swift
//  News
//
//  Created by Андрей Олесов on 10/4/19.
//  Copyright © 2019 Andrei Olesau. All rights reserved.
//

import Foundation

class NewsModel:Codable{
    var status:String?
    var totalResults:Int?
    var articles:[Article]?
    
    init(status:String?, totalResults:Int?, articles:[Article]?) {
        self.articles = articles
        self.status = status
        self.totalResults = totalResults
    }
}

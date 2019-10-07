//
//  Article.swift
//  News
//
//  Created by Андрей Олесов on 10/4/19.
//  Copyright © 2019 Andrei Olesau. All rights reserved.
//

import Foundation


class Article:Codable{
    var source:Source?
    var author:String?
    var title:String?
    var description:String?
    var url:String?
    var urlToImage:String?
    var publishedAt:String?
    var content:String?
}

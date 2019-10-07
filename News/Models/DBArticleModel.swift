//
//  DBArticleModel.swift
//  News
//
//  Created by Андрей Олесов on 10/7/19.
//  Copyright © 2019 Andrei Olesau. All rights reserved.
//

import Foundation
import RealmSwift

class DBArticleModel:Object{
    @objc dynamic var author:String?
    @objc dynamic var title:String?
    @objc dynamic var shortDescription:String?
    @objc dynamic var url:String?
    @objc dynamic var urlToImage:String?
    @objc dynamic var publishedAt:String?
    @objc dynamic var content:String?
}

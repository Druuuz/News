//
//  DBUtil.swift
//  News
//
//  Created by Андрей Олесов on 10/7/19.
//  Copyright © 2019 Andrei Olesau. All rights reserved.
//

import Foundation
import RealmSwift

class DBUtil{

    static func save(article: Article?){
        guard let article = article else {return}
        let articleDBModel = DBArticleModel(value: [article.author, article.title, article.description,
                                                    article.url, article.urlToImage, article.publishedAt, article.content])
        let realm = try! Realm()
        try! realm.write {
            realm.add(articleDBModel)
        }
    }
    
    static func retrieve()->[Article]{
        let realm = try! Realm()
        let results = realm.objects(DBArticleModel.self)
        return results.toArrayOfArticleType()
    }
}

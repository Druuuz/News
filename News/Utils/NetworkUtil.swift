//
//  NetworkUtil.swift
//  News
//
//  Created by Андрей Олесов on 10/4/19.
//  Copyright © 2019 Andrei Olesau. All rights reserved.
//

import Foundation

class NetworkUtil{
    
    private static let headers = [
        "X-Api-Key": "68f2b000e6d44183a0f3332ec90ff1ed"
    ]

    private static let defaultUrl = "https://newsapi.org/v2/everything"
    
  
    public static func createRequest(fromDate startDate:Date, tillDate endDate:Date)->URLRequest?{
        guard let url = URL(string: "\(defaultUrl)?from=\(startDate.toString(withFormat: .YYYY_MM_DD))&to=\(endDate.toString(withFormat: .YYYY_MM_DD))&sortBy=publishedAt&sources=bbc-news&pageSize=100") else {return nil}
        print(url)
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        return request
    }
    
    public static func getNews(byRequest request:URLRequest, completion: @escaping (NewsModel)->()){
        
        URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
        guard let data = data, let _ = response, error == nil else {
            print("LOG: Incorrect response from endpoint, error = \(String(describing: error))")
            return
        }
        print("LOG: Downloded...")
        do{
            let jsonDecoder = JSONDecoder()
            let dataJson = try jsonDecoder.decode(NewsModel?.self, from: data)
            guard let results = dataJson else {
                print("LOG: Response from api is nil")
                return
            }
            print(results)
                completion(results)
            }
            catch{
                print("LOG: Error while fettching result")
            }
            }).resume()
    }
    
}

//
//  NewsTableViewCell.swift
//  News
//
//  Created by Андрей Олесов on 10/3/19.
//  Copyright © 2019 Andrei Olesau. All rights reserved.
//

import UIKit
import SDWebImage

class NewsTableViewCell: UITableViewCell {

    @IBOutlet var date: UILabel!
    @IBOutlet var title: UILabel!
    @IBOutlet var shortDescription: UILabel!
    @IBOutlet var previewImageView: UIImageView!
    
    var article:Article?{
        didSet{
            title.text = article?.title
            date.text = article?.publishedAt?.toDate(withFormat: .YYYY_MM_DD_Z)?.toString(withFormat: .DD_MM_YYYY)
            shortDescription.text = article?.description
            DispatchQueue.main.async {
                self.shortDescription.addTrailing(moreText: " ...Show more", moreTextFont: UIFont(name: "Helvetica Neue", size: 10.0)!, moreTextColor: UIColor.blue)
            }
            guard let imageUrl = URL(string: article?.urlToImage ?? "") else {return}
            previewImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named:"no-image"), options: [.continueInBackground], completed: nil)
        }
    }
}

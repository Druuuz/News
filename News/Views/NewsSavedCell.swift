//
//  NewsCell.swift
//  News
//
//  Created by Андрей Олесов on 10/7/19.
//  Copyright © 2019 Andrei Olesau. All rights reserved.
//

import UIKit
import SDWebImage
class NewsSavedCell: UICollectionViewCell {
    
    @IBOutlet var previewImage: UIImageView!
    
    @IBOutlet var text: UILabel!
    var article:Article?{
        didSet{
            text.text = article?.title
            guard let imageUrl = URL(string: article?.urlToImage ?? "") else {return}
            previewImage.sd_setImage(with: imageUrl, placeholderImage: UIImage(named:"no-image"), options: [.continueInBackground], completed: nil)
        }
    }
}

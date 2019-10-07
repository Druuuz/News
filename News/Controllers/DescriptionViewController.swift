//
//  DescriptionViewController.swift
//  News
//
//  Created by Андрей Олесов on 10/6/19.
//  Copyright © 2019 Andrei Olesau. All rights reserved.
//

import UIKit
import SDWebImage
import SafariServices

class DescriptionViewController: UIViewController {

    @IBOutlet var buttonOpenInSafari: UIButton!
    @IBOutlet var content: UITextView!
    @IBOutlet var date: UILabel!
    @IBOutlet var image: UIImageView!
    @IBOutlet var articleTitle: UILabel!
    @IBOutlet var buttonSave: UIButton!
    
    var isStored:Bool = false
    
    var article:Article?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if article?.url == nil{
            buttonOpenInSafari.isEnabled = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpUIFromArticle()
        if isStored {
            UIView.animate(withDuration: 0.3, animations: {
                self.buttonSave.isHidden = true
            })
        }
        content.isEditable = false
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func setUpUIFromArticle(){
        if let articleContent = article?.content{
            if let range = articleContent.range(of: "… [") {
              let substring = articleContent[..<range.lowerBound] // or str[str.startIndex..<range.lowerBound]
              content.text = "\(substring) ... [You can read more on website]"
            } else {
              content.text = articleContent
            }
        }
        articleTitle.text = article?.title
        date.text = article?.publishedAt?.toDate(withFormat: .YYYY_MM_DD_Z)?.toString(withFormat: .DD_MM_YYYY)
        guard let imageUrl = URL(string: article?.urlToImage ?? "") else {return}
        image.sd_setImage(with: imageUrl, placeholderImage: UIImage(named:"no-image"), options: [.continueInBackground, .progressiveLoad], completed: nil)
    }

    @IBAction func openInSafari(_ sender: UIButton) {
        guard let url = URL(string: article?.url ?? "") else {return}
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }

    @IBAction func saveArticle(_ sender: UIButton) {
        DBUtil.save(article: self.article)
        UIView.animate(withDuration: 0.3, animations: {
            self.buttonSave.isHidden = true
        })
        isStored = true
    }
    
}

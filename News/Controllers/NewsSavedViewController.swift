//
//  NewsController.swift
//  News
//
//  Created by Андрей Олесов on 10/7/19.
//  Copyright © 2019 Andrei Olesau. All rights reserved.
//

import UIKit

class NewsSavedViewController: UIViewController {
    private let numOfNotesInLine:CGFloat = 2
    private let borderWidth:CGFloat = 10
    @IBOutlet var collectionView: UICollectionView!
    
    var articles:[Article]{
        get{
            return DBUtil.retrieve()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
}
    
    extension NewsSavedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return articles.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsSavedCell", for: indexPath) as! NewsSavedCell
            cell.article = articles[indexPath.item]
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = ((collectionView.frame.width  - borderWidth) / numOfNotesInLine)
            let height = width + 20
            return CGSize(width: width, height: height)
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            guard let DVC = storyboard?.instantiateViewController(withIdentifier: "DescriptionViewController") as? DescriptionViewController else {return}
            DVC.article = articles[indexPath.item]
            DVC.isStored = true
            self.present(DVC, animated: true, completion: nil)
            
        }
        
    }



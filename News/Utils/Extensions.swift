//
//  Extensions.swift
//  News
//
//  Created by Андрей Олесов on 10/4/19.
//  Copyright © 2019 Andrei Olesau. All rights reserved.
//

import Foundation
import RealmSwift

extension Date{

    func toString(withFormat format:DateFormat)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: self)
    }
    
    func minusHours(_ hours:Int)->Date{
        return Calendar.current.date(byAdding: .hour, value: -hours, to: self) ?? self
    }
}

extension String{
    func toDate(withFormat format:DateFormat)->Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.date(from: self)
    }
}

extension Results{
    func toArrayOfArticleType()->[Article]{
        var arrayOfArticle = [Article]()
        var arrayOfArtileDBModel = [DBArticleModel]()
        for i in 0 ..< count {
            if let result = self[i] as? DBArticleModel {
                arrayOfArtileDBModel.append(result)
            }
        }
        
        for i in 0 ..< arrayOfArtileDBModel.count{
            let newArticle = Article()
            newArticle.author = arrayOfArtileDBModel[i].author
            newArticle.content = arrayOfArtileDBModel[i].content
            newArticle.description = arrayOfArtileDBModel[i].shortDescription
            newArticle.publishedAt = arrayOfArtileDBModel[i].publishedAt
            newArticle.title = arrayOfArtileDBModel[i].title
            newArticle.url = arrayOfArtileDBModel[i].url
            newArticle.urlToImage = arrayOfArtileDBModel[i].urlToImage
            arrayOfArticle.append(newArticle)
        }
        return arrayOfArticle
    }
}
enum DateFormat:String{
    case YYYY_MM_DD_Z = "yyyy-MM-dd'T'HH:mm:ssZ"
    case YYYY_MM_DD = "yyyy-MM-dd'T'HH:mm:ss"
    case DD_MM_YYYY = "dd/MM/yyyy HH:mm"
}

extension UILabel {

    func addTrailing(moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
        let lengthForVisibleString: Int = self.vissibleTextLength

        guard let text = self.text else {return}
        guard lengthForVisibleString < text.count else {return}

        self.text?.removeSubrange(text.index(text.endIndex, offsetBy: lengthForVisibleString - moreText.count - text.count - 3)..<text.endIndex)
        let answerAttributed = NSMutableAttributedString(string: self.text!, attributes: [NSAttributedString.Key.font: self.font])
        let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: moreTextFont, NSAttributedString.Key.foregroundColor: moreTextColor])
        answerAttributed.append(readMoreAttributed)
        self.attributedText = answerAttributed
    }

    var vissibleTextLength: Int {
        let font: UIFont = self.font
        let mode: NSLineBreakMode = self.lineBreakMode
        let labelWidth: CGFloat = self.frame.size.width
        let labelHeight: CGFloat = self.frame.size.height
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)

        let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: font]
        let attributedText = NSAttributedString(string: self.text!, attributes: attributes as? [NSAttributedString.Key : Any])
        let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)

        if boundingRect.size.height > labelHeight {
            var index: Int = 0
            var prev: Int = 0
            let characterSet = CharacterSet.whitespacesAndNewlines
            repeat {
                prev = index
                if mode == NSLineBreakMode.byCharWrapping {
                    index += 1
                } else {
                    index = (self.text! as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: self.text!.count - index - 1)).location
                }
            } while index != NSNotFound && index < self.text!.count && (self.text! as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedString.Key : Any], context: nil).size.height <= labelHeight
            return prev
        }
        return self.text!.count
    }
}

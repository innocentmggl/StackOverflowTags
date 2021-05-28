//
//  Extensions.swift
//  StackOverflowTags
//
//  Created by Innocent Magagula on 2021/05/20.
//

import UIKit

protocol Localizable {
    var localized: String { get }
}

protocol XIBLocalizable {
    var xibLocalizedKey: String? { get set }
}

extension String: Localizable {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    var html2AttributedString: String {
        guard let data = data(using: .utf8) else { return self }
        do {
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                                .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil).string

        } catch let error as NSError {
            print(error.localizedDescription)
            return self
        }
    }
}

extension UILabel: XIBLocalizable {
    @IBInspectable var xibLocalizedKey: String? {
        get { return nil }
        set(key) {
            text = key?.localized
        }
    }
}

extension UIButton: XIBLocalizable {
    @IBInspectable var xibLocalizedKey: String? {
        get { return nil }
        set(key) {
            setTitle(key?.localized, for: .normal)
        }
   }
}

extension UIColor {
    class var indigo: UIColor {
        return UIColor(red: 64/255, green: 120/255, blue: 196/255, alpha: 1.0)
    }

    class var mountainMist: UIColor {
        return UIColor(red: 143/255, green: 142/255, blue: 148/255, alpha: 1.0)
    }
}

extension Int {
    var roundedWithAbbreviations: String {
        let number = Double(self)
        let thousand = number / 1000
        let million = number / 1000000
        if million >= 1.0 {
            return "\(round(million*10)/10)M"
        }
        else if thousand >= 1.0 {
            return "\(round(thousand*10)/10)K"
        }
        else {
            return "\(self)"
        }
    }
}

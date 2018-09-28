//
//  ExtString.swift
//  StackOverflowClient
//
//  Created by aivanovskij on 18.09.2018.
//  Copyright © 2018 aivanovskij. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Decoding HTML

extension String {
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    
    
    func decodeTitleSymbols() -> String {
        var decodedTitle = self.replacingOccurrences(of: "&#39;", with: "'", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "&quot;", with: "\"", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "&#252;", with: "ü", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "&#246;", with: "ö", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "&gt;", with: ">", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "&lt;", with: "<", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "&#225;", with: "á", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "&#233;", with: "é", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "&#250;", with: "ú", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "&#220;", with: "Ü", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "&#231;", with: "ç", options: .regularExpression, range: nil)
        
        decodedTitle = decodedTitle.replacingOccurrences(of: "<p>", with: "", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "</p>", with: "", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "<strong>", with: "", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "</strong>", with: "", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "<pre>", with: "", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "</pre>", with: "", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "</pre>", with: "", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "<ul>", with: "", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "</ul>", with: "", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "<ol>", with: "", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "</ol>", with: "", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "<li>", with: "", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "</li>", with: "", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "<kbd>", with: "", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "</kbd>", with: "", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "<em>", with: "", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "</em>", with: "", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "<br>", with: "", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "<br />", with: "", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "<h1>", with: "", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "</h1>", with: "", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "<h2>", with: "", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "</h2>", with: "", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "<h3>", with: "", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "</h3>", with: "", options: .regularExpression, range: nil)
        
        decodedTitle = decodedTitle.replacingOccurrences(of: "<hr>", with: "--------------", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "</hr>", with: "--------------", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: """
        <a href="
        """, with: "\n", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "</a>", with: "", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: """
        ">
        """, with: " ", options: .regularExpression, range: nil)
        
        decodedTitle = decodedTitle.replacingOccurrences(of: "<blockquote>", with: "'''", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "</blockquote>", with: "'''", options: .regularExpression, range: nil)
        
//        decodedTitle = decodedTitle.replacingOccurrences(of: "<code>", with: "\n<code>\n", options: .regularExpression, range: nil)
//        decodedTitle = decodedTitle.replacingOccurrences(of: "</code>", with: "\n</code>\n", options: .regularExpression, range: nil)
        
        return decodedTitle
    }
    
    func colorCode() -> NSMutableAttributedString {
        
        var str = self
        let codeOpeningString = "<code>"
        let codeEndingString = "</code>"
        
        let finalStringAttributed = NSMutableAttributedString()
        var binard: Int = 0
        
        str.append("<code>")
        
        while !(str == "<code>") {
            if binard == 0 {
                let range = str.range(of: codeOpeningString)!
                let startString = str.prefix(upTo: range.lowerBound)
                let rangeToDelete = str.startIndex..<range.lowerBound
                str.removeSubrange(rangeToDelete)
                finalStringAttributed.append(NSAttributedString(string: String(startString)))
                binard = 1
            }
            if binard == 1, let range = str.range(of: codeEndingString) {
                let startString = str.prefix(upTo: range.upperBound)
                let rangeToDelete = str.startIndex..<range.upperBound
                str.removeSubrange(rangeToDelete)
                var start = String(startString)
                start = start.replacingOccurrences(of: codeOpeningString, with: "")
                start = start.replacingOccurrences(of: codeEndingString, with: "")
                finalStringAttributed.append(NSAttributedString(string: String(start), attributes: [NSAttributedString.Key.backgroundColor:UIColor.lightGray.withAlphaComponent(0.25), NSAttributedString.Key.font:UIFont.monospacedDigitSystemFont(ofSize: 12.0, weight: .regular)]))
                binard = 0
            }
        }
        return finalStringAttributed
    }
}

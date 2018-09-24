//
//  ExtString.swift
//  StackOverflowClient
//
//  Created by aivanovskij on 18.09.2018.
//  Copyright © 2018 aivanovskij. All rights reserved.
//

import Foundation

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
        
        decodedTitle = decodedTitle.replacingOccurrences(of: "<p>", with: "", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "</p>", with: "", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "<strong>", with: "", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "</strong>", with: "", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "<pre>", with: "", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "</pre>", with: "", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "</pre>", with: "", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "<blockquote>", with: "'''", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "</blockquote>", with: "'''", options: .regularExpression, range: nil)
        
        decodedTitle = decodedTitle.replacingOccurrences(of: "<code>", with: "\n<code>\n", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "</code>", with: "\n</code>\n", options: .regularExpression, range: nil)
        
        return decodedTitle
    }
}

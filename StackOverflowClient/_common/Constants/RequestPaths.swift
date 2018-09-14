//
//  RequestPaths.swift
//  StackOverflowClient
//
//  Created by aivanovskij on 03.09.2018.
//  Copyright © 2018 aivanovskij. All rights reserved.
//

import Foundation

enum RequestPaths {
    
    // MARK: - API
    static let baseURL = "https://api.stackexchange.com/2.2/"
    
    enum RequestType {
        
        // MARK: Type (Ищем все вопросы, отвечающие установленным в компонентах критериям)
        static let search = "search/advanced"
    }
    
    enum RequestComponents {
        
        // MARK: - Page
        static let pageNum = "page="
        
        // MARK: - Page size
        static let pageSize = "pagesize=50"
        
        // MARK: - Order
        static let order = "order=desc"
        
        // MARK: - Sort
        static let sortActivity = "sort=activity"
        
        // MARK: - Answers
        static let minAnswers = "answers=1"
        
        // MARK: - Tagged
        static let taggedSwift = "tagged=swift"
        static let taggedObjectiveC = "tagged=objective-c"
        static let taggedIOS = "tagged=ios"
        static let taggedXCode = "tagged=xcode"
        static let taggedCocoaTouch = "tagged=cocoa-touch"
        static let taggedIPhone = "tagged=iphone"
        
        // MARK: - Site
        static let site = "site=stackoverflow"
    }
}


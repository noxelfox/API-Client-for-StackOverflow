//
//  RequestPaths.swift
//  StackOverflowClient
//
//  Created by aivanovskij on 03.09.2018.
//  Copyright © 2018 aivanovskij. All rights reserved.
//

import Foundation

enum RequestPaths {
    static let baseURL = "https://api.stackexchange.com"
    
    enum GetQuestions {
        static let getSwift = RequestPaths.baseURL + "/2.2/search/advanced?page=1&pagesize=100&order=desc&sort=activity&answers=1&tagged=swift&site=stackoverflow"
        static let getObjC = RequestPaths.baseURL + "/2.2/search/advanced?page=1&pagesize=100&order=desc&sort=activity&answers=1&tagged=objective-c&site=stackoverflow"
        static let getIOS = RequestPaths.baseURL + "/2.2/search/advanced?page=1&pagesize=100&order=desc&sort=activity&answers=1&tagged=ios&site=stackoverflow"
        static let getXcode = RequestPaths.baseURL + "/2.2/search/advanced?page=1&pagesize=100&order=desc&sort=activity&answers=1&tagged=xcode&site=stackoverflow"
        static let getCocoaTouch = RequestPaths.baseURL + "/2.2/search/advanced?page=1&pagesize=100&order=desc&sort=activity&answers=1&tagged=cocoa-touch&site=stackoverflow"
        static let getIphone = RequestPaths.baseURL + "/2.2/search/advanced?page=1&pagesize=100&order=desc&sort=activity&answers=1&tagged=iphone&site=stackoverflow"
    }
}


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
        static let getSwift = RequestPaths.baseURL + "/2.2/search/advanced?pagesize=100&order=desc&sort=activity&answers=1&tagged=Swift&site=stackoverflow"
    }
}


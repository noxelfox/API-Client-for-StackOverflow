//
//  RequestManager.swift
//  StackOverflowClient
//
//  Created by aivanovskij on 03.09.2018.
//  Copyright © 2018 aivanovskij. All rights reserved.
//

import Foundation
import Alamofire

class RequestManager {
    
    var page = 1
    
    func requestBuilder(tag: String, page: Int) -> String {
        
        switch tag {
        case Tags.swift:
            print("\(RequestPaths.baseURL)\(RequestPaths.RequestType.search)?\(RequestPaths.RequestComponents.pageNum)\(String(page))&\(RequestPaths.RequestComponents.pageSize)&\(RequestPaths.RequestComponents.order)&\(RequestPaths.RequestComponents.sortActivity)&\(RequestPaths.RequestComponents.minAnswers)&\(RequestPaths.RequestComponents.taggedSwift)&\(RequestPaths.RequestComponents.site)")
            return "\(RequestPaths.baseURL)\(RequestPaths.RequestType.search)?\(RequestPaths.RequestComponents.pageNum)\(String(page))&\(RequestPaths.RequestComponents.pageSize)&\(RequestPaths.RequestComponents.order)&\(RequestPaths.RequestComponents.sortActivity)&\(RequestPaths.RequestComponents.minAnswers)&\(RequestPaths.RequestComponents.taggedSwift)&\(RequestPaths.RequestComponents.site)"
        case Tags.objectiveC:
            return "\(RequestPaths.baseURL)\(RequestPaths.RequestType.search)?\(RequestPaths.RequestComponents.pageNum)\(page)&\(RequestPaths.RequestComponents.pageSize)&\(RequestPaths.RequestComponents.order)&\(RequestPaths.RequestComponents.sortActivity)&\(RequestPaths.RequestComponents.minAnswers)&\(RequestPaths.RequestComponents.taggedObjectiveC)&\(RequestPaths.RequestComponents.site)"
        case Tags.iOS:
            return "\(RequestPaths.baseURL)\(RequestPaths.RequestType.search)?\(RequestPaths.RequestComponents.pageNum)\(page)&\(RequestPaths.RequestComponents.pageSize)&\(RequestPaths.RequestComponents.order)&\(RequestPaths.RequestComponents.sortActivity)&\(RequestPaths.RequestComponents.minAnswers)&\(RequestPaths.RequestComponents.taggedIOS)&\(RequestPaths.RequestComponents.site)"
        case Tags.xCode:
            return "\(RequestPaths.baseURL)\(RequestPaths.RequestType.search)?\(RequestPaths.RequestComponents.pageNum)\(page)&\(RequestPaths.RequestComponents.pageSize)&\(RequestPaths.RequestComponents.order)&\(RequestPaths.RequestComponents.sortActivity)&\(RequestPaths.RequestComponents.minAnswers)&\(RequestPaths.RequestComponents.taggedXCode)&\(RequestPaths.RequestComponents.site)"
        case Tags.cocoaTouch:
            return "\(RequestPaths.baseURL)\(RequestPaths.RequestType.search)?\(RequestPaths.RequestComponents.pageNum)\(page)&\(RequestPaths.RequestComponents.pageSize)&\(RequestPaths.RequestComponents.order)&\(RequestPaths.RequestComponents.sortActivity)&\(RequestPaths.RequestComponents.minAnswers)&\(RequestPaths.RequestComponents.taggedCocoaTouch)&\(RequestPaths.RequestComponents.site)"
        case Tags.iPhone:
            return "\(RequestPaths.baseURL)\(RequestPaths.RequestType.search)?\(RequestPaths.RequestComponents.pageNum)\(page)&\(RequestPaths.RequestComponents.pageSize)&\(RequestPaths.RequestComponents.order)&\(RequestPaths.RequestComponents.sortActivity)&\(RequestPaths.RequestComponents.minAnswers)&\(RequestPaths.RequestComponents.taggedIPhone)&\(RequestPaths.RequestComponents.site)"
        default:
            return "\(RequestPaths.baseURL)\(RequestPaths.RequestType.search)?\(RequestPaths.RequestComponents.pageNum)1&\(RequestPaths.RequestComponents.pageSize)&\(RequestPaths.RequestComponents.order)&\(RequestPaths.RequestComponents.sortActivity)&\(RequestPaths.RequestComponents.minAnswers)&\(RequestPaths.RequestComponents.taggedSwift)&\(RequestPaths.RequestComponents.site)"
        }
    }

}

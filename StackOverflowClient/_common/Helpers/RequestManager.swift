//
//  RequestManager.swift
//  StackOverflowClient
//
//  Created by aivanovskij on 03.09.2018.
//  Copyright © 2018 aivanovskij. All rights reserved.
//

import Foundation
import Alamofire
import Cache

class RequestManager {
    
    // MARK: - Cache config
    
    let diskConfig = DiskConfig(name: "Questions_cache")
    let memoryConfig = MemoryConfig(expiry: .seconds(300), countLimit: 50, totalCostLimit: 0)
    lazy var storage = try? Storage(
        diskConfig: diskConfig,
        memoryConfig: memoryConfig,
        transformer: TransformerFactory.forCodable(ofType: QuestionResponse.self) // Storage<ResponseQuestions>
    )
    
    func requestBuilder(tag: Tags, page: Int) -> String {
        switch tag {
        case .swift:
            return "\(RequestPaths.baseURL)\(RequestPaths.RequestType.search)?\(RequestPaths.RequestComponents.pageNum)\(String(page))&\(RequestPaths.RequestComponents.pageSize)&\(RequestPaths.RequestComponents.order)&\(RequestPaths.RequestComponents.sortActivity)&\(RequestPaths.RequestComponents.minAnswers)&\(RequestPaths.RequestComponents.taggedSwift)&\(RequestPaths.RequestComponents.site)"
        case .objectiveC:
            return "\(RequestPaths.baseURL)\(RequestPaths.RequestType.search)?\(RequestPaths.RequestComponents.pageNum)\(page)&\(RequestPaths.RequestComponents.pageSize)&\(RequestPaths.RequestComponents.order)&\(RequestPaths.RequestComponents.sortActivity)&\(RequestPaths.RequestComponents.minAnswers)&\(RequestPaths.RequestComponents.taggedObjectiveC)&\(RequestPaths.RequestComponents.site)"
        case .iOS:
            return "\(RequestPaths.baseURL)\(RequestPaths.RequestType.search)?\(RequestPaths.RequestComponents.pageNum)\(page)&\(RequestPaths.RequestComponents.pageSize)&\(RequestPaths.RequestComponents.order)&\(RequestPaths.RequestComponents.sortActivity)&\(RequestPaths.RequestComponents.minAnswers)&\(RequestPaths.RequestComponents.taggedIOS)&\(RequestPaths.RequestComponents.site)"
        case .xCode:
            return "\(RequestPaths.baseURL)\(RequestPaths.RequestType.search)?\(RequestPaths.RequestComponents.pageNum)\(page)&\(RequestPaths.RequestComponents.pageSize)&\(RequestPaths.RequestComponents.order)&\(RequestPaths.RequestComponents.sortActivity)&\(RequestPaths.RequestComponents.minAnswers)&\(RequestPaths.RequestComponents.taggedXCode)&\(RequestPaths.RequestComponents.site)"
        case .cocoaTouch:
            return "\(RequestPaths.baseURL)\(RequestPaths.RequestType.search)?\(RequestPaths.RequestComponents.pageNum)\(page)&\(RequestPaths.RequestComponents.pageSize)&\(RequestPaths.RequestComponents.order)&\(RequestPaths.RequestComponents.sortActivity)&\(RequestPaths.RequestComponents.minAnswers)&\(RequestPaths.RequestComponents.taggedCocoaTouch)&\(RequestPaths.RequestComponents.site)"
        case .iPhone:
            return "\(RequestPaths.baseURL)\(RequestPaths.RequestType.search)?\(RequestPaths.RequestComponents.pageNum)\(page)&\(RequestPaths.RequestComponents.pageSize)&\(RequestPaths.RequestComponents.order)&\(RequestPaths.RequestComponents.sortActivity)&\(RequestPaths.RequestComponents.minAnswers)&\(RequestPaths.RequestComponents.taggedIPhone)&\(RequestPaths.RequestComponents.site)"
        }
    }

}

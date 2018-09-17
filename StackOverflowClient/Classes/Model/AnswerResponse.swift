//
//  AnswerResponse.swift
//  StackOverflowClient
//
//  Created by aivanovskij on 17.09.2018.
//  Copyright © 2018 aivanovskij. All rights reserved.
//
// To parse the JSON, add this file to your project and do:
//
//   let answerResponse = try? newJSONDecoder().decode(AnswerResponse.self, from: jsonData)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseAnswerResponse { response in
//     if let answerResponse = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

struct AnswerResponse: Codable {
    let items: [AnswerItem]
    let hasMore: Bool
    let page: Int
    let pageSize: Int
    
    enum CodingKeys: String, CodingKey {
        case items = "items"
        case hasMore = "has_more"
        case page = "page"
        case pageSize = "page_size"
    }
}

struct AnswerItem: Codable {
    let answers: [Answer]
    let owner: AnswerOwner
    let score: Int
    let lastActivityDate: Int
    let questionID: Int
    let title: String
    let body: String
    
    enum CodingKeys: String, CodingKey {
        case answers = "answers"
        case owner = "owner"
        case score = "score"
        case lastActivityDate = "last_activity_date"
        case questionID = "question_id"
        case title = "title"
        case body = "body"
    }
}

struct Answer: Codable {
    let owner: AnswerOwner
    let isAccepted: Bool
    let score: Int
    let lastActivityDate: Int
    let lastEditDate: Int?
    let creationDate: Int
    let answerID: Int
    let body: String
    
    enum CodingKeys: String, CodingKey {
        case owner = "owner"
        case isAccepted = "is_accepted"
        case score = "score"
        case lastActivityDate = "last_activity_date"
        case lastEditDate = "last_edit_date"
        case creationDate = "creation_date"
        case answerID = "answer_id"
        case body = "body"
    }
}

struct AnswerOwner: Codable {
    let displayName: String
    
    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
    }
}

func answerJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, *) {
        decoder.dateDecodingStrategy = .secondsSince1970
    }
    return decoder
}

// MARK: - Alamofire response handlers

extension DataRequest {
    fileprivate func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            guard error == nil else { return .failure(error!) }
            
            guard let data = data else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }
            
            return Result { try newJSONDecoder().decode(T.self, from: data) }
        }
    }
    
    @discardableResult
    fileprivate func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseAnswerResponse(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<AnswerResponse>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}

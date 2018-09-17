//
//  ResponseStruct.swift
//  StackOverflowClient
//
//  Created by aivanovskij on 04.09.2018.
//  Copyright © 2018 aivanovskij. All rights reserved.
//

import Foundation
import Alamofire

struct ResponseQuestions: Codable {
    let items: [Item]?
    let hasMore: Bool
    let quotaMax, quotaRemaining: Int
    
    enum CodingKeys: String, CodingKey {
        case items
        case hasMore = "has_more"
        case quotaMax = "quota_max"
        case quotaRemaining = "quota_remaining"
    }
}

struct Item: Codable {
    let tags: [String]
    let owner: Owner
    let isAnswered: Bool
    let viewCount, answerCount, score: Int
    let lastActivityDate: Date
    let creationDate: Date
    let lastEditDate: Date?
    let questionID: Int
    let link: String
    let title: String
    let acceptedAnswerID, bountyAmount, bountyClosesDate: Int?
    
    enum CodingKeys: String, CodingKey {
        case tags, owner
        case isAnswered = "is_answered"
        case viewCount = "view_count"
        case answerCount = "answer_count"
        case score
        case lastActivityDate = "last_activity_date"
        case creationDate = "creation_date"
        case lastEditDate = "last_edit_date"
        case questionID = "question_id"
        case link, title
        case acceptedAnswerID = "accepted_answer_id"
        case bountyAmount = "bounty_amount"
        case bountyClosesDate = "bounty_closes_date"
    }
}

struct Owner: Codable {
    let reputation: Int? //Иногда обнаруживала nil
    let userID: Int? //Иногда обнаруживала nil
    let userType: String? //Иногда обнаруживала nil
    let acceptRate: Int?
    let profileImage: String?
    let displayName: String
    let link: String?
    
    enum CodingKeys: String, CodingKey {
        case reputation
        case userID = "user_id"
        case userType = "user_type"
        case acceptRate = "accept_rate"
        case profileImage = "profile_image"
        case displayName = "display_name"
        case link
    }
}

//enum UserType: String, Codable {
//    case registered = "registered"
//}

func newJSONDecoder() -> JSONDecoder {
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
    func responseResponseQuestions(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<ResponseQuestions>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}

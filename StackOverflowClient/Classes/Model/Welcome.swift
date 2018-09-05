//
//  Welcome.swift
//  StackOverflowClient
//
//  Created by aivanovskij on 04.09.2018.
//  Copyright © 2018 aivanovskij. All rights reserved.
//
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseWelcome { response in
//     if let welcome = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

struct Welcome: Codable {
    let items: [Item]
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
    let link, title: String
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
    let reputation, userID: Int
    let userType: UserType
    let acceptRate: Int?
    let profileImage, displayName, link: String
    
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

enum UserType: String, Codable {
    case registered = "registered"
}

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .secondsSince1970
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
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
    func responseWelcome(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<Welcome>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}

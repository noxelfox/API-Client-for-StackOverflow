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
    
    var questions = [Question]()
    
    func callAPIforQuestions() {
//        Alamofire.request("\(RequestPaths.GetQuestions.getSwift)", method: .get).responseJSON { response in
//            guard response.result.isSuccess else {
//                print("Ошибка при запросе данных\(String(describing: response.result.error))")
//                return
//            }
//
//            guard let arrayOfQuestions = response.result.value as? [[String:AnyObject]]
//                else {
//                    print(response.result.value!)
//                    print("Не могу перевести в массив")
//                    return
//            }
//
////            let arrayOfQuestions = response.result.value as? [[String:AnyObject]]
//
//            for item in arrayOfQuestions {
//                let question = Question(questionAuthor: item["display_name"] as! String, questionLastEdit: item["last_edit_date"] as! Date, questionTitle: item["title"] as! String, questionNumAnswers: item["answer_count"] as! Int)
//                self.questions.append(question)
//            }
//        }
        
        Alamofire.request("\(RequestPaths.GetQuestions.getSwift)", method: .get).responseWelcome { response in
//            print(response.data)
//            print(response)
            print("Rezult: \(response.result)")
            print("Value: \(response.result.value!)")
            if let welcome = response.result.value {
//                print(welcome)
                for item in welcome.items {
                    if item.lastEditDate == nil {
                        let nullDate = item.creationDate
                        let question = Question(questionAuthor: item.owner.displayName as String, questionLastEdit: nullDate , questionTitle: item.title as String, questionNumAnswers: item.answerCount as Int)
                        self.questions.append(question)
                    } else {
                        let question = Question(questionAuthor: item.owner.displayName as String, questionLastEdit: item.lastEditDate! as Date, questionTitle: item.title as String, questionNumAnswers: item.answerCount as Int)
                        self.questions.append(question)
                    }
                }
            }
            print(self.questions)
        }
    }
}

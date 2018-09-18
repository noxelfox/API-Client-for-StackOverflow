//
//  AnswersViewController.swift
//  StackOverflowClient
//
//  Created by aivanovskij on 17.09.2018.
//  Copyright © 2018 aivanovskij. All rights reserved.
//

import UIKit
import Alamofire
import Cache

class AnswersViewController: UIViewController {
    
    let loadTableIndicator: UIActivityIndicatorView = UIActivityIndicatorView();
    let requestManager = RequestManager()
    let dateFormatter = DateFormatter()
    
    var answers = [Case]()
    var questionID: Int = 0
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = questionID.description
        
//        showLoadingTableIndicator()
        callAPIforAnswers(questionID: questionID)
        tableView.reloadData()
//        loadRefreshControll()
//        addLoadMore()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        answers.removeAll()
        tableView.reloadData()
    }
    
    func callAPIforAnswers(questionID: Int){
        
        Alamofire.request("\(requestManager.answerRequestBuilder(id: questionID))", method: .get).responseAnswerResponse { response in
            
            let actualResponse = response.result.value
            
            // MARK: - Print response
            print("\nCALL: \(self.requestManager.answerRequestBuilder(id: questionID))")
            if response.result.error != nil {
                print("ERROR: \(String(describing: response.result.error))")
            } else {
                print("RESULT: \(response.result)")
            }
            
            // MARK: - Parsing response <QuestionResponse> into Case object
            
            self.parseAnswersResponse(actualResponse: actualResponse)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func parseAnswersResponse(actualResponse: AnswerResponse?){
        
        if let answerResponse = actualResponse {
            guard let items = answerResponse.items else { return }
            for item in items {
                guard let answerItems = item.answers else { return }
                print(item.owner)
                print(item.title)
                print(item.score)
                print(item.body!)
                for answerItem in answerItems {
                    if answerItem.lastEditDate == nil {
                        let nullDate = answerItem.lastActivityDate
                        let answer = Case(caseAuthor: answerItem.owner.displayName as String, caseLastEdit: nullDate, caseTitle: answerItem.body as String, caseNum: answerItem.score as Int, caseId: answerItem.answerID, isAccepted: answerItem.isAccepted)
                        self.answers.append(answer)
                    } else {
                        let answer = Case(caseAuthor: answerItem.owner.displayName as String, caseLastEdit: answerItem.lastActivityDate, caseTitle: answerItem.body as String, caseNum: answerItem.score as Int, caseId: answerItem.answerID, isAccepted: answerItem.isAccepted)
                        self.answers.append(answer)
                    }
                }
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.hideLoadingTableIndicator()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - Table view Data Source

extension AnswersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath) as! CaseTableViewCell
        let indexAnswer = answers[indexPath.row]
        // Configure the cell...
        cell.cellAuthor.text = indexAnswer.caseAuthor.decodeTitleSymbols()
        cell.cellDate.text = indexAnswer.caseLastEdit.timeAgoDisplay()
        cell.cellNumAnswers.text = "±\(indexAnswer.caseNum.description)"
        cell.cellText.text = indexAnswer.caseTitle.decodeTitleSymbols()
        
        return cell
    }
}

// MARK: - Loading Indecator

extension AnswersViewController {
    
    func showLoadingTableIndicator(){
        loadTableIndicator.center = self.view.center;
        loadTableIndicator.hidesWhenStopped = true;
        loadTableIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray;
        view.addSubview(loadTableIndicator);
        
        loadTableIndicator.startAnimating();
        UIApplication.shared.beginIgnoringInteractionEvents();
    }
    
    func hideLoadingTableIndicator(){
        loadTableIndicator.stopAnimating();
        UIApplication.shared.endIgnoringInteractionEvents();
    }
}

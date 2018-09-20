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
    private let refreshControl = UIRefreshControl()
    
    var answers = [Case]()
    var questionID: Int = 0
    var questionDate: Date = Date.distantPast
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = questionID.description
        
        showLoadingTableIndicator()
        callAPIforAnswers(questionID: questionID)
        tableView.reloadData()
        loadRefreshControll()
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
                let question = Case(caseAuthor: item.owner.displayName as String, caseLastEdit: questionDate as Date, caseTitle: item.title + "\n\n" + item.body!, caseNum: item.score, caseId: item.questionID as Int, isAccepted: nil, isZero: true)
                self.answers.append(question)
                
                for answerItem in answerItems {
                    if answerItem.lastEditDate == nil {
                        let nullDate = answerItem.lastActivityDate
                        let answer = Case(caseAuthor: answerItem.owner.displayName as String, caseLastEdit: nullDate, caseTitle: answerItem.body as String, caseNum: answerItem.score as Int, caseId: answerItem.answerID, isAccepted: answerItem.isAccepted, isZero: false)
                        self.answers.append(answer)
                    } else {
                        let answer = Case(caseAuthor: answerItem.owner.displayName as String, caseLastEdit: answerItem.lastActivityDate, caseTitle: answerItem.body as String, caseNum: answerItem.score as Int, caseId: answerItem.answerID, isAccepted: answerItem.isAccepted, isZero: false)
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
        if indexAnswer.isZero == true {
            cell.backgroundColor = UIColor.darkGray.withAlphaComponent(0.75)
            cell.cellAuthor.textColor = .cyan
            cell.cellDate.textColor = UIColor.lightText
            cell.cellNumAnswers.textColor = .cyan
            cell.cellText.textColor = .white
        } else {
            cell.backgroundColor = UIColor.clear
            cell.cellAuthor.textColor = UIColor(red: 0.105, green: 0.34, blue: 0.56, alpha: 0.95)
            cell.cellDate.textColor = UIColor.darkGray
            cell.cellNumAnswers.textColor = UIColor(red: 0.105, green: 0.34, blue: 0.56, alpha: 0.95)
            cell.cellText.textColor = UIColor.darkText
        }
        
        
        
        cell.cellAuthor.text = indexAnswer.caseAuthor.decodeTitleSymbols()
        cell.cellDate.text = indexAnswer.caseLastEdit.timeAgoDisplay()
        cell.cellNumAnswers.text = "±\(indexAnswer.caseNum.description)"
        cell.cellText.text = indexAnswer.caseTitle.decodeTitleSymbols()
        
        return cell
    }
    
    // MARK: - Refresh answers
    
    func loadRefreshControll(){
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing data...")
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshAnswersData(_:)), for: .valueChanged)
    }
    
    @objc private func refreshAnswersData(_ sender: Any) {
        callAPIforAnswers(questionID: questionID)
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
//    func colorForIndex(index: Int) -> UIColor {
//        let itemCount = answers.count - 1
//        let color = (CGFloat(index) / CGFloat(itemCount)) * 0.6
//        return UIColor(red: 1.0, green: color, blue: 0.0, alpha: 1.0)
//    }
//    
//    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell,
//                            forRowAtIndexPath indexPath: NSIndexPath) {
//        cell.backgroundColor = colorForIndex(index: indexPath.row)
//    }
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

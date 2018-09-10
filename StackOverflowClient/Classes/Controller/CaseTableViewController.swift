//
//  TableViewController.swift
//  StackOverflowClient
//
//  Created by aivanovskij on 03.09.2018.
//  Copyright © 2018 aivanovskij. All rights reserved.
//

import UIKit
import Alamofire

class CaseTableViewController: UIViewController {
    
    let requestManager = RequestManager()
    let dateFormatter = DateFormatter()
    
    var questions = [Question]()
    var page = 1
    var activityIndicator: LoadMoreActivityIndicator!
    var currentTag: String = Tags.swift
    var hasMore: Bool = false

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        callAPIforQuestions(callTag: currentTag, callPage: page)
        
        tableView.tableFooterView = UIView()
        activityIndicator = LoadMoreActivityIndicator(tableView: tableView, spacingFromLastCell: 10, spacingFromLastCellWhenLoadMoreActionStart: 60)
        print(tableView.frame)
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        questions.removeAll()
    }
    
    func callAPIforQuestions(callTag: String, callPage: Int) {
        self.title = callTag
        Alamofire.request("\(requestManager.requestBuilder(tag: callTag, page: callPage))", method: .get).responseResponseStruct { response in
            print("Result: \(response.result)")
            if response.result.error != nil {
                print("Error: \(String(describing: response.result.error))")
            }
            if let questionResponse = response.result.value {
                self.hasMore = questionResponse.hasMore
                guard let items = questionResponse.items else { return }
                for item in items {
                    if item.lastEditDate == nil {
                        let nullDate = item.lastActivityDate
                        let question = Question(questionAuthor: item.owner.displayName as String, questionLastEdit: nullDate , questionTitle: item.title as String, questionNumAnswers: item.answerCount as Int, questionId: item.questionID)
                        self.questions.append(question)
                    } else {
                        let question = Question(questionAuthor: item.owner.displayName as String, questionLastEdit: item.lastActivityDate as Date, questionTitle: item.title as String, questionNumAnswers: item.answerCount as Int, questionId: item.questionID)
                        self.questions.append(question)
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func changeTag(newTag: String){
        page = 1
        currentTag = newTag
    }
}

extension CaseTableViewController : UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CaseCell", for: indexPath) as! CaseTableViewCell
        let indexQuestion = questions[indexPath.row]
        
        // Configure the cell...
        cell.caseAuthor.text = indexQuestion.questionAuthor
        cell.caseDate.text = indexQuestion.questionLastEdit.timeAgoDisplay()
        cell.caseNumAnswers.text = "|\(indexQuestion.questionNumAnswers.description)"
        cell.caseQuestion.text = decodeTitleSymbols(incodedTitle: indexQuestion.questionTitle)
        
        return cell
    }
    
    // MARK: - Load More Questions
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if hasMore == true {
            activityIndicator.scrollViewDidScroll(scrollView: scrollView) {
                DispatchQueue.global(qos: .utility).async {
                    self.page = self.page + 1
                    self.callAPIforQuestions(callTag: self.currentTag, callPage: self.page)
                    for i in 0..<3 {
                        print(i)
                        sleep(1)
                    }
                    DispatchQueue.main.async { [weak self] in
                        self?.tableView.reloadData()
                        self?.activityIndicator.loadMoreActionFinshed(scrollView: scrollView)
                    }
                }
            }
        }
    }
    
    func decodeTitleSymbols(incodedTitle: String) -> String{
        var decodedTitle = incodedTitle.replacingOccurrences(of: "&#39;", with: "'", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "&quot;", with: "\"", options: .regularExpression, range: nil)
        return decodedTitle
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}


// MARK: - Time ago date format

extension Date {
    func timeAgoDisplay() -> String {
        
        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        
        if minuteAgo < self {
            let diff = Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
            return "\(diff) sec ago"
        } else if hourAgo < self {
            let diff = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
            return "\(diff) min ago"
        } else if dayAgo < self {
            let diff = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
            return "\(diff) hrs ago"
        } else if weekAgo < self {
            let diff = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
            return "\(diff) days ago"
        }
        let diff = Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear ?? 0
        return "\(diff) weeks ago"
    }
}

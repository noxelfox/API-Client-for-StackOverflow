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

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callAPIforQuestions()
        self.title = "Swift"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func callAPIforQuestions() {
        Alamofire.request("\(RequestPaths.GetQuestions.getSwift)", method: .get).responseWelcome { response in
            print("Result: \(response.result)")
            print("Value: \(response.result.value!)")
            if let questionResponse = response.result.value {
                for item in questionResponse.items {
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
//            print(self.questions)
            self.tableView.reloadData()
        }
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
        
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
        
        // Configure the cell...
        cell.caseAuthor.text = indexQuestion.questionAuthor
        cell.caseDate.text = dateFormatter.string(from: indexQuestion.questionLastEdit)
        cell.caseNumAnswers.text = "|\(indexQuestion.questionNumAnswers.description)"
        cell.caseQuestion.text = decodeTitleSymbols(incodedTitle: indexQuestion.questionTitle)
        
        return cell
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

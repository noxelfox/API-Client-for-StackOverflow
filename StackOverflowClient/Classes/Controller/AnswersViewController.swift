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
    
    var answers = [Case]()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        cell.caseAuthor.text = decodeTitleSymbols(incodedTitle: indexAnswer.caseAuthor)
        cell.caseDate.text = indexAnswer.caseLastEdit.timeAgoDisplay()
        cell.caseNumAnswers.text = "|\(indexAnswer.caseNum.description)"
        cell.caseQuestion.text = decodeTitleSymbols(incodedTitle: indexAnswer.caseTitle)
        
        return cell
    }
    
    
}

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
    
    let questionID: Int = 0
    let loadTableIndicator: UIActivityIndicatorView = UIActivityIndicatorView();
    
    var answers = [Case]()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = questionID.description
        
        showLoadingTableIndicator()
//        callAPIforQuestions(callTag: currentTag, callPage: page)
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
        
    }
    
    func parseAnswersResponse(actualResponse: AnswerResponse?){
        
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
        cell.caseAuthor.text = indexAnswer.caseAuthor.decodeTitleSymbols()
        cell.caseDate.text = indexAnswer.caseLastEdit.timeAgoDisplay()
        cell.caseNumAnswers.text = "|\(indexAnswer.caseNum.description)"
        cell.caseText.text = indexAnswer.caseTitle.decodeTitleSymbols()
        
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

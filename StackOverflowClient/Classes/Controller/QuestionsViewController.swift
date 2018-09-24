//
//  TableViewController.swift
//  StackOverflowClient
//
//  Created by aivanovskij on 03.09.2018.
//  Copyright © 2018 aivanovskij. All rights reserved.
//

import UIKit
import Alamofire
import Cache

class QuestionsViewController: UIViewController {
    
    let requestManager = RequestManager()
    let dateFormatter = DateFormatter()
    let loadTableIndicator: UIActivityIndicatorView = UIActivityIndicatorView();
    private let refreshControl = UIRefreshControl()
        
    var questions = [Case]()
    var page = 1
    var questionID = 0
    var questionDate: Date = Date.distantPast
    var loadMoreIndicator: LoadMoreActivityIndicator!
    var currentTag: Tags = .swift
    var hasMore: Bool = false

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerTop: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.isHidden = true
        
        showLoadingTableIndicator()
        callAPIforQuestions(callTag: currentTag, callPage: page)
        tableView.reloadData()
        loadRefreshControll()
        addLoadMore()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        questions.removeAll()
        try? requestManager.storage?.removeAll()
        tableView.reloadData()
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        if pickerView.isHidden == true {
            showPickerView()
        } else {
            hidePickerView()
        }
    }
    
    func callAPIforQuestions(callTag: Tags, callPage: Int) {
        self.title = callTag.rawValue
        
        // MARK: - Force removing cache if Expired
        
        try? requestManager.storage?.removeExpiredObjects()
        
        let hasCachedResponse = try? self.requestManager.storage?.existsObject(forKey: "cache \(callTag) \(callPage)")
        print("\nHAS CACHE FOR RESPONSE: \(String(describing: hasCachedResponse.unsafelyUnwrapped!).uppercased())\n")
        
        // MARK: - Checking for cached response. If FALSE - do API request
        
        if hasCachedResponse == true {
            questions.removeAll()
            parseQuestionResponse(actualResponse: try! self.requestManager.storage?.object(forKey: "cache \(callTag) \(callPage)"))
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else {
            
            // MARK: - API request
            
            Alamofire.request("\(requestManager.questionRequestBuilder(tag: callTag, page: callPage))", method: .get).responseQuestionResponse { response in
                
                let actualResponse = response.result.value
                
                // MARK: - Print response
                
                print("\nCALL: \(self.requestManager.questionRequestBuilder(tag: callTag, page: callPage))")
                if response.result.error != nil {
                    print("ERROR: \(String(describing: response.result.error))")
                } else {
                    print("RESULT: \(response.result)")
                }
                
                // MARK: - Caching...
                
                do {
                    try self.requestManager.storage?.setObject(response.result.value!, forKey: "cache \(callTag) \(callPage)", expiry: .date(Date().addingTimeInterval(1 * 300)))
                } catch { print(error) }
                
                // MARK: - Parsing response <QuestionResponse> into Case object
                
                self.parseQuestionResponse(actualResponse: actualResponse)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Parsing response
    
    func parseQuestionResponse(actualResponse: QuestionResponse?){
        if let questionResponse = actualResponse {
            self.hasMore = questionResponse.hasMore
            guard let items = questionResponse.items else { return }
            for item in items {
                if item.lastEditDate == nil {
                    let nullDate = item.lastActivityDate
                    let question = Case(caseAuthor: item.owner.displayName as String, caseLastEdit: nullDate , caseTitle: item.title as String, caseNum: item.answerCount as Int, caseId: item.questionID, isAccepted: nil, isZero: nil)
                    self.questions.append(question)
                } else {
                    let question = Case(caseAuthor: item.owner.displayName as String, caseLastEdit: item.lastActivityDate as Date, caseTitle: item.title as String, caseNum: item.answerCount as Int, caseId: item.questionID, isAccepted: nil, isZero: nil)
                    self.questions.append(question)
                }
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.hideLoadingTableIndicator()
        }
    }
    
    func addLoadMore(){
        tableView.tableFooterView = UIView()
        loadMoreIndicator = LoadMoreActivityIndicator(tableView: tableView, spacingFromLastCell: 10, spacingFromLastCellWhenLoadMoreActionStart: 60)
    }
    
    func changeTag(newTag: Tags){
        questions.removeAll()
        tableView.reloadData()
        page = 1
        currentTag = newTag
        showLoadingTableIndicator()
        callAPIforQuestions(callTag: currentTag, callPage: page)
    }
    
    // MARK: - Refresh questions
    
    func loadRefreshControll(){
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing data...")
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshQuestionsData(_:)), for: .valueChanged)
    }
    
    @objc private func refreshQuestionsData(_ sender: Any) {
        page = 1
        callAPIforQuestions(callTag: currentTag, callPage: page)
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    // MARK: - Shake gesture
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            print("shaked")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "passID" {
            if let destinationVC = segue.destination as? AnswersViewController {
                destinationVC.questionID = questionID
                destinationVC.questionDate = questionDate
            }
        }
    }
}

// MARK: - Table view data source

extension QuestionsViewController : UITableViewDelegate, UITableViewDataSource {
    
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
        cell.cellAuthor.text = indexQuestion.caseAuthor.decodeTitleSymbols()
        cell.cellDate.text = indexQuestion.caseLastEdit.timeAgoDisplay()
        cell.cellNumAnswers.text = "|\(indexQuestion.caseNum.description)"
        cell.cellText.text = indexQuestion.caseTitle.decodeTitleSymbols()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        questionID = questions[indexPath.row].caseId
        questionDate = questions[indexPath.row].caseLastEdit
        self.performSegue(withIdentifier: "passID", sender: questionID)
    }
    
    
    // MARK: - Load More Questions
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if hasMore == true {
            loadMoreIndicator.scrollViewDidScroll(scrollView: scrollView) {
                DispatchQueue.global(qos: .utility).async {
                    self.page = self.page + 1
                    let hasCachedResponse = try? self.requestManager.storage?.existsObject(forKey: "cache \(self.currentTag) \(self.page)")
                    
                    if hasCachedResponse == true {
                        self.parseQuestionResponse(actualResponse: try! self.requestManager.storage?.object(forKey: "cache \(self.currentTag) \(self.page)"))
                        for i in 0..<3 {
                            print(i)
                            sleep(1)
                        }
                        DispatchQueue.main.async { [weak self] in
                            self?.tableView.reloadData()
                            self?.loadMoreIndicator.loadMoreActionFinshed(scrollView: scrollView)
                        }
                    } else {
                        self.callAPIforQuestions(callTag: self.currentTag, callPage: self.page)
                        for i in 0..<3 {
                            print(i)
                            sleep(1)
                        }
                        DispatchQueue.main.async { [weak self] in
                            self?.tableView.reloadData()
                            self?.loadMoreIndicator.loadMoreActionFinshed(scrollView: scrollView)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - PickerView Extension

extension QuestionsViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Tags.tagArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Tags.tagArray[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        changeTag(newTag: Tags.tagArray[row])
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = Tags.tagArray[row]
        let myTitle = NSAttributedString(string: titleData.rawValue, attributes: [NSAttributedStringKey.font:UIFont(name: "Helvetica", size: 20.0)!,NSAttributedStringKey.foregroundColor:UIColor.white])
        return myTitle
    }
    
    func showPickerView() {
        pickerView.isHidden = false
        pickerTop.constant = -pickerView.bounds.height
        UIView.animate(withDuration: 0.3, animations: {
            self.tableView.contentInset.bottom = self.tableView.contentInset.bottom + 140
            self.view.layoutIfNeeded()
        })
    }
    
    func hidePickerView() {
        pickerTop.constant = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.tableView.contentInset.bottom = self.tableView.contentInset.bottom - 140
            self.view.layoutIfNeeded()
            }) { (true) in
                self.pickerView.isHidden = true
        }
    }
}

 // MARK: - Loading Indecator

extension QuestionsViewController {
    
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
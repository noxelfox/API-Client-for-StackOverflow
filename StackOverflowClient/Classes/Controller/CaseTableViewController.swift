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

class CaseTableViewController: UIViewController {
    
    let requestManager = RequestManager()
    let dateFormatter = DateFormatter()
    let loadTableIndicator: UIActivityIndicatorView = UIActivityIndicatorView();
    private let refreshControl = UIRefreshControl()
        
    var questions = [Question]()
    var page = 1
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
            parseResponse(actualResponse: try! self.requestManager.storage?.object(forKey: "cache \(callTag) \(callPage)"))
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else {
            
            // MARK: - API request
            
            Alamofire.request("\(requestManager.requestBuilder(tag: callTag, page: callPage))", method: .get).responseResponseStruct { response in
                
                let actualResponse = response.result.value
                
                // MARK: - Print response
                
                print("\nCALL: \(self.requestManager.requestBuilder(tag: callTag, page: callPage))")
                if response.result.error != nil {
                    print("ERROR: \(String(describing: response.result.error))")
                } else {
                    print("RESULT: \(response.result)")
                }
                
                // MARK: - Caching...
                
                do {
                    try self.requestManager.storage?.setObject(response.result.value!, forKey: "cache \(callTag) \(callPage)", expiry: .date(Date().addingTimeInterval(1 * 300)))
                } catch { print(error) }
                
                // MARK: - Parsing response <ResponseStruct> into Question object
                
                self.parseResponse(actualResponse: actualResponse)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func parseResponse(actualResponse: ResponseStruct?){
        if let questionResponse = actualResponse {
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
    
    // MARK: - Loading next page...
    
    func loadRefreshControll(){
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing questions...")
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
}

// MARK: - Table view data source

extension CaseTableViewController : UITableViewDelegate, UITableViewDataSource {
    
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
        cell.caseAuthor.text = decodeTitleSymbols(incodedTitle: indexQuestion.questionAuthor)
        cell.caseDate.text = indexQuestion.questionLastEdit.timeAgoDisplay()
        cell.caseNumAnswers.text = "|\(indexQuestion.questionNumAnswers.description)"
        cell.caseQuestion.text = decodeTitleSymbols(incodedTitle: indexQuestion.questionTitle)
        
        return cell
    }
    
    
    // MARK: - Load More Questions
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if hasMore == true {
            loadMoreIndicator.scrollViewDidScroll(scrollView: scrollView) {
                DispatchQueue.global(qos: .utility).async {
                    self.page = self.page + 1
                    let hasCachedResponse = try? self.requestManager.storage?.existsObject(forKey: "cache \(self.currentTag) \(self.page)")
                    
                    if hasCachedResponse == true {
                        self.parseResponse(actualResponse: try! self.requestManager.storage?.object(forKey: "cache \(self.currentTag) \(self.page)"))
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
    
    func decodeTitleSymbols(incodedTitle: String) -> String{
        var decodedTitle = incodedTitle.replacingOccurrences(of: "&#39;", with: "'", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "&quot;", with: "\"", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "&#252;", with: "ü", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "&#246;", with: "ö", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "&gt;", with: ">", options: .regularExpression, range: nil)
        decodedTitle = decodedTitle.replacingOccurrences(of: "&lt;", with: "<", options: .regularExpression, range: nil)
        return decodedTitle
    }
}

// MARK: - PickerView Extension

extension CaseTableViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
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

//
//  TagsViewController.swift
//  StackOverflowClient
//
//  Created by aivanovskij on 26.09.2018.
//  Copyright © 2018 aivanovskij. All rights reserved.
//

import UIKit

class TagsViewController: UIViewController {
    
    weak var delegate: TagsViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layer.shadowOpacity = 0.9
        // Do any additional setup after loading the view.
    }
}

extension TagsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Tags.tagArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TagCell", for: indexPath) as! TagsTableViewCell
        let tag = Tags.tagArray[indexPath.row]
        
        // Configure the cell...
//        cell.heightAnchor.constraint(equalTo: tableView.heightAnchor, multiplier: 0.8)
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .white
        cell.textLabel?.text = tag.rawValue
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectTag(Tags.tagArray[indexPath.row])
    }
}

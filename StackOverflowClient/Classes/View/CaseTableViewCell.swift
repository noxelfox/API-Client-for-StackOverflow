//
//  TableViewCell.swift
//  StackOverflowClient
//
//  Created by aivanovskij on 03.09.2018.
//  Copyright © 2018 aivanovskij. All rights reserved.
//

import UIKit

class CaseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var caseAuthor: UILabel!
    @IBOutlet weak var caseDate: UILabel!
    @IBOutlet weak var caseNumAnswers: UILabel!
    @IBOutlet weak var caseText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

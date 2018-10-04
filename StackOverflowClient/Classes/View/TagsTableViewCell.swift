//
//  TagsTableViewCell.swift
//  StackOverflowClient
//
//  Created by aivanovskij on 02.10.2018.
//  Copyright © 2018 aivanovskij. All rights reserved.
//

import UIKit

class TagsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tagLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

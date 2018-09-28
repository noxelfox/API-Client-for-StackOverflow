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
        
        self.view.layer.shadowOpacity = 1.4
        // Do any additional setup after loading the view.
    }
    
    @IBAction func swiftTapped(_ sender: UIButton) {
        delegate?.didSelectTag(Tags.swift)
    }
    
    @IBAction func objcTapped(_ sender: UIButton) {
        delegate?.didSelectTag(Tags.objectiveC)
    }
    
    @IBAction func iosTapped(_ sender: Any) {
        delegate?.didSelectTag(Tags.iOS)
    }
    
    @IBAction func xcodeTapped(_ sender: Any) {
        delegate?.didSelectTag(Tags.xCode)
    }
    
    @IBAction func cocoatouchTapped(_ sender: Any) {
        delegate?.didSelectTag(Tags.cocoaTouch)
    }
    
    @IBAction func iphoneTapped(_ sender: Any) {
        delegate?.didSelectTag(Tags.iPhone)
    }
}

//
//  TagsViewControllerDelegate.swift
//  StackOverflowClient
//
//  Created by aivanovskij on 27.09.2018.
//  Copyright © 2018 aivanovskij. All rights reserved.
//

import Foundation

// MARK: - Protocol to send selected tag to fetch new data

protocol TagsViewControllerDelegate: class {
    
    func didSelectTag(_ tag: Tags)
}

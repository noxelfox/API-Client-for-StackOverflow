//
//  LoadMoreActivityIndicator.swift
//  StackOverflowClient
//
//  Created by aivanovskij on 10.09.2018.
//  Copyright © 2018 aivanovskij. All rights reserved.
//

import Foundation
import UIKit

class LoadMoreActivityIndicator {
    
    let spacingFromLastCell: CGFloat
    let spacingFromLastCellWhenLoadMoreActionStart: CGFloat
    let activityIndicatorView: UIActivityIndicatorView
    weak var tableView: UITableView!
    
    private var defaultY: CGFloat {
        return tableView.contentSize.height + spacingFromLastCell
    }
    
    init (tableView: UITableView, spacingFromLastCell: CGFloat, spacingFromLastCellWhenLoadMoreActionStart: CGFloat) {
        self.tableView = tableView
        self.spacingFromLastCell = spacingFromLastCell
        self.spacingFromLastCellWhenLoadMoreActionStart = spacingFromLastCellWhenLoadMoreActionStart
        let size:CGFloat = 40
        let frame = CGRect(x: (tableView.frame.width-size)/2, y: tableView.contentSize.height + spacingFromLastCell, width: size, height: size)
        activityIndicatorView = UIActivityIndicatorView(frame: frame)
        activityIndicatorView.color = .black
        activityIndicatorView.isHidden = false
        activityIndicatorView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        tableView.addSubview(activityIndicatorView)
        activityIndicatorView.isHidden = isHidden
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var isHidden: Bool {
        if tableView.contentSize.height < tableView.frame.size.height {
            return true
        } else {
            return false
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView, loadMoreAction: ()->()) {
        let offsetY = scrollView.contentOffset.y
        activityIndicatorView.isHidden = isHidden
        if !isHidden && offsetY >= 0 {
            let contentDelta = scrollView.contentSize.height - scrollView.frame.size.height
            let offsetDelta = offsetY - contentDelta
            
            let newY = defaultY-offsetDelta
            if newY < tableView.frame.height {
                activityIndicatorView.frame.origin.y = newY
            } else {
                if activityIndicatorView.frame.origin.y != defaultY {
                    activityIndicatorView.frame.origin.y = defaultY
                }
            }
            
            if !activityIndicatorView.isAnimating {
                if offsetY > contentDelta && offsetDelta >= spacingFromLastCellWhenLoadMoreActionStart && !activityIndicatorView.isAnimating {
                    activityIndicatorView.startAnimating()
                    loadMoreAction()
                }
            }
            
            if scrollView.isDecelerating {
                if activityIndicatorView.isAnimating && scrollView.contentInset.bottom == 0 {
                    UIView.animate(withDuration: 0.3) { [weak self] in
                        if let bottom = self?.spacingFromLastCellWhenLoadMoreActionStart {
                            scrollView.contentInset = UIEdgeInsetsMake(0, 0, bottom, 0)
                        }
                    }
                }
            }
        }
    }
    
    func loadMoreActionFinshed(scrollView: UIScrollView) {
        
        let contentDelta = scrollView.contentSize.height - scrollView.frame.size.height
        let offsetDelta = scrollView.contentOffset.y - contentDelta
        if offsetDelta >= 0 {
            // Animate hiding when activity indicator displaying
            UIView.animate(withDuration: 0.3) {
                scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            }
        } else {
            // Hiding without animation when activity indicator displaying
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        }
        
        activityIndicatorView.stopAnimating()
        activityIndicatorView.isHidden = false
    }
}

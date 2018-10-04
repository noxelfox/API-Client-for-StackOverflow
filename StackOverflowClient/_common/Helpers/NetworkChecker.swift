//
//  NetworkChecker.swift
//  StackOverflowClient
//
//  Created by aivanovskij on 28.09.2018.
//  Copyright © 2018 aivanovskij. All rights reserved.
//

import Foundation
import Alamofire

class NetworkChecker {
    
    private let manager = NetworkReachabilityManager(host: "www.apple.com")
    
    func isNetworkReachable() -> Bool {
        return manager?.isReachable ?? false
    }
    
    func checkConnection(caller: UIViewController) -> Bool {
        if isNetworkReachable() == false {
            let alert = UIAlertController(title: "Oops...", message: "Looks like you don't have internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            caller.present(alert, animated: true, completion: nil)
            return false
        } else {
            return true
        }
    }
}

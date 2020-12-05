//
//  Util.swift
//  UIUC Student Planner
//
//  Created by Jeffery Wang on 12/5/20.
//

import UIKit

class Util{
    private init(){}
    static public func isValidUrl(_ str: String) -> Bool{
        if let url = NSURL(string: str) {
            return UIApplication.shared.canOpenURL(url as URL)
        }
        return false
    }
}

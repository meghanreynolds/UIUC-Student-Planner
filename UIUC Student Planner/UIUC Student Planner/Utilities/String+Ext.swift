//
//  String+Ext.swift
//  UIUC Student Planner
//
//  Created by Jeffery Wang on 10/25/20.
//

import Foundation
import UIKit

extension String{
    func width(withFont font: UIFont) -> CGFloat{
        let attr = [NSAttributedString.Key.font: font]
        return (self as NSString).size(withAttributes: attr).width
    }
}

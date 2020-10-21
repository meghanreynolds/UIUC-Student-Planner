//
//  Date+Ext.swift
//  UIUC Student Planner
//
//  Created by Jeffery Wang on 10/16/20.
//

import Foundation

extension Date{
    func toString(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String{
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        return formatter.string(from: self)
    }
}

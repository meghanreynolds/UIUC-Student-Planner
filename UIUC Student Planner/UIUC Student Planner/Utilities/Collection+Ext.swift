//
//  Collection+Ext.swift
//  UIUC Student Planner
//
//  Created by Jeffery Wang on 11/15/20.
//

import Foundation

extension Collection{
    //safer way to get subscript
    subscript (safe i: Index) -> Element? {
        return indices.contains(i) ? self[i] : nil
    }
    
    //safer way to get subscript when at least 1 element presented
    subscript (get i: Index) -> Element {
        return indices.contains(i) ? self[i] : self[0 as! Self.Index]
    }
}

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
}

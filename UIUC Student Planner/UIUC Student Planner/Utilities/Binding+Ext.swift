//
//  Binding+Ext.swift
//  UIUC Student Planner
//
//  Created by Jeffery Wang on 12/5/20.
//  Adapted from https://stackoverflow.com/questions/57518852/swiftui-picker-onchange-or-equivalent
//

import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        return Binding(
            get: { self.wrappedValue },
            set: { selection in
                self.wrappedValue = selection
                handler(selection)
        })
    }
}

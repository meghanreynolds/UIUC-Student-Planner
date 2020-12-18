//
//  FilterItems.swift
//  UIUC Student Planner
//
//  Created by Jathin Nama on 12/8/20.
//

import SwiftUI
class Order: ObservableObject {
    @Published var minPoints = (5, false)
    @Published var isPinned = false
    @Published var maxPoints = (5, false)
    @Published var isNormal = false
    @Published var isHigh = false
    @Published var isLow = false
    
    init() {
        isPinned = false
    }
    // Conditionals set to return true or false based on selected filters
    public  func isNotFiltered(assignment: Assignment, selectedSorts: String) -> Bool {
        if(selectedSorts == "Min Points") {
            minPoints.1 = true
            if (minPoints.1 && assignment.points >= minPoints.0) { return true }
        }
        if(selectedSorts == "Max Points") {
            maxPoints.1 = true
            if (maxPoints.1 && assignment.points <= maxPoints.0) { return true }
        }
        
        if (selectedSorts == "Pinned") {
            isPinned = true;
            if(assignment.pinned == true) {return true}
        }
        if ( selectedSorts == "None") {
            return true;
        }
        return false;
    }
}

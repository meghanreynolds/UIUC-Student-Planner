//
//  AssignmentAttributes.swift
//  UIUC Student Planner
//
//  Created by Faraz Siddiqi on 10/18/20.
//

import SwiftUI

struct AssignmentAttributes: View {
    var assignment: Assignment
    var body: some View {
        VStack {
        Text("Assignment Name: \(assignment.name ?? "Unknown")")
            .font(.headline)
            .fontWeight(.heavy)
            HStack {
        Text("Due Date: \(assignment.dueDate ?? Date())")
            .fontWeight(.light)
        Text("Points: \(assignment.points)")
            }
        }
    }
}

struct AssignmentAttributes_Previews: PreviewProvider {
    static var previews: some View {
        AssignmentAttributes(assignment: Assignment())
    }
}

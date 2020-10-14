//
//  AssignmentView.swift
//  UIUC Student Planner
//
//  Created by Matthew Geimer on 10/7/20.
//

import SwiftUI

struct AssignmentView: View {
    //Viewcontext for the database
    @Environment(\.managedObjectContext) private var viewContext
    
    //The assignment passed in from the parent view
    @State var assignment: Assignment
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                    Text("\(assignment.name ?? "Test Assignment")")
                            .font(.largeTitle)
                        .fontWeight(.medium)
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(assignment.timestamp ?? Date(), formatter: dayFormatter)")
                        Spacer()
                        Text("\(assignment.points) Points")
                            .foregroundColor(Color.green)
                    }
                    Text("\(assignment.timestamp ?? Date(), formatter: timeFormatter)")
                }
                
                Spacer()
            }
            .padding()
        }
    }
    
    private let dayFormatter: DateFormatter = {
        //Starter code, feel free to remove this based on that the assignment entry data has
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d, y"
        return formatter
    }()
    
    private let timeFormatter: DateFormatter = {
        //Starter code, feel free to remove this based on that the assignment entry data has
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter
    }()
}

struct AssignmentView_Previews: PreviewProvider {
    static var previews: some View {
        AssignmentView(assignment: Assignment(context: PersistenceController.preview.container.viewContext))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            
    }
}

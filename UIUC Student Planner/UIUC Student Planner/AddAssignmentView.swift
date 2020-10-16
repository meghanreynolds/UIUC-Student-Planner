//
//  AddAssignmentView.swift
//  UIUC Student Planner
//
//  Created by Matthew Geimer on 10/7/20.
//

import SwiftUI
import CoreData

struct AddAssignmentView: View {
    //Viewcontext for the database
    @Environment(\.managedObjectContext) private var viewContext
    
    //private var assignments: FetchedResults<Assignment>
    
    //essential values for assignment
    @State var assignmentName: String = ""
    @State var assignmentValue: String = ""
    @State var selectedDate = Date()
    
    var body: some View {
        NavigationView {
            Form {
                //user input for values
                TextField("Assignment Name", text: $assignmentName)
                TextField("Assignment Value", text: $assignmentValue)
                    .keyboardType(.numberPad)
                DatePicker("Select Due Date and Time", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
            }
            //title of the page
            .navigationBarTitle("Add Assignment")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        //passes in current values of the user input
                        addAssignment(name: assignmentName, points: assignmentValue, date: selectedDate)
                    }) {
                        //creates the "plus" button on top right
                        Label("Add Item", systemImage: "plus")
                    }
                }

            }
            
        }
    }
    
    func addAssignment(name: String, points: String, date: Date) {
        //create new Assignment and set its values
        let newAssignment = Assignment(context: viewContext)
        newAssignment.name = name
        newAssignment.points = Int64(points)!
        newAssignment.dueDate = date
        
        saveContext()
    }
    
    func saveContext() {
      do {
        try viewContext.save()
      } catch {
        print("Error saving managed object context: \(error)")
      }
    }

}

struct AddAssignmentView_Previews: PreviewProvider {
    static var previews: some View {
        AddAssignmentView()
    }
}

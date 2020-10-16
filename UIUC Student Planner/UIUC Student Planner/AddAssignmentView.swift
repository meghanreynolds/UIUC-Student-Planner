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

    //essential values for assignment
    @State var assignmentName: String = ""
    @State var pointValue: Int64 = 0
    @State var selectedDate = Date()
    var body: some View {
        NavigationView {
            Form {
                Section{
                    TextField("Assignment Name", text: $assignmentName)
                }
                Section(header: Text("Assignment Details")) {
                    Stepper(value: $pointValue,in: 0...100) {
                        Text("\(pointValue) Point\(pointValue != 1 ? "s" : "")")
                    }
                    DatePicker("Deadline", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                }
                Button(action: {
                    addAssignment(name: assignmentName, points: pointValue, date: selectedDate)
                    //change view back to home view
                }, label: {
                    HStack{
                        Spacer()
                        Text("Save")
                        Spacer()
                    }
                })
            }
            //title of the page
            .navigationBarTitle("Add Assignment")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        //change view back to home view
                    }, label : {
                        Text("Cancel")
                    })
                }
            }
        }
    }
    
    func addAssignment(name: String, points: Int64, date: Date) {
        //create new Assignment and set its values
        let newAssignment = Assignment(context: viewContext)
        newAssignment.name = name
        newAssignment.points = points
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
        Group {
            AddAssignmentView()
            AddAssignmentView()
        }
    }
}

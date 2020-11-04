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
    @Environment(\.presentationMode) var presentationMode
    //essential values for assignment
    //default values are later registered in initializers.
    @State var assignmentName: String
    @State var pointValue: Int64
    @State var selectedDate: Date
    var navigationBarTitle = ""
    
    
    /*
     Default View Initializer
     - if no value is passed (e.g. AddAssignmentView()), the view will initialize with a name of "", point of 0, and date of now, which serves as an assignment adder.
     */
    init(){
        self._assignmentName = State.init(initialValue: "")
        self._pointValue = State.init(initialValue: 0)
        self._selectedDate = State.init(initialValue: Date.init(timeIntervalSinceNow: 0))
        self.navigationBarTitle = "Add Assignment"
    }
    
    /*
    View Initializer with values
     - if value is passed, such as passing values from the assignment that the user just tapped, the view will initialze with those values, which serves as an assignment editor.
     - Noted that we are still using `EditAssignmentView.swift` this is just a backup feature.
     */
    init(assignmentName: String, pointValue: Int64, date: Date){
        self._assignmentName = State.init(initialValue: assignmentName)
        self._pointValue = State.init(initialValue: pointValue)
        self._selectedDate = State.init(initialValue: date)
        self.navigationBarTitle = "Edit Assignment"
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section{
                    TextField("Assignment Name", text: $assignmentName)
                    TagView(addable: true, selectedTags: [])
                    //TagView is under development.
                }
                Section(header: Text("Assignment Details")) {
                    Stepper(value: $pointValue,in: 0...100) {
                        Text("\(pointValue) Point\(pointValue != 1 ? "s" : "")")
                    }
                }
                DeadlinePickerView(selectedDate: self.$selectedDate)
                Button(action: {
                    addAssignment(name: assignmentName, points: pointValue, date: selectedDate)
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    HStack{
                        Spacer()
                        Text("Save")
                        Spacer()
                    }
                })
            }
            //title of the page
            .navigationBarTitle(self.navigationBarTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
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
            AddAssignmentView.init(assignmentName: "Finish Reading Chapter 1", pointValue: 20, date: Date.init(timeIntervalSinceNow: 86400 * 2))
        }
    }
}

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
    @State var formShowing: Bool = false
    @State var holder: String = ""
    @State var isPinned: Bool = false
    @State var selectedTag = Array<String>()
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
                    NavigationLink(destination: TagPicker(selectedTags: self.$selectedTag)){
                        self.getSelectedTagText()
                    }
                }
                Section(header: Text("Assignment Details")) {
                    //Point Value Stepper
                    Stepper(value: $pointValue,in: 0...100) {
                        Text("\(pointValue) Point\(pointValue != 1 ? "s" : "")")
                    }
                    //Allows the user to add a link to their assignment
                    List{
                        //textfield allowing a user to add a link
                        if formShowing {
                            HStack {
                                //closes textfield view if user no longer wants a link
                                Button(action: {formShowing = false
                                    holder = ""
                                }) {
                                    HStack {
                                        Image(systemName: "minus.circle.fill")
                                            .foregroundColor(.red)
                                    }
                                }
                                Text("link")
                                    .foregroundColor(.blue)
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                                Divider()
                                //allows user to input link without dealing with autocorect and autocapitalization
                                TextField("link to assignment", text: $holder)
                                    .disableAutocorrection(true)
                                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                            }
                        }
                        //Causes add link textfield to appear on click
                        Button(action: {formShowing = true
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.green)
                                Text("Add a link")
                            }
                        }
                    }
                    Toggle(isOn: $isPinned) {
                        Text("Pin Assignment")
                    }
                }
                DeadlinePickerView(selectedDate: self.$selectedDate)
                Button(action: {
                    addAssignment(name: assignmentName, points: pointValue, date: selectedDate, convertToLink: holder)
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
    
    func addAssignment(name: String, points: Int64, date: Date, convertToLink: String) {
        //create new Assignment and set its values
        let newAssignment = Assignment(context: viewContext)
        newAssignment.name = name
        newAssignment.points = points
        newAssignment.dueDate = date
        newAssignment.pinned = isPinned
        if (convertToLink != "") {
            let link: URL = URL(string: convertToLink)!
            newAssignment.linkToAssignment = link
        } else {
            newAssignment.linkToAssignment = nil
        }
        saveContext()
    }
    
    func saveContext() {
      do {
        try viewContext.save()
      } catch {
        print("Error saving managed object context: \(error)")
      }
    }
    
    private func getSelectedTagText() -> some View{
        let s = self.selectedTag.joined(separator: ", ")
        if s.count == 0{
            return Text("no tag selected")
                .foregroundColor(.gray)
                .font(Font.system(size: 15))
        }
        return Text(s.dropLast(1)).font(Font.system(size: 15))
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

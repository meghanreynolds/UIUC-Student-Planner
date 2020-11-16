//
//  AddCourse.swift
//  UIUC Student Planner
//
//  Created by Meghan Reynolds on 11/14/20.
//

import SwiftUI

struct AddCourse: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @State var courseName: String = ""
    @State var pointSystem: String = ""
    @State var pickerShowing: Bool = false
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Course Name", text: $courseName)
                }
                Section(header: Text("Grading System")) {
                    //allows user to change the assignment's priority
                    HStack {
                        Text("Grading System  ")
                        Divider()
                        Button(action:{pickerShowing = !pickerShowing}, label: {
                            Text("\(pointSystem)")
                                .foregroundColor(.black)
                        })
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.blue)
                    }
                    //if the user clicks to change the priority they are presented with a wheel picker
                    if (pickerShowing) {
                        Picker("Grading System", selection: $pointSystem) {
                                Text("Points").tag("Points")
                                Text("Percentages").tag("Percentages")
                        }.pickerStyle(WheelPickerStyle())
                    }
                }
                Section {
                    Button(action: {
                        addCourse(name: courseName, pointsOrPercents: pointSystem)
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        HStack{
                            Spacer()
                            Text("Save")
                            Spacer()
                        }
                    })
                }
            }
            .navigationBarTitle("Add a Course")
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
    func addCourse(name: String, pointsOrPercents: String) {
        //create new Course and set its values
        let newCourse = Course(context: viewContext)
        newCourse.name = name
        if(pointsOrPercents == "Points") {
            newCourse.pointValues = true
        } else if (pointsOrPercents == "Percentages"){
            newCourse.pointValues = false
        }
        
        //create new tag base on the course title
        let newTag = Tag(context: self.viewContext)
        newTag.name = name
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

struct AddCourse_Previews: PreviewProvider {
    static var previews: some View {
        AddCourse()
    }
}

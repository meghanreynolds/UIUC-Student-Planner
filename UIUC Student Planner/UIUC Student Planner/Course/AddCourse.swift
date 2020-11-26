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
    @State var selectedColor = Color(red: 1, green: 0, blue: 0)
    @State var colorAsString = "Red"
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    //TextField allows user to set the course's name
                    TextField("Course Name", text: $courseName)
                }
                Section(header: Text("Course Details")) {
                    //allows user to change the assignment's grading system
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
                    //if the user clicks to change the grading system they are presented with a wheel picker
                    if (pickerShowing) {
                        Picker("Grading System", selection: $pointSystem) {
                                Text("Points").tag("Points")
                                Text("Percentages").tag("Percentages")
                        }.pickerStyle(WheelPickerStyle())
                    }
                }
                HStack {
                    //interactive course tag preview
                    Text("Course Tag Preview")
                    Button(action:{}, label: {
                        if(courseName != "") {
                            Text("\(courseName)")
                        } else {
                            Text("Untitled Course")
                        }
                    })
                    .padding(10.0)
                    .foregroundColor(.white)
                    .background(selectedColor)
                    .cornerRadius(25.0)
                }
                
                VStack {
                    //allows the user to set the course tag's color
                    Text("Select Course Color: ")
                    HStack {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 25, height: 25)
                            .onTapGesture {
                                selectedColor = Color.red
                                colorAsString = "Red"
                            }
                        
                        Circle()
                            .fill(Color.orange)
                            .frame(width: 25, height: 25)
                            .onTapGesture {
                                selectedColor = Color.orange
                                colorAsString = "Orange"
                            }
                        
                        Circle()
                            .fill(Color.yellow)
                            .frame(width: 25, height: 25)
                            .onTapGesture {
                                selectedColor = Color.yellow
                                colorAsString = "Yellow"
                            }
                        Circle()
                            .fill(Color.green)
                            .frame(width: 25, height: 25)
                            .onTapGesture {
                                selectedColor = Color.green
                                colorAsString = "Green"
                            }
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 25, height: 25)
                            .onTapGesture {
                                selectedColor = Color.blue
                                colorAsString = "Blue"
                            }
                        
                        Circle()
                            .fill(Color.purple)
                            .frame(width: 25, height: 25)
                            .onTapGesture {
                                selectedColor = Color.purple
                                colorAsString = "Purple"
                            }
                        Circle()
                            .fill(Color.pink)
                            .frame(width: 25, height: 25)
                            .onTapGesture {
                                selectedColor = Color.pink
                                colorAsString = "Pink"
                            }
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 25, height: 25)
                            .onTapGesture {
                                selectedColor = Color.gray
                                colorAsString = "Gray"
                            }
                        
                        Circle()
                            .fill(Color.black)
                            .frame(width: 25, height: 25)
                            .onTapGesture {
                                selectedColor = Color.black
                                colorAsString = "Black"
                            }
                    }.padding(.leading).padding(.trailing)
                }
                
                
                //Save button
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
        newCourse.color = colorAsString
        
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

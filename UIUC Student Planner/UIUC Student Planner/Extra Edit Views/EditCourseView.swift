//
//  EditCourseView.swift
//  UIUC Student Planner
//
//  Created by Meghan Reynolds on 11/14/20.
//

import SwiftUI
import CoreData

struct EditCourseView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @State var item: FetchedResults<Course>.Element
    
    @State var newCourseName: String = ""
    @State var newPointSystem: String = ""
    @State var pickerShowing: Bool = false
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Course Name", text: $newCourseName)
                }
                Section(header: Text("Grading System")) {
                    //allows user to change the assignment's grading system
                    HStack {
                        Text("Grading System  ")
                        Divider()
                        Button(action:{pickerShowing = !pickerShowing}, label: {
                            Text("\(newPointSystem)")
                                .foregroundColor(.black)
                        })
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.blue)
                    }
                    //if the user clicks to change the grading system they are presented with a wheel picker
                    if (pickerShowing) {
                        Picker("Grading System", selection: $newPointSystem) {
                                Text("Points").tag("Points")
                                Text("Percentages").tag("Percentages")
                        }.pickerStyle(WheelPickerStyle())
                    }
                }
                Section {
                    Button(action: {
                        saveContext()
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        HStack{
                            Spacer()
                            Text("Save")
                            Spacer()
                        }
                    })
                }
            } .onAppear {
                newCourseName = item.name ?? "Untitled Course"
                if (item.pointValues) {
                    newPointSystem = "Points"
                } else if (!item.pointValues) {
                    newPointSystem = "Percentages"
                }
            }
            .navigationBarTitle("Edit Course")
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

    func saveContext() {
      do {
        //update tag name that corresponds to the course.
        //update tag name for any assignment that contains the tag.
        let request: NSFetchRequest<Tag> = Tag.fetchRequest()
        request.predicate = NSPredicate(format: "name = %@", item.name! as CVarArg)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        var tags = Array<Tag>()
        try tags = self.viewContext.fetch(request) as [Tag]
        if let t = tags[safe: 0]{
            t.name = newCourseName
        }
        
        //update course
        item.name = newCourseName
        if (newPointSystem == "Points") {
            item.pointValues = true
        } else if (newPointSystem == "Percentages") {
            item.pointValues = false
        }

        try viewContext.save()
      } catch {
        print("Error saving managed object context: \(error)")
      }
    }}

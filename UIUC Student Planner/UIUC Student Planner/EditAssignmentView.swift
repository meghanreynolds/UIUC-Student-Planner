//
//  EditAssignmentView.swift
//  UIUC Student Planner
//
//  Created by Matthew Geimer on 10/7/20.
//

import SwiftUI

struct EditAssignmentView: View {
    //Viewcontext for the database
    @Environment(\.managedObjectContext) private var viewContext
    
    //The item passed in from the parent view
    @State var item: FetchedResults<Assignment>.Element
    
    @State var newName: String = ""
    @State var newPoints: Int64 = 0
    @State var newDate = Date.init(timeIntervalSinceNow: 0)
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Assignment Name")){
                    TextField(item.name ?? "Assignment Name", text: $newName)
                        //updates item.name if the user changes the assignment's name
                        .onChange(of: newName) { value in
                          item.name = newName
                        }
                }
                Section(header: Text("Assignment Details")) {
                    Stepper(value: $newPoints,in: 0...100){
                       Text(getPoints())
                    }
                }
                Button(action: {
                    saveContext()
                    //change view back to home view
                }, label : {
                    HStack {
                        Spacer()
                        Text("Save")
                        Spacer()
                    }
                })
            }
            .navigationBarTitle("Edit Assignment")
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
    func saveContext() {
      do {
        try viewContext.save()
      } catch {
        print("Error saving managed object context: \(error)")
      }
    }
    
    func getPoints() -> String {
        //updates the assignment's points and displays the points to the user
        item.points = newPoints
        return "\(item.points) Point\(item.points != 1 ? "s" : "")"
    }
}

struct EditAssignmentView_Previews: PreviewProvider {
    static var previews: some View {
        EditAssignmentView(item: Assignment(context: PersistenceController.preview.container.viewContext))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}


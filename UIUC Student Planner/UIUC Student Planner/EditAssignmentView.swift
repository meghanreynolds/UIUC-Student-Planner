//
//  EditAssignmentView.swift
//  UIUC Student Planner
//
//  Created by Matthew Geimer on 10/7/20.
//

import SwiftUI
import UIKit

struct EditAssignmentView: View {
    //Viewcontext for the database
    @Environment(\.managedObjectContext) private var viewContext
    
    //The item passed in from the parent view
    @State var item: FetchedResults<Assignment>.Element
    @State var newName: String = ""
    @State var newPoints: Int64 = 0
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Assignment Details")) {
                    Stepper(value: $newPoints,in: 0...100){
                       Text(getPoints())
                    }
                }
                Button(action: {
                    //update assignment
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


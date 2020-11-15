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
    @State var isPresented = false
    //The assignment passed in from the parent view
    @State var assignment: Assignment
    @State var isPinned: Bool = false
    
    var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("\(assignment.name ?? "Test Assignment")")
                            .font(.largeTitle)
                        .fontWeight(.medium)
                    Spacer()
                    if(isPinned) {
                        Button(action: {isPinned = false
                            saveContext()
                        }, label: {
                            Image(systemName: "pin.fill")
                                .foregroundColor(.black)
                        })
                    } else {
                        Button(action: {isPinned = true
                            saveContext()
                        }, label: {
                            Image(systemName: "pin")
                                .foregroundColor(.black)
                        })
                    }
                }
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(assignment.dueDate ?? Date(), formatter: dayFormatter)")
                        Spacer()
                        Text("\(assignment.points) Points")
                    }
                Text("\(assignment.dueDate ?? Date(), formatter: timeFormatter)")
                HStack {
                    if (assignment.completed == true) {
                        Button(action: {}) {
                            HStack {
                                Text("Completed")
                            }
                        }
                        .padding(10.0)
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(25.0)
                    }
                    if (assignment.priority == 0) {
                        Button(action: {}) {
                            HStack {
                                Text("Priority: Low")
                            }
                        }
                        .padding(10.0)
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(25.0)
                    } else if (assignment.priority == 1) {
                        Button(action: {}) {
                            HStack {
                                Text("Priority: Normal")
                            }
                        }
                        .padding(10.0)
                        .foregroundColor(.white)
                        .background(Color.yellow)
                        .cornerRadius(25.0)
                    } else {
                        Button(action: {}) {
                            HStack {
                                Text("Priority: High")
                            }
                        }
                        .padding(10.0)
                        .foregroundColor(.white)
                        .background(Color.red)
                        .cornerRadius(25.0)
                    }
                }
                }.toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Edit", action: {
                            self.isPresented.toggle();
                        })
                    }
                }
                .sheet(isPresented: $isPresented, /*onDismiss:(updatedAssignment: Assignment) -> {assignment = updatedAssignment},*/ content: {
                    EditAssignmentView(item: assignment)
                    
                })
                
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(){
                isPinned = assignment.pinned
               // assignment.name = assignment.name
            }
        }
    
       
    
    private let dayFormatter: DateFormatter = {
        //Starter code, feel free to remove this based on that the assignment entry data has
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d"
        return formatter
    }()
    
    private let timeFormatter: DateFormatter = {
        //Starter code, feel free to remove this based on that the assignment entry data has
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter
    }()
    
    func saveContext() {
      do {
        assignment.pinned = isPinned
        try viewContext.save()
      } catch {
        print("Error saving managed object context: \(error)")
      }
    }
}

struct AssignmentView_Previews: PreviewProvider {
    static var previews: some View {
        AssignmentView(assignment: Assignment(context: PersistenceController.preview.container.viewContext))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            
    }
}

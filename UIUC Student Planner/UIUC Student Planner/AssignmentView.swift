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
    
    //Courses are fetched
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Course.name, ascending: true)])
    private var courses: FetchedResults<Course>
    //assignment values
    @State var selectedDate = Date()
    @State var assignmentName: String = ""
    @State var isPinned: Bool = false
    @State var assignmentPriority: Int64 = 1
    //Text Editor height
    @State var editorHeight: Int64 = 50
    //point values
    @State var pointPickerShowing: Bool = false
    @State var newPoints: Int64 = 0
    //link values
    @State var assignmentLink: URL = URL(string: "https://google.com")!
    @State var formShowing: Bool = false
    @State var holder: String = "https://google.com"
    @State var defaultLink: URL = URL(string: "https://gooogle.com")!
    //course values
    @State var courseName: String = ""
    @State var showCourse: Bool = false
    @State var points: Bool = false
    @State var colorIndex = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                //TextEditor allows user to change assignment name if they want by clicking on the text
                TextEditor(text: $assignmentName)
                    .frame(width: 275, height: CGFloat(editorHeight))
                    .font(.largeTitle)
                //displays filled in pin for pinned assignments and unfilled pin for unpinned assignments, user can pin/unpin this by clicking the icon
                if(isPinned) {
                    Button(action: {isPinned = false
                        savePinContext()
                    }, label: {
                        Image(systemName: "pin.fill")
                            .foregroundColor(.black)
                    })
                } else {
                    Button(action: {isPinned = true
                        savePinContext()
                    }, label: {
                        Image(systemName: "pin")
                            .foregroundColor(.black)
                    })
                }
            }
            VStack(alignment: .leading) {
                //displays stepper for user to change points/percentage the assignment is worth depending on the selected course's grading system
                HStack {
                    if(points) {
                        Stepper(value: $newPoints ,in: 0...100){
                            Text(getPoints())
                                .font(.headline)
                                .bold()
                        }
                    } else {
                        Stepper(value: $newPoints ,in: 0...100){
                            Text(getPercents())
                                .font(.headline)
                                .bold()
                        }
                    }
                }.padding(.bottom)
                //allows user to change deadline using deadline picker view
                Text("Deadline: ")
                    .font(.subheadline)
                    .bold()
                DeadlinePickerView(selectedDate: $selectedDate)
                //allows user to click on the link to their assignment (if they don't have one google is the default) and also edit and save an updated link
                HStack {
                    Text("Link to Assignment: ")
                        .font(.subheadline)
                        .bold()
                    if(formShowing) {
                        TextEditor(text: $holder)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .frame(width: 150, height: 25)
                            .font(.subheadline)
                        Spacer()
                        Button(action: {
                            if (holder != "") {
                                let link: URL = URL(string: holder)!
                                assignmentLink = link
                            } else {
                                assignmentLink = URL(string: "https://google.com")!
                            }
                            saveLinkContext()
                            formShowing = false
                        }, label: {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        })
                    } else {
                        Link("\(assignmentLink)", destination: assignmentLink)
                        Spacer()
                        Button(action: {formShowing = true}, label: {
                            Image(systemName: "pencil.circle.fill")
                                .foregroundColor(.blue)
                        })
                    }
                }.padding(.bottom)
                .padding(.top)
                HStack {
                    //allows user to click the priority tag to change its priority
                    if (assignmentPriority == 0) {
                        Button(action: {
                            assignmentPriority = 1
                            savePriorityContext()
                        }) {
                            HStack {
                                Text("Priority: Low")
                            }
                        }
                        .padding(10.0)
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(25.0)
                    } else if (assignmentPriority == 1) {
                        Button(action: {
                            assignmentPriority = 2
                            savePriorityContext()
                        }) {
                            HStack {
                                Text("Priority: Normal")
                            }
                        }
                        .padding(10.0)
                        .foregroundColor(.white)
                        .background(Color.yellow)
                        .cornerRadius(25.0)
                    } else {
                        Button(action: {
                            assignmentPriority = 0
                            savePriorityContext()
                        }) {
                            HStack {
                                Text("Priority: High")
                            }
                        }
                        .padding(10.0)
                        .foregroundColor(.white)
                        .background(Color.red)
                        .cornerRadius(25.0)
                    }
                    //if the assignment has a course, it displays the user's custom course tag
                    if(showCourse) {
                        Button(action: {}) {
                            HStack {
                                Text("\(courseName)")
                            }
                        }
                        .padding(10.0)
                        .foregroundColor(.white)
                        .background(Color.Material.palette[get: self.colorIndex])
                        .cornerRadius(25.0)
                    }
                }
                Spacer()
                //allows the user to save changes made to the assignment
                HStack{
                    Spacer()
                    Button(action: {saveContext()}, label: {Text("Save Changes")})
                        .padding()
                        .border(Color.blue)
                    Spacer()
                }
                
            }.toolbar {
            }
            Spacer()
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .onAppear() {
            //sets initial values
            isPinned = assignment.pinned
            assignmentName = assignment.name ?? "Unititled Assignment"
            //sets how large the text editor needs to be to fit the assignment name
            editorHeight = Int64(assignmentName.count / 11 * 50) + 50
            
            selectedDate = assignment.dueDate ?? Date(timeIntervalSinceNow: 0)
            assignmentPriority = assignment.priority
            newPoints = assignment.points
            
            assignmentLink = assignment.linkToAssignment ?? URL(string: "https://google.com")!
            holder = assignmentLink.absoluteString
            
            //sets course values if the assignment has a course
            if(assignment.course != nil) {
                showCourse = true
                courseName = assignment.course!.name!
                points = assignment.course!.pointValues
                colorIndex = Int(assignment.course!.colorIndex)
                //sets link to default link if the user did not put in a different link
                if (assignment.linkToAssignment == nil) {
                    assignmentLink = assignment.course!.courseLink ?? URL(string: "https://google.com")!
                    holder = assignmentLink.absoluteString
                }
                //sets default link value to the course's default link
                defaultLink = assignment.course!.courseLink ?? URL(string: "https://google.com")!
            }
        }
    }
    //saves changes to assignment name, points, and due dates
    func saveContext() {
        do {
            assignment.name = assignmentName
            assignment.points = newPoints
            assignment.dueDate = selectedDate
            try viewContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    //saves changes to whether or not the assignment is pinned
    func savePinContext() {
        do {
            assignment.pinned = isPinned
            try viewContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    //saves changes made to the assignment's priority
    func savePriorityContext() {
        do {
            assignment.priority = assignmentPriority
            try viewContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    //saves changes made to the link
    func saveLinkContext() {
        do {
            if(holder == "") {
                assignmentLink = defaultLink
                holder = assignmentLink.absoluteString
                assignment.linkToAssignment = assignmentLink
            }
            //assignment.linkToAssignment = assignmentLink
            if(holder.contains("http://") || holder.contains("https://")) {
                let link: URL = URL(string: holder)!
                assignment.linkToAssignment = link
            } else {
                let finLink = "http://" + holder
                let link: URL = URL(string: finLink)!
                assignment.linkToAssignment = link
                assignmentLink = link
                holder = finLink
            }
            try viewContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    
    func getPoints() -> String {
        //updates the assignment's points and displays the points to the user
        return "\(newPoints) Point\(newPoints != 1 ? "s" : "")"
        
    }
    
    func getPercents() -> String {
        //updates the assignment's percent worth and displays the percentage to the user
        return "\(newPoints) Percent"
        
    }
    
}

struct AssignmentView_Previews: PreviewProvider {
    static var previews: some View {
        AssignmentView(assignment: Assignment(context: PersistenceController.preview.container.viewContext))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        
    }
}

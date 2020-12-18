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
    //The fetch request getting all the courses and sorting them by their names
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Course.name, ascending: true)])
    private var courses: FetchedResults<Course>
    
    //essential values for assignment
    //default values are later registered in initializers.
    @State var assignmentName: String
    @State var pointValue: Int
    @State var selectedDate: Date
    @State var formShowing: Bool = false
    @State var holder: String = ""
    @State var isPinned: Bool = false
    @State var courseIndex: Int = -1
    @State var pickerShowing: Bool = false
    @State var pickerPointShowing: Bool = false
    @State var setPriority = Priority.normal
    @State var selectedTag = Array<Tag>()
    @State var pointsOrPercents: Bool = true
    @State var numTimes: Int64 = 0
    @State var appeared: Bool = false
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
        self._pointValue = State.init(initialValue: Int(pointValue))
        self._selectedDate = State.init(initialValue: date)
        self.navigationBarTitle = "Edit Assignment"
    }
    //enumeration of possible priorities
    enum Priority: String, CaseIterable, Identifiable {
        case Low
        case normal
        case High
        
        var id: String { self.rawValue }
    }
    var body: some View {
        NavigationView {
            Form {
                Section{
                    //lets user set the assignment's name
                    TextField("Assignment Name", text: $assignmentName)
                    //lets user pick tags for the assignment
                    NavigationLink(destination: TagPicker(selectedTags: self.$selectedTag)){
                        self.getSelectedTagText()
                    }
                    //lets user pick a course without displaying empty courses
                    VStack{
                        Picker(selection: self.$courseIndex, label: Text("Course")){
                            ForEach(self.courses.indices, id: \.self) { i in
                                Text(self.courses[i].name!)
                            }
                        }
                    }
                }
                Section(header: Text("Assignment Details")) {
                    //lets user pick how much an assignment is worth
                    HStack {
                        Text("Percent")
                        Divider()
                        Button(action:{pickerPointShowing = !pickerPointShowing}, label: {
                            Text("\(pointValue)")
                                .foregroundColor(.black)
                        })
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.blue)
                        
                        if (pickerPointShowing){
                            Picker("Point Picker", selection: $pointValue){
                                ForEach(0 ..< 101) {
                                    Text("\($0)")
                                }
                            }.pickerStyle(WheelPickerStyle())
                        }
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
                    //allows user to set the assignment's priority
                    HStack {
                        Text("Priority  ")
                        Divider()
                        Button(action:{pickerShowing = !pickerShowing}, label: {
                            Text("\(setPriority.rawValue.capitalized)")
                                .foregroundColor(.black)
                        })
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.blue)
                    }
                    //if the user clicks to change the priority they are presented with a wheel picker
                    if (pickerShowing) {
                        Picker("Priority", selection: $setPriority) {
                            Text("Low").tag(Priority.Low)
                            Text("Normal").tag(Priority.normal)
                            Text("High").tag(Priority.High)
                        }.pickerStyle(WheelPickerStyle())
                    }
                    Toggle(isOn: $isPinned) {
                        Text("Pin Assignment")
                    }
                }
                //lets user select a deadline
                DeadlinePickerView(selectedDate: self.$selectedDate)
                
                //save button lets user add the assignment
                Button(action: {
                    addAssignment(name: assignmentName, points: Int64(pointValue), date: selectedDate, convertToLink: holder)
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
            //sets course context and default values on first appearance
            .onAppear() {
                if(numTimes == 0) {
                    appeared = true
                }
                numTimes += 1;
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
            if(convertToLink.contains("http://") || convertToLink.contains("https://")) {
                let link: URL = URL(string: convertToLink)!
                newAssignment.linkToAssignment = link
            } else {
                let finLink = "http://" + convertToLink
                let link: URL = URL(string: finLink)!
                newAssignment.linkToAssignment = link
            }
            
        } else {
            newAssignment.linkToAssignment = nil
        }
        if (setPriority.rawValue == Priority.normal.rawValue) {
            newAssignment.priority = 1;
        } else if (setPriority.rawValue == Priority.High.rawValue) {
            newAssignment.priority = 2;
        } else {
            newAssignment.priority = 0;
        }
        newAssignment.tags = Set(self.selectedTag) as NSSet
        //attatches selected course to the assignment if setCourse is not an empty course and sets hasCourse to true
        if(self.courseIndex != -1){
            newAssignment.course = self.courses[self.courseIndex]
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
        if self.selectedTag.count == 0{
            return Text("no tag selected")
                .foregroundColor(.gray)
                .font(Font.system(size: 15))
        }
        var s = ""
        for i in stride(from: 0, to: self.selectedTag.count - 1, by: 1){
            s += self.selectedTag[i].name! + ", "
        }
        s += self.selectedTag.last!.name!
        return Text(s).font(Font.system(size: 15))
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

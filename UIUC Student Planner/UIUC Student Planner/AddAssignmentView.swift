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

    //essential values for assignment
    @State var assignmentName: String = ""
    @State var pointValue: Int64 = 0
    @State var selectedDate = Date()
    
    @State var showSelectDateDetail = false
    @State var showSelectTimeDetail = false
    
    
    var body: some View {
        NavigationView {
            Form {
                Section{
                    TextField("Assignment Name", text: $assignmentName)
                }
                Section(header: Text("Assignment Details")) {
                    Stepper(value: $pointValue,in: 0...100) {
                        Text("\(pointValue) Point\(pointValue != 1 ? "s" : "")")
                    }
                }
                self.deadline
                Button(action: {
                    addAssignment(name: assignmentName, points: pointValue, date: selectedDate)
                    //change view back to home view
                }, label: {
                    HStack{
                        Spacer()
                        Text("Save")
                        Spacer()
                    }
                })
            }
            /*.animation(.linear)
             SwiftUI animation glitch.
             https://stackoverflow.com/questions/62570238/fix-odd-datepicker-animation-behaviour-in-swiftui-form
             */
            
            //title of the page
            .navigationBarTitle("Add Assignment")
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
    
    var deadline: some View{
        Section(header: Text("DEADLINE")){
            HStack{
                Image.init(systemName: "calendar")
                    .font(.system(size: 18))
                    .foregroundColor(.white).padding(5)
                    .background(RoundedRectangle(cornerRadius: 7)
                        .aspectRatio(1, contentMode: .fill)
                        .foregroundColor(.red))
                Text("Date")
                    .padding(.leading, 5)
                    .font(.system(size: 18))
                Spacer()
                Text("\(self.selectedDate.toString(dateStyle: .medium, timeStyle: .none))")
                    .padding(.vertical, 10)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                self.showSelectDateDetail.toggle()
                self.showSelectTimeDetail = false
            }
            if self.showSelectDateDetail{
                DatePicker.init(selection: self.$selectedDate, displayedComponents: .date){
                    
                }
                .datePickerStyle(GraphicalDatePickerStyle.init())
            }
            
            HStack{
                Image.init(systemName: "clock.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.white).padding(5)
                    .background(RoundedRectangle(cornerRadius: 7)
                        .aspectRatio(1, contentMode: .fill)
                        .foregroundColor(.blue))
                Text("Time")
                    .padding(.leading, 5)
                    .font(.system(size: 18))
                Spacer()
                Text("\(self.selectedDate.toString(dateStyle: .none, timeStyle: .short))")
                .padding(.vertical, 10)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                self.showSelectDateDetail = false
                self.showSelectTimeDetail.toggle()
            }
            if self.showSelectTimeDetail{
                DatePicker.init(selection: self.$selectedDate, displayedComponents: .hourAndMinute){
                    
                }
                .datePickerStyle(GraphicalDatePickerStyle.init())
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
            AddAssignmentView()
        }
    }
}

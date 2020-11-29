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
    
    @State var courseName: String = "Course Name"
    @State var pointSystem: Int = 0
    @State var selectedColorIndex = 0
    
    //columns item for colors
    private var columns: [GridItem] =
            Array(repeating: .init(.flexible()), count: 6)
    
    
    init() {
        //get rid of UITextView background color
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        NavigationView {
            
            ScrollView {
                LazyVStack{
                    //TextField allows user to set the course's name
                    ZStack{
                        RoundedRectangle(cornerRadius: 10.0)
                            .fill(Color.Material.palette[get: self.selectedColorIndex])
                            .padding([.leading, .trailing], 40)
                        TextEditor(text: self.$courseName)
                            .font(Font(UIFont.systemFont(ofSize: 22, weight: .bold)))
                            .lineLimit(1)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color.Material.palette[get: self.selectedColorIndex].isDarkColor ? .white : .black)
                            .padding(.top, 5)
                            .padding(.bottom, 50)
                            .padding([.leading, .trailing], 50)
                            .zIndex(1)
                    }  //ZStack
                    .padding(.top, -30)
                    .padding(.bottom, 10)
                    .padding([.leading, .trailing], 10)
                    .onTapGesture {
                        if !self.courseName.isEmpty{
                            self.courseName = ""
                        }
                    }.animation(.easeInOut(duration: 0.25))
                    
                    //allows the user to set the course tag's color
                    LazyVGrid(columns: self.columns){
                        ForEach(0..<Color.Material.palette.count){ i in
                            ZStack{
                                if(self.selectedColorIndex == i){
                                    Circle()
                                        .fill(Color.Material.lightGrey)
                                        .frame(width: 40, height: 40)
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 35, height: 35)
                                }else{
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 40, height: 40)
                                }
                                    
                                Circle()
                                    .fill(Color.Material.palette[get: i])
                                    .frame(width: 30, height: 30)
                                    .onTapGesture {
                                        selectedColorIndex = i
                                    }
                            } //ZStack
                        } // ForEach
                    } //LazyVGrid
                    .padding([.leading, .trailing], 10)
                    .padding([.top, .bottom], 10)
                    
                    //allows user to change the assignment's grading system
                    HStack {
                        Spacer(minLength: 25)
                        Text("Grading:")
                        Spacer(minLength: 25)
                        Picker(selection: self.$pointSystem, label: Text("")){
                            Text("point").tag(0)
                            Text("percentage").tag(1)
                        }.pickerStyle(SegmentedPickerStyle())
                        Spacer(minLength: 25)
                    }.padding([.top, .bottom], 10)
                }  //LazyVStack
                
                

            }
            .toolbar {
                //Cancel Button
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label : {
                        Text("Cancel")
                    })
                }
                //NavigationTitle
                ToolbarItem(placement: .principal){
                    Text("New Course").bold()
                }
                //Save Button
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        addCourse()
                        self.presentationMode.wrappedValue.dismiss()
                    }, label : {
                        Text("Done")
                    })
                }
            }
        }
    }
    
    func addCourse() {
        //create new Course and set its values
        let newCourse = Course(context: viewContext)
        newCourse.name = self.courseName
        newCourse.pointValues = self.pointSystem == 0 ? true : false
        newCourse.colorIndex = Int16(self.selectedColorIndex)
        
        //create new tag base on the course title
        let newTag = Tag(context: self.viewContext)
        newTag.name = self.courseName
        
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

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
    //link values
    @State var courseLink = ""
    @State var showInvalidLink = false
    
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
                    
                    
                    //allows user to change the assignment's grading syste
                    VStack{
                        HStack{
                            Text("grading:")
                                .font(.system(size: 12))
                                .foregroundColor(Color.Material.grey)
                            Spacer()
                        }
                        Picker(selection: self.$pointSystem, label: Text("")){
                            Text("point").tag(0)
                            Text("percentage").tag(1)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.top, -5.0)
                    }
                    .padding(.top, 10)
                    .padding([.leading, .trailing], 20)
                    
                    
                    //allows user to click on the default link for this course (if they don't have one google is the default) and also edit and save an updated link
                    VStack{
                        HStack{
                            Text("link (optional):")
                                .font(.system(size: 12))
                                .foregroundColor(self.showInvalidLink ? Color.Material.red : Color.Material.grey)
                            Spacer()
                        }
                        TextField("https://example.com", text: self.$courseLink, onCommit: {
                            guard Util.isValidUrl(self.courseLink) else{
                                self.showInvalidLink.toggle()
                                self.courseLink = ""
                                return
                            }
                        })
                        .padding(10)
                        .textContentType(.URL)
                        .keyboardType(.URL)
                        .font(Font.system(size: 15))
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemGroupedBackground)))
                        .foregroundColor(.black)
                        .accentColor(.black)
                        .padding(.top, -5.0)
                    }
                    .padding(.top, 10)
                    .padding([.leading, .trailing], 20)
                    .alert(isPresented: self.$showInvalidLink){
                        Alert.init(title: Text("invalid URL"), message: nil, dismissButton: .default(Text("Ok")))
                    }
                    
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
                        self.addCourse()
                        self.presentationMode.wrappedValue.dismiss()
                    }, label : {
                        Text("Save")
                    })
                }
            }
        }
    }
    
    private func addCourse() {
        //create new Course and set its values
        let newCourse = Course(context: viewContext)
        newCourse.name = self.courseName
        newCourse.pointValues = self.pointSystem == 0 ? true : false
        newCourse.colorIndex = Int16(self.selectedColorIndex)
        newCourse.courseLink = URL.init(string: self.courseLink)
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

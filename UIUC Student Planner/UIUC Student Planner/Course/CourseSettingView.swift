//
//  CourseSettingView.swift
//  UIUC Student Planner
//
//  Created by Jeffery Wang on 12/5/20.
//

import SwiftUI


struct CourseSettingView: View{
    //Viewcontext for the database
    @Environment(\.managedObjectContext) var viewContext
    //The course passed in from the parent view
    @Binding var course: Course
    @Binding var parentColorIndex: Int
    @State var courseName: String = ""
    @State var pointSystem: Int = 0
    //link values
    @State var courseLink: String = ""
    @State var showInvalidLink: Bool = false
    
    //columns item for colors
     var columns: [GridItem] =
            Array(repeating: .init(.flexible()), count: 6)
    
    init(course: Binding<Course>, parentColorIndex: Binding<Int>) {
        //get rid of UITextView background color
        UITextView.appearance().backgroundColor = .clear
        self._course = course
        self._parentColorIndex = parentColorIndex
        assert(Int(self.course.colorIndex) == self.parentColorIndex)
        self._courseName = State.init(initialValue: self.course.name!)
        self._pointSystem = State.init(initialValue: self.course.pointValues ? 0 : 1)
        let url = self.course.courseLink ?? URL.init(string: "https://google.com")!
        self._courseLink = State.init(initialValue: "\(url)")
    }
    
    var body: some View {
        LazyVStack{
            VStack{
                HStack{
                    Text("course name")
                        .font(.system(size: 12))
                        .foregroundColor(self.showInvalidLink ? Color.Material.red : Color.Material.grey)
                    Spacer()
                }
                TextField("https://example.com", text: self.$courseName, onCommit: {
                    self.course.name = self.courseName
                    self.saveContext()
                })
                .padding(10)
                .font(Font.system(size: 15))
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemGroupedBackground)))
                .foregroundColor(.black)
                .accentColor(.black)
                .padding(.top, -5.0)
            }
            .padding(.top, 20)
            .padding([.leading, .trailing], 20)
            
            //allows the user to set the course tag's color
            LazyVGrid(columns: self.columns){
                ForEach(0..<Color.Material.palette.count){ i in
                    ZStack{
                        if(self.parentColorIndex == i){
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
                                self.parentColorIndex = i
                                self.course.colorIndex = Int16(self.parentColorIndex)
                                self.saveContext()
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
                Picker(selection: self.$pointSystem.onChange(self.pointPickerDidChange), label: Text("")){
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
                    self.course.courseLink = URL.init(string: self.courseLink)
                    self.saveContext()
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
    
    private func pointPickerDidChange(_ tag: Int){
        self.pointSystem = tag
        self.course.pointValues = self.pointSystem == 0 ? true : false
        self.saveContext()
    }
    
    func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
}

//
//  CourseDetailView.swift
//  UIUC Student Planner
//
//  Created by Meghan Reynolds on 11/14/20.
//
import SwiftUI
import UIKit

struct CourseDetailView: View {
    //Viewcontext for the database
    @Environment(\.managedObjectContext) var viewContext
    //The course passed in from the parent view
    @State var course: Course
    @State var courseName: String = ""
    @State var pointSystem: Int = 0
    @State var selectedColorIndex = 0
    //link values
    @State var courseLink: URL = URL(string: "https://google.com")!
    @State var formShowing: Bool = false
    @State var holder: String = "https://google.com"
    
    //columns item for colors
     var columns: [GridItem] =
            Array(repeating: .init(.flexible()), count: 6)
    var body: some View {
            VStack {
                Spacer()
                
                Text("Course Tag Preview:")
                    .bold()
                    .font(.headline)
                LazyVStack{
                    //TextField allows user to set the course's name
                    ZStack{
                        RoundedRectangle(cornerRadius: 10.0)
                            .fill(Color.Material.palette[get: self.selectedColorIndex])
                            .padding([.leading, .trailing], 40)
                        TextEditor(text: $courseName)
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
                    
                    //allows user to click on the default link for this course (if they don't have one google is the default) and also edit and save an updated link
                    HStack {
                        Text("Default Link: ")
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
                                    courseLink = link
                                } else {
                                    courseLink = URL(string: "https://google.com")!
                                }
                                saveLinkContext()
                                formShowing = false
                            }, label: {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            })
                        } else {
                            Link("\(courseLink)", destination: courseLink)
                            Spacer()
                            Button(action: {formShowing = true}, label: {
                                Image(systemName: "pencil.circle.fill")
                                    .foregroundColor(.blue)
                            })
                        }
                    }.padding(.bottom)
                    .padding(.top)
                    .padding(.leading)
                    
                }.padding(.bottom)
                    //LazyVStack
                
                //button allows user to save changes to the course
                HStack{
                    Spacer()
                    Button(action: {
                            saveContext()
                            
                    }, label: {Text("Save Changes")})
                        .padding()
                        .border(Color.blue)
                    Spacer()
                }
                Spacer()
            }.onAppear() {
                courseName = course.name ?? ""
                if (course.pointValues) {
                    pointSystem = 0
                } else {
                    pointSystem = 1
                }
                selectedColorIndex = Int(Int16(course.colorIndex))
                UITextView.appearance().backgroundColor = .clear
                
                courseLink = course.courseLink ?? URL(string: "https://google.com")!
                holder = courseLink.absoluteString
            }
        
    }
    func saveContext() {
      do {
        course.name = courseName
        course.pointValues = self.pointSystem == 0 ? true : false
        course.colorIndex = Int16(self.selectedColorIndex)
        try viewContext.save()
      } catch {
        print("Error saving managed object context: \(error)")
      }
    }
    
    //saves changes made to the link
    func saveLinkContext() {
      do {
        if(holder == "") {
            courseLink = URL(string: "https://google.com")!
            holder = "https://google.com"
            course.courseLink = URL(string: "https://google.com")!
        }
        //assignment.linkToAssignment = assignmentLink
        if(holder.contains("http://") || holder.contains("https://")) {
            let link: URL = URL(string: holder)!
            course.courseLink = link
        } else {
            let finLink = "http://" + holder
            let link: URL = URL(string: finLink)!
            course.courseLink = link
            courseLink = link
            holder = finLink
        }
        try viewContext.save()
      } catch {
        print("Error saving managed object context: \(error)")
      }
    }
}

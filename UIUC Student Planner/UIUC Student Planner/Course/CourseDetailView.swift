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
    @Environment(\.managedObjectContext) private var viewContext
    //The course passed in from the parent view
    @State var course: Course
    @State var courseName: String = ""
    @State var pointSystem: String = ""
    @State var pickerShowing: Bool = false
    @State var colorAsString: String = ""
    @State var selectedColor = Color(decimalRed: 1.0, green: 0.0, blue: 0.0)
    
    var body: some View {
            VStack(alignment: .leading) {
                HStack {
                    //Text editor allowing the user to change the coure's name if they click on the text
                    TextEditor(text: $courseName)
                        .frame(width: 275, height: 50)
                        .font(.largeTitle)
                }
                    HStack {
                        //picker allowing the user to change the course's grading system
                        Text("Grading System: ")
                            .bold()
                        Spacer()
                        Button(action: {pickerShowing = !pickerShowing}, label: {
                            Text("\(pointSystem)")
                                .foregroundColor(.black)
                       })
                        Spacer()
                    }.padding(.bottom)
                        //if the user clicks to change the grading system they are presented with a wheel picker
                        if (pickerShowing) {
                            Picker("Grading System", selection: $pointSystem) {
                                    Text("Points").tag("Points")
                                    Text("Percentages").tag("Percentages")
                            }.pickerStyle(WheelPickerStyle())
                        }
                
                
                HStack {
                    //Displays an interactive Course tag preview
                    Text("Course Tag Preview: ")
                        .bold()
                    Spacer()
                    Button(action:{}, label: {
                        if(courseName != "") {
                            Text("\(courseName)")
                        } else {
                            Text("Untitled Course")
                        }
                    })
                    .padding(10.0)
                    .foregroundColor(.white)
                    .background(selectedColor)
                    .cornerRadius(25.0)
                    Spacer()
                }.padding(.bottom)
                
                VStack(alignment: .center){
                    //Allows user to change the color of the custom course tag
                    Text("   Select Course Color: ")
                        .bold()
                    HStack {
                        Circle()
                            .fill(Color.clear)
                            .frame(width: 25, height: 25)
                        Circle()
                            .fill(Color.red)
                            .frame(width: 25, height: 25)
                            .onTapGesture {
                                selectedColor = Color.red
                                colorAsString = "Red"
                            }
                        
                        Circle()
                            .fill(Color.orange)
                            .frame(width: 25, height: 25)
                            .onTapGesture {
                                selectedColor = Color.orange
                                colorAsString = "Orange"
                            }
                        
                        Circle()
                            .fill(Color.yellow)
                            .frame(width: 25, height: 25)
                            .onTapGesture {
                                selectedColor = Color.yellow
                                colorAsString = "Yellow"
                            }
                        Circle()
                            .fill(Color.green)
                            .frame(width: 25, height: 25)
                            .onTapGesture {
                                selectedColor = Color.green
                                colorAsString = "Green"
                            }
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 25, height: 25)
                            .onTapGesture {
                                selectedColor = Color.blue
                                colorAsString = "Blue"
                            }
                        
                        Circle()
                            .fill(Color.purple)
                            .frame(width: 25, height: 25)
                            .onTapGesture {
                                selectedColor = Color.purple
                                colorAsString = "Purple"
                            }
                        Circle()
                            .fill(Color.pink)
                            .frame(width: 25, height: 25)
                            .onTapGesture {
                                selectedColor = Color.pink
                                colorAsString = "Pink"
                            }
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 25, height: 25)
                            .onTapGesture {
                                selectedColor = Color.gray
                                colorAsString = "Gray"
                            }
                        Circle()
                            .fill(Color.black)
                            .frame(width: 25, height: 25)
                            .onTapGesture {
                                selectedColor = Color.black
                                colorAsString = "Black"
                            }
                    
                    
                    }
                }
                
                
                Spacer()
                //button allows user to save changes to the course
                HStack{
                    Spacer()
                    Button(action: {saveContext()}, label: {Text("Save Changes")})
                        .padding()
                        .border(Color.blue)
                    Spacer()
                }
            }
            .onAppear(){
                //sets initial course values
                courseName = course.name ?? "Untitled Course"
                if (course.pointValues) {
                    pointSystem = "Points"
                } else if (!course.pointValues) {
                    pointSystem = "Percentages"
                }
               colorAsString = course.color ?? "Red"
                if(colorAsString == "Red") {
                    selectedColor = Color.red
                } else if (colorAsString == "Orange") {
                    selectedColor = Color.orange
                } else if (colorAsString == "Yellow") {
                    selectedColor = Color.yellow
                } else if (colorAsString == "Green") {
                    selectedColor = Color.green
                } else if (colorAsString == "Blue") {
                    selectedColor = Color.blue
                } else if (colorAsString == "Purple") {
                    selectedColor = Color.purple
                } else if (colorAsString == "Pink") {
                    selectedColor = Color.pink
                } else if (colorAsString == "Gray") {
                    selectedColor = Color.gray
                } else if (colorAsString == "Black") {
                    selectedColor = Color.black
                } else {
                    selectedColor = Color.red
                }
            }
        
    }
    func saveContext() {
      do {
        course.name = courseName
        if(pointSystem == "Points") {
            course.pointValues = true
        } else if (pointSystem == "Percentages"){
            course.pointValues = false
        }
        course.color = colorAsString
        try viewContext.save()
      } catch {
        print("Error saving managed object context: \(error)")
      }
    }
}

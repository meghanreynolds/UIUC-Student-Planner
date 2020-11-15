//
//  CourseDetailView.swift
//  UIUC Student Planner
//
//  Created by Meghan Reynolds on 11/14/20.
//
import SwiftUI

struct CourseDetailView: View {
    //Viewcontext for the database
    @Environment(\.managedObjectContext) private var viewContext
    @State var isPresented = false
    //The course passed in from the parent view
    @State var course: Course
    @State var pointSystem: String = ""
    var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("\(course.name ?? "Test Assignment")")
                        .font(.largeTitle)
                        .fontWeight(.medium)
                    Spacer()
                    Button(action:{isPresented = true}, label: {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.blue)
                    })
                }
                    HStack {
                        Text("Grading System: ")
                            .bold()
                        Spacer()
                        Text("\(pointSystem)")
                    }
                .sheet(isPresented: $isPresented, content: {
                    EditCourseView(item: course)
                })
                
                Spacer()
            }
            .padding()
            .onAppear(){
                if (course.pointValues) {
                    pointSystem = "Points"
                } else if (!course.pointValues) {
                    pointSystem = "Percentages"
                }
            }
    }
}

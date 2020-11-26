//
//  AddCourseView.swift
//  UIUC Student Planner
//
//  Created by Meghan Reynolds on 11/11/20.
//

import SwiftUI
import CoreData

struct CourseView: View {

    //Viewcontext for the database
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    //The fetch request getting all the courses and sorting them by their names
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Course.name, ascending: true)])
    private var items: FetchedResults<Course>
    
    @State var showingDetail: Bool = false
    @State var courseName: String = ""
    
    var body: some View {
        NavigationView {
            //displays all courses that are not empty courses with navigation links to detailedCourseView
            List {
                ForEach(items){item in
                    if (item.name != "No Course") {
                        NavigationLink(destination:CourseDetailView(course: item)) {
                            Text("\(item.name ?? "Untitled Course")")
                        }
                    }
                }
                .onDelete(perform: deleteCourses)
            }
            .navigationBarTitle(Text("Courses"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    //button to add a course that takes the user to add course view
                    Button(action: {self.showingDetail.toggle()}) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }
        .navigationTitle("Course")
        .sheet(isPresented: $showingDetail) {
            AddCourse()
        }
    }
    
    func saveContext() {
      do {
        try viewContext.save()
      } catch {
        print("Error saving managed object context: \(error)")
      }
    }
    
    private func deleteCourses(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
            }
        }
    }

}

struct CourseView_Previews: PreviewProvider {
    static var previews: some View {
        CourseView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}



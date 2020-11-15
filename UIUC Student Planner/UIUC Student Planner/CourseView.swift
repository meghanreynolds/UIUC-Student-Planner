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
      //  NavigationView {
            List {
                ForEach(items){item in
                    NavigationLink(destination:CourseDetailView(course: item)) {
                        Text("\(item.name ?? "Untitled Course")")
                    }
                }
                .onDelete(perform: deleteCourses)
            }
            .navigationBarTitle(Text("Courses"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
              //  ToolbarItem(placement: .navigationBarLeading) {
               //     EditButton()
                //}
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {self.showingDetail.toggle()}) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
       // }
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



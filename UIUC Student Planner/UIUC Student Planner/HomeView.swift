//
//  HomeView.swift
//  UIUC Student Planner
//
//  Created by Meghan Reynolds on 11/11/20.
//
import SwiftUI
import CoreData

extension Color {
    
    public static var ListBackground: Color {
        return Color(decimalRed: 19, green: 41 , blue: 75 )
    }
    
}
//extension NSManagedObject: Identifiable { }


struct HomeView: View {
    //Viewcontext for the database
    @Environment(\.managedObjectContext) private var viewContext
    
    //The fetch request getting all the assignments and sorting them by their timestamps
    @FetchRequest(entity: Assignment.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Assignment.dueDate, ascending: true)],
                  animation: .default) var items: FetchedResults<Assignment>
    
    //The fetch request getting all the courses and sorting them by their names
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Course.name, ascending: true)])
    private var courses: FetchedResults<Course>
    
    @State private var showingDetail = false
    
    @State private var sort: Int = 0
    
    //Values for the filter menu
    private var filters = ["None","Min Points", "Pinned", "Max Points"]
    
    
    var body: some View {
        let FilterObject = Order();
        //Displays assignments that were fetched.
        NavigationView {
            List {
                ForEach(items) { item in
                    //Apply filter
                    if (FilterObject.isNotFiltered(assignment: item, selectedSorts: filters[sort])) {
                        // Link to individual assignment details.
                        NavigationLink(destination:AssignmentView(assignment: item)) {
                            //                       Text("Item at \(item.timestamp!, formatter: itemFormatter)") // creates the text in the list
                            HStack {
                                AssignmentAttributes(assignment: item)
                                    .cornerRadius(15)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 7)
                                    .foregroundColor(.white)
                            }
                            
                        }
                    }
                }
                .onDelete(perform: deleteItems)
                .background(Color.ListBackground)
                .cornerRadius(15)
            }
            .navigationTitle("UIUC Student Planner")
            .navigationBarTitleDisplayMode(.inline)
            
            
            .toolbar {
                //Toggle delete assignemnts from home page
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                // Toggles sheet to display form to add a new assignment
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {self.showingDetail.toggle()}) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
                //Toggles menu to display filter options
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Picker(selection: $sort, label: Text("Sorting options")) {
                            ForEach(0 ..< filters.count) {
                                Text(self.filters[$0])
                            }
                        }
                    }
                    label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    }
                }
            }
        }
        // sheet to display the view that allows users to add asignments
        .sheet(isPresented: $showingDetail) {
            AddAssignmentView()
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Assignment(context: viewContext)
            newItem.dueDate = Date()
            
            do {
                try viewContext.save()
            } catch {
                // Matt's Note: Ignore this, it shouldn't matter
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Matt's Note: Ignore this, it shouldn't matter
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

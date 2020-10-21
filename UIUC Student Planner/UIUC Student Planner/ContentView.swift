import SwiftUI
import CoreData

struct ContentView: View {
    //Viewcontext for the database
    @Environment(\.managedObjectContext) private var viewContext

    //The fetch request getting all the assignments and sorting them by their timestamps
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Assignment.dueDate, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Assignment>
    
    @State private var showingDetail = false
    
    var body: some View {
           NavigationView {
               List {
                   ForEach(items) { item in
                        NavigationLink(destination: ItemTestView()) {
//                       Text("Item at \(item.timestamp!, formatter: itemFormatter)") // creates the text in the list
                            AssignmentAttributes(assignment: item)
                                
                       }
                   }
                   .onDelete(perform: deleteItems)
               }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {self.showingDetail.toggle()}) {
                        
                        Label("Add Item", systemImage: "plus")
                    }
                    .sheet(isPresented: $showingDetail) {
                        Text("This is where the Detail View will go. (add button to close this view")
                            .padding()
                    }
                }
            }
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

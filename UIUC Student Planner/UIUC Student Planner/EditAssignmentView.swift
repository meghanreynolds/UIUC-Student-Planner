//
//  EditAssignmentView.swift
//  UIUC Student Planner
//
//  Created by Matthew Geimer on 10/7/20.
//

import SwiftUI

struct EditAssignmentView: View {
    //Viewcontext for the database
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    //The item passed in from the parent view
    @State var item: FetchedResults<Assignment>.Element
    
    @State var newName: String = ""
    @State var newPoints: Int64 = 0
    
    @State var formShowing: Bool = false
    @State var newLink: URL = URL(string: "tester.com")!
    @State var holder: String = ""
    
    @State var isPinned: Bool = false
    
    @State var newDate = Date.init(timeIntervalSinceNow: 0)
    
    @State var newSelectedTag = Array<Tag>()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Assignment Name")){
                    TextField("Assignment Name", text: $newName)
                        //updates item.name if the user changes the assignment's name
                    NavigationLink(destination: TagPicker(selectedTags: self.$newSelectedTag)){
                        self.getSelectedTagText()
                    }
                }
                Section (header: Text("Assignment Details")) {
                    Stepper(value: $newPoints ,in: 0...100){
                       Text(getPoints())
                    }
                    //Allows the user to add or remove a link to their assignment
                        List{
                            if formShowing {
                                //textfield allowing a user to add a link
                                HStack {
                                    //closes textfield view if user no longer wants a link
                                    Button(action: {formShowing = false
                                        holder = ""
                                    }) {
                                        HStack {
                                            Image(systemName: "minus.circle.fill")
                                                .foregroundColor(.red)
                                        }
                                    }
                                    Text("link")
                                        .foregroundColor(.blue)
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                    Divider()
                                    //allows user to input link without dealing with autocorect and autocapitalization
                                    TextField("link to assignment", text: $holder)
                                        .disableAutocorrection(true)
                                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                                }
                            }
                            //Causes add link textfield to appear on click
                            Button(action: {formShowing = true
                            }) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(.green)
                                    Text("Add a link")
                                }
                            }
                        }
                    Toggle(isOn: $isPinned) {
                        Text("Pin Assignment")
                    }
                }
                DeadlinePickerView.init(selectedDate: self.$newDate)
                Button(action: {
                    saveContext()
                    self.presentationMode.wrappedValue.dismiss()
                }, label : {
                    HStack {
                        Spacer()
                        Text("Save")
                        Spacer()
                    }
                })
            }
            .navigationBarTitle("Edit Assignment")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label : {
                        Text("Cancel")
                    })
                }
            }
        }
        .onAppear {
            newName = item.name ?? "Untitled Assignment"
            newPoints = item.points
            newDate = item.dueDate ?? Date()
            newLink = item.linkToAssignment ?? URL(string: "tester.com")!
            isPinned = item.pinned
            //causes link textfield to appear immediately if the user has already entered a link and to remain hidden otherwise
            if newLink != URL(string: "tester.com")! {
                formShowing = true
                holder = "\(newLink)"
            }
            newSelectedTag = Array.init((item.tags ?? NSSet()) as! Set)
        }
    }
    
    func saveContext() {
      do {
        item.name = newName
        item.points = newPoints
        item.dueDate = newDate
        item.pinned = isPinned
        if holder != "" {
            let link: URL = URL(string: holder)!
            item.linkToAssignment = link
        } else {
            item.linkToAssignment = nil
        }
        item.tags = Set(self.newSelectedTag) as NSSet
        
        try viewContext.save()
      } catch {
        print("Error saving managed object context: \(error)")
      }
    }
    
    func getPoints() -> String {
        //updates the assignment's points and displays the points to the user
        return "\(newPoints) Point\(newPoints != 1 ? "s" : "")"
    }
    
    private func getSelectedTagText() -> some View{
        if self.newSelectedTag.count == 0{
            return Text("no tag selected")
                .foregroundColor(.gray)
                .font(Font.system(size: 15))
        }
        var s = ""
        for i in stride(from: 0, to: self.newSelectedTag.count - 1, by: 1){
            s += self.newSelectedTag[i].name! + ", "
        }
        s += self.newSelectedTag.last!.name!
        return Text(s).font(Font.system(size: 15))
    }
}

struct EditAssignmentView_Previews: PreviewProvider {
    static var previews: some View {
        EditAssignmentView(item: Assignment(context: PersistenceController.preview.container.viewContext))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}


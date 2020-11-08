//
//  TagPickerView.swift
//  UIUC Student Planner
//
//  Created by Jeffery Wang on 10/25/20.
//

import SwiftUI
import CoreData

struct TagPicker: View{
    
    @State var createNewTag = false
    @State var newTagName: String = ""
    @Binding var selectedTags: Array<String>
    
    @Environment(\.managedObjectContext) private var viewContext
    //The fetch request getting all the assignments and sorting them by their timestamps
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Tag.name, ascending: true)],
        animation: .default)
    private var tags: FetchedResults<Tag>
    
    var body: some View{
        Spacer()
        HStack{
            Button("+"){
                self.createNewTag.toggle()
            }.font(Font.system(size: 25))
            Spacer()
        }.padding([.leading, .trailing], 20)
        if self.createNewTag{
            HStack{
                TextField("new tag name", text: self.$newTagName)
                Button("cancel") {
                    self.newTagName = ""
                    self.createNewTag.toggle()
                }
                Button("save"){
                    let t = Tag(context: self.viewContext)
                    t.name = self.newTagName
                    do{
                        try self.viewContext.save()
                    }catch{
                        
                    }
                    self.selectedTags.append(self.newTagName)
                    self.newTagName = ""
                    self.createNewTag.toggle()
                }.disabled(self.newTagName == "")
            }.padding([.leading, .trailing], 20)
        }
        
        List{
            ForEach.init(self.tags) { tag in
                HStack{
                    Text(tag.name!)
                    Spacer()
                    if self.selectedTags.contains(tag.name ?? ""){
                        Image.init(systemName: "checkmark").foregroundColor(.blue)
                    }else{
                        EmptyView()
                    }
                }.contentShape(Rectangle()).onTapGesture {
                    if self.selectedTags.contains(tag.name!){
                        self.selectedTags.remove(at: self.selectedTags.firstIndex(of: tag.name!)!)
                    }else{
                        self.selectedTags.append(tag.name!)
                    }
                }
            }
        }.navigationTitle("Tags")
    }
}

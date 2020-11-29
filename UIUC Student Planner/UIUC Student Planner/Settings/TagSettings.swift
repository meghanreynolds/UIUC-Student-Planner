//
//  TagSettings.swift
//  UIUC Student Planner
//
//  Created by Meghan Reynolds on 11/14/20.
//

import SwiftUI

struct TagSettings: View {
    
    @State var isNavigationBarHidden: Bool = true
    
    @Environment(\.managedObjectContext) private var viewContext

    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Tag.name, ascending: true)],
        animation: .default)
    private var tags: FetchedResults<Tag>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Course.name, ascending: true)],
        animation: .default)
    private var courses: FetchedResults<Course>
    
    var body: some View {
        
        List{
            Section(header: Text("tags from course")){
                ForEach.init(self.tags){ tag in
                    if self.courses.contains(where: {$0.name == tag.name}){
                        Text(tag.name!)
                    }
                }
            }
            
            Section(header: Text("tags created")){
                ForEach.init(self.tags){ tag in
                    if !self.courses.contains(where: {$0.name == tag.name}){
                        Text(tag.name!)
                    }
                }
            }
        }.navigationBarTitle("Tags", displayMode: .inline)
    }
}

struct TagSettings_Previews: PreviewProvider {
    static var previews: some View {
        TagSettings().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

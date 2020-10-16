//
//  EditAssignmentView.swift
//  UIUC Student Planner
//
//  Created by Matthew Geimer on 10/7/20.
//

import SwiftUI
import UIKit

struct EditAssignmentView: View {
    //Viewcontext for the database
    @Environment(\.managedObjectContext) private var viewContext
    
    //The item passed in from the parent view
    @State var item: FetchedResults<Assignment>.Element
    var body: some View {
        Text("Hello World")
    }
}

struct EditAssignmentView_Previews: PreviewProvider {
    static var previews: some View {
        EditAssignmentView(item: Assignment(context: PersistenceController.preview.container.viewContext))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}


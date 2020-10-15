//
//  AddAssignmentView.swift
//  UIUC Student Planner
//
//  Created by Matthew Geimer on 10/7/20.
//

import SwiftUI

struct AddAssignmentView: View {
    //Viewcontext for the database
    @Environment(\.managedObjectContext) private var viewContext
    @State var pointValue: Int64 = 0
    var body: some View {
        NavigationView {
            Form {
                TextField("Points", value: $pointValue, formatter: NumberFormatter())
            }
            .navigationBarTitle("Add Assignment")
        }
    }
}

struct AddAssignmentView_Previews: PreviewProvider {
    static var previews: some View {
        AddAssignmentView()
    }
}

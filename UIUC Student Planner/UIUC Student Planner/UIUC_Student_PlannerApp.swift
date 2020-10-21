//
//  UIUC_Student_PlannerApp.swift
//  UIUC Student Planner
//
//  Created by Matthew Geimer on 10/7/20.
//

import SwiftUI

@main
struct UIUC_Student_PlannerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

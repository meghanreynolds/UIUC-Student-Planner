//
//  Persistence.swift
//  UIUC Student Planner
//
//  Created by Matthew Geimer on 10/7/20.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Assignment(context: viewContext)
            newItem.dueDate = Date()
            newItem.name = ""
            newItem.points = 0
            newItem.completed = false
            newItem.pinned = false
            newItem.priority = 0
        }
        let t1 = Tag(context: viewContext)
        t1.name = "CS 125"
        let t2 = Tag(context: viewContext)
        t2.name = "CS 196"
        let t3 = Tag(context: viewContext)
        t3.name = "Test Course 1"
        let t4 = Tag(context: viewContext)
        t4.name = "Test Course 2"
        let c1 = Course(context: viewContext)    //added Course context for testing
        c1.pointValues = true
        c1.name = "Test Course 1"
        let c2 = Course(context: viewContext)
        c2.pointValues = false
        c2.name = "Test Course 2"
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "UIUC_Student_Planner")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}

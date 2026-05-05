//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by Екатерина Протасова on 05.05.2026.
//

import SwiftUI
import CoreData

@main
struct ToDoListApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

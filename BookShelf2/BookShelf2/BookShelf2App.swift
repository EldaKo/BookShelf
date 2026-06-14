//
//  BookShelf2App.swift
//  BookShelf2
//
//  Created by Elda Ko on 2026/06/13.
//

import SwiftUI

@main
struct BookShelf2App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

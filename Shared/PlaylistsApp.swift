//
//  PlaylistsApp.swift
//  Shared
//
//  Created by Felipe on 4/12/22.
//

import SwiftUI

@main
struct PlaylistsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

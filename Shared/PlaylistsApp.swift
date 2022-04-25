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
    let dataBaseInitializer = DataBaseInitializer()
    let appearance: UITabBarAppearance = UITabBarAppearance()
    
    var body: some Scene {
        WindowGroup {
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            TabView {
                LibraryView()
                    .tabItem {
                        Label("Library", systemImage: "music.note.list")
                    }
//                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                
                PreparedView()
                    .tabItem {
                        Label("Prepared", systemImage: "checklist")
                    }
//                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                
                PlaylistsView()
                    .tabItem {
                        Label("Playlists", systemImage: "list.star")
                    }
            }
            .onAppear {
                UITabBar.appearance().scrollEdgeAppearance = appearance
                //UITableViewHeaderFooterView.appearance().backgroundView = .init()
                UITableViewHeaderFooterView.appearance().backgroundView = .init()
                dataBaseInitializer.initialize()
            }
            
        }
    }
}

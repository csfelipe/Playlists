//
//  CreatePlaylistView.swift
//  Playlists
//
//  Created by Felipe on 4/15/22.
//

import SwiftUI

struct CreatePlaylistView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var title: String = ""
    @State var showErrorAlert: Bool = false
    @FocusState private var isFocused: Bool
    var viewModel = CreatePlaylistViewModel()
    var needsNavigation: Bool = true

    var body: some View {
        switch needsNavigation {
        case true:
            NavigationView {
                contentView
            }
        case false:
            contentView
        }
    }
        
    var contentView: some View {
        VStack(alignment: .center) {
            TextField("e.g. Jane & John's Wedding", text: $title)
                .focused($isFocused)
                .padding(EdgeInsets(top: 20, leading: 35, bottom: 20, trailing: 35))
            Spacer()
        }
        .navigationTitle("Create a playlist")
        .toolbar {
            ToolbarItemGroup(placement: .cancellationAction) {
                if needsNavigation {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            
            ToolbarItemGroup(placement: .confirmationAction) {
                Button("Create") {
                    viewModel.createPlaylist(named: title) { successful in
                        switch successful {
                        case true:
                            presentationMode.wrappedValue.dismiss()
                        case false:
                            showErrorAlert = true
                        }
                    }
                }
            }
        }
        .onAppear {
            print("starting focus")
            isFocused = true
        }
        .alert("Failed to create Playlist", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) { }
        }
    }
    
    @ToolbarContentBuilder var toolBarWhenNavigationViewIsAvailable: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }
        }
        
        ToolbarItem(placement: .confirmationAction) {
            Button("Create") {
                viewModel.createPlaylist(named: title) { successful in
                    switch successful {
                    case true:
                        presentationMode.wrappedValue.dismiss()
                    case false:
                        showErrorAlert = true
                    }
                }
            }
        }
    }
    
    @ToolbarContentBuilder var toolBarWhenNavigationViewIsNoAvailable: some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            Button("Create") {
                viewModel.createPlaylist(named: title) { successful in
                    switch successful {
                    case true:
                        presentationMode.wrappedValue.dismiss()
                    case false:
                        showErrorAlert = true
                    }
                }
            }
        }
    }
}

struct CreatePlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePlaylistView()
    }
}

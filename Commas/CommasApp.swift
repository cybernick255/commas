//
//  CommasApp.swift
//  Commas
//
//  Created by Nicolas Deleasa on 6/16/25.
//

import SwiftUI
import SwiftData

@main
struct CommasApp: App
{
    var body: some Scene
    {
        WindowGroup
        {
            ContentView()
        }
        .modelContainer(for: Snapshot.self)
    }
}



// MARK: Notes
// Searchable comments:
// - //Note:
// - //Error:

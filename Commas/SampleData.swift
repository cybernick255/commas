//
//  SampleData.swift
//  Commas
//
//  Created by Nicolas Deleasa on 6/16/25.
//

import Foundation
import SwiftData

@MainActor
class SampleData
{
    static let shared = SampleData()
    
    let modelContainer: ModelContainer
    
    var modelContext: ModelContext
    {
        modelContainer.mainContext
    }
    
    private init()
    {
        let schema =
        Schema(
            [
                Snapshot.self
            ]
        )
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        
        do
        {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            insertSampleData()
            
            try modelContext.save()
        }
        catch
        {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    private func insertSampleData()
    {
        for snapshot in Snapshot.sampleData
        {
            modelContext.insert(snapshot)
        }
    }
}

//
//  ContentView.swift
//  Commas
//
//  Created by Nicolas Deleasa on 6/16/25.
//

import SwiftUI
import SwiftData

struct ContentView: View
{
    var body: some View
    {
        NetWorthView()
    }
}

#Preview
{
    ContentView()
        .modelContainer(SampleData.shared.modelContainer)
}

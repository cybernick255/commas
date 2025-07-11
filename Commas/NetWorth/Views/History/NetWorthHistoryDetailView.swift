//
//  NetWorthHistoryDetailView.swift
//  Commas
//
//  Created by Nicolas Deleasa on 6/18/25.
//

import SwiftUI

struct NetWorthHistoryDetailView: View
{
    let snapshot: Snapshot
    
    @State private var presentSheet: Bool = false
        
    var body: some View
    {
        ScrollView
        {
            VStack
            {
                NetWorthHeaderView(snapshot: snapshot)
                NetWorthListView(snapshot: snapshot)
            }
            .padding()
            .navigationTitle(formattedDate(snapshot.date))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar
            {
                ToolbarItem(placement: .topBarTrailing)
                {
                    Button("", systemImage: "plus", action: {presentSheet = true})
                }
            }
            .sheet(isPresented: $presentSheet)
            {
                NetWorthItemValueAddView(snapshot: snapshot)
            }
        }
        .scrollIndicators(.hidden)
    }
}

#Preview
{
    NavigationStack
    {
        NetWorthHistoryDetailView(snapshot: errorSnapshot)
    }
}

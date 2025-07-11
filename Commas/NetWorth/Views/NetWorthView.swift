//
//  NetWorthView.swift
//  Commas
//
//  Created by Nicolas Deleasa on 6/17/25.
//

import SwiftUI
import SwiftData

struct NetWorthView: View
{
    @Query private var snapshots: [Snapshot]
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var presentSheet: Bool = false
    
    var currentSnapshot: Snapshot
    {
        if let snapshot = snapshots.last
        {
            return snapshot
        }
        else
        {
            // Error: Should not happen.
            return errorSnapshot
        }
    }
    
    init()
    {
        _snapshots = Query(sort: \.date)
    }
    
    var body: some View
    {
        NavigationStack
        {
            GeometryReader
            { geometry in
                ScrollView
                {
                    VStack
                    {
                        NetWorthHeaderView(snapshot: currentSnapshot)
                        NetWorthChartView(geometry: geometry, snapshot: currentSnapshot)
                        NavigationLink(destination: NetWorthHistoryView())
                        {
                            HStack
                            {
                                Text(formattedDate(currentSnapshot.date))
                                    .font(.title2)
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .padding(.vertical)
                            .foregroundStyle(colorScheme == .light ? .black : .white)
                        }
                        
                        NetWorthListView(snapshot: currentSnapshot)
                    }
                    .padding()
                    .frame(width: geometry.size.width)
                }
                .scrollIndicators(.hidden)
            }
            .onAppear(perform: fillInMissingSnapshots)
            .toolbar
            {
                ToolbarItem(placement: .topBarTrailing)
                {
                    Button("", systemImage: "plus", action: {presentSheet = true})
                }
            }
            .sheet(isPresented: $presentSheet)
            {
                NetWorthItemValueAddView(snapshot: currentSnapshot)
            }
        }
    }
    
    private func fillInMissingSnapshots()
    {
        guard let lastSnapshot = snapshots.last
        else
        {
            // Snapshots empty, create first snapshot.
            createFirstSnapshotIfEmpty()
            
            return
        }
        
        var calendar = Calendar.current
        calendar.timeZone = .gmt
        let now = calendar.startOfDay(for: Date())
        var currentDate = calendar.startOfDay(for: lastSnapshot.date).addingTimeInterval(86400) // Next day
        
        while currentDate <= now
        {
            let newSnapshot =
            Snapshot(
                date: currentDate,
                itemValues: lastSnapshot.itemValues.map { NetWorthItemValue(item: $0.item, value: $0.value) }
            )
            
            modelContext.insert(newSnapshot)
            
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
    }
    
    private func createFirstSnapshotIfEmpty()
    {
        var calendar = Calendar.current
        calendar.timeZone = .gmt
        let now = calendar.startOfDay(for: Date())
        
        let newSnapshot: Snapshot =
        Snapshot(date: now, itemValues: [])
        
        modelContext.insert(newSnapshot)
    }
}

#Preview
{
    NetWorthView()
}

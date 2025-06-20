//
//  NetWorthHistoryMonthView.swift
//  Commas
//
//  Created by Nicolas Deleasa on 6/18/25.
//

import SwiftUI
import SwiftData

struct NetWorthHistoryMonthView: View
{
    @Query private var snapshots: [Snapshot]
    
    let calendar: Calendar
    let navTitle: String
    
    init(year: Int, month: Int)
    {
        self.navTitle = String("\(monthName(from: month)) \(year)")
        
        var calendar = Calendar.current
        calendar.timeZone = .gmt
        self.calendar = calendar
        
        // Start of the selected month
        let startDate = calendar.date(from: DateComponents(year: year, month: month, day: 1))!
        // Start of the next month
        let endDate = calendar.date(from: DateComponents(year: year, month: month + 1, day: 1))!
        
        let predicate = #Predicate<Snapshot>
        { snapshot in
            snapshot.date >= startDate && snapshot.date < endDate
        }
        
        _snapshots = Query(filter: predicate, sort: \.date, order: .reverse)
    }
    
    var body: some View
    {
        GeometryReader
        { geometry in
            List
            {
                ForEach(snapshots)
                { snapshot in
                    NavigationLink(destination: NetWorthHistoryDetailView(snapshot: snapshot))
                    {
                        HStack
                        {
                            Text("\(calendar.component(.day, from: snapshot.date))")
                                .frame(width: geometry.size.width * 0.1)
                            Divider()
                            Text(formatValue(value: snapshot.netWorth))
                        }
                    }
                }
            }
        }
        .navigationTitle(navTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview
{
    NavigationStack
    {
        NetWorthHistoryMonthView(year: 2025, month: 6)
    }
}

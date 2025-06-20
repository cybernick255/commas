//
//  NetWorthHistoryView.swift
//  Commas
//
//  Created by Nicolas Deleasa on 6/18/25.
//

import SwiftUI
import SwiftData

struct NetWorthHistoryView: View
{
    @Query private var snapshots: [Snapshot]
    
    @State private var expandedYears: [Int: Bool] = [:]
    
    private var yearAndMonths: [YearAndMonths]
    {
        return getYearAndMonths(from: snapshots.first?.date, to: snapshots.last?.date)
    }
    
    init()
    {
        _snapshots = Query(sort: \.date)
    }
    
    var body: some View
    {
        List
        {
            ForEach(yearAndMonths.reversed(), id: \.year)
            { item in
                DisclosureGroup(
                    isExpanded:
                        Binding(
                            get:
                                {
                                    expandedYears[item.year] ?? false
                                },
                            set:
                                { expandedYears[item.year] = $0
                                }
                        ),
                    content:
                        {
                            ForEach(item.months.reversed(), id: \.self)
                            { month in
                                NavigationLink(destination: NetWorthHistoryMonthView(year: item.year, month: month))
                                {
                                    Text(monthName(from: month))
                                }
                            }
                        },
                    label:
                        {
                            Text(String(item.year))
                        }
                )
            }
        }
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear
        {
            for item in yearAndMonths
            {
                if expandedYears[item.year] == nil
                {
                    expandedYears[item.year] = false
                }
            }
        }
    }
    
    private struct YearAndMonths: CustomStringConvertible
    {
        let year: Int
        let months: [Int]
        
        var description: String
        {
            "Year \(year): Months \(months)"
        }
    }
    
    private func getYearAndMonths(from first: Date?, to last: Date?) -> [YearAndMonths]
    {
        var result: [YearAndMonths] = []
        var calendar = Calendar.current
        calendar.timeZone = .gmt
        
        guard let first = first, let last = last
        else { return result }
        
        guard let startYear = calendar.dateComponents([.year], from: first).year,
              let startMonth = calendar.dateComponents([.month], from: first).month,
              let endYear = calendar.dateComponents([.year], from: last).year,
              let endMonth = calendar.dateComponents([.month], from: last).month
        else { return result }
        
        for year in startYear...endYear
        {
            let months: [Int]
            if year == startYear && year == endYear
            {
                months = Array(startMonth...endMonth)
            }
            else if year == startYear
            {
                months = Array(startMonth...12)
            }
            else if year == endYear
            {
                months = Array(1...endMonth)
            }
            else
            {
                months = Array(1...12)
            }
            
            result.append(YearAndMonths(year: year, months: months))
        }
        
        return result
    }
}

#Preview
{
    NavigationStack
    {
        NetWorthHistoryView()
    }
}

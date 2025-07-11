//
//  NetWorthChartView.swift
//  Commas
//
//  Created by Nicolas Deleasa on 6/17/25.
//

import SwiftUI
import SwiftData
import Charts

struct NetWorthChartView: View
{
    @Environment(\.modelContext) private var context
    @State private var selectedRange: TimeRange = .all
    @State private var snapshots: [Snapshot] = []
    
    @State private var netWorthChange: NetWorthChange = NetWorthChange(price: 0, percent: 0, duration: "Error", color: .purple, rotation: 45)
    
    let geometry: GeometryProxy
    // To update UI without having to change selectedRange.
    let snapshot: Snapshot
    
    
    var body: some View
    {
        VStack
        {
            HStack
            {
                Image(systemName: "triangle.fill")
                    .foregroundStyle(netWorthChange.color)
                    .rotationEffect(.degrees(netWorthChange.rotation))
                Text(formatValue(value: netWorthChange.price))
                    .foregroundStyle(netWorthChange.color)
                if netWorthChange.price >= 0 && netWorthChange.percent < 0
                {
                    EmptyView()
                }
                else
                {
                    Text("(\(String(format: "%.2f", NSDecimalNumber(decimal: netWorthChange.percent).doubleValue))%)")
                        .foregroundStyle(netWorthChange.color)
                }
                Text(netWorthChange.duration)
                Spacer()
            }
            Chart
            {
                ForEach(snapshots)
                { snapshot in
                    LineMark(
                        x: .value("Date", snapshot.date),
                        y: .value("Net Worth", Decimal(snapshot.netWorth) * 0.01)
                    )
                }
            }
            .chartXAxis
            {
                // Leave empty
            }
            .chartYAxis
            {
                // Leave empty
            }
            .frame(width: geometry.size.width, height: geometry.size.height * 0.3)
            .onAppear(perform: fetchSnapshots)
            .onChange(of: selectedRange, fetchSnapshots)
            .onChange(of: snapshot.netWorth, fetchSnapshots)
        }
        
        ChartSegmentedPickerView(selectedRange: $selectedRange)
    }
    
    private struct NetWorthChange
    {
        let price: Int
        let percent: Decimal
        let duration: String
        let color: Color
        let rotation: Double
    }
    
    private func fetchSnapshots()
    {
        let descriptor: FetchDescriptor<Snapshot>
        
        if let startDate = selectedRange.startDate()
        {
            descriptor = FetchDescriptor<Snapshot>(
                predicate: #Predicate { $0.date >= startDate },
                sortBy: [SortDescriptor(\.date, order: .reverse)]
            )
        }
        else
        {
            descriptor = FetchDescriptor<Snapshot>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        }
        
        do
        {
            snapshots = try context.fetch(descriptor)
            // Descriptor order is reverse, so first is last and last is first.
            fetchNetWorthChange(first: snapshots.last ?? errorSnapshot, last: snapshots.first ?? errorSnapshot)
        }
        catch
        {
            print("Error fetching snapshots: \(error)")
        }
    }
    
    private func fetchNetWorthChange(first: Snapshot, last: Snapshot)
    {
        let price: Int = last.netWorth - first.netWorth
        let percent: Decimal = ((Decimal(last.netWorth) - Decimal(first.netWorth)) / Decimal(first.netWorth)) * 100
        let duration: String
        switch selectedRange
        {
        case .all:
            duration = "All time"
        case .week:
            duration = "Past week"
        case .month:
            duration = "Past month"
        case .quarter:
            duration = "Past quarter"
        case .year:
            duration = "Past year"
        }
        let color: Color
        let rotation: Double
        if price >= 0
        {
            color = .green
            rotation = 0.0
        }
        else
        {
            color = .red
            rotation = 180.0
        }
        
        netWorthChange = NetWorthChange(price: price, percent: percent, duration: duration, color: color, rotation: rotation)
    }
}

//#Preview
//{
//    NetWorthChartView(geometry: <#GeometryProxy#>)
//}



private struct ChartSegmentedPickerView: View
{
    @Binding var selectedRange: TimeRange
    
    var body: some View
    {
        Picker("Select range", selection: $selectedRange)
        {
            ForEach(TimeRange.allCases)
            { range in
                Text(range.rawValue.capitalized).tag(range)
            }
        }
        .pickerStyle(.segmented)
    }
}

enum TimeRange: String, CaseIterable, Identifiable
{
    case all, week, month, quarter, year
    
    var id: String { self.rawValue }
    
    func startDate() -> Date?
    {
        var calendar = Calendar.current
        calendar.timeZone = .gmt
        let now = calendar.startOfDay(for: Date())
        
        switch self
        {
        case .all: return nil
        case .week: return calendar.date(byAdding: .day, value: -6, to: now)
        case .month: return calendar.date(byAdding: .month, value: -1, to: now)
        case .quarter: return calendar.date(byAdding: .month, value: -3, to: now)
        case .year: return calendar.date(byAdding: .year, value: -1, to: now)
        }
    }
}

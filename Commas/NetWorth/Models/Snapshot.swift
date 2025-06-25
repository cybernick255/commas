//
//  Snapshot.swift
//  Commas
//
//  Created by Nicolas Deleasa on 6/16/25.
//

import Foundation
import SwiftData

@Model
class Snapshot
{
    private(set) var date: Date
    private(set) var netWorth: Int
    
    @Relationship(deleteRule: .cascade) private(set) var itemValues: [NetWorthItemValue]
    
    init(date: Date, itemValues: [NetWorthItemValue])
    {
        let assets: [NetWorthItemValue] = itemValues.filter { $0.item.isAsset }
        let liabilities: [NetWorthItemValue] = itemValues.filter { !$0.item.isAsset }
        
        let assetTotal: Int = assets.reduce(0) { $0 + $1.value }
        let liabilityTotal: Int = liabilities.reduce(0) { $0 + $1.value }
                
        self.date = date
        self.netWorth = assetTotal - liabilityTotal
        self.itemValues = itemValues
    }
    
    func updateNetWorth()
    {
        let assets: [NetWorthItemValue] = itemValues.filter { $0.item.isAsset }
        let liabilities: [NetWorthItemValue] = itemValues.filter { !$0.item.isAsset }
        
        let assetTotal: Int = assets.reduce(0) { $0 + $1.value }
        let liabilityTotal: Int = liabilities.reduce(0) { $0 + $1.value }
        
        self.netWorth = assetTotal - liabilityTotal
    }
    
    func addItemValue(item: NetWorthItem, value: Int)
    {
        self.itemValues.append(NetWorthItemValue(item: item, value: value))
        
        updateNetWorth()
    }
    
    func editItemValue(itemValue: NetWorthItemValue, name: String, value: Int)
    {
        self.itemValues[self.itemValues.firstIndex(of: itemValue)!].item.name = name
        self.itemValues[self.itemValues.firstIndex(of: itemValue)!].value = value
        
        updateNetWorth()
    }
    
    func deleteItemValue(itemValue: NetWorthItemValue)
    {
        if let index = self.itemValues.firstIndex(of: itemValue)
        {
            itemValues.remove(at: index)
        }
        
        updateNetWorth()
    }
    
    static let sampleData: [Snapshot] =
    {
        var snapshots: [Snapshot] = []
        
        let calendar = Calendar.current
        let baseDate = calendar.date(byAdding: .day, value: -99, to: Date())!
        
        for offset in 0..<100
        {
            let currentDate = calendar.date(byAdding: .day, value: offset, to: baseDate)!
            let components = calendar.dateComponents(in: TimeZone(secondsFromGMT: 0)!, from: currentDate)
            
            let year = components.year!
            let month = components.month!
            let day = components.day!
            
            // Simulate trends
            // Days 0-20: bumpy plateau
            // Days 20-40: steep rise
            // Days 40-55: sharp drop
            // Days 55-70: continue drop
            // Days 70-85: jagged bottom
            // Days 85-99: recovery
            let trendFactor: Int
            
            switch offset
            {
            case 0..<20:
                trendFactor = 9_000 + Int.random(in: -500...500) // initial plateau with bumps
            case 20..<40:
                trendFactor = 10_000 + (offset - 20) * 700 + Int.random(in: -300...300) // steep rise
            case 40..<55:
                trendFactor = 24_000 - (offset - 40) * 800 + Int.random(in: -300...300) // sharp drop
            case 55..<70:
                trendFactor = 12_000 - (offset - 55) * 150 + Int.random(in: -400...400) // continue drop
            case 70..<85:
                trendFactor = 8_000 + Int.random(in: -600...600) // jagged bottom
            default:
                trendFactor = 9_000 + (offset - 85) * 250 + Int.random(in: -200...200) // recovery
            }
            
            let assets: [NetWorthItemValue] =
            [
                NetWorthItemValue(item: sampleAsset, value: trendFactor + Int.random(in: 0...500)),
                NetWorthItemValue(item: sampleAsset2, value: 2_000 + Int.random(in: 0...1_000))
            ]
            let liabilities: [NetWorthItemValue] =
            [
                NetWorthItemValue(item: sampleLiability, value: max(1, Int(Double(trendFactor) * 0.4) + Int.random(in: -300...300)))
            ]
            
            snapshots.append(Snapshot(date: calendar.date(from: DateComponents(timeZone: .gmt, year: year, month: month, day: day))!, itemValues: assets + liabilities))
        }
        
        return snapshots
    }()
}

let errorSnapshot: Snapshot =
Snapshot(
    date: Date(),
    itemValues:
    [
        NetWorthItemValue(
            item: NetWorthItem(
                name: "Error",
                isAsset: true
            ),
            value: 0
        ),
        NetWorthItemValue(
            item: NetWorthItem(
                name: "Error",
                isAsset: false
            ),
            value: 0
        )
    ]
)

let sampleAsset: NetWorthItem =
NetWorthItem(
    name: "Cash",
    isAsset: true
)

let sampleAsset2: NetWorthItem =
NetWorthItem(
    name: "Brokerage",
    isAsset: true
)

let sampleLiability: NetWorthItem =
NetWorthItem(
    name: "Credit Card",
    isAsset: false
)

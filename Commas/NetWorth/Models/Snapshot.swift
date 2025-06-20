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
    [
        Snapshot(
            date: Calendar.current.date(from: DateComponents(timeZone: .gmt, year: 2025, month: 6, day: 18))!,
            itemValues:
                [
                    NetWorthItemValue(
                        item: sampleAsset,
                        value: 1000
                    ),
                    NetWorthItemValue(
                        item: sampleLiability,
                        value: 500
                    )
                ]
        ),
        Snapshot(
            date: Calendar.current.date(from: DateComponents(timeZone: .gmt, year: 2025, month: 6, day: 19))!,
            itemValues:
                [
                    NetWorthItemValue(
                        item: sampleAsset,
                        value: 1000
                    ),
                    NetWorthItemValue(
                        item: sampleLiability,
                        value: 0
                    )
                ]
        )
    ]
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

let sampleLiability: NetWorthItem =
NetWorthItem(
    name: "Credit Card",
    isAsset: false
)

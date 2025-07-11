//
//  NetWorthListView.swift
//  Commas
//
//  Created by Nicolas Deleasa on 6/17/25.
//

import SwiftUI

struct NetWorthListView: View
{
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var selectedRange: ItemRange = .assets
    
    let snapshot: Snapshot
    
    @State private var chosenItemValue: NetWorthItemValue?
    
    var body: some View
    {
        VStack
        {
            ListSegmentedPickerView(selectedRange: $selectedRange)
            if selectedRange == .assets
            {
                if snapshot.itemValues.filter({ $0.item.isAsset }).isEmpty
                {
                    ContentUnavailableView("No Assets", systemImage: "chart.bar.doc.horizontal", description: nil)
                }
                else
                {
                    ForEach(snapshot.itemValues.filter({ $0.item.isAsset }).sorted { $0.value > $1.value })
                    { asset in
                        Button(action: {chosenItemValue = asset})
                        {
                            HStack
                            {
                                VStack(alignment: .leading)
                                {
                                    Text(asset.item.name)
                                    Text(formatValue(value: asset.value))
                                        .font(.headline)
                                }
                                Spacer()
                                Image(systemName: "pencil")
                            }
                            .padding()
                            .foregroundStyle(colorScheme == .light ? .black : .white)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.clear)
                                    .stroke(colorScheme == .dark ? .white : .black, lineWidth: 2)
                            )
                        }
                    }
                }
            }
            else
            {
                if snapshot.itemValues.filter({ !$0.item.isAsset }).isEmpty
                {
                    ContentUnavailableView("No Liabilities", systemImage: "chart.bar.doc.horizontal", description: nil)
                }
                else
                {
                    ForEach(snapshot.itemValues.filter({ !$0.item.isAsset }).sorted { $0.value > $1.value })
                    { liability in
                        Button(action: {chosenItemValue = liability})
                        {
                            HStack
                            {
                                VStack(alignment: .leading)
                                {
                                    Text(liability.item.name)
                                    Text(formatValue(value: liability.value))
                                        .font(.headline)
                                }
                                Spacer()
                                Image(systemName: "pencil")
                            }
                            .padding()
                            .foregroundStyle(colorScheme == .light ? .black : .white)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.clear)
                                    .stroke(colorScheme == .dark ? .white : .black, lineWidth: 2)
                            )
                        }
                    }
                }
            }
        }
        .sheet(item: $chosenItemValue)
        { itemValue in
            NetWorthItemValueEditView(itemValue: itemValue, snapshot: snapshot)
        }
    }
}

#Preview
{
    NetWorthListView(snapshot: errorSnapshot)
}



struct ListSegmentedPickerView: View
{
    @Binding var selectedRange: ItemRange
    
    var body: some View
    {
        Picker("Select range", selection: $selectedRange)
        {
            ForEach(ItemRange.allCases)
            { range in
                Text(range.rawValue.capitalized).tag(range)
            }
        }
        .pickerStyle(.segmented)
    }
}

enum ItemRange: String, CaseIterable, Identifiable
{
    case assets, liabilities
    
    var id: String { self.rawValue }
}

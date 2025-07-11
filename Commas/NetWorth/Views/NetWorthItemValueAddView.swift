//
//  NetWorthAddItemView.swift
//  Commas
//
//  Created by Nicolas Deleasa on 6/18/25.
//

import SwiftUI

struct NetWorthItemValueAddView: View
{
    let snapshot: Snapshot
    
    @Environment(\.dismiss) var dismiss
        
    let itemOptions: [String] = ["Asset", "Liability"]
    @State private var selectedItemOption: String = "Asset"
    
    @State private var itemName: String = ""
    @State private var number: CustomNumber = CustomNumber()
    
    var body: some View
    {
        NavigationStack
        {
            GeometryReader
            { geometry in
                List
                {
                    Picker("Type", selection: $selectedItemOption)
                    {
                        ForEach(itemOptions, id: \.self)
                        {
                            Text($0)
                        }
                    }
                    TextField("Name", text: $itemName)
                        .submitLabel(.done)
                    Section
                    {
                        HStack
                        {
                            Spacer()
                            CustomNumberPadView(number: $number, geometry: geometry)
                            Spacer()
                        }
                        .listRowBackground(Color.clear)
                        .buttonStyle(.plain)
                    }
                }
                .navigationTitle(formattedDate(snapshot.date))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar
                {
                    ToolbarItem(placement: .cancellationAction)
                    {
                        Button("Cancel")
                        {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .confirmationAction)
                    {
                        Button("Save")
                        {
                            addItemValue()
                        }
                    }
                }
            }
        }
    }
    
    func addItemValue()
    {
        if selectedItemOption == "Asset"
        {
            snapshot.addItemValue(
                item: NetWorthItem(
                    name: itemName,
                    isAsset: true
                ),
                value: number.int
            )
        }
        else
        {
            snapshot.addItemValue(
                item: NetWorthItem(
                    name: itemName,
                    isAsset: false
                ),
                value: number.int
            )
        }
        
        dismiss()
    }
}

#Preview
{
    NetWorthItemValueAddView(snapshot: errorSnapshot)
}

//
//  NetWorthItemValueEditView.swift
//  Commas
//
//  Created by Nicolas Deleasa on 6/20/25.
//

import SwiftUI

struct NetWorthItemValueEditView: View
{
    @Environment(\.dismiss) var dismiss
    
    let itemValue: NetWorthItemValue
    let snapshot: Snapshot
    
    @State private var name: String
    @State private var number: CustomNumber
    @State private var showSavedView: Bool = false
    
    @State private var presentDeleteAlert: Bool = false
    
    init(itemValue: NetWorthItemValue, snapshot: Snapshot)
    {
        self.itemValue = itemValue
        self.snapshot = snapshot
        
        self.name = itemValue.item.name
        self.number = CustomNumber(int: itemValue.value)
    }
    
    var body: some View
    {
        ZStack
        {
            NavigationStack
            {
                GeometryReader
                { geometry in
                    ZStack
                    {
                        List
                        {
                            TextField("Name", text: $name)
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
                        
                        VStack
                        {
                            Spacer()
                            Button(action: { presentDeleteAlert = true })
                            {
                                Text("Delete")
                                    .foregroundStyle(.red)
                            }
                            .padding(.bottom)
                        }
                        .ignoresSafeArea(.keyboard)
                    }
                }
                .navigationTitle(itemValue.item.isAsset ? "Edit Asset" : "Edit Liability")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar
                {
                    ToolbarItem(placement: .confirmationAction)
                    {
                        Button("Save")
                        {
                            editItemValue()
                        }
                    }
                    ToolbarItem(placement: .cancellationAction)
                    {
                        Button("Cancel")
                        {
                            dismiss()
                        }
                    }
                }
                .alert("Delete this item?", isPresented: $presentDeleteAlert)
                {
                    Button("Cancel", role: .cancel) {}
                    Button("Delete", role: .destructive)
                    {
                        deleteItemValue()
                        dismiss()
                    }
                }
            message:
                {
                    Text("This can't be undone.")
                }
            }
            
            if showSavedView
            {
                NetWorthItemValueSavedView()
                    .transition(.opacity)
            }
        }
    }
    
    func editItemValue()
    {
        snapshot.editItemValue(itemValue: itemValue, name: name, value: number.int)
        
        withAnimation
        {
            showSavedView = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1)
        {
            dismiss()
        }
    }
    
    func deleteItemValue()
    {
        snapshot.deleteItemValue(itemValue: itemValue)
    }
}

#Preview
{
    NetWorthItemValueEditView(itemValue: NetWorthItemValue(item: NetWorthItem(name: "Asset", isAsset: true), value: 100), snapshot: errorSnapshot)
}

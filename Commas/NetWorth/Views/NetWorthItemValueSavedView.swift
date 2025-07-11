//
//  NetWorthItemValueSavedView.swift
//  Commas
//
//  Created by Nicolas Deleasa on 7/11/25.
//

import SwiftUI

struct NetWorthItemValueSavedView: View
{
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View
    {
        GeometryReader
        { geometry in
            ZStack
            {
                if colorScheme == .dark
                {
                    Color.white.opacity(0.3)
                        .ignoresSafeArea()
                }
                else
                {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                }
                VStack
                {
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.green)
                    Text("Saved!")
                        .font(.title)
                }
                .padding()
                .frame(width: geometry.size.width * 0.5, height: geometry.size.width * 0.5)
                .background(RoundedRectangle(cornerRadius: 16).foregroundStyle(colorScheme == .dark ? .black : .white))
            }
        }
    }
}

#Preview
{
    NetWorthItemValueSavedView()
}

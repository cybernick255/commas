//
//  CustomNumberPadView.swift
//  Commas
//
//  Created by Nicolas Deleasa on 6/18/25.
//

import SwiftUI

struct CustomNumberPadView: View
{
    @Binding var number: CustomNumber
    let geometry: GeometryProxy
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View
    {
        HStack
        {
            Spacer()
            VStack(spacing: geometry.size.width * 0.05)
            {
                Text(number.string)
                HStack(spacing: geometry.size.width * 0.05)
                {
                    Button(action: { number.appendDigit(1) })
                    {
                        Text("1")
                            .modifierNumberPadKey(geometry: geometry, colorScheme: colorScheme)
                    }
                        
                    Button(action: { number.appendDigit(2) })
                    {
                        Text("2")
                            .modifierNumberPadKey(geometry: geometry, colorScheme: colorScheme)
                    }
                    Button(action: { number.appendDigit(3) })
                    {
                        Text("3")
                            .modifierNumberPadKey(geometry: geometry, colorScheme: colorScheme)
                    }
                }
                HStack(spacing: geometry.size.width * 0.05)
                {
                    Button(action: { number.appendDigit(4) })
                    {
                        Text("4")
                            .modifierNumberPadKey(geometry: geometry, colorScheme: colorScheme)
                    }
                    Button(action: { number.appendDigit(5) })
                    {
                        Text("5")
                            .modifierNumberPadKey(geometry: geometry, colorScheme: colorScheme)
                    }
                    Button(action: { number.appendDigit(6) })
                    {
                        Text("6")
                            .modifierNumberPadKey(geometry: geometry, colorScheme: colorScheme)
                    }
                }
                HStack(spacing: geometry.size.width * 0.05)
                {
                    Button(action: { number.appendDigit(7) })
                    {
                        Text("7")
                            .modifierNumberPadKey(geometry: geometry, colorScheme: colorScheme)
                    }
                    Button(action: { number.appendDigit(8) })
                    {
                        Text("8")
                            .modifierNumberPadKey(geometry: geometry, colorScheme: colorScheme)
                    }
                    Button(action: { number.appendDigit(9) })
                    {
                        Text("9")
                            .modifierNumberPadKey(geometry: geometry, colorScheme: colorScheme)
                    }
                }
                HStack(spacing: geometry.size.width * 0.05)
                {
                    Button(action: { number.togglePositiveNegative() })
                    {
                        Image(systemName: "plus.forwardslash.minus")
                            .modifierNumberPadKey(geometry: geometry, colorScheme: colorScheme)
                    }
                    Button(action: { number.appendDigit(0) })
                    {
                        Text("0")
                            .modifierNumberPadKey(geometry: geometry, colorScheme: colorScheme)
                    }
                    Button(action: { number.deleteLastDigit() })
                    {
                        Image(systemName: "chevron.left")
                            .modifierNumberPadKey(geometry: geometry, colorScheme: colorScheme)
                    }
                }
            }
            Spacer()
        }
    }
}

//#Preview
//{
//    CustomNumberPadView(number: .constant(CustomNumber()), geometry: <#GeometryProxy#>)
//}



struct CustomNumber
{
    private(set) var int: Int
    private(set) var string: String
    
    init(int: Int = 0)
    {
        self.int = int
        self.string = formatValue(value: int)
    }
    
    mutating func deleteLastDigit()
    {
        int /= 10
        self.string = formatValue(value: int)
        triggerHaptic(.selection)
        print(int)
    }
    
    mutating func togglePositiveNegative()
    {
        if int == 0
        {
            return
        }
        else
        {
            int *= -1
            self.string = formatValue(value: int)
        }
        triggerHaptic(.selection)
    }
    
    mutating func appendDigit(_ digit: Int)
    {
        // Prevent users from exceeding 1 quadrillion ($10 trillion).
        // Seems that a number with 20 digits crashes preview.
        if int * 10 >= 1_000_000_000_000_000
        {
            return
        }
        
        if int == 0
        {
            int = digit
            self.string = formatValue(value: int)
        }
        else
        {
            int *= 10
            if int > 0
            {
                int += digit
            }
            else
            {
                int -= digit
            }
            self.string = formatValue(value: int)
        }
        triggerHaptic(.selection)
    }
}



extension View
{
    func modifierNumberPadKey(geometry: GeometryProxy, colorScheme: ColorScheme) -> some View
    {
        self
            .font(.title2)
            .fontWeight(.medium)
            .frame(width: geometry.size.width * 0.2, height: geometry.size.width * 0.15)
            .background(RoundedRectangle(cornerRadius: 16).foregroundStyle(colorScheme == .dark ? .black : .white))
    }
}

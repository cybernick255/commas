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
    
    var body: some View
    {
        HStack
        {
            Spacer()
            VStack
            {
                Text(number.string)
                HStack
                {
                    Button(action: { number.appendDigit(1) })
                    {
                        Text("1")
                            .frame(width: geometry.size.width * 0.3, height: geometry.size.width * 0.15)
                    }
                        
                    Button(action: { number.appendDigit(2) })
                    {
                        Text("2")
                            .frame(width: geometry.size.width * 0.3, height: geometry.size.width * 0.15)
                    }
                    Button(action: { number.appendDigit(3) })
                    {
                        Text("3")
                            .frame(width: geometry.size.width * 0.3, height: geometry.size.width * 0.15)
                    }
                }
                HStack
                {
                    Button(action: { number.appendDigit(4) })
                    {
                        Text("4")
                            .frame(width: geometry.size.width * 0.3, height: geometry.size.width * 0.15)
                    }
                    Button(action: { number.appendDigit(5) })
                    {
                        Text("5")
                            .frame(width: geometry.size.width * 0.3, height: geometry.size.width * 0.15)
                    }
                    Button(action: { number.appendDigit(6) })
                    {
                        Text("6")
                            .frame(width: geometry.size.width * 0.3, height: geometry.size.width * 0.15)
                    }
                }
                HStack
                {
                    Button(action: { number.appendDigit(7) })
                    {
                        Text("7")
                            .frame(width: geometry.size.width * 0.3, height: geometry.size.width * 0.15)
                    }
                    Button(action: { number.appendDigit(8) })
                    {
                        Text("8")
                            .frame(width: geometry.size.width * 0.3, height: geometry.size.width * 0.15)
                    }
                    Button(action: { number.appendDigit(9) })
                    {
                        Text("9")
                            .frame(width: geometry.size.width * 0.3, height: geometry.size.width * 0.15)
                    }
                }
                HStack
                {
                    Button(action: { number.togglePositiveNegative() })
                    {
                        Image(systemName: "plus.forwardslash.minus")
                            .frame(width: geometry.size.width * 0.3, height: geometry.size.width * 0.15)
                    }
                    Button(action: { number.appendDigit(0) })
                    {
                        Text("0")
                            .frame(width: geometry.size.width * 0.3, height: geometry.size.width * 0.15)
                    }
                    Button(action: { number.deleteLastDigit() })
                    {
                        Image(systemName: "chevron.left")
                            .frame(width: geometry.size.width * 0.3, height: geometry.size.width * 0.15)
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
    }
}

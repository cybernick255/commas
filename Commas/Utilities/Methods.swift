//
//  Methods.swift
//  Commas
//
//  Created by Nicolas Deleasa on 6/17/25.
//

import Foundation

// MARK: Net Worth

func formatValue(value: Int?) -> String
{
    if let value = value
    {
        return (Decimal(value) * 0.01).formatted(.currency(code: "USD"))
    }
    else
    {
        return "N/A"
    }
}

func formattedDate(_ date: Date) -> String
{
    let formatter = DateFormatter()
    
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    formatter.timeZone = .gmt
    
    return formatter.string(from: date)
}

func monthName(from number: Int) -> String
{
    let formatter = DateFormatter()
    formatter.locale = Locale.current
    return formatter.monthSymbols[number - 1]
}

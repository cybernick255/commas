//
//  NetWorthItemValue.swift
//  Commas
//
//  Created by Nicolas Deleasa on 6/20/25.
//

import Foundation
import SwiftData

@Model
class NetWorthItemValue
{
    @Relationship var item: NetWorthItem
    var value: Int // In cents
    
    init(item: NetWorthItem, value: Int)
    {
        self.item = item
        self.value = value
    }
}

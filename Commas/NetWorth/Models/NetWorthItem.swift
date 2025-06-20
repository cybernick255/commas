//
//  NetWorthItem.swift
//  Commas
//
//  Created by Nicolas Deleasa on 6/19/25.
//

import Foundation
import SwiftData

@Model
class NetWorthItem
{
    var name: String
    var isAsset: Bool
    
    init(name: String, isAsset: Bool)
    {
        self.name = name
        self.isAsset = isAsset
    }
}

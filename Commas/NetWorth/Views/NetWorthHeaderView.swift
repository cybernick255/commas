//
//  NetWorthHeaderView.swift
//  Commas
//
//  Created by Nicolas Deleasa on 6/17/25.
//

import SwiftUI

struct NetWorthHeaderView: View
{
    let snapshot: Snapshot
    
    var body: some View
    {
        HStack
        {
            VStack(alignment: .leading)
            {
                Text("Net Worth")
                    .font(.title2)
                Text(formatValue(value: snapshot.netWorth))
                    .font(.largeTitle)
                    .lineLimit(1)
            }
            Spacer()
        }
    }
}

#Preview
{
    NetWorthHeaderView(snapshot: errorSnapshot)
}

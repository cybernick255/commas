//
//  ProfileView.swift
//  Commas
//
//  Created by Nicolas Deleasa on 6/24/25.
//

import SwiftUI

struct ProfileView: View
{
    var body: some View
    {
        NavigationStack
        {
            Text("Profile View")
                .toolbar
                {
                    ToolbarItem(placement: .topBarLeading)
                    {
                        NavigationLink(destination: SettingsView(), label: {Label("Settings", systemImage: "gear")})
                    }
                }
        }
    }
}

#Preview
{
    ProfileView()
}

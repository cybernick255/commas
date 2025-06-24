//
//  SettingsView.swift
//  Commas
//
//  Created by Nicolas Deleasa on 6/24/25.
//

import SwiftUI

struct SettingsView: View
{
    var body: some View
    {
        List
        {
            Section
            {
                NavigationLink("Notifications")
                {
                    NotificationsView()
                }
            }
            Section
            {
                VersionView()
            }
            .listRowBackground(Color.clear)
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private struct VersionView: View
    {
        let appVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        let buildNumber: String = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
        
        var body: some View
        {
            HStack
            {
                Spacer()
                Text("Version: \(appVersion)")
                if let buildNumberInt = Int(buildNumber)
                {
                    if buildNumberInt > 1
                    {
                        Text("(\(buildNumber))")
                    }
                }
                Spacer()
            }
            .foregroundStyle(.gray)
        }
    }
}

#Preview
{
    NavigationStack
    {
        SettingsView()
    }
}

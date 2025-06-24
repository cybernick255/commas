//
//  NotificationsView.swift
//  Commas
//
//  Created by Nicolas Deleasa on 6/24/25.
//

import SwiftUI
import UserNotifications

struct NotificationsView: View
{
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var notificationsAllowed: Bool = false
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = false
    @AppStorage("dailyReminderTime") private var dailyReminderTime: Date = Calendar.current.date(bySettingHour: 19, minute: 0, second: 0, of: Date()) ?? Date()
    
    var body: some View
    {
        List
        {
            Section
            {
                NotificationsStatusView(notificationsAllowed: $notificationsAllowed, notificationsEnabled: $notificationsEnabled)
            }
            Section
            {
                DatePicker("Daily Reminder", selection: $dailyReminderTime, displayedComponents: .hourAndMinute)
                    .disabled(notificationsAllowed == false || notificationsEnabled == false)
            }
        footer:
            {
                HStack
                {
                    Spacer()
                    EarthTimeView(dailyReminderTime: $dailyReminderTime)
                }
            }
            .opacity(notificationsAllowed && notificationsEnabled ? 1.0 : 0.5)
        }
        .onAppear(perform: requestAuthorization)
        .onChange(of: scenePhase, scenePhaseUpdate)
        .onChange(of: dailyReminderTime, setDailyReminderTime)
        .onChange(of: notificationsEnabled, updateNotificationRequests)
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func requestAuthorization()
    {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
        { success, error in
            if success
            {
                notificationsAllowed = true
                removeDeliveredNotificationRequests()
                print("Notification on.")
            }
            else if let error
            {
                notificationsAllowed = false
                removePendingNotificationRequests()
                print(error.localizedDescription)
            }
            else
            {
                notificationsAllowed = false
                removePendingNotificationRequests()
                print("success == false, error == nil.")
            }
        }
    }
    
    func scenePhaseUpdate()
    {
        if scenePhase == .active
        {
            requestAuthorization()
            print("Scene is active!")
        }
    }
    
    func setDailyReminderTime()
    {
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        
        dateComponents.hour = Calendar.current.component(.hour, from: dailyReminderTime)
        dateComponents.minute = Calendar.current.component(.minute, from: dailyReminderTime)
        
        // Show this notification every day at this time
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let content = UNMutableNotificationContent()
        content.title = "Commas"
        content.subtitle = "Time to log your commas!"
        content.sound = UNNotificationSound.default
        
        // Choose identifier
        let identifier = "dailyReminderTime"
        
        // Create the request
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        // Remove pending notification requests
        removePendingNotificationRequests(withIdentifiers: [identifier])
        
        // Schedule the request with the system
        let notificationCenter = UNUserNotificationCenter.current()
        
        // Add our notification request
        notificationCenter.add(request)
    }
    
    func removePendingNotificationRequests(withIdentifiers: [String] = ["dailyReminderTime"])
    {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: withIdentifiers)
    }
    
    func removeDeliveredNotificationRequests(withIdentifiers: [String] = ["dailyReminderTime"])
    {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: withIdentifiers)
    }
    
    func updateNotificationRequests()
    {
        let identifiers = ["dailyReminderTime"]
        
        if notificationsEnabled
        {
            setDailyReminderTime()
        }
        else
        {
            removePendingNotificationRequests(withIdentifiers: identifiers)
        }
    }
    
    private struct NotificationsStatusView: View
    {
        @Environment(\.colorScheme) private var colorScheme
        
        @Binding var notificationsAllowed: Bool
        @Binding var notificationsEnabled: Bool
        
        var body: some View
        {
            if notificationsAllowed
            {
                Toggle("Allow Notifications", isOn: $notificationsEnabled)
            }
            else
            {
                Button(action: openAppSettings)
                {
                    HStack
                    {
                        Text("Allow Notifications")
                        Spacer()
                        Toggle("Allow Notifications", isOn: .constant(false))
                            .disabled(true)
                            .labelsHidden()
                    }
                    .foregroundStyle(colorScheme == .light ? Color.black : Color.white)
                }
            }
        }
        
        func openAppSettings()
        {
            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url)
            {
                UIApplication.shared.open(url)
            }
        }
    }
    
    private struct EarthTimeView: View
    {
        @Binding var dailyReminderTime: Date
        
        @State private var earthTime: String = ""
        
        var body: some View
        {
            Text("Earth Time: \(earthTime)")
                .onAppear(perform: convertDateToEarthTime)
                .onChange(of: dailyReminderTime, convertDateToEarthTime)
        }
        
        func convertDateToEarthTime()
        {
            let formatter = DateFormatter()
                formatter.timeZone = TimeZone(secondsFromGMT: 0) // UTC
                formatter.dateStyle = .none
                formatter.timeStyle = .short
                
                earthTime = formatter.string(from: dailyReminderTime)
        }
    }
}

#Preview
{
    NotificationsView()
}

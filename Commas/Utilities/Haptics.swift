//
//  Haptics.swift
//  Commas
//
//  Created by Nicolas Deleasa on 7/11/25.
//

import UIKit

enum HapticType
{
    case impact(style: UIImpactFeedbackGenerator.FeedbackStyle)
    case notification(type: UINotificationFeedbackGenerator.FeedbackType)
    case selection
}

func triggerHaptic(_ type: HapticType)
{
    switch type
    {
    case .impact(let style):
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    case .notification(let feedbackType):
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(feedbackType)
    case .selection:
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}

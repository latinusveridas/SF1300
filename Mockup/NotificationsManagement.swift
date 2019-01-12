//
//  Notifications.swift
//  Mockup
//
//  Created by Quentin Duquesne on 12/01/2019.
//  Copyright © 2019 Quentin Duquesne. All rights reserved.
//

import UserNotifications

class NotifSetup {

    func CreateSuccessLoginNotif() {
    
        //creating the notification content
        let content = UNMutableNotificationContent()

        //adding title, subtitle, body and badge
        content.title = "Bienvenue sur StreetFit"
        content.subtitle = ""
        content.body = "Vous êtes désormais connecté à StreetFit"
        content.badge = 0

        //getting the notification trigger
        //it will be called after 5 seconds
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        //getting the notification request
        let request = UNNotificationRequest(identifier: "SuccessLoginNotif", content: content, trigger: trigger)

        //adding the notification to notification center
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)

    }
}

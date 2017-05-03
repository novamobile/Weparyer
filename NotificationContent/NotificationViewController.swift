//
//  NotificationViewController.swift
//  NotificationContent
//
//  Created by Jeccy on 17/1/23.
//  Copyright © 2017年 Jeccy. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import AVFoundation

class NotificationViewController: UIViewController,UNNotificationContentExtension{
    
    var audioPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = CGRectMake(0, 0, 320, 100)
    }
    
    func didReceive(notification: UNNotification) {
        let dic = notification.request.content.userInfo
        print("收到的内容:",dic)
    }

    func didReceiveNotification(notification: UNNotification) {
        let dic = notification.request.content.userInfo
        print("收到的内容:",dic)
        let name = dic["key"] as! String
        playSound(name)
    }

    func playSound(soundName:String) {
        let str =  soundName.componentsSeparatedByString(".")
        let musicPath = NSBundle.mainBundle().pathForResource("\(str[0])", ofType: "\(str[1])")
        let url = NSURL(fileURLWithPath: musicPath!)
        do {
            try self.audioPlayer = AVAudioPlayer(contentsOfURL: url)
        } catch {
            print("could not create AVAudioPlayer \(error)")
            return
        }
        self.audioPlayer.volume = 0.75
        
        self.audioPlayer.play()
        
    }
    
}

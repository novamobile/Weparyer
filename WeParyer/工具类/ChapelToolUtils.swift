//
//  ChapelToolUtils.swift
//  chapel
//
//  Created by Jacy on 16/4/21.
//  Copyright © 2016年 Jacy. All rights reserved.
//

import UIKit
import AVFoundation
class ChapelToolUtils: NSObject,AVAudioPlayerDelegate,UIAlertViewDelegate {
    
    
    var audioPlayer: AVAudioPlayer!
    let names = ["fajr":ChapelToolUtils.getLocalizedStr("key_fajr"),
                 "sunrise":ChapelToolUtils.getLocalizedStr("key_sunrise"),
                 "dhuhr":ChapelToolUtils.getLocalizedStr("key_dhuhr"),
                 "asr":ChapelToolUtils.getLocalizedStr("key_asr"),
                 "maghrib":ChapelToolUtils.getLocalizedStr("key_maghrib"),
                 "ishaa":ChapelToolUtils.getLocalizedStr("key_ishaa")]

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

    //设置用户信息
   class func setUserInformation(key:String,value:AnyObject) {
        NSUserDefaults.standardUserDefaults().setObject(value, forKey: key)
    }
    //获取用户设置的信息
   class func getUserInformation(key:String) -> AnyObject {
        return NSUserDefaults.standardUserDefaults().objectForKey(key)!
    }

    class func getLocalizedStr(str:String) -> String
    {
        let prayTime = PrayTime()
        return prayTime.DPLocalizedString(str)
    }
    
    class func getAllSound() ->[String]
    {
        let Sounds = [
            "Al-Affassi.mp3",
            "Fajr Malek Chebae.mp3",
            "Hamad Degheri.mp3",
            "Mansour-Az-Zahrani-Fajr-Intro.mp3",
            "Nasser Al Qatami.mp3",
            "Youssef Maati.mp3",
            "Egypt.mp3",
            "Fatih Seferagic.mp3",
            "Wadii Hamadi.mp3",
            "Bilal.mp3",
            "Bosnie.mp3",
            "Abdelmajid.mp3",
            "Maroc.mp3",
            ]
        return Sounds
    }
    
    func showAlertController(userInfo : NSDictionary) {
        //let notification = sender as! NSNotification
        //let userInfo = notification.userInfo! as NSDictionary
        let view = IMStrandsViewController()
        let keyStr = userInfo.valueForKey("key") as! String
        let message1 =  names[keyStr]
        let selectSoundIndex = NSUserDefaults.standardUserDefaults().integerForKey(keyStr + "sound")
        if selectSoundIndex >= 0 && selectSoundIndex < ChapelToolUtils.getAllSound().count {
            if(selectSoundIndex > 0 && selectSoundIndex <= ChapelToolUtils.getAllSound().count)
            {
                let soundName = ChapelToolUtils.getAllSound()[selectSoundIndex-1]
                playSound(soundName)
                view.musicName = soundName
            }
            else{
                return
            }
        }
        else{
            return
        }
        let alertController = UIAlertController(title: ChapelToolUtils.getLocalizedStr("key_AthanAlarm"), message: message1, preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: ChapelToolUtils.getLocalizedStr("key_stopAthan"), style: .Cancel) { (alertAction: UIAlertAction)->() in
            print("TODO")
            if(self.audioPlayer != nil)
            {
                self.audioPlayer.stop()
                view.stopMusic()
                view.dismissViewControllerAnimated(true, completion: nil)
            }
        }

        //修改title
        let alertControllerStr = NSMutableAttributedString.init(string: ChapelToolUtils.getLocalizedStr("key_AthanAlarm"))
        alertControllerStr.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(16), range: NSMakeRange(0, ChapelToolUtils.getLocalizedStr("key_AthanAlarm").characters.count))
        alertController.setValue(alertControllerStr, forKey: "attributedTitle")
        
        //修改message
        let alertControllerMessageStr = NSMutableAttributedString.init(string: message1!)
        alertControllerMessageStr.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(18), range: NSMakeRange(0, (message1?.characters.count)!))
        alertController.setValue(alertControllerMessageStr, forKey: "attributedMessage")
        
        alertController.addAction(cancelAction)
        view.customTitle = message1;
        view.customKey = keyStr;
//        let nav = UINavigationController(rootViewController: view)
        UIApplication.sharedApplication().keyWindow?.rootViewController!.presentViewController(alertController, animated: true) {}
//        view.presentViewController(alertController, animated: true, completion: nil)
    }
    
}

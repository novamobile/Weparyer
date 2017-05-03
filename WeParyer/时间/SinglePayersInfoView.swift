//
//  SinglePayersInfoVIew.swift
//  chapel
//
//  Created by Jeccy on 16/5/8.
//  Copyright © 2016年 Jacy. All rights reserved.
//

import UIKit
import AVFoundation

class SinglePayersInfoView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var img_paryerName: UIImageView!
    @IBOutlet weak var payersNameLabel: UILabel!
    @IBOutlet weak var payersTimeLabel: UILabel!
//    @IBOutlet weak var payersSoundName: UILabel!

    @IBOutlet var imageLayoutXPrecent: NSLayoutConstraint!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var grayView: UIView!

    @IBOutlet var topLineView: UIView!
    @IBOutlet var contentView: UIView!
    
    var spayerskey : String!
    var payersName : String!
    var paryerTime : String = ""
    var notice : UILocalNotification? = nil
    var isNextNoticeCell : Bool = false
    var willAddParyerTime : Int = 0
    var chapelToolUtils = ChapelToolUtils()
//    var is12HoursStyle : Bool = false
    
    @IBOutlet weak var soundSwitch: UISwitch!
//    let images = [
//        "fajr":"img_fajr",
//        "sunrise":"img_sunrise",
//        "dhuhr":"img_dhuhr",
//        "asr":"img_asr",
//        "maghrib":"img_maghrib",
//        "ishaa":"img_ishaa"
//    ]
    let soundShotName = [
        "key_Shot_Al-Affassi",
        "key_Shot_Fajr Malek Chebae",
        "key_Shot_Hamad Degheri",
        "key_Shot_Mansour-Az-Zahrani-Fajr-Intro",
        "key_Shot_Nasser Al Qatami",
        "key_Shot_Youssef Maati",
        "key_Shot_Egypt",
        "key_Shot_Fatih Seferagic",
        "key_Shot_Wadii Hamadi",
        "key_Shot_Bilal",
        "key_Shot_Bosnie",
        "key_Shot_Abdelmajid",
        "key_Shot_Maroc",
    ]
    let timeArab = [
        "0":"٠",
        "1":"١",
        "2":"٢",
        "3":"٣",
        "4":"٤",
        "5":"٥",
        "6":"٦",
        "7":"٧",
        "8":"٨",
        "9":"٩",
    ]
    
    //初始化工具类
    let prayTime = PrayTime()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialFromXib(frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initialFromXib(newFrame: CGRect) {
        self.frame = newFrame
        self.setNeedsUpdateConstraints()
        self.updateConstraints()
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "SinglePayersInfo", bundle: bundle)
        contentView = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        contentView.frame = bounds
        addSubview(contentView)
        
//        grayView.hidden = true
        payersTimeLabel.textColor = UIColor.blackColor()
        payersNameLabel.textColor = UIColor.blackColor()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(self.notificationReceive(_:)),
                                                         name: "revicePayersTimesNotification", object: nil)
        
//        payersSoundName.hidden = true
        var cornerSize = CGSizeMake(25, 25)
        if(UIScreen.mainScreen().bounds.size.width <= 320)
        {
            cornerSize = CGSizeMake(15, 15)
            if IS_ARB{
                payersTimeLabel.font = UIFont(name: CUSTOM_ARABIC_FONT, size: 17)
                payersNameLabel.font = UIFont(name: CUSTOM_ARABIC_FONT, size: 17)
            }
            else{
//                payersTimeLabel.font = UIFont.boldSystemFontOfSize(20)
                payersTimeLabel.font = UIFont.systemFontOfSize(14)
                payersNameLabel.font = UIFont.systemFontOfSize(14)
            }
        }
        
        self.backgroundColor = UIColor.clearColor()
//        let maskPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: .AllCorners, cornerRadii: cornerSize)
//        let maskLayer = CAShapeLayer.init()
//        maskLayer.frame = self.bounds
//        maskLayer.path = maskPath.CGPath
//        self.layer.mask = maskLayer
        print("是否是24小时制:",Is12HoursStyle(),imageLayoutXPrecent.multiplier)
        self.performSelector(#selector(SinglePayersInfoView.changeImagePosition(_:)), withObject: nil, afterDelay: 0.01)
        contentView.hidden = true
    }
    
    func changeImagePosition(sender:AnyObject) {
        if IS_ARB {
            if(UIScreen.mainScreen().bounds.size.width >= 414)
            {
                imageLayoutXPrecent.constant = 0.142*414
            }
            else if(UIScreen.mainScreen().bounds.size.width < 414 && UIScreen.mainScreen().bounds.size.width > 320){
                imageLayoutXPrecent.constant = 0.128*375
            }
            else if(UIScreen.mainScreen().bounds.size.width <= 320){
                imageLayoutXPrecent.constant = 0.12*320
            }
        }
        else{
            if(UIScreen.mainScreen().bounds.size.width >= 414)
            {
                imageLayoutXPrecent.constant = 0.126*414
            }
            else if(UIScreen.mainScreen().bounds.size.width < 414 && UIScreen.mainScreen().bounds.size.width > 320){
                imageLayoutXPrecent.constant = 0.135*375
            }
            else if(UIScreen.mainScreen().bounds.size.width <= 320){
                imageLayoutXPrecent.constant = 0.132*320
            }
        }

        contentView.hidden = false
    }
    
    @IBAction func soundSelectClick(sender: AnyObject) {
        if(paryerTime == "")
        {
            return
        }
        let addParyerTime = NSUserDefaults.standardUserDefaults().integerForKey(spayerskey + "i_time")
        
        let date = NSDate()
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let prefixDate = dateFormatter.stringFromDate(date) as String
        let noticeTime = prefixDate + " \(paryerTime)"
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm"
        let noticeDate =  dateFormatter.dateFromString(noticeTime)
        
        let newNoticeTime = NSTimeInterval((noticeDate?.timeIntervalSince1970)!) + NSTimeInterval(Double(addParyerTime)*60.0)
        
        let d = NSDate(timeIntervalSince1970: newNoticeTime)
        dateFormatter.dateFormat = "HH:mm"
        var timeRes = dateFormatter.stringFromDate(d)
        let isOpen = NSUserDefaults.standardUserDefaults().boolForKey(spayerskey + "handAdjustOpen")
        if isOpen {
            timeRes = paryerTime
        }
        
        let userInfo:Dictionary<String,String> = ["key":spayerskey,"time":timeRes]
        NSNotificationCenter.defaultCenter().postNotificationName("pushToSoundSelectViewNotification", object: nil, userInfo: userInfo)
    }
    @IBAction func soundSwitchClick(sender: AnyObject) {
//        if !soundSwitch.on && self.notice != nil
//        {
//            UIApplication.sharedApplication().cancelLocalNotification(self.notice!)
//        }
//        NSUserDefaults.standardUserDefaults().setBool(soundSwitch.on, forKey: spayerskey)
//        if (paryerTime != "") {
//            handlerLocalNotification(paryerTime,isAuto: false)
//        }
        
    }
    func setPayersInfo(key : String, name: String) {
        spayerskey = key
        payersName = name
        payersNameLabel.text = payersName
        
        if spayerskey == "fajr" {
            topLineView.hidden = false
        }
        else{
            topLineView.hidden = true
        }
        
//        let remind =  NSUserDefaults.standardUserDefaults().boolForKey(spayerskey)
//        if remind == true {
//            soundSwitch.setOn(true, animated: true)
//        }else{
//            soundSwitch.setOn(false, animated: true)
//        }
//        self.img_paryerName.image = UIImage(named: self.images[spayerskey]!)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(self.refreshParyerWillAddTime(_:)),
                                                         name: spayerskey + "Notification", object: nil)
//        willAddParyerTime = NSUserDefaults.standardUserDefaults().integerForKey(spayerskey + "i_time")
        
        let isOpen = NSUserDefaults.standardUserDefaults().boolForKey(spayerskey + "handAdjustOpen")
        if isOpen {
            willAddParyerTime = NSUserDefaults.standardUserDefaults().integerForKey(spayerskey + "i_time")
        }
        else{
            willAddParyerTime = 0
        }
        
//        let selectSoundIndex = NSUserDefaults.standardUserDefaults().integerForKey(spayerskey + "sound")
//        payersSoundName.text = ChapelToolUtils.getLocalizedStr(soundShotName[selectSoundIndex])
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(self.RefreshNotificationFullAthan(_:)),
                                                         name: spayerskey + "NotificationFullAthanSound", object: nil)
    }
    
    func RefreshNotificationFullAthan(sender :NSNotification) {
//        let selectSoundIndex = NSUserDefaults.standardUserDefaults().integerForKey(spayerskey + "sound")
//        payersSoundName.text = ChapelToolUtils.getLocalizedStr(soundShotName[selectSoundIndex])
    }
    
    func setPayersTime(time : String) {
        paryerTime = time
        let time_str = Handle12HoursStyle(paryerTime)
        print("Handle12HoursStyle",time_str)
        if Is12HoursStyle() {
            let stringCount = time_str.characters.count
            print("StringCount = %1d",stringCount)
            
            let attributeString = NSMutableAttributedString(string:time_str)
            let font_size = payersTimeLabel.font.pointSize
            if IS_ARB{
                attributeString.addAttribute(NSFontAttributeName, value: UIFont(name: CUSTOM_ARABIC_FONT, size: 15)!,
                                             range: NSMakeRange(stringCount-1,1))
                attributeString.addAttribute(NSFontAttributeName, value: UIFont(name: CUSTOM_ARABIC_FONT, size: 17)!,
                                             range: NSMakeRange(0,stringCount-1))
                let stringCount2 = payersNameLabel.text?.characters.count
                let attributeString2 = NSMutableAttributedString(string:payersNameLabel.text!)
                attributeString2.addAttribute(NSFontAttributeName, value: UIFont(name: CUSTOM_ARABIC_FONT, size: 17)!,
                                              range: NSMakeRange(0,stringCount2!))
                payersNameLabel.attributedText = attributeString2
            }
            else{
                attributeString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(font_size/2),
                                             range: NSMakeRange(stringCount-2,2))
            }
            payersTimeLabel.attributedText = attributeString
//            payersTimeLabel.font = UIFont(name: "AdobeArabic-Bold", size: 50)
//            payersNameLabel.font = UIFont(name: "AdobeArabic-Regular", size: 22)
        }else{
            if IS_ARB{
                payersTimeLabel.font = UIFont(name: CUSTOM_ARABIC_FONT, size: 17)
                payersNameLabel.font = UIFont(name: CUSTOM_ARABIC_FONT, size: 17)
            }
            payersTimeLabel.text = time_str
        }
        saveDataTodayByNSUserDefaults(time, key: spayerskey)
        print("payersTimeLabel.text",time_str)
        handlerLocalNotification(time,isAuto: true)
    }
    
    func updateFrame(newFrame : CGRect) {
        self.frame = newFrame
        
        print("newFrame",newFrame)
        
        for constrains in self.constraints {
            if constrains.firstAttribute == .Height {
                constrains.constant = self.frame.size.height/2
                constrains.secondItem?.updateConstraints()
            }
        }
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 6.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.orangeColor().CGColor
        
        let lineFrame = CGRectMake(30, self.frame.size.height - 1, self.frame.size.width-30, 1.0)
        print("lineView",lineFrame)
        let lineView = UIView(frame: lineFrame)
        lineView.backgroundColor = UIColor.init(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        self.addSubview(lineView)
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    func refreshParyerWillAddTime(sender :NSNotification) {
        if (paryerTime != "") {
            var addTime = 0
            if willAddParyerTime != 0 {
                addTime = -willAddParyerTime
            }
            let isOpen = NSUserDefaults.standardUserDefaults().boolForKey(spayerskey + "handAdjustOpen")
            if isOpen {
                willAddParyerTime = NSUserDefaults.standardUserDefaults().integerForKey(spayerskey + "i_time")
            }
            else{
                willAddParyerTime = 0
            }
            
            handleParyerTime(paryerTime, lastAddTime: addTime)
        }
    }
    
    func handleParyerTime(timeStr : String, lastAddTime : Int) {
        print("changeBefore",spayerskey,timeStr,willAddParyerTime)
        let date = NSDate()
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let prefixDate = dateFormatter.stringFromDate(date) as String
        let noticeTime = prefixDate + " \(timeStr)"
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm"
        let noticeDate =  dateFormatter.dateFromString(noticeTime)
        
        let newNoticeTime = NSTimeInterval((noticeDate?.timeIntervalSince1970)!) + NSTimeInterval(Double(willAddParyerTime+lastAddTime)*60.0)
        
        let d = NSDate(timeIntervalSince1970: newNoticeTime)
        dateFormatter.dateFormat = "HH:mm"
        setPayersTime(dateFormatter.stringFromDate(d))
        handleIsWillStartParyer(newNoticeTime)
        print("changeAfter",paryerTime)
    }
    
    func handleIsWillStartParyer(seconds : Double) -> Bool
    {
        var res = false
        let curTimeSeconds = NSDate().timeIntervalSince1970
        let interval = curTimeSeconds - seconds
        if(interval > 0 && interval < 120)
        {
            //let notification =  UILocalNotification()
            let userInfo =  NSDictionary.init(object: spayerskey, forKey: "key")
/*            notification.userInfo = userInfo as [NSObject : AnyObject]
            let soundFlag = NSUserDefaults.standardUserDefaults().integerForKey(spayerskey + "push_sound")
            let isOpen = NSUserDefaults.standardUserDefaults().boolForKey(spayerskey+"push_sound_switch")
            if soundFlag == 0 && isOpen {
                NSNotificationCenter.defaultCenter().postNotificationName("reviceNotification", object: nil, userInfo: notification.userInfo)
            }
             */
            let isOpen = NSUserDefaults.standardUserDefaults().boolForKey(spayerskey+"push_sound_switch")
            if(isOpen == true)
            {
                chapelToolUtils.showAlertController(userInfo)
            }
            res = true
        }
        return res
    }
    
    func setLineViewHidden(isHidden : Bool) {
//        self.lineView.hidden = isHidden
    }
    
    func handlerLocalNotification(time : String,isAuto : Bool) {
        if self.notice != nil {
            UIApplication.sharedApplication().cancelLocalNotification(self.notice!)
        }
        let isOpen = NSUserDefaults.standardUserDefaults().boolForKey(spayerskey+"push_sound_switch")
        if(isOpen == false)
        {
            return
        }
        
        let date = NSDate()
        var  dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let prefixDate = dateFormatter.stringFromDate(date) as String
        let noticeTime = prefixDate + " \(time)"
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm"
        let noticeDate =  dateFormatter.dateFromString(noticeTime)
        //        let specificTime = dateFormatter.stringFromDate(NSDate()) as String
        //        let specificDate =  dateFormatter.dateFromString(specificTime)
        print(noticeDate?.timeIntervalSince1970 )
        //如果要通知的话
        let notification =  UILocalNotification()
        notification.fireDate = noticeDate
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.repeatInterval = NSCalendarUnit.Day
        //let flag =  true//NSUserDefaults.standardUserDefaults().boolForKey(spayerskey)
        let soundFlag = NSUserDefaults.standardUserDefaults().integerForKey(spayerskey + "push_sound")
        
        if soundFlag == 0 {
            notification.soundName = "pushSound.aiff"///ChapelToolUtils.getAllSound()[selectSoundIndex]
            notification.alertBody = ChapelToolUtils.getLocalizedStr("key_timeTo"+spayerskey)
        }
        else if soundFlag == 1 {
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.alertBody = ChapelToolUtils.getLocalizedStr("key_timeToSimple"+spayerskey)
        }
        else {
            notification.soundName = ""
            notification.alertBody = ChapelToolUtils.getLocalizedStr("key_timeToSimple"+spayerskey)
        }
        
//        notification.alertBody = ChapelToolUtils.getLocalizedStr("key_timeTo"+spayerskey)
        notification.alertAction = NSLocalizedString(ChapelToolUtils.getLocalizedStr("key_startPary"), comment:"")
        notification.applicationIconBadgeNumber = 1
        let userInfo =  NSDictionary.init(object: spayerskey, forKey: "key")
        notification.userInfo = userInfo as [NSObject : AnyObject]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        self.notice = notification
        if isNextNoticeCell {
//            grayView.hidden = true
            self.payersTimeLabel.textColor = UIColor.redColor()
            self.payersNameLabel.textColor = UIColor.redColor()
        }
    }
    
    func notificationReceive(sender :NSNotification) {
        let latitude = NSUserDefaults.standardUserDefaults().doubleForKey("latitude")
        let longitude = NSUserDefaults.standardUserDefaults().doubleForKey("longitude")
        let calcMethodID = NSUserDefaults.standardUserDefaults().integerForKey("calcTimeMethod")
        let methodid = Int32(calcMethodID)
        let nextNotice = sender.userInfo!["nextNotice"] as! String
        if latitude == 0 && longitude == 0  { //定位未开启
            return
        }
        
        if(nextNotice == "selectZone")
        {
            SwiftNotice.showNoticeWithText(.success, text: ChapelToolUtils.getLocalizedStr("key_setSuccess") , autoClear: true, autoClearTime: 1)
        }
        
        var add:Int32 = 0
        let  addTimeZone = NSUserDefaults.standardUserDefaults().integerForKey("daylight")
        if addTimeZone == 0 {
            add = 1
        }
        else if addTimeZone == 2 {
            add = -1
        }
        if nextNotice == spayerskey {
            isNextNoticeCell = true
        }
        
        var times = self.prayTime.prayerTimes(0, andLatitude: latitude, andLongitude: longitude,andtimeZone: add,calcMethod: methodid) as [AnyObject]
        if spayerskey == "fajr"
        {
            handleParyerTime(times[0] as! String, lastAddTime: 0)
        }
        else if spayerskey == "sunrise"
        {
            handleParyerTime(times[1] as! String, lastAddTime: 0)
        }
        else if spayerskey == "dhuhr"
        {
            handleParyerTime(times[2] as! String, lastAddTime: 0)
        }
        else if spayerskey == "asr"
        {
            handleParyerTime(times[3] as! String, lastAddTime: 0)
        }
        else if spayerskey == "maghrib"
        {
            handleParyerTime(times[4] as! String, lastAddTime: 0)
        }
        else if spayerskey == "ishaa"
        {
            //            setPayersTime(times[6] as! String)
            handleParyerTime(times[6] as! String, lastAddTime: 0)
        }
        

    }
    

}

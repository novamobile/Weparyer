//
//  PrayersViewController.swift
//  chapel
//
//  Created by Jacy on 16/4/19.
//  Copyright © 2016年 Jacy. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import AVFoundation
import UserNotifications

class PrayersViewController: UIViewController,CLLocationManagerDelegate,UNUserNotificationCenterDelegate{
    var _lastPosition:CGFloat = 0.0
    
    var audioPlayer: AVAudioPlayer!
    
    var prayersTime:[AnyObject] = []
    //纬度
    var latitude: CLLocationDegrees = 0.0
    //精度
    var longitude: CLLocationDegrees = 0.0
    
    //屏幕尺寸
    let bounds =  UIScreen.mainScreen().bounds
   
    @IBOutlet weak var PayersView: UIView!
//    @IBOutlet weak var dhuhrTimeLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!

    @IBOutlet weak var dateLabel: UILabel!

//    @IBOutlet weak var titleItem: UINavigationItem!
//    @IBOutlet weak var paryerBackImg: UIImageView!
    @IBOutlet weak var image_BackGround: UIImageView!
    @IBOutlet weak var image_BackGround1: UIImageView!

//    @IBOutlet weak var stackView: UIView!
//    @IBOutlet weak var leftButton: UIButton!
//    @IBOutlet weak var rightButton: UIButton!
    let names = [
        "fajr":ChapelToolUtils.getLocalizedStr("key_fajr"),
        "sunrise":ChapelToolUtils.getLocalizedStr("key_sunrise"),
        "dhuhr":ChapelToolUtils.getLocalizedStr("key_dhuhr"),
        "asr":ChapelToolUtils.getLocalizedStr("key_asr"),
        "maghrib":ChapelToolUtils.getLocalizedStr("key_maghrib"),
        "ishaa":ChapelToolUtils.getLocalizedStr("key_ishaa")
    ]
    
    let allKeys = ["fajr","sunrise","dhuhr","asr","maghrib","ishaa"]
    //初始化工具类
    let prayTime = PrayTime()
    
    //是否加载过
    var isLoadPrayersTime = false
    var isLoadPayersView = false
    
     //定位管理器
    let locationManager:CLLocationManager = CLLocationManager()
    //当前时间
    var date:NSDate = NSDate()
    //需要传递的值
    var willSendToSoundViewValue : String = ""
    
    override func viewDidLoad() {
        print("时间 viewDidLoad")
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
//
        //设置定位服务管理器代理
        locationManager.delegate = self
        //设置定位精度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //更新距离
        locationManager.distanceFilter = 100
        //发送授权申请
        locationManager.requestWhenInUseAuthorization()
        //加载时间
        self.loadDateLabel()
        //初始化提醒按钮
        self.loadRemindButton()
        
//        self.createAthanView()
        
        self.navigationItem.title = ChapelToolUtils.getLocalizedStr("key_time")
        if IS_ARB {
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: CUSTOM_ARABIC_FONT, size: 24)!, NSForegroundColorAttributeName: UIColor.blackColor()]
        }
//        self.navigationController?.navigationBar.titleTextAttributes =  [NSForegroundColorAttributeName:UIColor.blackColor()]
//        self.navigationController?.navigationBar.barStyle = .Default
//        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        
//        PayersView.layer.borderWidth = 0.5
//        let colorBorder = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
//        PayersView.layer.borderColor = colorBorder.CGColor

        PayersView.layer.masksToBounds = true
        PayersView.layer.cornerRadius = 20
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(self.pushToSoundSelectView(_:)),name: "pushToSoundSelectViewNotification", object: nil)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func createAthanView() {
        print(self.PayersView.frame)
        print(self.PayersView.bounds)
        let offestY : CGFloat = (self.PayersView.frame.size.height)/6
        for index in 0...allKeys.count-1 {
            var frame = CGRectMake(-30*bounds.width/375.0, CGFloat(Float(index))*(offestY), bounds.width*0.85, offestY)
            if IS_ARB {
                frame = CGRectMake(-10*bounds.width/375.0, CGFloat(Float(index))*(offestY), bounds.width*0.85, offestY)
            }
            
            print("frame",frame)
            let view = SinglePayersInfoView(frame: frame)
//            let view = singlePayerInfoViews(frame:frame)
            let key = allKeys[index]
            view.setPayersInfo(allKeys[index],name: self.names[key]!)
            view.setLineViewHidden(index%2 == 0)
            view.tag = index + 2000
            self.PayersView.addSubview(view)
            self.isLoadPayersView = true
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear1",self.isLoadPayersView )
        
        if self.isLoadPayersView == false {
            createAthanView()
        }
        willSendToSoundViewValue = ""
        
        if (CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() != .Denied) {
            locationManager.startUpdatingLocation()
        }
        else{
            showEventsAcessDeniedAlert()
        }
        
//        let offestY = (self.PayersView.frame.size.height)/6
//        for index in 0...4 {
//            let frame = CGRectMake(5, CGFloat(Float(index))*offestY, bounds.width, offestY)
//            print(frame)
//            let view = self.PayersView.viewWithTag(2000 + index)
//            if (view != nil) {
//                let aView = view as! SinglePayersInfoView
////                aView.updateFrame(frame)
//            }
//        }
        

    }

    func loadRemindButton(){
        //判断是不是第一次启动
        let initApp =  NSUserDefaults.standardUserDefaults().integerForKey("init")
        if initApp == 0 {
            NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "init")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: allKeys[0])
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: allKeys[1])
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: allKeys[2])
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: allKeys[3])
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: allKeys[4])
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: allKeys[5])
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: allKeys[0]+"i_time")
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: allKeys[1]+"i_time")
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: allKeys[2]+"i_time")
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: allKeys[3]+"i_time")
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: allKeys[4]+"i_time")
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: allKeys[5]+"i_time")
            NSUserDefaults.standardUserDefaults().setInteger(1, forKey: allKeys[0]+"sound")
            NSUserDefaults.standardUserDefaults().setInteger(1, forKey: allKeys[1]+"sound")
            NSUserDefaults.standardUserDefaults().setInteger(1, forKey: allKeys[2]+"sound")
            NSUserDefaults.standardUserDefaults().setInteger(1, forKey: allKeys[3]+"sound")
            NSUserDefaults.standardUserDefaults().setInteger(1, forKey: allKeys[4]+"sound")
            NSUserDefaults.standardUserDefaults().setInteger(1, forKey: allKeys[5]+"sound")
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: allKeys[0]+"push_sound")
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: allKeys[1]+"push_sound")
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: allKeys[2]+"push_sound")
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: allKeys[3]+"push_sound")
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: allKeys[4]+"push_sound")
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: allKeys[5]+"push_sound")
            NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "daylight")
            NSUserDefaults.standardUserDefaults().setInteger(3, forKey: "calcTimeMethod")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: wIsTourist)
            NSUserDefaults.standardUserDefaults().setObject("", forKey: wTouristAccessToken)
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isNetWorkPic")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: allKeys[0]+"push_sound_switch")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: allKeys[1]+"push_sound_switch")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: allKeys[2]+"push_sound_switch")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: allKeys[3]+"push_sound_switch")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: allKeys[4]+"push_sound_switch")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: allKeys[5]+"push_sound_switch")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: allKeys[0]+"sound_switch")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: allKeys[1]+"sound_switch")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: allKeys[2]+"sound_switch")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: allKeys[3]+"sound_switch")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: allKeys[4]+"sound_switch")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: allKeys[5]+"sound_switch")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: allKeys[0]+"handAdjustOpen")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: allKeys[1]+"handAdjustOpen")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: allKeys[2]+"handAdjustOpen")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: allKeys[3]+"handAdjustOpen")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: allKeys[4]+"handAdjustOpen")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: allKeys[5]+"handAdjustOpen")
        }
        
        let arDic = NSUserDefaults.standardUserDefaults().dictionaryRepresentation()
        let allKeys1 = arDic.keys
        var isHave_114Keys = false
        var isHaveSunRise = false
        for key in allKeys1 {
            if key == "calcTimeMethod" {
                isHave_114Keys = true
            }
            
            if key == "sunrise" {
                isHaveSunRise = true
            }
        }
        if isHave_114Keys == false {
            NSUserDefaults.standardUserDefaults().setInteger(3, forKey: "calcTimeMethod")
        }
        if isHaveSunRise == false {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: allKeys[1])
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: allKeys[1]+"i_time")
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: allKeys[1]+"sound")
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: allKeys[1]+"push_sound")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: allKeys[1]+"push_sound_switch")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: allKeys[1]+"sound_switch")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: allKeys[1]+"handAdjustOpen")
        }
        if(NSUserDefaults.standardUserDefaults().objectForKey("default-city") == nil)
        {
             NSUserDefaults.standardUserDefaults().setObject("", forKey: "default-city")
        }
        if(NSUserDefaults.standardUserDefaults().objectForKey("currentParyer") == nil)
        {
            NSUserDefaults.standardUserDefaults().setObject("default", forKey: "currentParyer")
        }
    }
    
    @IBAction func leftBarButtonItemClick(sender: AnyObject) {

    }
    @IBAction func RightBarButtonItemClick(sender: AnyObject) {
//        self.navigationController?.pushViewController(SoundViewController(), animated: true)
//        self.performSegueWithIdentifier("timeToSound", sender: self)
        let nav = UINavigationController(rootViewController: InmobiADViewController())
        self.presentViewController(nav, animated: true) {
        }
    }
    
    func pushToSoundSelectView(sender: AnyObject)  {
        let notice = sender as! NSNotification
        let userInfo = notice.userInfo! as! Dictionary<String,String>
        willSendToSoundViewValue = userInfo["key"]!
        let time = userInfo["time"]!
        let disetinationVC = SinglePayerViewController()
        disetinationVC.customKey = willSendToSoundViewValue
        disetinationVC.customTime = time
        
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(disetinationVC, animated: true)
        self.hidesBottomBarWhenPushed = false
//        self.performSegueWithIdentifier("timeToSound", sender: self)
    }
    
    //加载时间文本
    func loadDateLabel(){
        self.placeLabel.text = self.presentDate() + "\n" + self.weekdayStringFromDate(NSDate())
        if IS_ARB {
            self.placeLabel.font = UIFont(name: CUSTOM_ARABIC_FONT, size: 17)
            self.dateLabel.font = UIFont(name: CUSTOM_ARABIC_FONT, size: 17)
            
        }
        let countryStr = NSUserDefaults.standardUserDefaults().objectForKey("appLocationCountry") as! String
        let cityStr = NSUserDefaults.standardUserDefaults().objectForKey("appLocationCity") as! String
        if cityStr == "" {
            self.dateLabel.text = countryStr
        }
        else{
            self.dateLabel.text = cityStr + "," + countryStr
        }
        
//        self.placeLabel.text = self.weekdayStringFromDate(NSDate())
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
        print("viewWillAppear",UIApplication.sharedApplication().statusBarHidden)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if CLLocationManager.locationServicesEnabled() {
            locationManager.stopUpdatingLocation()
        }
        else
        {
//            showEventsAcessDeniedAlert()
        }
//        self.hidesBottomBarWhenPushed = false
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        //获取最新的坐标
        let currLocation:CLLocation = locations.last!
        
        print("经度->>>>>>1：\(currLocation.coordinate.longitude)")
        print("纬度->>>>>>2：\(currLocation.coordinate.latitude)")
        self.latitude = currLocation.coordinate.latitude
        self.longitude = currLocation.coordinate.longitude
        NSUserDefaults.standardUserDefaults().setDouble(self.latitude, forKey: "latitude")
        NSUserDefaults.standardUserDefaults().setDouble(self.longitude, forKey: "longitude")
        
        self.reverseGeocode(self.latitude, longitude: self.longitude)
        //加载礼拜时间
        if self.isLoadPrayersTime == false {
            self.loadPrayersTime()
            self.requestNotification()
        }
        
        Flurry.setLatitude(currLocation.coordinate.latitude, longitude: currLocation.coordinate.longitude, horizontalAccuracy: Float(currLocation.horizontalAccuracy), verticalAccuracy: Float(currLocation.verticalAccuracy))
    }
    
    //地理反编码
    func reverseGeocode(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let geocoder = CLGeocoder()
        
        var place:CLPlacemark?
        
        let currentLocation = CLLocation(latitude: latitude, longitude: longitude)
        
        geocoder.reverseGeocodeLocation(currentLocation) { ( placemarks:[CLPlacemark]?, error:NSError?) in
            if error != nil {
                print("错误：\(error!.localizedDescription))")
                //                self.hornLabel.text = "定位失败"
                return
            }
            
            if placemarks?.count > 0 {
                place = placemarks?[0]
//                print(place)
                //地理位置
//                self.placeLabel.text = (place?.locality)! + "," + (place?.country)!
                if(place?.country != nil && place?.locality != nil)
                {
                    NSUserDefaults.standardUserDefaults().setObject((place?.country)!, forKey: "appLocationCountry")
                    NSUserDefaults.standardUserDefaults().setObject((place?.locality)!, forKey: "appLocationCity")
                    if (place?.locality)! == "" {
                        self.dateLabel.text = "Auto"
                        let default_string = NSUserDefaults.standardUserDefaults().objectForKey("default-city") as! String
                        if(default_string != "")
                        {
                            self.dateLabel.text = default_string
                        }
                    }
                    else{
                        self.dateLabel.text = (place?.locality)! //+ "," + (place?.country)!
                        saveDataTodayByNSUserDefaults((place?.locality)!, key: "TodayWidget-city")
                        let default_string = NSUserDefaults.standardUserDefaults().objectForKey("default-city") as! String
                        if(default_string != (place?.locality)!)
                        {
//                            self.dateLabel.text = (place?.locality)! //+ "," + (place?.country)!
                            if(default_string == "")
                            {
                                NSUserDefaults.standardUserDefaults().setObject((place?.locality)!, forKey: "default-city")
                            }
                        }
                    }
                }
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .NotDetermined:
            print("NotDetermined")
            locationManager.requestWhenInUseAuthorization()
            break
        case .Restricted:
            print("Restricted")
//            locationManager.requestWhenInUseAuthorization()
            break
        case .AuthorizedAlways:
            print("AuthorizedAlways")
            locationManager.requestWhenInUseAuthorization()
//            locationManager.requestLocation()
            break
        case .AuthorizedWhenInUse:
            print("AuthorizedWhenInUse")
            locationManager.requestWhenInUseAuthorization()
            break
        default:
            print("default")
            showEventsAcessDeniedAlert()
            setDefaultLocation()
        }
    }
    
    func setDefaultLocation() {
        
        self.latitude = NSUserDefaults.standardUserDefaults().doubleForKey("latitude")
        self.longitude = NSUserDefaults.standardUserDefaults().doubleForKey("longitude")
        
        if(self.latitude < 0.001 && self.longitude < 0.001)
        {
            return
        }
        self.reverseGeocode(self.latitude, longitude: self.longitude)
        //加载礼拜时间
        if self.isLoadPrayersTime == false {
            self.loadPrayersTime()
            self.requestNotification()
        }
    }
    
    func showEventsAcessDeniedAlert() {
        let alertController = UIAlertController(title: ChapelToolUtils.getLocalizedStr("key_wenxingtishi"),
                                                message: ChapelToolUtils.getLocalizedStr("key_weikaiqidingweitip"),
                                                preferredStyle: .Alert)
        let settingsAction = UIAlertAction(title: ChapelToolUtils.getLocalizedStr("key_GotoSetting"), style: .Default) { (alertAction) in
            // THIS IS WHERE THE MAGIC HAPPENS!!!!
            if let appSettings = NSURL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.sharedApplication().openURL(appSettings)
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: ChapelToolUtils.getLocalizedStr("key_cancle"), style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
        saveDataTodayByNSUserDefaults("", key: "TodayWidget-city")
    }
    
    
    func showNotificationDeniedAlert() {
        let alertController = UIAlertController(title: "开启推送",
                                                message: "开启推送",
                                                preferredStyle: .Alert)
        let settingsAction = UIAlertAction(title: ChapelToolUtils.getLocalizedStr("key_GotoSetting"), style: .Default) { (alertAction) in
            // THIS IS WHERE THE MAGIC HAPPENS!!!!
            if let appSettings = NSURL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.sharedApplication().openURL(appSettings)
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: ChapelToolUtils.getLocalizedStr("key_cancle"), style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func requestNotification() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.currentNotificationCenter().requestAuthorizationWithOptions([.Alert,.Sound,.Badge], completionHandler: { (ganted, error) in
                if ganted {
                    print("用户允许推送")
                    self.requestLocationNotification()
                }
                else{
                    print("用户不允许推送")
//                    self.showNotificationDeniedAlert()
                }
            })
        }
        else{
            let application = UIApplication.sharedApplication()
            if application.respondsToSelector(#selector(UIApplication.isRegisteredForRemoteNotifications)) {
                application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [UIUserNotificationType.Sound, UIUserNotificationType.Alert, UIUserNotificationType.Badge], categories: nil))
                application.registerForRemoteNotifications()
            } else {
                application.registerForRemoteNotificationTypes([UIRemoteNotificationType.Sound, UIRemoteNotificationType.Alert, UIRemoteNotificationType.Badge])
            }
        }
    }
    
    //获取当前时间
    func presentDate() -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-M-d"
        dateFormatter.dateStyle = .LongStyle
        
        return dateFormatter.stringFromDate(self.date) as String
    }
//    @IBAction func leftButtonClick(sender: AnyObject) {
//    }
//    @IBAction func rightButtonClick(sender: AnyObject) {
//    }
    //获取当前语言
    func presentLanguage() -> String{
       let userDefaults =  NSUserDefaults.standardUserDefaults()
        
       let languages  = userDefaults.objectForKey("AppleLanguages") as! [AnyObject]
        
        return languages.first as! String
        
    }
    
    func weekdayStringFromDate(inputDate:NSDate) -> String
    {
        let weekdays = [ChapelToolUtils.getLocalizedStr("key_7"),
                        ChapelToolUtils.getLocalizedStr("key_1"),
                        ChapelToolUtils.getLocalizedStr("key_2"),
                        ChapelToolUtils.getLocalizedStr("key_3"),
                        ChapelToolUtils.getLocalizedStr("key_4"),
                        ChapelToolUtils.getLocalizedStr("key_5"),
                        ChapelToolUtils.getLocalizedStr("key_6")]
        let calendar = NSCalendar.init(calendarIdentifier: NSCalendarIdentifierGregorian)
        calendar?.timeZone = NSTimeZone.defaultTimeZone()
        let components = calendar?.components(NSCalendarUnit.Weekday, fromDate: inputDate)
        return weekdays[(components?.weekday)! - 1]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //加载礼拜时间表
    func loadPrayersTime(){
        if self.isLoadPrayersTime == false {
            //取消所有的
            UIApplication.sharedApplication().cancelAllLocalNotifications()
            //通知礼拜的时间
            
            var add:Int32 = 0
            let  addTimeZone = NSUserDefaults.standardUserDefaults().integerForKey("daylight")
            if addTimeZone == 0 {
                add = 1
            }
            let calcMethodID = NSUserDefaults.standardUserDefaults().integerForKey("calcTimeMethod")
            let methodid = Int32(calcMethodID)
            let times = self.prayTime.prayerTimes(0, andLatitude: self.latitude, andLongitude: self.longitude,andtimeZone: add,calcMethod: methodid) as [AnyObject]
            let (nextNotice,keyIndex) = self.calcLastParyerTime(times)
            let userInfo =  NSDictionary.init(object: nextNotice, forKey: "nextNotice") as [NSObject : AnyObject]
            NSNotificationCenter.defaultCenter().postNotificationName("revicePayersTimesNotification", object: nil, userInfo: userInfo)
            NSNotificationCenter.defaultCenter().postNotificationName("notificationQiblaChangeBackGround", object: nil, userInfo: userInfo)
            
            
            
            self.isLoadPrayersTime = true
            var currentPrayerName = ""
            var currentPrayerTimeKey = keyIndex
            if currentPrayerTimeKey <= 0  {
                currentPrayerName = allKeys[0]
            }
            else if(currentPrayerTimeKey > 5){
                currentPrayerName = allKeys[5]
            }
            else{
                currentPrayerName = allKeys[currentPrayerTimeKey-1]
            }
            let imageName = currentPrayerName+"_backGround"
            let imageName1 = currentPrayerName+"_backGround_1"
            self.image_BackGround.image = UIImage(named: imageName)
            self.image_BackGround1.image = UIImage(named: imageName1)
            NSUserDefaults.standardUserDefaults().setObject(currentPrayerName, forKey: "currentParyer")
            self.image_BackGround.hidden = false
            self.image_BackGround1.hidden = false
        }
    }
    
    //计算下次礼拜时间
    func calcLastParyerTime(times : [AnyObject]) ->(String,Int)
    {
        /*
         获取时间戳
         设置格式
         得到年,月,日 的字符
         计算出1970年以后的
         bori是当前时间的年月日拼接上times的[index]
         */
        //seconds_v 数组中存的类型是 double
        var seconds_v : [Double] = [Double]()
        
        let  dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let prefixDate = dateFormatter.stringFromDate(NSDate()) as String
        for index in 0...6 {
            if index != 5 {
                let sufixDate = times[index] as! String
                let noticeTime = prefixDate + " \(sufixDate)"
                dateFormatter.dateFormat = "YYYY-MM-dd HH:mm"
                let bori = dateFormatter.dateFromString(noticeTime)
                let seconds = (bori!.timeIntervalSince1970) as Double
                seconds_v.append(seconds)
            }
        }
        
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm"
        //现在时间
        let nowTime = dateFormatter.stringFromDate(NSDate()) as String
        //现在时间数字
        let nowSec = (dateFormatter.dateFromString(nowTime)?.timeIntervalSince1970)! as Double
        if nowSec < seconds_v[0] {
            return (allKeys[0],0)
        }else if nowSec > seconds_v[0]  && nowSec <= seconds_v[1] {
            return (allKeys[1],1)
        }else if nowSec > seconds_v[1]  && nowSec <= seconds_v[2] {
            return (allKeys[2],2)
        }else if nowSec > seconds_v[2]  && nowSec <= seconds_v[3] {
            return (allKeys[3],3)
        }else if nowSec > seconds_v[3]  && nowSec <= seconds_v[4] {
            return (allKeys[4],4)
        }else if nowSec > seconds_v[4]  && nowSec <= seconds_v[5] {
            return (allKeys[5],5)
        }
        return (allKeys[5],6)
    }

    func insertBlurView (view: UIView,  style: UIBlurEffectStyle) {
        view.backgroundColor = UIColor.clearColor()
        
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.insertSubview(blurEffectView, atIndex: 0)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "timeToSound"
        {
            if willSendToSoundViewValue != "" {
                let disetinationVC = segue.destinationViewController as! SoundViewController
                disetinationVC.customTitle = self.names[willSendToSoundViewValue]!
            }
        }
    }

    func requestLocationNotification()
    {
        /*
        if #available(iOS 10.0, *) {
            let content = UNMutableNotificationContent()
            content.sound = UNNotificationSound.defaultSound()
            content.badge = 10
            content.title = "Wepray吊炸天通知测试！-标题"
            content.subtitle = "Wepray吊炸天通知测试！-副标题"
            content.body = "Wepray吊炸天通知测试！-正文"
            
            let path = NSBundle.mainBundle().pathForResource("img_timeBackGround@2x", ofType: "png")
            do {
                let att = try UNNotificationAttachment(identifier: "att1", URL: NSURL(fileURLWithPath: path!), options: nil)
                content.attachments = [att]
                content.launchImageName = "img_timeBackGround2"
            }catch{
                print("notification catch error")
            }
            
            content.userInfo = ["key": ChapelToolUtils.getAllSound()[0]]
            content.categoryIdentifier = "myNotificationCategory1"
            // 需要使用UNNotificationTrigger的子类UNTimeIntervalNotificationTrigger来实例化
            let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 10, repeats: false)
            let request = UNNotificationRequest.init(identifier: "youIdentifier", content: content, trigger: trigger)
            let center = UNUserNotificationCenter.currentNotificationCenter()
            // 在代理里面接收通知信息
            center.delegate = self
            center.addNotificationRequest(request, withCompletionHandler: nil)
            print("添加一个推送")
        } else {
            // Fallback on earlier versions
        }
*/
        
        /*
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"徐不同测试通知";
    content.subtitle = @"测试通知";
    content.body = @"来自徐不同的简书";
    content.badge = @1;
    
    NSError *error = nil;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"icon_certification_status1@2x" ofType:@"png"];
    /*
     // 1.gif图的路径
     NSString *path = [[NSBundle mainBundle] pathForResource:@"test1" ofType:@"gif"];
     //  2.mp4的路径
     //    NSString *path = [[NSBundle mainBundle] pathForResource:@"flv视频测试用例1" ofType:@"mp4"];
     
     
     NSMutableDictionary *dict = [NSMutableDictionary dictionary];
     
     
     附件通知键值使用说明
     1.UNNotificationAttachmentOptionsTypeHintKey
     dict[UNNotificationAttachmentOptionsTypeHintKey] = (__bridge id _Nullable)(kUTTypeImage);
     
     2.UNNotificationAttachmentOptionsThumbnailHiddenKey
     dict[UNNotificationAttachmentOptionsThumbnailHiddenKey] =  @YES;
     
     3.UNNotificationAttachmentOptionsThumbnailClippingRectKey
     dict[UNNotificationAttachmentOptionsThumbnailClippingRectKey] = (__bridge id _Nullable)((CGRectCreateDictionaryRepresentation(CGRectMake(0, 0, 1 ,1))));
     Rect对应的意思
     thumbnailClippingRect =     {
     Height = "0.1";
     Width = "0.1";
     X = 0;
     Y = 0;
     };
     4. UNNotificationAttachmentOptionsThumbnailTimeKey-选取影片的某一秒做推送显示的缩略图
     dict[UNNotificationAttachmentOptionsThumbnailTimeKey] =@10;
     */
    
    
    UNNotificationAttachment *att = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
    if (error) {
    NSLog(@"attachment error %@", error);
    }
    content.attachments = @[att];
    content.launchImageName = @"icon_certification_status1@2x.png";
    
    //这里设置category1， 是与之前设置的category对应
    content.categoryIdentifier = @"category1";
    
    UNNotificationSound *sound = [UNNotificationSound defaultSound];
    content.sound = sound;
    
    
    
    
    /*触发模式1*/
    UNTimeIntervalNotificationTrigger *trigger1 = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
    
    /*触发模式2*/
    UNTimeIntervalNotificationTrigger *trigger2 = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
    
    /*触发模式3*/
    // 周一早上 8：00 上班
    NSDateComponents *components = [[NSDateComponents alloc] init];
    // 注意，weekday是从周日开始的，如果想设置为从周一开始，大家可以自己想想~
    components.weekday = 2;
    components.hour = 8;
    UNCalendarNotificationTrigger *trigger3 = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:YES];
    
    
    
    // 创建本地通知
    NSString *requestIdentifer = @"TestRequestww1";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:trigger1];
    
    //把通知加到UNUserNotificationCenter, 到指定触发点会被触发
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
    }];
 
 
 */
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void) {
        let content = response.notification.request.content
        print("userInfo = \(content.userInfo), subtitle = \(content.subtitle), title = \(content.title) ,body = \(content.body) ,badge = \(content.badge) ,sound = \(content.sound)")
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void) {
        print("willPresent")
    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(center: UNUserNotificationCenter, willPresentNotification notification: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.Alert)
    }
    
    /* iOS 10收到通知
    - (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题

    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
    
    
    }
    else {
    // 判断为本地通知
    NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    
    
    
    
    }

*/

}

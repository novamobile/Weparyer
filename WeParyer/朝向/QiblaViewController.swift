//
//  QiblaViewController.swift
//  chapel
//
//  Created by Jacy on 16/4/19.
//  Copyright © 2016年 Jacy. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation
import AudioToolbox

class QiblaViewController: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet weak var directImageView: UIImageView!
    @IBOutlet weak var hornLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var item: UINavigationItem!

    //麦加纬度
    let latitude: CLLocationDegrees = 21.416667
    //麦加经度
    let longitude: CLLocationDegrees = 39.816667
    
    var locationManager:CLLocationManager!

    //自己的纬度
    var myLatitude: CLLocationDegrees = 0.0
    //自己的经度
    var myLongitude: CLLocationDegrees = 0.0
    
    @IBOutlet weak var imageView: UIImageView!
    
    var headingValue = 0.0
    
    var initDirectValue = 0.0
    
    var imageArrow : UIImageView!
    
    var cityHeading : CLLocationDirection = 0.0
    var currentHeading : CLLocationDirection = 0.0 
    var currentLocation : CLLocationCoordinate2D! // = CLLocationCoordinate2D.init(latitude: 0.0, longitude: 0.0)
    @IBOutlet weak var backGround: UIImageView!
    
    var isLoadArrows : Bool = false
    
    @IBOutlet weak var arrowNanView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        //设置定位精度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //更新距离
        locationManager.distanceFilter = kCLDistanceFilterNone
        //发送授权申请
        locationManager.requestWhenInUseAuthorization()
        self.navigationItem.title = ChapelToolUtils.getLocalizedStr("key_Qibla")
        if IS_ARB {
            self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: CUSTOM_ARABIC_FONT, size: 24)!, NSForegroundColorAttributeName: UIColor.blackColor()]
        }
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(self.changeBackGround(_:)),
                                                         name: "notificationQiblaChangeBackGround", object: nil)

    }
    
    override func viewDidAppear(animated: Bool) {
        let currentParyer = NSUserDefaults.standardUserDefaults().objectForKey("currentParyer") as! String
        if(currentParyer != "default")
        {
            let imageName = currentParyer+"_backGround"
            self.backGround.image = UIImage(named: imageName)
            self.backGround.hidden = false
        }
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        if(UIScreen.mainScreen().bounds.height == 480.0)
        {
            print(self.hornLabel.frame)
            let frameL = self.hornLabel.frame
            self.hornLabel.frame = CGRectMake(frameL.origin.x, 401.0, frameL.size.width, frameL.size.height)
        }
        
    }
    
    func changeBackGround(sender :NSNotification)
    {
        let nextNotice = sender.userInfo!["nextNotice"] as! String
        if(nextNotice != "")
        {
            let imageName = nextNotice+"_backGround"
            self.backGround.image = UIImage(named: imageName)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if CLLocationManager.headingAvailable() && self.locationManager != nil {
            locationManager.startUpdatingHeading()
        }
        
        self.myLatitude = NSUserDefaults.standardUserDefaults().doubleForKey("latitude")
        self.myLongitude = NSUserDefaults.standardUserDefaults().doubleForKey("longitude")
        
        currentLocation = CLLocationCoordinate2D.init(latitude: self.myLatitude, longitude: self.myLongitude)
        
        let countryStr = NSUserDefaults.standardUserDefaults().objectForKey("appLocationCountry") as! String
        let cityStr = NSUserDefaults.standardUserDefaults().objectForKey("appLocationCity") as! String
        if cityStr == "" {
            self.hornLabel.text = countryStr
        }
        else{
            self.hornLabel.text = cityStr + "," + countryStr
        }
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if CLLocationManager.headingAvailable() && self.locationManager != nil {
            locationManager.stopUpdatingHeading()
        }
    }

    //地理反编码
    func reverseGeocode(latitude: CLLocationDegrees, longitude: CLLocationDegrees){

    }
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        //new 
        if let headingValue = manager.heading {
            let oldRad = Float(-(headingValue.trueHeading) * M_PI / 180.0)
            let newRad = Float(-newHeading.trueHeading * M_PI / 180.0)
            
            let theAnimation : CABasicAnimation
            theAnimation = CABasicAnimation.init(keyPath: "transform.rotation")
            theAnimation.fromValue = NSNumber.init(float: oldRad)
            theAnimation.toValue = NSNumber.init(float: newRad)
            theAnimation.duration = 0.5
            imageView.layer.addAnimation(theAnimation, forKey: "animateMyRotation")
            imageView.transform = CGAffineTransformMakeRotation(CGFloat(newRad))
//            directImageView.layer.addAnimation(theAnimation, forKey: "animateMyRotation")
//            directImageView.transform = CGAffineTransformMakeRotation(CGFloat(newRad))
            
            var theHeading : CLLocationDirection
            if newHeading.trueHeading > 0
            {
                theHeading = newHeading.trueHeading
            }
            else
            {
                theHeading = newHeading.magneticHeading
            }
            
            cityHeading = self.directionFrom(currentLocation)
            currentHeading = theHeading;
            self.updateHeadingDisplays()
            
            let num1 = self.toRad(self.cityHeading) as Double
            let num2 = Double(oldRad)
            
            if(abs(num1 + num2) < 0.05)
            {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            }
            
            print("updateHeadingDisplays",self.toRad(self.cityHeading),self.toRad(self.currentHeading))
            print("oldRad",oldRad)
            print("newRad",newRad)
            
//            let du1 = NSString(format: "%.0f", (currentHeading)%360)
//            let du2 = NSString(format: "%.0f", (cityHeading)%360)
//            self.cityLabel.text = "Now: \(du1)°,Qibla：\(du2)°"
        }
        else
        {
            print("系统错误")
        }
    }


    func directionFrom(startPt : CLLocationCoordinate2D) -> CLLocationDirection
    {
        let lat1 = toRad(startPt.latitude);
        let lat2 = toRad(21.4266700);
        let lon1 = toRad(startPt.longitude);
        let lon2 = toRad(39.8261100);
        let dLon = (lon2-lon1);
        
        let y = sin(dLon) * cos(lat2);
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
        var brng = toDeg(atan2(y, x));
        
        brng = (brng+360);
        if brng > 360
        {
            brng = brng-360
        }
        
        if brng < 360{
           brng = (brng+360);
        }
        
        return brng;
    }
    
    func updateHeadingDisplays()
    {
        print("updateHeadingDisplays",self.toRad(self.cityHeading),self.toRad(self.currentHeading))
        
        let headingRotation = CGAffineTransformRotate(CGAffineTransformIdentity, CGFloat(self.toRad(self.cityHeading)-self.toRad(self.currentHeading)))
        self.directImageView.transform = headingRotation
        
//        UIView.animateWithDuration(0.2, delay: 0.0, options: [.BeginFromCurrentState, .CurveEaseOut, .AllowUserInteraction],
//                                   animations: { 
//                                        let headingRotation = CGAffineTransformRotate(CGAffineTransformIdentity, CGFloat(self.toRad(self.cityHeading)-self.toRad(self.currentHeading)))
//                                        self.directImageView.transform = headingRotation
//                                    }) { (let finished:Bool) in
//                                        self.isLoadArrows = true
//                                    }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func toRad(jValue:Double) -> Double
    {
        return jValue*M_PI/180.0
    }
    func toDeg(fValue:Double) -> Double
    {
        return fValue*180.0/M_PI
    }
}

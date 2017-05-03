//
//  RootTabBarController.swift
//  chapel
//
//  Created by Jacy on 16/4/19.
//  Copyright © 2016年 Jacy. All rights reserved.
//

import UIKit

extension UITabBar {
    func showBadgeOnItemIndex(index : Int)
    {
        self.removeBadgeOnItemIndex(index)
        let view = UIView()
        view.tag = 888 + index
        view.layer.cornerRadius = 4.8
        view.backgroundColor = UIColor.redColor()
        let frame = self.frame
        
        let percentX = (CGFloat(index) + 0.58) / 3 as CGFloat
        let x = ceil(percentX*frame.size.width)
        let y = ceil(0.1*frame.size.height)
        view.frame = CGRectMake(x, y, 10, 10)
        self.addSubview(view)
    }
    
    func hideBadgeOnItemIndex(index : Int) {
        self.removeBadgeOnItemIndex(index)
    }
    
    func removeBadgeOnItemIndex(index : Int) {
        for subView in self.subviews {
            if(subView.tag == 888 + index)
            {
                subView.removeFromSuperview()
            }
        }
    }
}

class RootTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //init AdView
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Fade)
        initViewControllers()
        
        if WPLocationManager.significantLocationChangeMonitoringAvailable(){
           
            if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000 {
                WPLocationManager.sharedManager().requestAlwaysAuthorization()
            }else if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000 {
                if #available(iOS 9.0, *) {
                    WPLocationManager.sharedManager().allowsBackgroundLocationUpdates = true
                }
            }
            WPLocationManager.sharedManager().startUpdatingLocation()
            WPLocationManager.sharedManager().startMonitoringSignificantLocationChanges()
        }
        
    }
    
    //初始化视图
    func initViewControllers() {
        //Prayers
//        let attributes_normal =  [NSForegroundColorAttributeName: UIColor.lightGrayColor(),
//                                  NSFontAttributeName: UIFont(name: CUSTOM_ARABIC_FONT, size: 14)!]
//        let attributes_select =  [NSForegroundColorAttributeName: UIColor.init(red: 0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0),NSFontAttributeName: UIFont(name: CUSTOM_ARABIC_FONT, size: 14)!]
        let qiblastoryboard = UIStoryboard(name:"QiblaStoryboard", bundle: nil)
        let  qiblaViewController = qiblastoryboard.instantiateViewControllerWithIdentifier("QiblaViewController")
        let qiblaTabBarItem = UITabBarItem(title: "", image: UIImage(named:"qibla"), selectedImage:UIImage(named:"qibla_selected")?.imageWithRenderingMode(.AlwaysOriginal))
//        if IS_ARB {
//            qiblaTabBarItem.setTitleTextAttributes(attributes_normal , forState: UIControlState.Normal)
//            qiblaTabBarItem.setTitleTextAttributes(attributes_select , forState: UIControlState.Selected)
//        }
        qiblaTabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        qiblaViewController.tabBarItem = qiblaTabBarItem
        
        let storyboard = UIStoryboard(name:"PrayersStoryboard", bundle: nil)
        let  prayersViewController = storyboard.instantiateViewControllerWithIdentifier("PrayersViewController")
        let prayersTabBarItem = UITabBarItem(title: "", image: UIImage(named:"prayers"), selectedImage:UIImage(named:"prayers_selected")?.imageWithRenderingMode(.AlwaysOriginal))
        prayersTabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        prayersViewController.tabBarItem = prayersTabBarItem
        
        let settingViewController = UDNavigationController(rootViewController: SettingViewController())
        let settingTabBarItem = UITabBarItem(title: "", image: UIImage(named:"mosques"), selectedImage:UIImage(named:"mosques_selected")?.imageWithRenderingMode(.AlwaysOriginal))
        settingTabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        settingViewController.tabBarItem = settingTabBarItem

//        let bloggerstoryboard = UIStoryboard(name:"BloggerView", bundle: nil)
//        let  bloggerMainViewController = bloggerstoryboard.instantiateViewControllerWithIdentifier("BloggerMainViewController")
//        
////        let oauth = OauthViewController(nibName: "OauthViewController", bundle: nil)
//        let bloggerTabBarItem = UITabBarItem(title: ChapelToolUtils.getLocalizedStr("key_Blogger"), image: UIImage(named:"blogger"), selectedImage:UIImage(named:"blogger_selected")?.imageWithRenderingMode(.AlwaysOriginal))
//        bloggerMainViewController.tabBarItem = bloggerTabBarItem
        
        self.viewControllers = [qiblaViewController,prayersViewController,settingViewController]
        
        self.selectedIndex = 1
        self.tabBar.tintColor = UIColor.init(red: 0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        self.tabBar.backgroundImage = UIImage.init(named: "tabBarBackGround")//imageWithColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0))
//        self.tabBar.shadowImage = UIImage.init(named: "tabBarBackGround")//imageWithColor(UIColor.init(red: 1, green: 1, blue: 1, alpha: 0))
        
        /*新功能红点
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(self.showNewMessageRedPoint(_:)),
                                                         name: "showNewMessageRedPointNotification", object: nil)
        self.showNewMessageRedPoint(1)
        */
//        self.tabBar.tintColor = UIColor.init(colorLiteralRed: 47.0/255.0, green: 155.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
        
//        self.tabBar.alpha = 0.2
//        self.tabBar.backgroundImage = UIImage.init(named: "grid")
    }

    func imageWithColor(color:UIColor) -> UIImage {
        let rect = CGRectMake(0, 0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context!, color.CGColor)
        CGContextFillRect(context!, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hideTabBarView(sender : AnyObject)
    {
    }
    
    func showTabBarView(sender : AnyObject)
    {
    }

    func showNewMessageRedPoint(sender : AnyObject) {
//        let initMessage1 =  NSUserDefaults.standardUserDefaults().integerForKey("firstOpenPushSoundView")
        let initMessage2 =  NSUserDefaults.standardUserDefaults().integerForKey("isFirstOpenSelectCalcTimeViewController")
        var selectIndex = 2
        if NSLocale.preferredLanguages()[0].containsString("ar") {
            selectIndex = 0
        }
        if(initMessage2 == 1)
        {
            self.tabBar.removeBadgeOnItemIndex(selectIndex)
        }
        else{
            self.tabBar.showBadgeOnItemIndex(selectIndex)
        }
    }
    
    func DayLightSelectResult(sender : AnyObject) {
        self.selectedIndex = 1
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

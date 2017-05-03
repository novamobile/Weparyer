//
//  ShowAdBaseViewController.swift
//  WeParyer
//
//  Created by Jeccy on 16/5/31.
//  Copyright © 2016年 Jeccy. All rights reserved.
//

import UIKit

class ShowAdBaseViewController: ZLViewController {

    var imageUrl: String!
    var gotResponse: Bool!
    
    
    override func loadNativeAd () {
        self.native = IMNative(placementId: 1463138731612, delegate: self)
        self.native?.load()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        gotResponse = false

        self.setup()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(self.urlLoaded(_:)), name: "UrlLoaded", object: nil)
        
        self.view.clipsToBounds = true
        
        self.swipeableView.allowedDirection = .Horizontal
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(self.notificationReceive(_:)),
                                                         name: "ImageUrlReceiveNotification", object: nil)
        let firstShowAd =  NSUserDefaults.standardUserDefaults().integerForKey("firstShowAd")
        if(firstShowAd == 0)
        {
            NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "firstShowAd")
            let alert : UIAlertView = UIAlertView(title: ChapelToolUtils.getLocalizedStr("key_wenxingtishi"),
                                                  message: ChapelToolUtils.getLocalizedStr("key_showAdTip"),
                                                  delegate: self,
                                                  cancelButtonTitle: ChapelToolUtils.getLocalizedStr("key_Oktip"))
            alert.show()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup () {
        self.items = NSMutableArray ()
        self.alltitles = NSMutableArray ()
    }
    

    func urlLoaded(notif: NSNotification!) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.reloadData()
        })
    }
    
    func notificationReceive(sender: NSNotification) {
        self.presentADView()
    }
    
    override func presentADView() {
        let dict: NSDictionary? = IMUtilities.dictFromNativeContent(self.nativeContent as String!)
        if dict != nil {
            self.native?.reportAdClickAndOpenLandingURL(dict as! [NSObject : AnyObject])
        }
    }
    
    func reloadData () {
        let imageName: String? = self.items?.objectAtIndex(Int(0)) as? String
        if (gotResponse == true) &&  (imageName != nil) {
            let view = self.swipeableView.topView() as! ADCellView
            let adPlaceholder: UIImageView? = UIImageView (frame: view.bounds)
            adPlaceholder?.image = UIImage (named: "adImage")
            view.addSubview(adPlaceholder!)
        
            ImageLoader.sharedLoader.imageForUrl(imageName!, completionHandler:{(image: UIImage?, url: String) in
                view.imageView?.image = image
                IMNative.bindNative(self.native, toView: view);
            })
        }
    }
    
    
    // MARK: native delegate methods
    
    override func nativeDidFinishLoading(native: IMNative!) {
        super.nativeDidFinishLoading(native)
        gotResponse = true
        if let receiveData = IMUtilities.dictFromNativeContent(self.nativeContent as String!) {
            let jsonValue = receiveData as NSDictionary
            let iconDict: NSDictionary? = jsonValue.objectForKey("screenshots") as? NSDictionary
            print("a",iconDict?.objectForKey("url"))
            if let url = iconDict?.objectForKey("url") as? String
            {
                self.items.removeAllObjects()
                let escapedURL = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
                print("b",escapedURL!)
                self.items?.addObject(escapedURL!)
            }
            let title = jsonValue.objectForKey("title") as! String
            self.alltitles?.addObject(title)
        }
        self.reloadData()
    }
    
    func insertBlurView (view: UIView,  style: UIBlurEffectStyle) {
        view.backgroundColor = UIColor.clearColor()
        
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.insertSubview(blurEffectView, atIndex: 0)
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

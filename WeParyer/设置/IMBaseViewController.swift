//
//  IMBaseViewController.swift
//  WeParyer
//
//  Created by Jeccy on 16/5/31.
//  Copyright © 2016年 Jeccy. All rights reserved.
//

import UIKit

class IMBaseViewController: UIViewController, NSURLConnectionDelegate, NSURLConnectionDataDelegate, IMNativeDelegate {

    var connection: NSURLConnection?
    var activityIndicator: UIActivityIndicatorView?
    var statusLabel: UILabel?
    var responseData: NSMutableData?
    var requstStatusCode: Int?
    var native: IMNative?
    var nativeContent: NSString?
    var items: NSMutableArray?

    override func viewDidLoad () {
    
        super.viewDidLoad();
    
//        self.navigationController?.navigationBar.tintColor = UIColor(red: 101/255.0, green: 151/255.0, blue: 213/255.0, alpha: 1.0)
//

        self.statusLabel = UILabel(frame: self.view.frame)
    
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        self.activityIndicator?.frame = self.view.frame;
        self.activityIndicator?.hidden = true
        self.view.addSubview(self.activityIndicator!)

        if let servUrl = self.serverUrl() {
    
            self.activityIndicator?.startAnimating()

            self.items = NSMutableArray ()
        
            let url: NSURL = NSURL(string: servUrl)!

            let request: NSURLRequest = NSURLRequest(URL: url)

            self.responseData = NSMutableData()
    
            self.connection = NSURLConnection (request: request, delegate: self)
            self.connection?.start ()
        }
        else {
            self.loadNativeAd();
        }
    }
    
    // MARK: NSURLConnection Delegate
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        self.requstStatusCode = (response as! NSHTTPURLResponse).statusCode
        self.responseData?.length = 0;
    }

    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        self.statusLabel?.text = "Couldnt connect to server";
    }

    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        self.responseData?.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        self.activityIndicator?.stopAnimating()
        self.activityIndicator?.removeFromSuperview()
        
        let aDict = IMUtilities.dictFromJSONData(self.responseData) as NSDictionary
        
        if  aDict.allKeys.count > 0 {
            let itemsFromDict: NSArray = self.itemsFromJsonDict(aDict);
            if (itemsFromDict.count > 0) {
                self.items?.addObjectsFromArray(itemsFromDict as [AnyObject]);
                self.loadNativeAd();
                
            }
            
        }
        else {
            self.view.addSubview(self.statusLabel!)
                self.statusLabel?.text = "Got improper response from the server";
        }

        
    }

    // MARK:

    func serverUrl () -> String! {
        return nil; //Should be implemented by subclasses
    }
    
    func loadNativeAd () {
    // IMPLEMENT THIS IN SUBCLASSES
    }
    
    func itemsFromJsonDict(jsonDict: NSDictionary!) -> NSArray! {
    return nil; // IMPLEMENT THIS IN SUBCLASSES
    }

    func dictFromNativeContent() -> NSDictionary! {
        return nil; //Implement this in subclasses
    }
    
    // MARK: IMNative Delegate
    
    /**
    * The native ad has finished loading
    */
    func nativeDidFinishLoading(native: IMNative!) {
        
        NSLog("[IMBaseViewController %@]", #function)

        self.nativeContent = native.adContent;
        
        NSLog("JSON content is %@", self.nativeContent!);

    }
    /**
    * The native ad has failed to load with error.
    */
    
    func native(native: IMNative!, didFailToLoadWithError error: IMRequestStatus!) {
        NSLog("[IMBaseViewController %@]", #function)
        NSLog("Native ad failed to load with error %@", error);

    }
    
    /**
    * The native ad would be presenting a full screen content.
    */
    func nativeWillPresentScreen(native: IMNative!) {
        NSLog("[IMBaseViewController %@]", #function)
    }

    /**
    * The native ad has presented a full screen content.
    */
    func nativeDidPresentScreen(native: IMNative!) {
        NSLog("[IMBaseViewController %@]", #function)
    }

    /**
    * The native ad would be dismissing the presented full screen content.
    */
    func nativeWillDismissScreen(native: IMNative!) {
        NSLog("[IMBaseViewController %@]", #function)
    }

    /**
    * The native ad has dismissed the presented full screen content.
    */
    func nativeDidDismissScreen(native: IMNative!) {
        NSLog("[IMBaseViewController %@]", #function)
    }

    /**
    * The user will be taken outside the application context.
    */
    func userWillLeaveApplicationFromNative(native: IMNative!) {
        NSLog("[IMBaseViewController %@]", #function)
    }
}

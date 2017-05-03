////
////  ADViewController.swift
////  WeParyer
////
////  Created by Jeccy on 16/5/31.
////  Copyright © 2016年 Jeccy. All rights reserved.
////
//
//import UIKit
//
//class ADViewController: IMBaseViewController, ZLSwipeableViewDelegate, ZLSwipeableViewDataSource {
//
//    var swipeableView: ZLSwipeableView?
//    var imageUrl: String!
//    var gotResponse: Bool!
//    var showIndex = 0
//    
//    override func loadNativeAd () {
//        self.native = IMNative (placementId: 1463138731612, delegate: self)
//        self.native?.load()
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.view.backgroundColor = UIColor.whiteColor()
//        gotResponse = false
//
//        self.view.addSubview(self.SwipeableView())
//        
//        self.SwipeableView().delegate = self
//        self.SwipeableView().dataSource = self
//        
//        self.SwipeableView().translatesAutoresizingMaskIntoConstraints = false
//        self.SwipeableView().allowedDirection = .Horizontal
////        self.setup()
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("urlLoaded:"), name: "UrlLoaded", object: nil)
//        self.view.clipsToBounds = true
//        
//    }
//
//    func dictionaryOfNames(arr:UIView...) -> Dictionary<String,UIView> {
//        var d = Dictionary<String,UIView>()
//        for (ix,v) in arr.enumerate(){
//            d["v\(ix+1)"] = v
//        }
//        return d
//    }
//    
//    override func viewDidLayoutSubviews() {
//        self.SwipeableView().loadViewsIfNeeded()
//    }
//    
//    func SwipeableView() -> ZLSwipeableView {
//        if(self.swipeableView == nil)
//        {
//            self.swipeableView = ZLSwipeableView(frame: CGRectZero )
//        }
//        return self.swipeableView!
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    // MARK: --ZLSwipeableViewDelegate
//    func swipeableView(swipeableView: ZLSwipeableView!, didSwipeView view: UIView!, inDirection direction: ZLSwipeableViewDirection) {
//        print("did swipe in direction: %zd", direction)
//    }
//    
//    func swipeableView(swipeableView: ZLSwipeableView!, didCancelSwipe view: UIView!) {
//        print("did cancel swipe")
//    }
//    
//    func swipeableView(swipeableView: ZLSwipeableView!, didStartSwipingView view: UIView!, atLocation location: CGPoint) {
//        print("did start swiping at location: x %f, y %f", location.x, location.y)
//    }
//    
//    func swipeableView(swipeableView: ZLSwipeableView!, swipingView view: UIView!, atLocation location: CGPoint, translation: CGPoint) {
//        print("swiping at location: x %f, y %f, translation: x %f, y %f", location.x, location.y,
//        translation.x, translation.y)
//    }
//    
//    func swipeableView(swipeableView: ZLSwipeableView!, didEndSwipingView view: UIView!, atLocation location: CGPoint) {
//        print("did end swiping at location: x %f, y %f", location.x, location.y)
//    }
//    
//    // MARK: --ZLSwipeableViewDataSource
//    
//    func nextViewForSwipeableView(swipeableView: ZLSwipeableView!) -> UIView! {
//        
//        let view = ADCellView(frame : swipeableView.bounds)
//        return view
//    }
//    
//    // MARK: native delegate methods
//    override func nativeDidFinishLoading(native: IMNative!) {
//        super.nativeDidFinishLoading(native)
//        gotResponse = true
//        
////        if let nativeJson = self.dictFromNativeContent() {
////            if self.items?.count > 0 {
////                let iconDict: NSDictionary? = nativeJson.objectForKey("screenshots") as? NSDictionary
////                print("a",iconDict?.objectForKey("url"))
////                if let url = iconDict?.objectForKey("url") as? String
////                {
////                    let escapedURL = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
////                    print("b",escapedURL!)
////                    self.items?.insertObject(escapedURL!, atIndex: 4)
////                }
////            }
////        }
////        self.reloadData()
//    }
//    
//    /*
//    
//    func setup () {
//        self.items = NSMutableArray ()
//        for (var i = 0; i < 10; i++) {
//            self.items?.addObject("coverflow\(i+1)")
//        }
//        carousel?.reloadData()
//    }
//    
//    override func dictFromNativeContent() -> NSDictionary! {
//        return IMUtilities.dictFromNativeContent(self.nativeContent as String!)
//    }
//    
//    func urlLoaded(notif: NSNotification!) {
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            self.reloadData()
//        })
//    }
//    
//    
//    func reloadData () {
//        self.carousel?.reloadData();
//    }
//    
//    // MARK: iCarousel datasource and delegate
//    
//    func numberOfItemsInCarousel(carousel: iCarousel!) -> UInt {
//        if  (self.items != nil) {
//            return UInt((self.items?.count)!)
//        }
//        return 0
//    }
//    
//    func carousel(carousel: iCarousel!, viewForItemAtIndex index: UInt, reusingView view: UIView!) -> UIView! {
//        var view: UIImageView?
//        
//        if (view == nil)
//        {
//            view =  UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 300))
//        }
//        
//        let imageName: String? = self.items?.objectAtIndex(Int(index)) as? String
//        print("imageName",imageName)
//        if (index > 0 && index == 4) {
//            if gotResponse == true {
//                if (imageName != nil) {
//                    let adPlaceholder: UIImageView? = UIImageView (frame: view!.bounds)
//                    adPlaceholder?.image = UIImage (named: "adImage")
//                    view?.addSubview(adPlaceholder!)
//                    
//                    ImageLoader.sharedLoader.imageForUrl(imageName!, completionHandler:{(image: UIImage?, url: String) in
//                        view?.image = image
//                        IMNative.bindNative(self.native, toView: view);
//                    })
//                    
////                    let image: UIImage? = IMGlobalImageCache.sharedCache().imageForKey(imageName)
////                    view?.image = image
////                    IMNative.bindNative(self.native, toView: view);
//                }
//                else {
//                    view?.image = UIImage (named: "adImage")
//                }
//            } else {
//                view?.image = UIImage (named: imageName!)
//            }
//        } else {
//            view?.image = UIImage (named: imageName!)
//        }
//        view?.clipsToBounds = true;
//        view?.contentMode = .ScaleAspectFit;
//        
//        return view;
//    }
//    
//    
//    
//    func carousel(carousel: iCarousel!, itemTransformForOffset offset: CGFloat, baseTransform transform: CATransform3D) -> CATransform3D {
//        let transf = CATransform3DRotate(transform, CGFloat(M_PI / 8), 0, 1, 0)
//        return CATransform3DTranslate(transf, 0.0, 0.0, offset * carousel.itemWidth);
//        
//    }
//    
//    func carousel(carousel: iCarousel!, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
//        switch option {
//        case .Wrap:
//            return 0
//        case .Spacing:
//            return value * 1.05
//        default:
//            return value
//        }
//    }
//    
//    
//    // MARK: iCarousel taps
//    
//    func carousel(carousel: iCarousel!, didSelectItemAtIndex index: Int) {
//        NSLog("Tapped view number: \(index)")
//        
//        if (gotResponse == true && index == 4) {
//            
//            let dict: NSDictionary? = self.dictFromNativeContent()
//            
//            // Let sdk handles the ad click
//            
//            self.native?.reportAdClickAndOpenLandingURL(dict as! [NSObject : AnyObject])
//        }
//    }
//    
//
//    
//     */
//    
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}

//
//  ADCellView.swift
//  WeParyer
//
//  Created by Jeccy on 16/6/2.
//  Copyright © 2016年 Jeccy. All rights reserved.
//

import UIKit

class ADCellView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
//    var labelTitle : UILabel?
    var imageView : UIImageView?
    var native : IMNative?
    
    override init(frame:CGRect)
    {
        super.init(frame:frame)
        backgroundColor = UIColor.purpleColor()

        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOpacity = 0.33
        self.layer.shadowOffset = CGSizeMake(0, 1.5)
        self.layer.shadowRadius = 4.0
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.mainScreen().scale
        self.layer.cornerRadius = 10.0
        
        
        imageView = UIImageView()
        imageView?.frame = CGRectMake(5, 5, self.frame.size.width - 10, self.frame.size.height-10)
        imageView?.layer.cornerRadius =  8.0
//        imageView?.backgroundColor = UIColor.blueColor()
        self.addSubview(imageView!)
        
//        labelTitle = UILabel()
//        labelTitle?.frame = CGRectMake(20, self.frame.size.height-25, self.frame.size.width - 30, 20)
//        labelTitle?.textColor = UIColor.lightGrayColor()
//        self.addSubview(labelTitle!)

        let button = UIButton(type: .Custom)
        button.frame = self.frame
        button.addTarget(self, action: #selector(self.buttonTapped(_:)), forControlEvents: .TouchUpInside)
        self.addSubview(button)
        
    }
    
    func buttonTapped(sender:AnyObject)  {
        NSNotificationCenter.defaultCenter().postNotificationName("ImageUrlReceiveNotification", object: nil, userInfo: nil)
    }
    
    func setNative1(native1 : IMNative)
    {
        self.native = native1
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func notificationReceive(sender :NSNotification) {
        let nextNotice = sender.userInfo!["imageUrl"] as! String
        print("notificationReceive",nextNotice)
        ImageLoader.sharedLoader.imageForUrl(nextNotice, completionHandler:{(image: UIImage?, url: String) in
            self.imageView?.image = image
            IMNative.bindNative(self.native, toView: self);
        })

    }
}

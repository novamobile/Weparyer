//
//  ImageLoader.swift
//  extension
//
//  Created by Nate Lyman on 7/5/14.
//  Copyright (c) 2014 NateLyman.com. All rights reserved.
//
import UIKit
import Foundation


class ImageLoader {
    
    let cache = NSCache()

    class var sharedLoader : ImageLoader {
    struct Static {
        static let instance : ImageLoader = ImageLoader()
        }
        return Static.instance
    }
    
	func imageForUrl(urlString: String, completionHandler:(image: UIImage?, url: String) -> ()) {
        let kCachedNewImage = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0].stringByAppendingString("/adnew.png")
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {()in
			let data: NSData? = self.cache.objectForKey(urlString) as? NSData
			
			if let goodData = data {
				let image = UIImage(data: goodData)
				dispatch_async(dispatch_get_main_queue(), {() in
					completionHandler(image: image, url: urlString)
				})
				return
			}
			
			let downloadTask: NSURLSessionDataTask = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: urlString)!, completionHandler: {(data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
				if (error != nil) {
					completionHandler(image: nil, url: urlString)
					return
				}
				
				if let data = data {
					let image = UIImage(data: data)
//					self.cache.setObject(data, forKey: urlString)
                    data.writeToFile(kCachedNewImage, atomically: true)
					dispatch_async(dispatch_get_main_queue(), {() in
						completionHandler(image: image, url: urlString)
					})
					return
				}
				
			})
			downloadTask.resume()
		})
	}
    
    func isShouldDisplayAd() -> Bool {
        var res = false
        let kCachedCurrentImage = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0].stringByAppendingString("/adcurrent.png")
        let kCachedNewImage = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0].stringByAppendingString("/adnew.png")
        res = NSFileManager.defaultManager().fileExistsAtPath(kCachedCurrentImage, isDirectory: nil) || NSFileManager.defaultManager().fileExistsAtPath(kCachedNewImage, isDirectory: nil)
        return res
    }
    
    func getAdImage() -> UIImage {
        let kCachedCurrentImage = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0].stringByAppendingString("/adcurrent.png")
        let kCachedNewImage = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0].stringByAppendingString("/adnew.png")
        if(NSFileManager.defaultManager().fileExistsAtPath(kCachedNewImage, isDirectory: nil))
        {
            do {
                try NSFileManager.defaultManager().removeItemAtPath(kCachedCurrentImage)
            } catch let error as NSError {
                // 发生了错误
                print(error.localizedDescription)
            }

            do {
                try  NSFileManager.defaultManager().moveItemAtPath(kCachedNewImage, toPath: kCachedCurrentImage)
            } catch let error1 as NSError {
                // 发生了错误
                print(error1.localizedDescription)
            }
        }
        return UIImage.init(data: NSData.init(contentsOfFile: kCachedCurrentImage)!)!
    }
}
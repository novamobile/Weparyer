//
//  Category.swift
//  WeParyer
//
//  Created by Jeccy on 16/9/5.
//  Copyright © 2016年 Jeccy. All rights reserved.
//

import UIKit

extension NSString {
    func textSizeWithFont(font: UIFont, constrainedToSize size:CGSize) -> CGSize {
        var textSize:CGSize!
        if CGSizeEqualToSize(size, CGSizeZero) {
            let attributes = NSDictionary(object: font, forKey: NSFontAttributeName)
            textSize = self.sizeWithAttributes(attributes as? [String : AnyObject])
        } else {
            let option = NSStringDrawingOptions.UsesLineFragmentOrigin
            let attributes = NSDictionary(object: font, forKey: NSFontAttributeName)
            let stringRect = self.boundingRectWithSize(size, options: option, attributes: attributes as? [String : AnyObject], context: nil)
            textSize = stringRect.size
        }
        return textSize
    }
}

extension NSURLRequest {
    convenience init(path: String!,params: NSDictionary!) {
        let urlStr = NSMutableString(string: "\(kBaseURL)\(path)")
        //拼接参数
        if (params != nil) {
            //拼接一个?
            urlStr.appendFormat("?")
            
            //拼接accessToken
            urlStr.appendFormat("%@=%@",wAccessToken,AccountTool.sharedAccountTool().currentAccount.accessToken)
            print("发送请求",urlStr)
            params.enumerateKeysAndObjectsUsingBlock({
                (key, obj, stop) -> Void in
                urlStr.appendFormat("&%@=%@",key as! NSString,obj as! NSString)
            })
        }
        
        let url = NSURL(string: urlStr as String)
        self.init(URL: url!)
    }
}

extension NSMutableURLRequest {
    convenience init(path: String!) {
        let urlStr = NSMutableString(string: "\(kBaseURL)\(path)")
        let url = NSURL(string: urlStr as String)
        self.init(URL: url!)
    }
}

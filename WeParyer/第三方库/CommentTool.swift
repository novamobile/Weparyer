//
//  CommentTool.swift
//  Weibo
//
//  Created by 林億 on 14/6/26.
//  Copyright (c) 2014年 林億. All rights reserved.
//

import UIKit

class CommentTool: NSObject {
    class func commentsWithSinceId(sinceId:NSString?,maxId:NSString?,
        success:((comments:NSMutableArray!) -> Void)!, fail:(((Void) -> Void))!, isMentionComment:Bool!) {
        
            let params = NSMutableDictionary()
            params.setObject(sinceId!, forKey:"since_id")
            params.setObject(maxId!, forKey:"max_id")
            
            var request:NSURLRequest!
            if isMentionComment == true {
                request = NSURLRequest(path: kMentionComments,params: params)
            } else {
                request = NSURLRequest(path: kCommentsToMe,params: params)
            }
            let operation = AFJSONRequestOperation.init(request:request, success: {
                (request: NSURLRequest!, response: NSHTTPURLResponse!, let JSON) -> Void in
                let Dict = JSON as! NSDictionary
                
                //取出所有的微博数据
                let array = Dict["comments"] as! NSArray
                //解析数据为模型
                let comments = NSMutableArray()
                for i in 0..<array.count {
                    let dict = array[i] as! NSDictionary
                    let status = Comment(Dict: dict)
                    comments.addObject(status)
                }
                
                //回调success
                if (success != nil) {
                    success(comments:comments)
                }
                }, failure: {
                    (request: NSURLRequest!, response: NSHTTPURLResponse!, error:NSError!, let JSON) -> Void in
                    if (fail != nil) {
                        fail()
                    }
                })
            //发送请求
            operation.start()
    }
    
    class func commentsForStatus(idstr:NSString!, var sinceId:NSString?, var maxId:NSString?,
        success:((comments:NSMutableArray!) -> Void)!, fail:(((Void) -> Void))!) {
            if sinceId == nil {
                sinceId = "0"
            }
            if maxId == nil {
                maxId = "0"
            }
        
            let params = NSMutableDictionary()
            params.setObject(sinceId!, forKey:"since_id")
            params.setObject(maxId!, forKey:"max_id")
            params.setObject(idstr, forKey: "id")
            
            let request = NSURLRequest(path: kCommentsForStatus,params: params)
            let operation = AFJSONRequestOperation.init(request:request, success: {
                (request: NSURLRequest!, response: NSHTTPURLResponse!, let JSON) -> Void in
                let Dict = JSON as! NSDictionary
                
                //取出所有的微博数据
                let array = Dict["comments"] as! NSArray
                //解析数据为模型
                let comments = NSMutableArray()
                for i in 0..<array.count {
                    let dict = array[i] as! NSDictionary
                    let status = Comment(Dict: dict)
                    comments.addObject(status)
                }
                
                //回调success
                if (success != nil) {
                    success(comments:comments)
                }
                }, failure: {
                    (request: NSURLRequest!, response: NSHTTPURLResponse!, error:NSError!, let JSON) -> Void in
                    if (fail != nil) {
                        fail()
                    }
                })
            //发送请求
            operation.start()
    }

}

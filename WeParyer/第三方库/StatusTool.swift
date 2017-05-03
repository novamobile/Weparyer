//
//  StatusTool.swift
//  Weibo
//
//  Created by 林億 on 14/6/21.
//  Copyright (c) 2014年 林億. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class StatusTool: NSObject {
    class func statusesWithSinceId(sinceID:NSString?,
        success:((statuses:NSMutableArray!) -> Void)!, fail:(((Void) -> Void))!, isMention:Bool!) {

        var accessToken = ""
        if(AccountTool.sharedAccountTool().currentAccount != nil)
        {
            accessToken = AccountTool.sharedAccountTool().currentAccount.accessToken as String
        }else{
            accessToken = NSUserDefaults.standardUserDefaults().objectForKey(wTouristAccessToken) as! String
        }
        
        var para_listAll  = [String:AnyObject]()
        if sinceID == nil{
            para_listAll = ["accessToken": accessToken]
        }
        else{
            para_listAll = [
                "accessToken": accessToken,
                "startIndex" : sinceID!
            ]
        }

        Alamofire.request(.POST, POST_LIST_ALL_URL,parameters:para_listAll)
            .responseJSON { response in
                if let recvied = response.result.value {
                    print("get->returnJSON4: \(recvied)")
                    let json = JSON(recvied)
                    if(json["error_code"] == 10000)
                    {
                        let statuses_ = NSMutableArray()
                        print("json[].stringValue",json["data"].stringValue)
                        let dic_noteList = JSON.parse(json["data"].stringValue)
                        let dic = dic_noteList["noteList"].dictionary!
                        let dic_single = dic["data"]?.arrayObject!
                        for i in 0..<dic_single!.count {
                            let dict = dic_single![i]
                            let status = Status(Dict: dict as! NSDictionary)
                            statuses_.addObject(status)
                        }
                        
                        if(success != nil)
                        {
                            print("statuses",statuses_)
                            success(statuses:statuses_)
                        }
                    }
                    else{
                        fail()
                    }
                }
        }
    }
}

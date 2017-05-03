//
//  Contans.swift
//  WeParyer
//
//  Created by Jeccy on 16/7/4.
//  Copyright © 2016年 Jeccy. All rights reserved.
//

import Foundation
import UIKit


let TABLEVIEW_CELL_HEIGHT : CGFloat = 44.0

let CUSTOM_BLUE_COLOR : UIColor = UIColor.init(colorLiteralRed: 47.0/255.0, green: 177.0/255.0, blue: 1.0, alpha: 1.0)

let IS_ARB : Bool = NSLocale.preferredLanguages()[0].containsString("ar")

let IS_EN : Bool = NSLocale.preferredLanguages()[0].containsString("en")

let SCREEN_SIZE_WIDTH = UIScreen.mainScreen().bounds.size.width

let SCREEN_SIZE_HEIGHT = UIScreen.mainScreen().bounds.size.height

let CUSTOM_ARABIC_FONT = "Neo Sans Arabic"

func Is12HoursStyle() -> Bool {
    let h_String : NSString = NSDateFormatter.dateFormatFromTemplate("j", options: 0, locale: NSLocale.currentLocale())!
    let h_range = h_String.rangeOfString("a")
    return  (h_range.location != NSNotFound)
}

func Handle12HoursStyle(time : String) -> String {
    var finial_time_str : String = time
    if(Is12HoursStyle())
    {
        let dateFormatter = NSDateFormatter()
        if IS_ARB == false {
            dateFormatter.AMSymbol = "AM"
            dateFormatter.PMSymbol = "PM"
        }
        dateFormatter.dateFormat = "H:mm"
        let dateTime = dateFormatter.dateFromString(time)
        dateFormatter.dateFormat = "h:mma"
        finial_time_str = dateFormatter.stringFromDate(dateTime!) as String
    }
    return finial_time_str
}

// 昵称
let kScreenNameColor = UIColor.blackColor()//UIColor(red: 88/255.0, green: 88/255.0, blue: 88/255.0, alpha: 1)
// 会员昵称颜色
let kMBScreenNameColor = UIColor.blackColor()//UIColor(red: 244/255.0, green: 103/255.0, blue: 8/255.0, alpha: 1)
// 时间
let kTimeColor = UIColor.lightGrayColor()//UIColor(red: 246/255.0, green: 157/255.0, blue: 46/255.0, alpha: 1)
// 内容
let kContentColor = UIColor(red: 52/255.0, green: 52/255.0, blue: 52/255.0, alpha: 1)
// 来源
let kSourceColor = UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1)
// 被转发昵称
let kRetweetScreenNameColor = UIColor(red: 81/255.0, green: 126/255.0, blue: 175/255.0, alpha: 1)
// 被转发内容
let kRetweetContentColor = UIColor(red: 109/255.0, green: 109/255.0, blue: 109/255.0, alpha: 1)
// 回复的评论
let kReplyCommentContentColor = UIColor(red: 109/255.0, green: 109/255.0, blue: 109/255.0, alpha: 1)

// 字体大小
// 昵称
let kScreenNameFont = UIFont.boldSystemFontOfSize(13)
// 正文
let kContentFont = UIFont.systemFontOfSize(16)
// 时间
let kTimeFont = UIFont.systemFontOfSize(12)
// 来源
let kSourceFont = UIFont.systemFontOfSize(12)
// 图片
let kStatusOneImageWidth:CGFloat = UIScreen.mainScreen().bounds.size.width//380
let kStatusOneImageHeight:CGFloat = kStatusOneImageWidth//375

let kStatusImageMargin:CGFloat = 10
// 被转发的昵称
let kRetweetScreenNameFont = UIFont.systemFontOfSize(17)
// 被转发的正文
let kRetweetContentFont = UIFont.systemFontOfSize(17)
// 回复的评论正文
let kReplyCommentContentFont = UIFont.systemFontOfSize(17)

enum IconViewType:Int {
    case Small = 0,
    Default,
    Big
}


// 头像的尺寸
let kIconWidth:CGFloat = 50
let kIconHeight:CGFloat = 50

let kIconSmallWidth:CGFloat = 42//34
let kIconSmallHeight:CGFloat = 42//34

let kIconBigWidth:CGFloat = 85
let kIconBigHeight:CGFloat = 85

// 加V的尺寸
let kVerifiedWidth:CGFloat = 18
let kVerifiedHeight:CGFloat = 18

// 皇冠的尺寸
let kMBIconWidth:CGFloat = 14
let kMBIconHeight:CGFloat = 14

// cell边框的宽度
let kCellBorderWidth:CGFloat = 5

// 配图的尺寸
let kImageWidth:CGFloat = 120
let kImageHeight:CGFloat = 120

let kAppKey = "1994512405"
let kAppSecret = "8e21730770dcbf46edf44429fa61d802"

let kAdRequestURL = "http://146.0.229.49:9000/community/inMobi/obtain"

let kRedirectURL = "https://api.weibo.com/oauth2/default.html"

let kOauthURL = "https://api.weibo.com/oauth2/authorize?client_id=\(kAppKey)&redirect_uri=\(kRedirectURL)&display=mobile&response_type=code"
let kBaseURL = "https://api.weibo.com/2/"
let kStatusesPath = "statuses/friends_timeline.json"
let kFriendships = "friendships/friends.json"
let kTextStatus = "statuses/update.json"
let kImageStatus = "https://api.weibo.com/2/statuses/upload.json"
let kCommentCreate = "comments/create.json"
let kRepostStatus = "statuses/repost.json"
let kCommentReplay = "comments/reply.json"
let kCommentsToMe = "comments/to_me.json"
let kMentionStatuses = "statuses/mentions.json"
let kMentionComments = "comments/mentions.json"
let kCommentsForStatus = "comments/show.json"


/*
 var accessToken : NSString!
 var screenName  : NSString!
 var source      : NSInteger!
 var avatar      : NSString!
 var state       : NSInteger!
 var email       : NSString!
 var sex         : NSInteger!
 var tel         : NSInteger!
 var uid         : NSString!
 */

let wAccessToken = "w_access_token"
let wUid = "w_uid"
let wScreenName = "w_screen_name"
let wSource = "w_source"
let wAvatar = "w_avatar"
let wState = "w_state"
let wEmail = "w_email"
let wSex = "w_sex"
let wTel = "w_tel"

let wIsTourist = "w_IsTourist"
let wTouristAccessToken = "w_TouristAccessToken"

/*
 帖子接口定义
 */

//远程服务器地址
let postServerIp = "120.25.172.90:9000"

let TOURIST_LOGIN_URL       = "http://\(postServerIp)/community/user/tourist"

//注册接口
let REGISTE_URL             = "http://\(postServerIp)/community/user/register"

//激活用户
let ACTIVITY_URL            = "http://\(postServerIp)/community/user/activation"

//用户信息更新
let UPDATE_USER_INFO_URL    = "http://\(postServerIp)/community/user/update"

//发布动态
let POST_PUBLISH_URL        = "http://\(postServerIp)/community/post/publish"

//发表评论
let COMMENT_PUBLISH_URL     = "http://\(postServerIp)/community/comment/publish"

//点赞
let COMMENT_LIKES_URL       = "http://\(postServerIp)/community/post/likes"

//取消点赞
let COMMENT_UNLIKES_URL     = "http://\(postServerIp)/community/comment/unLikes"

//转发
let POST_FORWARD_URL        = "http://\(postServerIp)/community/post/forward"

//举报帖子
let TIPOFF_NOTE_URL         = "http://\(postServerIp)/community/tipOff/note"

//举报用户
let TIPOFF_USER_URL         = "http://\(postServerIp)/community/tipOff/user"

//关注
let FOLLOW_USER_URL         = "http://\(postServerIp)/community/follow/user"

//取消关注
let FOLLOW_UNUSER_URL       = "http://\(postServerIp)/community/follow/unUser"

//更新查看粉丝状态
let FOLLOW_STATE_URL        = "http://\(postServerIp)/community/follow/state"

//我关注人的列表
let FOLLOW_FOLLOW_URL       = "http://\(postServerIp)/community/follow/follow"

//粉丝列表
let FOLLOW_FANS_URL         = "http://\(postServerIp)/community/follow/fans"

//检索用户
let USER_SEARCH_URL         = "http://\(postServerIp)/community/user/search"

//用户列表
let USER_LIST_URL           = "http://\(postServerIp)/community/user/list"

//获取本人用户详情
let USER_GET_URL            = "http://\(postServerIp)/community/user/get"

//获取其他用户详情
let USER_GET_OTHER_URL      = "http://\(postServerIp)/community/user/getOther"

//更新用户状态
let USER_UPDATE_STATE_URL   = "http://\(postServerIp)/community/user/updateState"

//被举报的用户列表
let TIPOFF_USER_LIST_URL    = "http://\(postServerIp)/community/tipOff/userList"

//被举报的帖子列表
let TIPOFF_NOTE_LIST_URL    = "http://\(postServerIp)/community/tipOff/noteList"

//我所发布的所有帖子
let POST_LIST_URL           = "http://\(postServerIp)/community/post/list"

//附近所有
let POST_LIST_ALL_URL       = "http://\(postServerIp)/community/post/listAll"

//我关注人的帖子
let POST_FOLLOW_LIST_URL    = "http://\(postServerIp)/community/post/followList"

//搜索帖子
let POST_SEARCH_URL         = "http://\(postServerIp)/community/post/search"

//更新密码
let UPDATE_PASSWORD_URL     = "http://\(postServerIp)/community/user/updatePassword"

//找回密码
let RETRIEVE_PASSWORD_URL   = "http://\(postServerIp)/community/user/retrievePassword"

//用密码直接登录
let LOGIN_WITH_PASSWORD_URL = "http://\(postServerIp)/community/user/login"


/*
 其他定义
 */

let KEY_ACCESS_TOKEN        = "accessToken"

extension String {
    var unicodeStr:String {
        let tempStr1 = self.stringByReplacingOccurrencesOfString("\\u", withString: "\\U")
        let tempStr2 = tempStr1.stringByReplacingOccurrencesOfString("\"", withString: "\\\"")
        let tempStr3 = "\"".stringByAppendingString(tempStr2).stringByAppendingString("\"")
        let tempData = tempStr3.dataUsingEncoding(NSUTF8StringEncoding)
        var returnStr:String = ""
        do {
            returnStr = try NSPropertyListSerialization.propertyListWithData(tempData!, options: .Immutable, format: nil) as! String
        } catch {
            print(error)
        }
        return returnStr.stringByReplacingOccurrencesOfString("\\r\\n", withString: "\n")
    }
}

func saveDataTodayByNSUserDefaults(data:String,key:String){
    let userDefaults = NSUserDefaults.init(suiteName: "group.com.nova.wepray")
    userDefaults?.setObject(data, forKey: key)
    userDefaults?.synchronize()
}



//
//  SettingViewController.swift
//  WeParyer
//
//  Created by Jeccy on 16/4/19.
//  Copyright © 2016年 Jacy. All rights reserved.
//

import UIKit
//import Alamofire
//import SwiftyJSON

class SettingViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,ReaderViewControllerDelegate{
    
    var tableView:UITableView! = nil
    let prayTime = PrayTime()
    let items = [
                 [ChapelToolUtils.getLocalizedStr("key_DaylightSavingTime"),ChapelToolUtils.getLocalizedStr("key_CalcTimeMethod")],
                 [ChapelToolUtils.getLocalizedStr("key_ContactUs"),ChapelToolUtils.getLocalizedStr("key_TellFriend"),ChapelToolUtils.getLocalizedStr("key_Rating"),ChapelToolUtils.getLocalizedStr("key_FaceBookSupport")],
                 [ChapelToolUtils.getLocalizedStr("key_Version")]]
    
    let images = [
        ["dhuhr_set","img_calcMethod"],
        ["img_contactus","img_tellFriend","img_fivestarRate","img_faceBook"],
        ["img_currentVersion"],
        ]
    
    var userInfo = Dictionary<String, AnyObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = ChapelToolUtils.getLocalizedStr("key_Settings")
        if IS_ARB {
            self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: CUSTOM_ARABIC_FONT, size: 18)!, NSForegroundColorAttributeName: UIColor.blackColor()]
        }
//        self.navigationController?.navigationBar.titleTextAttributes =  [NSForegroundColorAttributeName:UIColor.blackColor()]
        //        self.navigationController?.navigationBar.barStyle = .Default
//        self.navigationController?.navigationBar.tintColor = UIColor.redColor() //init(colorLiteralRed: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        //加载表格视图
        self.loadTableView()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.DayLightSelectResult(_:)) , name: "changleDayLightResult", object: nil)
    }
    
    func RefreshUserInfo()
    {
        /*
        var accessToken = ""
        if(AccountTool.sharedAccountTool().currentAccount != nil)
        {
            accessToken = AccountTool.sharedAccountTool().currentAccount.accessToken as String
        }
        else{
            self.tableView.mj_header.endRefreshing()
        }
        
        let para_userGet = [
            "accessToken": accessToken
        ]
        
        Alamofire.request(.POST, USER_GET_URL,parameters:para_userGet)
            .responseJSON { response in
                if let recvied = response.result.value {
                    print("get->returnJSON3: \(recvied)")
                    let json = JSON(recvied)
                    if(json["error_code"] == 10000)
                    {
                        print("json[].stringValue",json["data"].stringValue)
                        let user_info = JSON.parse(json["data"].stringValue)
                        print("用户详情",user_info)
                        self.userInfo = user_info["user"].dictionaryObject!
                        self.tableView.reloadData()
                        self.tableView.mj_header.endRefreshing()
                    }
                    else{
                        self.tableView.mj_header.endRefreshing()
                    }
                }
        }
         */
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController!.navigationBar.tintColor = UIColor(colorLiteralRed: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)//改变返回按钮的箭头颜色
//        //        UDNavigationController *nav = (UDNavigationController *)self.navigationController;
//        let nav : UDNavigationController = self.navigationController as! UDNavigationController
//        nav.setAlph(1.0)
//        //        [nav setAlph:1];
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //加载表格视图
    func loadTableView() {
        self.tableView = UITableView(frame:self.view.frame, style: UITableViewStyle.Grouped)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.init(colorLiteralRed: 246.0/255.0, green: 246.0/255.0, blue: 246.0/255.0, alpha: 1.0)
        self.view.addSubview(self.tableView)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items[section].count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.section == 0 && indexPath.row == 0)
        {
            return TABLEVIEW_CELL_HEIGHT
        }
        else
        {
            return TABLEVIEW_CELL_HEIGHT
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "identtifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: identifier)
        }
        
        if self.items[indexPath.section][indexPath.row] != ChapelToolUtils.getLocalizedStr("key_Version") {
            cell?.accessoryType=UITableViewCellAccessoryType.DisclosureIndicator;
        }else{
            cell?.accessoryType=UITableViewCellAccessoryType.None
            let shortVersion = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
            cell?.detailTextLabel?.font = UIFont.systemFontOfSize(16)
            cell?.detailTextLabel!.text = "V"+"\(shortVersion)"
//            cell?.userInteractionEnabled = false
        }
        
        /*
        if(indexPath.section == 0 && indexPath.row == 0)
        {
            if AccountTool.sharedAccountTool().currentAccount != nil {
                cell?.textLabel?.text = AccountTool.sharedAccountTool().currentAccount.screenName as String
                
                var frame1 : CGRect = CGRectMake(15,(TABLEVIEW_CELL_HEIGHT-46.0)/2,46,46)
                if NSLocale.preferredLanguages()[0].containsString("ar") {
                    frame1 = CGRectMake(UIScreen.mainScreen().bounds.size.width-20,(TABLEVIEW_CELL_HEIGHT-46.0)/2,46,46)
                }
                
                cell?.imageView?.image = UIImage(named: "img_headImage1")
                cell?.imageView?.hidden = true

                if let view = cell?.viewWithTag(10101){
                    view.hidden = false
                }else{
                    let headImageView = UIImageView(frame: frame1)
                    let iconURL = NSURL(string: AccountTool.sharedAccountTool().currentAccount.avatar as String)
                    headImageView.sd_setImageWithURL(iconURL, placeholderImage: UIImage(named: "img_headImage1"), completed: { (image, error, type, url) in
                        headImageView.image = image
                    })
                    headImageView.layer.masksToBounds = true
                    headImageView.layer.cornerRadius = 46/2
                    headImageView.layer.borderWidth = 0.5
                    headImageView.layer.borderColor = UIColor.lightGrayColor().CGColor
                    headImageView.tag = 10101
                    cell?.addSubview(headImageView)
                }
            }else{
                cell?.imageView?.image = UIImage(named: "img_headImage1")
                cell?.imageView?.hidden = false
                cell?.textLabel?.text = "未登录"
                if let view = cell?.viewWithTag(10101){
                    view.hidden = true
                }
            }
        }
        else*/
        if self.images[indexPath.section][indexPath.row] != ""
        {
            cell?.imageView?.image = UIImage(named: self.images[indexPath.section][indexPath.row])
            cell?.textLabel?.text = self.items[indexPath.section][indexPath.row]
            print(cell?.textLabel?.font)
        }
        
        if self.items[indexPath.section][indexPath.row] == ChapelToolUtils.getLocalizedStr("key_DaylightSavingTime") {
            let frame1 : CGRect = CGRectMake(30,(TABLEVIEW_CELL_HEIGHT-20)/2.0,UIScreen.mainScreen().bounds.size.width-60,20)

            if(cell?.viewWithTag(880) == nil)
            {
                let dayLightResultLabel = UILabel(frame: frame1)
                dayLightResultLabel.tag = 880
                dayLightResultLabel.textColor = UIColor.lightGrayColor()
                if NSLocale.preferredLanguages()[0].containsString("ar") {
                    dayLightResultLabel.textAlignment = .Left
                }
                else
                {
                    dayLightResultLabel.textAlignment = .Right
                }
                let result = NSUserDefaults.standardUserDefaults().integerForKey("daylight")
                var resultStr = ""
                if(result == 0)
                {
                    resultStr = "+1"
                }else if(result == 1)
                {
                    resultStr = ChapelToolUtils.getLocalizedStr("key_DayLightingSaveDefault")
                }
                else if(result == 2)
                {
                    resultStr = "-1"
                }
                dayLightResultLabel.text = resultStr
                cell?.detailTextLabel?.font = UIFont.systemFontOfSize(16)
                cell?.detailTextLabel!.text = resultStr
//                cell?.addSubview(dayLightResultLabel)
            }
            else
            {
                let result = NSUserDefaults.standardUserDefaults().integerForKey("daylight")
                var resultStr = ""
                if(result == 0)
                {
                    resultStr = "+1"
                }else if(result == 1)
                {
                    resultStr = ChapelToolUtils.getLocalizedStr("key_DayLightingSaveDefault")
                }
                else if(result == 2)
                {
                    resultStr = "-1"
                }
                let view = cell?.viewWithTag(880) as! UILabel
                view.text = resultStr
            }
        }
        
        
//        let firstOpenPushSoundView =  NSUserDefaults.standardUserDefaults().integerForKey("firstOpenPushSoundView")
//        if firstOpenPushSoundView == 0 && indexPath.section == 0 && indexPath.row == 1 {
//            let view = UIView()
//            view.tag = 999
//            view.layer.cornerRadius = 4.8
//            view.backgroundColor = UIColor.redColor()
//            if NSLocale.preferredLanguages()[0].containsString("ar") {
//                view.frame = CGRectMake(-5, -5, 10, 10)
//            }
//            else
//            {
//                view.frame = CGRectMake(20, -5, 10, 10)
//            }
//            cell?.imageView?.addSubview(view)
//        }

//        let firstOpenSelectCalcTimeViewController =  NSUserDefaults.standardUserDefaults().integerForKey("isFirstOpenSelectCalcTimeViewController")
//        if(firstOpenSelectCalcTimeViewController == 0 && indexPath.section == 0 && indexPath.row == 1)
//        {
//            let view = UIView()
//            view.tag = 999
//            view.layer.cornerRadius = 4.8
//            view.backgroundColor = UIColor.redColor()
//            if NSLocale.preferredLanguages()[0].containsString("ar") {
//                view.frame = CGRectMake(-5, -5, 10, 10)
//            }
//            else
//            {
//                view.frame = CGRectMake(20, -5, 10, 10)
//            }
//            cell?.imageView?.addSubview(view)
//        }
        
        return cell!
    }
    
    func DayLightSelectResult(sender : AnyObject) {
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //取消选中的样式
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let item = UIBarButtonItem(title: ChapelToolUtils.getLocalizedStr("key_Settings"), style: .Plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item
        
//        //调整时间
//        if indexPath.section == 0 &&  indexPath.row == 0 {
//            self.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(SoundViewController(), animated: true)
//            self.hidesBottomBarWhenPushed = false
//        }
//        //推送声
//        else if indexPath.section == 0 &&  indexPath.row == 1 {
//            self.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(PushSoundSelectViewController(), animated: true)
//            self.hidesBottomBarWhenPushed = false
//            
//            NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "firstOpenPushSoundView")
//            let cell = tableView.cellForRowAtIndexPath(indexPath)
//            let redPointView = cell?.viewWithTag(999)
//            if(redPointView != nil)
//            {
//                redPointView?.removeFromSuperview()
//            }
//            NSNotificationCenter.defaultCenter().postNotificationName("showNewMessageRedPointNotification", object: nil, userInfo: nil)
//        }
//        //手动调整
//        else if indexPath.section == 0 &&  indexPath.row == 2 {
//            let controller = ImprovementTimeViewController(nibName:"ImprovementTimeViewController", bundle:nil)
//            self.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(controller, animated: true)
//            self.hidesBottomBarWhenPushed = false
//        }
        //夏令时
        /*
        if indexPath.section == 0 &&  indexPath.row == 0 {
            if(AccountTool.sharedAccountTool().currentAccount != nil)
            {
                self.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(UserInfoViewController(), animated: true)
                self.hidesBottomBarWhenPushed = false
            }
        }
        else */if indexPath.section == 0 &&  indexPath.row == 0 {
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(DaylightSavingTimeViewController(), animated: true)
            self.hidesBottomBarWhenPushed = false
        }
        else if indexPath.section == 0 &&  indexPath.row == 1 {
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(SelectCalcTimeViewController(), animated: true)
            self.hidesBottomBarWhenPushed = false
            
            /*移除新功能红点
            NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "isFirstOpenSelectCalcTimeViewController")
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            let redPointView = cell?.viewWithTag(999)
            if(redPointView != nil)
            {
                redPointView?.removeFromSuperview()
            }
            NSNotificationCenter.defaultCenter().postNotificationName("showNewMessageRedPointNotification", object: nil, userInfo: nil)
            */
        }
        else if indexPath.section == 0 &&  indexPath.row == 1 {
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(DaylightSavingTimeViewController(), animated: true)
            self.hidesBottomBarWhenPushed = false
            
            NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "firstOpenDayLightingTimeView")
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            let redPointView = cell?.viewWithTag(998)
            if(redPointView != nil)
            {
                redPointView?.removeFromSuperview()
            }
            NSNotificationCenter.defaultCenter().postNotificationName("showNewMessageRedPointNotification", object: nil, userInfo: nil)
        }
//        else if indexPath.section == 1 &&  indexPath.row == 0 {
//            openPDFView()
//        }
        //联系我们
        else if indexPath.section == 1 &&  indexPath.row == 0 {
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(MailInfoTableViewController(), animated: true) //新版联系我们
            self.hidesBottomBarWhenPushed = false
            //SendEmail()//self.navigationController?.pushViewController(DaylightSavingTimeViewController(), animated: true)
        }
            //告诉好友
        else if indexPath.section == 1 &&  indexPath.row == 1 {
            let actionSheet = UIAlertController(title: ChapelToolUtils.getLocalizedStr("key_TellFriend"), message: "", preferredStyle: .ActionSheet)
            let cancelAction = UIAlertAction(title: ChapelToolUtils.getLocalizedStr("key_cancle"), style: .Cancel) { (action) in
                print("取消")
            }
            let manAction=UIAlertAction(title:"WhatsApp",style:UIAlertActionStyle.Default){ (action) in
                print("信息")
                let url = self.prayTime.shareToWhatapp()
                if (url != nil) {
                    print("urlString",url)
                    if UIApplication.sharedApplication().canOpenURL(url) {
                        UIApplication.sharedApplication().openURL(url)
                    } else {
                        // Cannot open whatsapp
                    }
                }
            }
            //            let womenAction=UIAlertAction(title:"FaceBook",style:UIAlertActionStyle.Default){ (action) in
            //                print("FaceBook")
            ////                FBSDKMessengerSharer.shareImage(UIImage(named: ""), withMetadata: "sdasdjaksdkahsdkahsdkahsdkhaksdha", withContext: .None)
            ////                let options = FBSDKMessengerShareOptions()
            ////                options.metadata = "adasdasdasdasda"
            ////                options.sourceURL =  NSURL(string: "https://itunes.apple.com/us/app/wepray/id1111239523")
            ////                FBSDKMessengerSharer.shareImage(UIImage(named: "IconShare"), withOptions: options)
            //
            //                let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
            //                let urlWhats = "https://itunes.apple.com/us/app/wepray/id1111239523?l=zh&ls=1&mt=8"
            //                let urlString = urlWhats.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())
            //                content.contentURL = NSURL(string: urlString!)
            //
            //                FBSDKShareAPI.shareWithContent(content, delegate: nil)
            //
            //                let dialog = FBSDKShareDialog()
            //                dialog.fromViewController = self
            //                dialog.shareContent = content
            //                dialog.mode = .ShareSheet
            //                dialog.show()
            //
            ////                FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
            ////                content.contentURL = [NSURL URLWithString:@"https://developers.facebook.com"];
            //            }
            actionSheet.addAction(cancelAction)
            actionSheet.addAction(manAction)
            //            actionSheet.addAction(womenAction)
            self.presentViewController(actionSheet, animated: true, completion: nil)
        }
        //五星好评
        else if indexPath.section == 1 &&  indexPath.row == 2 {
            UIApplication.sharedApplication().openURL(NSURL(string: "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1111239523&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software")!)
            
            //            let view = IMStrandsViewController()
            //            view.musicName = "Fajr Malek Chebae.mp3"
            //            view.customTitle = "aaa";
            //            let nav = UINavigationController(rootViewController: view)
            //            UIApplication.sharedApplication().keyWindow?.rootViewController!.presentViewController(nav, animated: true) {}
            
            //UIApplication.sharedApplication().openURL(NSURL(string: "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1111239523")!)
        }
        else if indexPath.section == 1 &&  indexPath.row == 3 {
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(fbViewController(), animated: true)
            self.hidesBottomBarWhenPushed = false
            //            NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "firstOpenFaceBookWebView")
            //            let cell = tableView.cellForRowAtIndexPath(indexPath)
            //            let redPointView = cell?.viewWithTag(998)
            //            if(redPointView != nil)
            //            {
            //                redPointView?.removeFromSuperview()
            //            }
            //            NSNotificationCenter.defaultCenter().postNotificationName("showNewMessageRedPointNotification", object: nil, userInfo: nil)
        }
            //当前版本
        else if  indexPath.section == 2 &&  indexPath.row == 0 {
            
        }
        //夏令时
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openPDFView() {
        let phrase = ""
        let pdfs = NSBundle.mainBundle().pathsForResourcesOfType("pdf", inDirectory: nil)
        let filePath = pdfs.first
        let document = ReaderDocument.withDocumentFilePath(filePath, password: phrase)
        if (document != nil) {
            let readerViewController = ReaderViewController.init(readerDocument: document)
            readerViewController.delegate = self
            self.hidesBottomBarWhenPushed = true
            let nav : UDNavigationController = self.navigationController as! UDNavigationController
            nav.setAlph(0.0)
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.navigationController?.pushViewController(readerViewController, animated: true)
            self.hidesBottomBarWhenPushed = false
        }
    }
    
    // MARK: - ReaderViewDelegate
    func dismissReaderViewController(viewController: ReaderViewController!) {
        self.navigationController?.popViewControllerAnimated(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let nav : UDNavigationController = self.navigationController as! UDNavigationController
        nav.setAlph(1.0)
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
}

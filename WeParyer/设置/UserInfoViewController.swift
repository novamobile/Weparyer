//
//  UserInfoViewController.swift
//  WeParyer
//
//  Created by Jeccy on 16/9/10.
//  Copyright © 2016年 Jeccy. All rights reserved.
//

import UIKit
import MJRefresh
//import Alamofire
//import SwiftyJSON

class UserInfoViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var tableView:UITableView! = nil
//    let items = [["头像":"avatar","名字":"nickName","NOVA ID":"userId","性别":"sex"],
 //                ["个性签名":"autograph","我的唤礼声":"sound"],
 //                ["账户":"email","电话":"phone"]]
    let items = [[["头像","avatar"],["名字","nickName"],["NOVA ID","userId"],["性别","sex"]],
                 [["账户","email"],["更改密码",""]],
                    [["注销账户","LogOut"]]]
    
    let values = [
        ["","","",""],
        ["",""],
        [""]
    ]
    var userInfo = Dictionary<String, AnyObject>()
    let curAccount = AccountTool.sharedAccountTool().currentAccount
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    // 底部刷新
    let footer = MJRefreshAutoNormalFooter()
    
    let types = [
        [true,true,false,true],
        [true,false],
        [false,true]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "我"
        
        self.tableView = UITableView(frame: self.view.frame, style: .Grouped)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.view.addSubview(self.tableView)
        
        header.setRefreshingTarget(self, refreshingAction: #selector(self.headerRefresh(_:)))
//        footer.setRefreshingTarget(self, refreshingAction: #selector(self.footerRefresh(_:)))
        self.tableView.mj_header = header
//        self.tableView.mj_footer = footer
        
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 顶部刷新
    func headerRefresh(_:AnyObject){
        print("下拉刷新")
        RefreshUserInfo()
        // 结束刷新
//        self.tableView.mj_header.endRefreshing()
    }
    
    func RefreshUserInfo()
    {
        var accessToken = ""
        if(curAccount != nil)
        {
            accessToken = curAccount.accessToken as String
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
                    print("get->returnJSON5: \(recvied)")
                    let json = JSON(recvied)
                    if(json["error_code"] == 10000)
                    {
                        print("json[].stringValue",json["data"].stringValue)
                        let user_info = JSON.parse(json["data"].stringValue)
                        print("用户详情1",user_info["user"]["avatar"])
                        self.userInfo = user_info["user"].dictionaryObject!
                        self.curAccount.avatar = user_info["user"]["avatar"].stringValue
                        self.curAccount.screenName = user_info["user"]["nickName"].stringValue
                        self.curAccount.email = user_info["user"]["email"].stringValue
                        self.curAccount.source = user_info["user"]["source"].intValue
                        self.curAccount.sex = user_info["user"]["sex"].intValue
                        self.curAccount.uid = user_info["user"]["userId"].stringValue
                        self.tableView.reloadData()
                        self.tableView.mj_header.endRefreshing()
                    }
                    else{
                        self.tableView.mj_header.endRefreshing()
                    }
                }
        }
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
        return 44.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "identtifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: identifier)
        }
        
        let textValue = self.items[indexPath.section][indexPath.row][0]
        cell?.textLabel?.text = textValue
        let key = self.items[indexPath.section][indexPath.row][1]
//        cell?.detailTextLabel?.text = self.values[indexPath.section][indexPath.row]
        if(curAccount != nil)
        {
            if key == "avatar"  {
                var frame1 : CGRect = CGRectMake(UIScreen.mainScreen().bounds.size.width-80,(TABLEVIEW_CELL_HEIGHT-40.0)/2,40,40)
                if NSLocale.preferredLanguages()[0].containsString("ar") {
                    frame1 = CGRectMake(40,(TABLEVIEW_CELL_HEIGHT-40.0)/2,40,40)
                }
                let headImageView = UIImageView(frame: frame1)
                let iconURL = NSURL(string: curAccount.avatar as String)
                headImageView.sd_setImageWithURL(iconURL, placeholderImage:UIImage(named: "img_headImage1"), options:SDWebImageOptions.LowPriority)
                headImageView.layer.masksToBounds = true
                headImageView.layer.cornerRadius = kIconSmallWidth/2
                headImageView.layer.borderWidth = 0.5
                headImageView.layer.borderColor = UIColor.lightGrayColor().CGColor
//                    headImageView.image = UIImage(named: "img_headImage1")
                cell?.addSubview(headImageView)
            }
            else{
                if(key == "sex")
                {
                    if(curAccount.sex == 0)
                    {
                        cell?.detailTextLabel?.text = "女"
                    }
                    else{
                        cell?.detailTextLabel?.text = "男"
                    }
                }
                else if(key == "nickName")
                {
                    cell?.detailTextLabel?.text = curAccount.screenName as String
                }
                else if(key == "email")
                {
                    cell?.detailTextLabel?.text = curAccount.email as String
                }
                else if(key == "userId")
                {
                    cell?.detailTextLabel?.text = curAccount.uid as String
                }else if(key == "LogOut")
                {
                    cell?.textLabel?.hidden = true
                    let logOutLabel = UILabel(frame: CGRectMake(0,0,CGRectGetWidth(self.view.frame),CGRectGetHeight(cell!.frame)))
                    logOutLabel.font = UIFont.systemFontOfSize(16)
                    logOutLabel.text = textValue
                    logOutLabel.textColor = UIColor.redColor()
                    logOutLabel.textAlignment = .Center
                    cell?.addSubview(logOutLabel)
                }
                
            }
            
            if self.types[indexPath.section][indexPath.row] {
                cell?.accessoryType=UITableViewCellAccessoryType.DisclosureIndicator
            }
            else
            {
                cell?.accessoryType=UITableViewCellAccessoryType.None
            }
        }
        else{
            cell?.accessoryType=UITableViewCellAccessoryType.None
        }



        /*
        cell?.textLabel?.text = self.items[indexPath.section][indexPath.row]
        if self.items[indexPath.section][indexPath.row] == "头像"{
            var frame1 : CGRect = CGRectMake(UIScreen.mainScreen().bounds.size.width-80,(TABLEVIEW_CELL_HEIGHT-40.0)/2,40,40)
            if NSLocale.preferredLanguages()[0].containsString("ar") {
                frame1 = CGRectMake(40,(TABLEVIEW_CELL_HEIGHT-40.0)/2,40,40)
            }
            let headImageView = UIImageView(frame: frame1)
            headImageView.image = UIImage(named: "img_headImage1")
            cell?.addSubview(headImageView)
        }
        
        if(self.values[indexPath.section][indexPath.row] != "")
        {
            cell?.detailTextLabel?.text = self.values[indexPath.section][indexPath.row]
        }
        
        if self.types[indexPath.section][indexPath.row] {
            cell?.accessoryType=UITableViewCellAccessoryType.DisclosureIndicator
        }
        else
        {
            cell?.accessoryType=UITableViewCellAccessoryType.None
        }*/
        
        return cell!
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //取消选中的样式
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let item = UIBarButtonItem(title: "我", style: .Plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item
        
        let key = self.items[indexPath.section][indexPath.row][1]
        if(key == "LogOut")
        {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: wIsTourist)
            AccountTool.sharedAccountTool().removeCurrentAccount()
            self.navigationController?.popViewControllerAnimated(true)
        }
        
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

//
//  DaylightSavingTimeViewController.swift
//  WeParyer
//
//  Created by Jacy on 16/4/23.
//  Copyright © 2016年 Jacy. All rights reserved.
//

import UIKit

class DaylightSavingTimeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let dayLight = ["+1",ChapelToolUtils.getLocalizedStr("key_DayLightingSaveDefault"),"-1"]
    
    let dayLightValue = [1,0,-1]
    
    var selected:Int = 0
    
    var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ChapelToolUtils.getLocalizedStr("key_DaylightSavingTime")
        self.view.backgroundColor = UIColor.whiteColor()
        self.loadBackButton()
        self.loadTableView()
        if IS_ARB {
            UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: CUSTOM_ARABIC_FONT, size: 18)!], forState: .Normal)
        }
        //把设置和返回图片变成白的
//        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.whiteColor()], forState: .Normal)
//        let backButtonImage =  UIImage.init(named: "backButton")?.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 30, 0, 0))
//        UIBarButtonItem.appearance().setBackButtonBackgroundImage(backButtonImage, forState : UIControlState.Normal, barMetrics: .Default)
    }
    
    //加载表格视图
    func loadTableView() {
        self.tableView = UITableView(frame:self.view.frame, style: UITableViewStyle.Grouped)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
    }
    //返回按钮
    func loadBackButton(){
        
        //        let backBarButton = UIBarButtonItem(image: UIImage.init(named: "backButton"), style: .Plain, target: self, action: #selector(DaylightSavingTimeViewController.back))
        //        let backBarButton = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(DaylightSavingTimeViewController.back))
        //        self.navigationItem.leftBarButtonItem = backBarButton
        
    }
    //返回事件
    func back(){
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dayLight.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return TABLEVIEW_CELL_HEIGHT
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "identtifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifier)
        }
        let timeZone =  NSUserDefaults.standardUserDefaults().integerForKey("daylight")
        self.selected = timeZone
        if self.selected == indexPath.row {
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        }else{
            cell?.accessoryType = UITableViewCellAccessoryType.None
        }
        
        cell?.textLabel?.text = self.dayLight[indexPath.row]
        cell?.viewWithTag(indexPath.row)
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //取消选中的样式
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        selected = indexPath.row
        //        ChapelToolUtils.setUserInformation("daylight", value: self.dayLightValue[indexPath.row])
        print("选中时区 \(indexPath.row)")
        NSUserDefaults.standardUserDefaults().setInteger(indexPath.row, forKey: "daylight")
        tableView.reloadData()
        
        let userInfo =  NSDictionary.init(object: "selectZone", forKey: "nextNotice") as [NSObject : AnyObject]
        NSNotificationCenter.defaultCenter().postNotificationName("revicePayersTimesNotification", object: nil, userInfo: userInfo)
        NSNotificationCenter.defaultCenter().postNotificationName("changleDayLightResult", object: nil, userInfo: nil)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

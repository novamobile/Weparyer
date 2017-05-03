//
//  SelectCalcTimeViewController.swift
//  WeParyer
//
//  Created by Jeccy on 16/11/29.
//  Copyright © 2016年 Jeccy. All rights reserved.
//

import UIKit

class SelectCalcTimeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let calcTimeMethod = [ChapelToolUtils.getLocalizedStr("key_MWL"),ChapelToolUtils.getLocalizedStr("key_ISNA")]
    
    let calcTimeMethodValue = [3,2]
    
    var selected:Int = 0
    
    var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ChapelToolUtils.getLocalizedStr("key_CalcTimeMethod")
        self.view.backgroundColor = UIColor.whiteColor()
        self.loadTableView()
        if IS_ARB {
            UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: CUSTOM_ARABIC_FONT, size: 18)!], forState: .Normal)
        }
    }
    
    //加载表格视图
    func loadTableView() {
        self.tableView = UITableView(frame:self.view.frame, style: UITableViewStyle.Grouped)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
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
        return self.calcTimeMethod.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return TABLEVIEW_CELL_HEIGHT
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "calc_identtifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifier)
        }
        let timeZone =  NSUserDefaults.standardUserDefaults().integerForKey("calcTimeMethod")
        if timeZone == 3 {
            self.selected = 0
        }
        else if timeZone == 2 {
            self.selected = 1
        }
        else{
            self.selected = 0
        }
        
        if self.selected == indexPath.row {
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        }else{
            cell?.accessoryType = UITableViewCellAccessoryType.None
        }
        
        cell?.textLabel?.text = self.calcTimeMethod[indexPath.row]
        cell?.viewWithTag(indexPath.row)
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //取消选中的样式
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        selected = indexPath.row
        //        ChapelToolUtils.setUserInformation("daylight", value: self.dayLightValue[indexPath.row])
        print("选中计算方式 \(calcTimeMethodValue[indexPath.row])")
        NSUserDefaults.standardUserDefaults().setInteger(calcTimeMethodValue[indexPath.row], forKey: "calcTimeMethod")
        tableView.reloadData()
        
        let userInfo =  NSDictionary.init(object: "selectZone", forKey: "nextNotice") as [NSObject : AnyObject]
        NSNotificationCenter.defaultCenter().postNotificationName("revicePayersTimesNotification", object: nil, userInfo: userInfo)
        self.navigationController?.popViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

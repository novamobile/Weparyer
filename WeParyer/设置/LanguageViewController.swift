//
//  LanguageViewController.swift
//  WeParyer
//
//  Created by Jacy on 16/4/23.
//  Copyright © 2016年 Jacy. All rights reserved.
//

import UIKit

class LanguageViewController:UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    let languages = ["中文","阿拉伯"]
    let languagesValue = ["zh","ar"]
    var selected:Int = -1
    
    var tableView:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "语言"
        self.view.backgroundColor = UIColor.whiteColor()
        self.loadBackButton()
        self.loadTableView()
        
        //把设置和返回图片变成白的
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.whiteColor()], forState: .Normal)
        let backButtonImage =  UIImage.init(named: "backButton")?.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 30, 0, 0))
        UIBarButtonItem.appearance().setBackButtonBackgroundImage(backButtonImage, forState : UIControlState.Normal, barMetrics: .Default)
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
        let backBarButton = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(LanguageViewController.back))
        self.navigationItem.leftBarButtonItem = backBarButton
        
    }
    //返回事件
    func back(){
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.languages.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "identtifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifier)
        }
        let language =  NSUserDefaults.standardUserDefaults().integerForKey("language")
        self.selected = language
        if self.selected == indexPath.row {
        }else{
        }
        
        cell?.textLabel?.text = self.languages[indexPath.row]
        cell?.viewWithTag(indexPath.row)
        
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //取消选中的样式
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        selected = indexPath.row
//        ChapelToolUtils.setUserInformation("language", value: self.languagesValue[indexPath.row])
        NSUserDefaults.standardUserDefaults().setInteger(indexPath.row, forKey: "language")
        tableView.reloadData()
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

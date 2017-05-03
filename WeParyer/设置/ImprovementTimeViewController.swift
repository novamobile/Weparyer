//
//  ImprovementTimeViewController.swift
//  WeParyer
//
//  Created by Jeccy on 16/6/5.
//  Copyright © 2016年 Jeccy. All rights reserved.
//

import UIKit

class ImprovementTimeViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var pickView: UIPickerView!
    
    @IBOutlet weak var toolBar: UIToolbar!
    
    var curIndexPath : NSIndexPath!
    
    var allData = [Int : String ]()
    
    var curSelectedPickerRow : Int = 0
    var finalSelectedPickerRow : Int = 0
    
    @IBOutlet weak var cancleBtn: UIBarButtonItem!
    
    @IBOutlet weak var dBtn: UIBarButtonItem!
    let images = [
        "fajr":"img_fajr",
        "sunrise":"img_sunrise",
        "dhuhr":"img_dhuhr",
        "asr":"img_asr",
        "maghrib":"img_maghrib",
        "ishaa":"img_ishaa"
    ]
    
    let names = [
        "fajr":ChapelToolUtils.getLocalizedStr("key_fajr"),
        "sunrise":ChapelToolUtils.getLocalizedStr("key_sunrise"),
        "dhuhr":ChapelToolUtils.getLocalizedStr("key_dhuhr"),
        "asr":ChapelToolUtils.getLocalizedStr("key_asr"),
        "maghrib":ChapelToolUtils.getLocalizedStr("key_maghrib"),
        "ishaa":ChapelToolUtils.getLocalizedStr("key_ishaa")
    ]
    let allKeys = ["fajr","sunrise", "dhuhr","asr","maghrib","ishaa"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ChapelToolUtils.getLocalizedStr("key_HandAdjusting")
        initData()
        pickView.delegate = self
        pickView.dataSource = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.scrollEnabled = false
        
        pickView.selectRow(30, inComponent: 0, animated: true)
        // Do any additional setup after loading the view.
        //去掉TableView多余的分割线
        tableView.backgroundColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        let footerView = UIView(frame: CGRectZero)
        footerView.backgroundColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        let lineView1 = UIView(frame: CGRectMake(0,-0.5,self.view.bounds.size.width+20,0.5))
        lineView1.backgroundColor = UIColor(red: 200.0/255.0, green: 200.0/255.0, blue: 200.0/255.0, alpha: 1.0)
        footerView.addSubview(lineView1)
        tableView.tableFooterView = footerView
        
        let headerHeight : CGFloat = 22.0
        let headerView = UIView(frame: CGRectMake(0,0,self.view.bounds.size.width,headerHeight))
        headerView.backgroundColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        let lineView = UIView(frame: CGRectMake(0,21.5,self.view.bounds.size.width+20,0.5))
        lineView.backgroundColor = UIColor(red: 200.0/255.0, green: 200.0/255.0, blue: 200.0/255.0, alpha: 0.6)
        headerView.addSubview(lineView)
        
        tableView.tableHeaderView = headerView
        
        showPickerView(false, forTime: 0)
        
        cancleBtn.title = ChapelToolUtils.getLocalizedStr("key_cancle")
        
        dBtn.title = ChapelToolUtils.getLocalizedStr("key_done")
        
        if IS_ARB {
            UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: CUSTOM_ARABIC_FONT, size: 18)!], forState: .Normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initData() {
        for index in -30...30 {
            let key = String(index)
            allData[index] = key
            print("initData",index,allData[index])
        }
    }
    
    @IBAction func doneBtnClick(sender: AnyObject) {
        showPickerView(false,forTime: 0.25)
        let cell = self.tableView.cellForRowAtIndexPath(curIndexPath)
        let timeLabel = cell?.viewWithTag(2) as! UILabel
        timeLabel.textColor = UIColor.blackColor()
        finalSelectedPickerRow = curSelectedPickerRow
        timeLabel.text = String(allData[finalSelectedPickerRow-30]!) //+ ChapelToolUtils.getLocalizedStr("key_min")
        NSUserDefaults.standardUserDefaults().setInteger(finalSelectedPickerRow-30, forKey: allKeys[curIndexPath.row] + "i_time")
        NSNotificationCenter.defaultCenter().postNotificationName(allKeys[curIndexPath.row]+"Notification", object: nil, userInfo: nil)
        curIndexPath = nil
    }
    @IBAction func cancleBtnClick(sender: AnyObject) {
        showPickerView(false,forTime: 0.25)
        let cell = self.tableView.cellForRowAtIndexPath(curIndexPath)
        let timeLabel = cell?.viewWithTag(2) as! UILabel
        timeLabel.textColor = UIColor.blackColor()
//        timeLabel.text = String(allData[finalSelectedPickerRow-30]!)
        curIndexPath = nil
    }
    
    func showPickerView(isShow : Bool, forTime time : Double)  {
        if !isShow {
            let animations:(() -> Void) = {
                self.pickView.transform = CGAffineTransformMakeTranslation(0,244)
                self.toolBar.transform = CGAffineTransformMakeTranslation(0,244)
                if (UIScreen.mainScreen().bounds.size.height <= 480.0 && self.curIndexPath != nil){
                    if(self.curIndexPath.row > 2)
                    {
                        self.tableView.transform = CGAffineTransformIdentity
                    }
                }
            }
            let options = UIViewAnimationOptions(rawValue:7)
            UIView.animateWithDuration(time, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            let animations:(() -> Void) = {
                self.pickView.transform = CGAffineTransformIdentity//CGAffineTransformMakeTranslation(0,-200)
                self.toolBar.transform = CGAffineTransformIdentity
                if (UIScreen.mainScreen().bounds.size.height <= 480.0 && self.curIndexPath != nil){
                    if(self.curIndexPath.row > 2)
                    {
                        let offest = Double(self.curIndexPath.row - 2)*(-44.0) + 22.0
                        self.tableView.transform = CGAffineTransformMakeTranslation(0,CGFloat(offest))
                    }
                }
            }
            let options = UIViewAnimationOptions(rawValue:7)
            UIView.animateWithDuration(time, delay: 0, options:options, animations: animations, completion: nil)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        showPickerView(false, forTime: 0)
    }
    
    //MARK:- UITABLEVIEW
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "identtifier_improvementTimeTableViewCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: identifier)
        }
        
        let frame1 : CGRect = CGRectMake(40,(TABLEVIEW_CELL_HEIGHT-20)/2.0,UIScreen.mainScreen().bounds.size.width-80,20)
//        let name = UILabel(frame: frame1)
        cell?.textLabel!.text = self.names[allKeys[indexPath.row]]
        
        let timeInt = NSUserDefaults.standardUserDefaults().integerForKey(allKeys[indexPath.row] + "i_time")
        let time = UILabel(frame: frame1)
        time.text = String(timeInt) //+ ChapelToolUtils.getLocalizedStr("key_min")
        time.tag = 2
        cell?.addSubview(time)
        
        cell?.accessoryType = .DisclosureIndicator
//        cell?.userInteractionEnabled = false
        if NSLocale.preferredLanguages()[0].containsString("ar") {
            time.textAlignment = .Left
        }else{
            time.textAlignment = .Right
        }
        
        if self.images[allKeys[indexPath.row]] != ""
        {
            cell?.imageView?.image = UIImage(named: self.images[allKeys[indexPath.row]]!)
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return TABLEVIEW_CELL_HEIGHT
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(curIndexPath != nil)
        {
            let scell = tableView.cellForRowAtIndexPath(curIndexPath)
            let timeLabel = scell?.viewWithTag(2) as! UILabel
            timeLabel.textColor = UIColor.blackColor()
        }
        curIndexPath = indexPath
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let timeView = cell?.viewWithTag(2) as! UILabel
        timeView.textColor = UIColor.redColor()
        showPickerView(true,forTime: 0.25)
        let timeInt = NSUserDefaults.standardUserDefaults().integerForKey(allKeys[indexPath.row] + "i_time")
        pickView.selectRow(30+timeInt, inComponent: 0, animated: true)
        curSelectedPickerRow = 30+timeInt
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    //MARK:- UIPICKERVIEW
    // 设置列数
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // 设置行数
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        return allData.count
    }
    // 设置每行具体内容（titleForRow 和 viewForRow 二者实现其一即可）
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if Int(allData[row-30]!)! > 0 {
            return "+" + allData[row-30]!
        }
        else
        {
            return allData[row-30]
        }
    }
    // 选中行的操作
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        curSelectedPickerRow = row
        print("row",row);
        print("component",component)
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

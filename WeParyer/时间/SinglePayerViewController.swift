//
//  SinglePayerViewController.swift
//  WeParyer
//
//  Created by Jeccy on 16/8/14.
//  Copyright © 2016年 Jeccy. All rights reserved.
//

import UIKit
import AVFoundation

class SinglePayerViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource {

    let CUSTOM_MIN_LABLE_TAG : Int = 222
    let CUSTOM_FINAL_TIME_LABLE_TAG : Int = 223
    
    var AllTitle = [
        ChapelToolUtils.getLocalizedStr("key_HandAdjusting"),
        ChapelToolUtils.getLocalizedStr("key_notificationSoundTitle"),
        ChapelToolUtils.getLocalizedStr("key_athan"),
    ]
    
    var SubTitle_Normal = [
//        [ChapelToolUtils.getLocalizedStr("key_HandAdjusting"),ChapelToolUtils.getLocalizedStr("key_athan")],
        [ChapelToolUtils.getLocalizedStr("key_athan")],[ChapelToolUtils.getLocalizedStr("key_notificationSoundTitle"),ChapelToolUtils.getLocalizedStr("key_athan"),ChapelToolUtils.getLocalizedStr("key_Beep"),ChapelToolUtils.getLocalizedStr("Key_Silence")],
        [ChapelToolUtils.getLocalizedStr("key_None"),ChapelToolUtils.getLocalizedStr("key_Al-Affassi"),ChapelToolUtils.getLocalizedStr("key_Fajr Malek Chebae"),ChapelToolUtils.getLocalizedStr("key_Hamad Degheri"),ChapelToolUtils.getLocalizedStr("key_Mansour-Az-Zahrani-Fajr-Intro"),ChapelToolUtils.getLocalizedStr("key_Nasser Al Qatami"),ChapelToolUtils.getLocalizedStr("key_Youssef Maati"),ChapelToolUtils.getLocalizedStr("key_Egypt"),ChapelToolUtils.getLocalizedStr("key_Fatih Seferagic"),
            ChapelToolUtils.getLocalizedStr("key_Wadii Hamadi"),
            ChapelToolUtils.getLocalizedStr("key_Bilal"),
            ChapelToolUtils.getLocalizedStr("key_Bosnie"),
            ChapelToolUtils.getLocalizedStr("key_Abdelmajid"),
            ChapelToolUtils.getLocalizedStr("key_Maroc"),
        ],
    ]
    
    var SubTitle = [
        [ChapelToolUtils.getLocalizedStr("key_athan")],
        [ChapelToolUtils.getLocalizedStr("key_notificationSoundTitle")],
        [ChapelToolUtils.getLocalizedStr("key_athan")],
    ]
    
    let images = [
        "fajr":"img_fajr",
        "sunrise":"img_sunrise",
        "dhuhr":"img_dhuhr",
        "asr":"img_asr",
        "maghrib":"img_maghrib",
        "ishaa":"img_ishaa"
    ]
    
    var athanSounds : [String]!
    var pushSounds : [String] = ["pushSound.aiff","1307"]
    
    var audioPlayer: AVAudioPlayer!
    var curSelectMusicBtn : UIButton!
    var curSelectPushBtn : UIButton!
    
    var tableView:UITableView!
    var pickerView: UIPickerView!
    var toolBar : UIToolbar!
    
    var customKey : String = ""
    var customTime : String = ""
    var selectedSounds:Int = -1
    
    var allData = [Int : String ]()
    var curSelectedPickerRow : Int = 0
    var finalSelectedPickerRow : Int = 0
    
    var curIndexPath : NSIndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        if customKey == ""
        {
            self.title = ChapelToolUtils.getLocalizedStr("key_athan")
        }
        else
        {
            self.title = ChapelToolUtils.getLocalizedStr("key_" + customKey)
        }
        if IS_ARB {
            UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: CUSTOM_ARABIC_FONT, size: 14)!], forState: .Normal)
        }
        
        let isOpenAthanSound = NSUserDefaults.standardUserDefaults().boolForKey(customKey + "sound_switch")
        if isOpenAthanSound {
//            SubTitle = SubTitle_Normal
        }
        else{
//            SubTitle = SubTitle_Close
        }
        
        self.athanSounds = ChapelToolUtils.getAllSound()
        self.athanSounds.insert("NONE", atIndex: 0)
        print("self.athanSounds",self.athanSounds)
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView = UITableView(frame:self.view.frame, style: UITableViewStyle.Grouped)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.frame.origin.y = tableView.frame.origin.y + 64
        tableView.frame.size.height = self.view.frame.size.height - 64
        self.view.addSubview(self.tableView)
        
        //去掉TableView多余的分割线
        let footerView = UIView(frame: CGRectZero)
        /*
        let desLabel1 = UILabel.init()
        desLabel1.frame = CGRect(x: 20, y: -25, width: self.view.bounds.width - 40, height: 80)
        if(UIScreen.mainScreen().bounds.size.height <= 480.0)
        {
            desLabel1.frame = CGRect(x: 20, y: -20, width: self.view.bounds.width - 40, height: 80)
        }
        
        desLabel1.numberOfLines = 0
        desLabel1.text = ChapelToolUtils.getLocalizedStr("key_choiceSoundTip")
        desLabel1.textAlignment = .Left
        if NSLocale.preferredLanguages()[0].containsString("ar") {
            desLabel1.textAlignment = .Right
        }
        desLabel1.font = UIFont.systemFontOfSize(15)
        desLabel1.textColor = UIColor.lightGrayColor()
        footerView.insertSubview(desLabel1, atIndex: 0)
        footerView.backgroundColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        footerView.frame = CGRectMake(0, 0, self.view.bounds.width, 100)
 */
        self.tableView.tableFooterView = footerView
        
        //添加PICKVIEW
        self.pickerView=UIPickerView(frame: CGRectMake(0, self.view.frame.height - 200, view.frame.width, 200))
        self.pickerView.backgroundColor = UIColor.whiteColor()
        //将dataSource设置成自己
        self.pickerView.dataSource=self
        //将delegate设置成自己
        self.pickerView.delegate=self
        //设置选择框的默认值
        self.pickerView.selectRow(30,inComponent:0,animated:true)
        self.view.addSubview(self.pickerView)
        
        self.toolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.height - 200-44, view.frame.width, 44))
        self.view.addSubview(self.toolBar)
        configureToolbar()
        
        showPickerView(false, forTime: 0)
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        showPickerView(false, forTime: 0)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
    }
    
    func initData() {
        for index in -30...30 {
            let key = String(index)
            allData[index] = key
//            print("initData",index,allData[index])
        }
    }
    
    func configureToolbar(){
        let toolbarButtonItem = [addButtonItem,
                                 flexibleSpaceBarButtonItem,
                                 cameraButtonItem]
        toolBar.setItems(toolbarButtonItem, animated: true);
    }
    
    var addButtonItem:UIBarButtonItem{
        return UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(self.cancleBtnClick(_:)))
    }
    var cameraButtonItem:UIBarButtonItem{
        return UIBarButtonItem(barButtonSystemItem:.Done, target:self, action: #selector(self.doneBtnClick(_:)))
    }
    //item 之间直接弹簧 弹簧
    var flexibleSpaceBarButtonItem: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
    }
    
    func cancleBtnClick(sender: AnyObject) {
        showPickerView(false,forTime: 0.25)
        let cell = self.tableView.cellForRowAtIndexPath(curIndexPath)
        let timeLabel = cell?.viewWithTag(CUSTOM_MIN_LABLE_TAG) as! UILabel
        timeLabel.textColor = UIColor.blackColor()
    }
    
    func doneBtnClick(sender: AnyObject) {
        showPickerView(false,forTime: 0.25)
        let cell = self.tableView.cellForRowAtIndexPath(curIndexPath)
        let timeLabel = cell?.viewWithTag(CUSTOM_MIN_LABLE_TAG) as! UILabel
        let timeLabel2 = cell?.viewWithTag(CUSTOM_FINAL_TIME_LABLE_TAG) as! UILabel
        timeLabel.textColor = UIColor.blackColor()
        finalSelectedPickerRow = curSelectedPickerRow
        if timeLabel2.text != "--:--" {
            let date = NSDate()
            let  dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            let prefixDate = dateFormatter.stringFromDate(date) as String
            
            let noticeTime = prefixDate + " \(customTime)"
            dateFormatter.dateFormat = "YYYY-MM-dd H:mm"
            
            let noticeDate =  dateFormatter.dateFromString(noticeTime)
            let lastTimeMin = NSUserDefaults.standardUserDefaults().integerForKey(customKey + "i_time")
            let curTimeMin = curSelectedPickerRow - 30
            let interval = curTimeMin - lastTimeMin
            
            print("doneBtnClick = %d --- %d",(finalSelectedPickerRow - 30)*60,lastTimeMin)
            let sec = (noticeDate?.timeIntervalSince1970)! + NSTimeInterval((interval)*60)
            
            let d = NSDate(timeIntervalSince1970: sec)
            dateFormatter.dateFormat = "H:mm"
            let str_time = dateFormatter.stringFromDate(d)
            customTime = str_time
            let finial_time_str = Handle12HoursStyle(str_time)
            if Is12HoursStyle(){
                let stringCount = finial_time_str.characters.count
                let attributeString = NSMutableAttributedString(string:finial_time_str)
                let font_size = timeLabel2.font.pointSize
                attributeString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(font_size/2),
                                             range: NSMakeRange(stringCount-2,2))
                timeLabel2.attributedText = attributeString
            }
            else{
                timeLabel2.text = finial_time_str
            }
        }
        
        let timeMin = allData[finalSelectedPickerRow-30]!
        if(finalSelectedPickerRow-30 <= 0){
            timeLabel.text = String(timeMin) //+ ChapelToolUtils.getLocalizedStr("key_min")
        }else{
            timeLabel.text = "+"+String(timeMin)
        }
        
        NSUserDefaults.standardUserDefaults().setInteger(finalSelectedPickerRow-30, forKey: customKey + "i_time")
        NSNotificationCenter.defaultCenter().postNotificationName(customKey + "Notification", object: nil, userInfo: nil)
        
    }
    
    func showPickerView(isShow : Bool, forTime time : Double)  {
        if !isShow {
            let animations:(() -> Void) = {
                self.pickerView.transform = CGAffineTransformMakeTranslation(0,244)
                self.toolBar.transform = CGAffineTransformMakeTranslation(0,244)
            }
            let options = UIViewAnimationOptions(rawValue:7)
            UIView.animateWithDuration(time, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            let animations:(() -> Void) = {
                self.pickerView.transform = CGAffineTransformIdentity//CGAffineTransformMakeTranslation(0,-200)
                self.toolBar.transform = CGAffineTransformIdentity
            }
            let options = UIViewAnimationOptions(rawValue:7)
            UIView.animateWithDuration(time, delay: 0, options:options, animations: animations, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            let isOpenAthanSound = NSUserDefaults.standardUserDefaults().boolForKey(customKey + "handAdjustOpen")
            if isOpenAthanSound {
                return SubTitle_Normal[section].count
            }
            else{
                return 1
            }
        }
        else if section == 1 {
            let isOpenAthanSound = NSUserDefaults.standardUserDefaults().boolForKey(customKey + "push_sound_switch")
            if isOpenAthanSound {
                return SubTitle_Normal[section].count
            }
            else{
                return 1
            }
        }else if section == 2{
            //let isOpenAthanSound = NSUserDefaults.standardUserDefaults().boolForKey(customKey + "push_sound_switch")
            let isOpenAthanSound = NSUserDefaults.standardUserDefaults().boolForKey(customKey + "push_sound_switch")
//            let selectPushSound = NSUserDefaults.standardUserDefaults().integerForKey(customKey + "push_sound")
            if isOpenAthanSound == true {
                return SubTitle_Normal[section].count
            }
            else{
                return 0
            }
        }
        return SubTitle_Normal[section].count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return SubTitle_Normal.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 || section == 0 {
            return 55
        }
        return 20
    }
 
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 50) )
        let headerLabel = UILabel(frame: CGRectMake(15,20,self.view.frame.size.width-35,20))
        if section == 2 || section == 0 {
            headerView.frame = CGRectMake(0,0,self.view.frame.size.width,60)
            headerLabel.frame = CGRectMake(15,20,self.view.frame.size.width-35,40)
            headerLabel.numberOfLines = 0
            headerLabel.font = UIFont.systemFontOfSize(15)
            
            headerLabel.textColor = UIColor.lightGrayColor()
            headerLabel.font = UIFont.systemFontOfSize(16)
            headerLabel.shadowColor = UIColor.grayColor()
            headerLabel.shadowOffset = CGSizeMake(0, 0.5)
            headerLabel.text = AllTitle[section]
            print("viewForHeaderInSection%d,,,,%s",section,AllTitle[section])
            headerLabel.textAlignment = .Left
            if IS_ARB {
                headerLabel.textAlignment = .Right
            }
            
            let isOpenAthanSound = NSUserDefaults.standardUserDefaults().boolForKey(customKey + "push_sound_switch")
            if isOpenAthanSound {
                headerView.addSubview(headerLabel)
            }
            else
            {
                if section == 0 {
                    headerView.addSubview(headerLabel)
                }
            }
            
        }
        return headerView
    }
    
    func createHeaderView(section: Int){
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
//            if indexPath.row > 0 {
                tableView.deselectRowAtIndexPath(indexPath, animated: false)
                let cell = tableView.cellForRowAtIndexPath(indexPath)
                let timeView = cell?.viewWithTag(CUSTOM_MIN_LABLE_TAG) as! UILabel
                timeView.textColor = UIColor.redColor()
                showPickerView(true,forTime: 0.25)
                let timeInt = NSUserDefaults.standardUserDefaults().integerForKey(customKey + "i_time")
                self.pickerView.selectRow(30+timeInt, inComponent: 0, animated: true)
                curSelectedPickerRow = 30+timeInt
//            }
        }else if indexPath.section == 1 {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            if indexPath.row > 0 {
                NSUserDefaults.standardUserDefaults().setInteger(indexPath.row - 1, forKey: customKey + "push_sound")
                tableView.reloadData()
                let userInfo =  NSDictionary.init(object: customKey + "selectPushSound", forKey: "nextNotice") as [NSObject : AnyObject]
                NSNotificationCenter.defaultCenter().postNotificationName("revicePayersTimesNotification", object: nil, userInfo: userInfo)
            }
        }else if indexPath.section == 2 {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            if indexPath.row >= 0 {
                tableView.reloadData()
                NSUserDefaults.standardUserDefaults().setInteger(indexPath.row, forKey: customKey + "sound")
                NSNotificationCenter.defaultCenter().postNotificationName(customKey + "NotificationFullAthanSound",object: nil, userInfo: nil)
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return TABLEVIEW_CELL_HEIGHT
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let identifier = "identtifier_singlePayerCell"
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
//        var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
//        if cell == nil {
//            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifier)
//        }else{
//            for view in (cell?.subviews)! {
//                if view.isKindOfClass("UIButton"){
//                    view.removeFromSuperview()
//                }
//            }
//            var textView = cell?.viewWithTag(CUSTOM_MIN_LABLE_TAG)
//            var timeView = cell?.viewWithTag(CUSTOM_FINAL_TIME_LABLE_TAG)
//            if textView != nil {
//                textView?.removeFromSuperview()
//                textView = nil
//            }
//            if timeView != nil {
//                timeView?.removeFromSuperview()
//                timeView = nil
//            }
//            cell?.imageView?.image = nil
//        }
        if indexPath.section == 0 {
            let isOpen = NSUserDefaults.standardUserDefaults().boolForKey(customKey + "handAdjustOpen")
            if false {
                cell.selectionStyle = .None
                cell.accessoryType = .None
                let switchView = UISwitch.init(frame: CGRectZero)
                cell.accessoryView = switchView
                switchView.setOn(isOpen, animated: false)
                switchView.addTarget(self, action: #selector(self.handAdjustSwitch(_:)), forControlEvents: .ValueChanged)
                
                cell.textLabel?.text = self.SubTitle_Normal[indexPath.section][indexPath.row]
            }
            else{
                curIndexPath = indexPath
                let frame1 : CGRect = CGRectMake(40,(TABLEVIEW_CELL_HEIGHT-20)/2.0,UIScreen.mainScreen().bounds.size.width-80,20)
                if customKey == ""{
                    cell.textLabel!.text = ChapelToolUtils.getLocalizedStr("key_athan")
                }
                else{
                    cell.textLabel!.text = ChapelToolUtils.getLocalizedStr("key_" + customKey)
                }
                let timeInt = NSUserDefaults.standardUserDefaults().integerForKey(customKey + "i_time")
                let time = UILabel(frame: frame1)
                if ((cell.viewWithTag(CUSTOM_MIN_LABLE_TAG)) == nil) {
                    if timeInt <= 0 {
                        time.text = String(timeInt) //+ ChapelToolUtils.getLocalizedStr("key_min")
                    }else
                    {
                        time.text = "+"+String(timeInt)
                    }
                    
                    time.tag = CUSTOM_MIN_LABLE_TAG
                    cell.addSubview(time)
                }
                
                let time1 = UILabel(frame: CGRectMake(0,(TABLEVIEW_CELL_HEIGHT-20)/2.0,UIScreen.mainScreen().bounds.size.width,20))
                time1.textColor = UIColor(colorLiteralRed: 0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
                if ((cell.viewWithTag(CUSTOM_FINAL_TIME_LABLE_TAG)) == nil) {
                    time1.tag = CUSTOM_FINAL_TIME_LABLE_TAG
                    time1.textAlignment = .Center
                    cell.addSubview(time1)
                    if customTime == "" {
                        time1.text = "--:--"
                    }
                    else{
                        let time_str = Handle12HoursStyle(customTime)
                        if Is12HoursStyle() {
                            let stringCount = time_str.characters.count
                            let attributeString = NSMutableAttributedString(string:time_str)
                            let font_size = time1.font.pointSize
                            attributeString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(font_size/2),
                                                         range: NSMakeRange(stringCount-2,2))
                            time1.attributedText = attributeString
                        }
                        else{
                            time1.text = time_str
                        }
                    }
                }
                
                cell.accessoryType = .DisclosureIndicator
                if IS_ARB {
                    time.textAlignment = .Left
                }else{
                    time.textAlignment = .Right
                }
                
                if self.images[customKey] != ""
                {
                    cell.imageView?.image = UIImage(named: self.images[customKey]!)
                }
            }
        }
        else if indexPath.section == 1 {
            var isOpenAthanSound = NSUserDefaults.standardUserDefaults().boolForKey(customKey + "push_sound_switch")
            let selectPushSound = NSUserDefaults.standardUserDefaults().integerForKey(customKey + "push_sound")
            if selectPushSound == 3 && isOpenAthanSound == true {
                isOpenAthanSound = false
            }
            if isOpenAthanSound {
                if indexPath.row == 0 {
                    cell.selectionStyle = .None
                    cell.accessoryType = .None
                    let switchView = UISwitch.init(frame: CGRectZero)
                    cell.accessoryView = switchView
                    switchView.setOn(isOpenAthanSound, animated: false)
                    switchView.addTarget(self, action: #selector(self.pushSoundSwitch(_:)), forControlEvents: .ValueChanged)
                    
                    cell.textLabel?.text = self.SubTitle_Normal[indexPath.section][indexPath.row]
                }
                else{
                    let selectPushSound = NSUserDefaults.standardUserDefaults().integerForKey(customKey + "push_sound")
                    if selectPushSound == indexPath.row - 1 {
                        cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                        cell.selectionStyle = .Gray
                    }else{
                        cell.accessoryType = UITableViewCellAccessoryType.None
                    }
                    
                    cell.textLabel?.text = self.SubTitle_Normal[indexPath.section][indexPath.row]
                    cell.viewWithTag(indexPath.row)
                    
                    cell.tintColor = UIColor.init(red: 0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
                    var frame1 : CGRect = CGRectMake(UIScreen.mainScreen().bounds.size.width-73,(TABLEVIEW_CELL_HEIGHT-30.0)/2,30,30)
                    if NSLocale.preferredLanguages()[0].containsString("ar") {
                        frame1 = CGRectMake(40,(TABLEVIEW_CELL_HEIGHT-30.0)/2,30,30)
                    }
                    let playBtn = UIButton(type: .Custom)
                    playBtn.frame = frame1
                    playBtn.setImage(UIImage(named: "music_play"), forState: .Normal)
                    playBtn.setImage(UIImage(named: "music_stop"), forState: .Selected)
                    playBtn.addTarget(self, action: #selector(self.playPushSoundBtnClick(_:)), forControlEvents: .TouchUpInside)
                    playBtn.tag = indexPath.row - 1
                    if indexPath.row != 3{
                        cell.addSubview(playBtn)
                    }
                }
            }else{
                if indexPath.row == 0 {
                    cell.selectionStyle = .None
                    cell.accessoryType = .None
                    let switchView = UISwitch.init(frame: CGRectZero)
                    cell.accessoryView = switchView
                    switchView.setOn(isOpenAthanSound, animated: false)
                    switchView.addTarget(self, action: #selector(self.pushSoundSwitch(_:)), forControlEvents: .ValueChanged)
                    
                    cell.textLabel?.text = self.SubTitle_Normal[indexPath.section][indexPath.row]
                }
            }
        }
        else if indexPath.section == 2 {
            //let isOpenAthanSound = NSUserDefaults.standardUserDefaults().boolForKey(customKey + "sound_switch")
            let isOpenAthanSound = NSUserDefaults.standardUserDefaults().boolForKey(customKey + "push_sound_switch")
//            let selectPushSound = NSUserDefaults.standardUserDefaults().integerForKey(customKey + "push_sound")
//            if selectPushSound == 3 && isOpenAthanSound == true {
//                isOpenAthanSound = false
//            }
            if isOpenAthanSound {
                let selectAthanSound = NSUserDefaults.standardUserDefaults().integerForKey(customKey + "sound")
                if selectAthanSound == indexPath.row{
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                    cell.selectionStyle = .Gray
                }else{
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
                
                cell.textLabel?.text = self.SubTitle_Normal[indexPath.section][indexPath.row]
                cell.viewWithTag(indexPath.row)
                
                if(indexPath.row != 0)
                {
                    cell.tintColor = UIColor.init(red: 0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
                    var frame1 : CGRect = CGRectMake(UIScreen.mainScreen().bounds.size.width-73,(TABLEVIEW_CELL_HEIGHT-30.0)/2,30,30)
                    if NSLocale.preferredLanguages()[0].containsString("ar") {
                        frame1 = CGRectMake(40,(TABLEVIEW_CELL_HEIGHT-30.0)/2,30,30)
                    }
                    let playBtn = UIButton(type: .Custom)
                    playBtn.frame = frame1
                    playBtn.setImage(UIImage(named: "music_play"), forState: .Normal)
                    playBtn.setImage(UIImage(named: "music_stop"), forState: .Selected)
                    playBtn.addTarget(self, action: #selector(self.playAthanSoundBtnClick(_:)), forControlEvents: .TouchUpInside)
                    playBtn.tag = indexPath.row
                    cell.addSubview(playBtn)
                }
            }
        }
        return cell
    }
    
    func playAthanSoundBtnClick(sender : AnyObject) {
        let btn = sender as! UIButton
        
        if(curSelectMusicBtn != nil && curSelectMusicBtn != btn)
        {
            if(curSelectMusicBtn.selected == true)
            {
                curSelectMusicBtn.selected = false
                if(self.audioPlayer != nil){
                    self.audioPlayer.stop()
                }
            }
            
            btn.selected = true
            if(btn.tag > 0 && btn.tag <= self.athanSounds.count){
                self.playSound(self.athanSounds[btn.tag])
                curSelectMusicBtn = btn
            }
        }
        else{
            if btn.selected {
                btn.selected = false
                if(self.audioPlayer != nil){
                    self.audioPlayer.stop()
                }
            }else{
                btn.selected = true
                if(btn.tag > 0 && btn.tag <= self.athanSounds.count){
                    self.playSound(self.athanSounds[btn.tag])
                    curSelectMusicBtn = btn
                }
            }
        }
        
        print(btn.tag)
    }
    
    func playPushSoundBtnClick(sender : AnyObject) {
        let btn = sender as! UIButton
        
        if(curSelectPushBtn != nil && curSelectPushBtn != btn)
        {
            if(curSelectPushBtn.selected == true)
            {
                curSelectPushBtn.selected = false
                if(self.audioPlayer != nil){
                    self.audioPlayer.stop()
                }
            }
            
            btn.selected = true
            if(btn.tag >= 0 && btn.tag < self.pushSounds.count){
                self.playSound(self.pushSounds[btn.tag])
                curSelectPushBtn = btn
            }
        }
        else{
            if btn.selected {
                btn.selected = false
                if(self.audioPlayer != nil){
                    self.audioPlayer.stop()
                }
            }else{
                btn.selected = true
                if(btn.tag >= 0 && btn.tag < self.pushSounds.count){
                    self.playSound(self.pushSounds[btn.tag])
                    curSelectPushBtn = btn
                }
            }
        }
        
        print(btn.tag)
    }
    
    func handAdjustSwitch(sender:AnyObject) {
        let isOpenAthanSound = NSUserDefaults.standardUserDefaults().boolForKey(customKey + "handAdjustOpen")
        NSUserDefaults.standardUserDefaults().setBool(!isOpenAthanSound, forKey: customKey + "handAdjustOpen")
        self.tableView.reloadData()
        NSNotificationCenter.defaultCenter().postNotificationName(customKey + "Notification", object: nil, userInfo: nil)
    }
    
    func pushSoundSwitch(sender:AnyObject) {
        let isOpenAthanSound = NSUserDefaults.standardUserDefaults().boolForKey(customKey + "push_sound_switch")
        NSUserDefaults.standardUserDefaults().setBool(!isOpenAthanSound, forKey: customKey + "push_sound_switch")
        self.tableView.reloadData()
        NSNotificationCenter.defaultCenter().postNotificationName(customKey + "Notification", object: nil, userInfo: nil)
    }
    
    func athanSoundSwitch(sender:AnyObject) {
        let isOpenAthanSound = NSUserDefaults.standardUserDefaults().boolForKey(customKey + "sound_switch")
        NSUserDefaults.standardUserDefaults().setBool(!isOpenAthanSound, forKey: customKey + "sound_switch")
        self.tableView.reloadData()
    }
    
    func playSound(soundName:String) {
        if(soundName == "1307")
        {
            AudioServicesPlaySystemSound(1307)
            return
        }
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        let str =  soundName.componentsSeparatedByString(".")
        let musicPath = NSBundle.mainBundle().pathForResource("\(str[0])", ofType: "\(str[1])")
        let url = NSURL(fileURLWithPath: musicPath!)
        do {
            try self.audioPlayer = AVAudioPlayer(contentsOfURL: url)
        } catch {
            print("could not create AVAudioPlayer \(error)")
            return
        }
        self.audioPlayer.volume = 0.75
        
        self.audioPlayer.play()
        
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

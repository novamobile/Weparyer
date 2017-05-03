//
//  SoundViewController.swift
//  WeParyer
//
//  Created by Jeccy on 16/5/31.
//  Copyright © 2016年 Jeccy. All rights reserved.
//

import UIKit
import AVFoundation
class SoundViewController: UIViewController,UITableViewDelegate,UITableViewDataSource  {
    
    var audioPlayer: AVAudioPlayer!
    var customTitle : String = ""
    var curSelectMusicBtn : UIButton!
    
    let soundsName = [
//        ChapelToolUtils.getLocalizedStr("key_SystemDefault"),
        ChapelToolUtils.getLocalizedStr("key_Al-Affassi"),
        ChapelToolUtils.getLocalizedStr("key_Fajr Malek Chebae"),
        ChapelToolUtils.getLocalizedStr("key_Hamad Degheri"),
        ChapelToolUtils.getLocalizedStr("key_Mansour-Az-Zahrani-Fajr-Intro"),
        ChapelToolUtils.getLocalizedStr("key_Nasser Al Qatami"),
        ChapelToolUtils.getLocalizedStr("key_Youssef Maati"),
        ChapelToolUtils.getLocalizedStr("key_Egypt"),
        ChapelToolUtils.getLocalizedStr("key_Fatih Seferagic"),
        ChapelToolUtils.getLocalizedStr("key_Wadii Hamadi"),
        ChapelToolUtils.getLocalizedStr("key_Bilal"),
        ChapelToolUtils.getLocalizedStr("key_Bosnie"),
        ChapelToolUtils.getLocalizedStr("key_Abdelmajid"),
        ChapelToolUtils.getLocalizedStr("key_Maroc"),
    ]
    
    let imageName = [
        "A_soundName",
        "F_soundName",
        "H_soundName",
        "M_soundName",
        "N_soundName",
        "Y_soundName",
    ]
    
    var selected:Int = -1
    
//    @IBOutlet weak var tableView: UITableView!
    var tableView:UITableView!
    
    var Sounds : [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if customTitle == ""
        {
            self.title = ChapelToolUtils.getLocalizedStr("key_athan")
        }
        else
        {
            self.title = ChapelToolUtils.getLocalizedStr(customTitle)
        }
        self.view.backgroundColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        
        self.Sounds = ChapelToolUtils.getAllSound()
        
        //把设置和返回图片变成白的
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)], forState: .Normal)
        self.automaticallyAdjustsScrollViewInsets = false
        
        if tableView == nil {
            tableView = UITableView.init(frame: self.view.frame)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.frame.origin.y = tableView.frame.origin.y + 46+22
            self.view.addSubview(tableView)
        }
        tableView.backgroundColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        
        //去掉TableView多余的分割线
        let footerView = UIView(frame: CGRectZero)
        let desLabel1 = UILabel.init()
        desLabel1.frame = CGRect(x: 20, y: -15, width: self.view.bounds.width - 40, height: 80)
        if(UIScreen.mainScreen().bounds.size.height <= 480.0)
        {
            desLabel1.frame = CGRect(x: 20, y: -10, width: self.view.bounds.width - 40, height: 80)
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
        let lineView1 = UIView(frame: CGRectMake(0,-0.5,self.view.bounds.size.width+20,0.5))
        lineView1.backgroundColor = UIColor(red: 200.0/255.0, green: 200.0/255.0, blue: 200.0/255.0, alpha: 1.0)
        footerView.insertSubview(lineView1,atIndex: 1)
        footerView.backgroundColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        self.tableView.tableFooterView = footerView
        
        let headerView = UIView(frame: CGRectMake(0,0,self.view.bounds.size.width,22.0))
        headerView.backgroundColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        let lineView = UIView(frame: CGRectMake(0,21.5,self.view.bounds.size.width+20,0.5))
        lineView.backgroundColor = UIColor(red: 200.0/255.0, green: 200.0/255.0, blue: 200.0/255.0, alpha: 0.6)
        headerView.addSubview(lineView)
        tableView.tableHeaderView = headerView

    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //返回事件
    func back(){
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.Sounds.count
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
        self.selected = NSUserDefaults.standardUserDefaults().integerForKey("sound")
        if self.selected == indexPath.row {
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
            cell?.selectionStyle = .Gray
        }else{
            cell?.accessoryType = UITableViewCellAccessoryType.None
        }
        
        cell?.textLabel?.text = self.soundsName[indexPath.row]
        cell?.viewWithTag(indexPath.row)
        
        cell?.tintColor = UIColor.init(red: 0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
        //图标
//        if self.imageName[indexPath.row] != ""
//        {
//            cell?.imageView?.image = UIImage(named: self.imageName[indexPath.row])
//        }
        
        var frame1 : CGRect = CGRectMake(UIScreen.mainScreen().bounds.size.width-80,(TABLEVIEW_CELL_HEIGHT-30.0)/2,30,30)
        if NSLocale.preferredLanguages()[0].containsString("ar") {
            frame1 = CGRectMake(40,(TABLEVIEW_CELL_HEIGHT-30.0)/2,30,30)
        }
        let playBtn = UIButton(type: .Custom)
        playBtn.frame = frame1
        playBtn.setImage(UIImage(named: "music_play"), forState: .Normal)
        playBtn.setImage(UIImage(named: "music_stop"), forState: .Selected)
        playBtn.addTarget(self, action: #selector(self.playBtnClick(_:)), forControlEvents: .TouchUpInside)
        playBtn.tag = indexPath.row
        cell?.addSubview(playBtn)
        
        return cell!
    }
    
    func playBtnClick(sender : AnyObject) {
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
            if(btn.tag >= 0 && btn.tag < self.Sounds.count){
                self.playSound(self.Sounds[btn.tag])
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
                if(btn.tag >= 0 && btn.tag < self.Sounds.count){
                    self.playSound(self.Sounds[btn.tag])
                    curSelectMusicBtn = btn
                }
            }
        }
        
        print(btn.tag)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //取消选中的样式
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        selected = indexPath.row
        
        NSUserDefaults.standardUserDefaults().setInteger(indexPath.row, forKey: "sound")
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playSound(soundName:String) {
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

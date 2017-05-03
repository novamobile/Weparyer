//
//  MailInfoTableViewController.swift
//  WeParyer
//
//  Created by Jeccy on 16/7/4.
//  Copyright © 2016年 Jeccy. All rights reserved.
//

import UIKit
import MessageUI

class MailInfoTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate,UITextViewDelegate,UIImagePickerControllerDelegate
,UINavigationControllerDelegate{

    let MainFormat = [
        [""],
        ["Select from album"],
        ["Device","iOS"],
        ["Name","Version"]
    ]
    
    let MailFormatTitle = [
        "",
        "Attachment",
        "DEVICE INFO",
        "APP INFO"
    ]
    
    
    var tableView : UITableView!
    var cusTometextView : UITextView!
    var textViewIndexPath : NSIndexPath!
    
    var cellHeight : CGFloat = 160.0
    var imageAttachmentIndexPath : NSIndexPath!
    var selectImg : UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
//         self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.title = ChapelToolUtils.getLocalizedStr("key_ContactUs")
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.tableView = UITableView(frame:self.view.frame, style: UITableViewStyle.Grouped)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.frame.origin.y = tableView.frame.origin.y + 44
        tableView.frame.size.height = self.view.frame.size.height - 44
        self.view.addSubview(self.tableView)
        
        let sendBtn = UIBarButtonItem(title: "Mail", style: .Plain, target: self, action: #selector(self.sendMail(_:)))
        self.navigationItem.rightBarButtonItem = sendBtn
        
        if IS_ARB {
            UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: CUSTOM_ARABIC_FONT, size: 18)!], forState: .Normal)
        }
        
//        let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(tapAd))
//        self.view.addGestureRecognizer(singleTap)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let value = cusTometextView {
            cusTometextView.becomeFirstResponder()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return MainFormat.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return MainFormat[section].count
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 50) )
        
        let headerLabel = UILabel(frame: CGRectMake(15,-10,self.view.frame.size.width-35,19))
//        headerLabel.backgroundColor = UIColor.redColor()
        headerLabel.textColor = UIColor.lightGrayColor()
        headerLabel.font = UIFont.systemFontOfSize(16)
        headerLabel.shadowColor = UIColor.grayColor()
        headerLabel.shadowOffset = CGSizeMake(0, 0.5)
        headerLabel.text = MailFormatTitle[section]
        headerLabel.textAlignment = .Left
        if IS_ARB {
            headerLabel.textAlignment = .Right
        }
        headerView.addSubview(headerLabel)
        return headerView
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "identtifier_mailInfo"
//        var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
//        if cell == nil {
            let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: identifier)
//        }
        
        cell.textLabel?.text = MainFormat[indexPath.section][indexPath.row]
        cell.textLabel?.font = UIFont.systemFontOfSize(18)
        
        var info : String = ""
        if MainFormat[indexPath.section][indexPath.row] == "Device" {
            info = getDeviceVersion()
        }else if MainFormat[indexPath.section][indexPath.row] == "iOS" {
            info = UIDevice.currentDevice().systemVersion
        }else if MainFormat[indexPath.section][indexPath.row] == "Name" {
            info = "WePray"
        }else if MainFormat[indexPath.section][indexPath.row] == "Version" {
            info = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
        }
        
//        let infoLabel = UILabel()
//        if IS_ARB {
//            infoLabel.textAlignment = .Left
//            infoLabel.frame = CGRectMake(20,0,((cell.frame.size.width)-20),(cell.frame.size.height))
//        }
//        else{
//            infoLabel.textAlignment = .Right
//            infoLabel.frame = CGRectMake(20,0,((cell.frame.size.width)),(cell.frame.size.height))
//        }
//        infoLabel.text = info
//        infoLabel.tag = 999
//        infoLabel.textColor = UIColor.grayColor()
//        if cell.viewWithTag(999) == nil {
//            cell.addSubview(infoLabel)
        if (info != ""){
            cell.detailTextLabel?.text = info
            cell.detailTextLabel?.textColor = UIColor.grayColor()
            cell.detailTextLabel?.font = UIFont.systemFontOfSize(16)
        }
        
        if indexPath.section == 0 && indexPath.row == 0 {
            cusTometextView = UITextView(frame: CGRectMake(20, 10, cell.frame.size.width, 135))
//            cusTometextView.backgroundColor = UIColor.orangeColor()
            cusTometextView.delegate = self
            cusTometextView.returnKeyType = .Done
            cusTometextView.font = UIFont.systemFontOfSize(16)
            cell.addSubview(cusTometextView)
            cusTometextView.scrollEnabled = false
            
            if IS_ARB {
                cusTometextView.textAlignment = .Right
            }
            else{
                cusTometextView.textAlignment = .Left
            }
        }
        if indexPath.section == 1 && indexPath.row == 0 {
            imageAttachmentIndexPath = indexPath
            if let value = selectImg { /* 有值, 返回 true */
                cell.imageView?.image = value
            }
            cell.selectionStyle = .None
            cell.accessoryType = .DisclosureIndicator
            cell.textLabel?.textColor = UIColor.grayColor()
        }
        else{
            cell.selectionStyle = .None
        }
        if indexPath.section == 2 && indexPath.row == 0 {
            textViewIndexPath = indexPath
        }
        
        return cell
    }
 
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            if cellHeight < 160.0 {
                cellHeight = 160.0
            }
            return cellHeight
        }
        else{
            return 44.0
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return TABLEVIEW_CELL_HEIGHT - 20
    }

    func sendMail(sender: AnyObject) {
        SendEmail()
    }
    
    func SendEmail(){
        //首先要判断设备具不具备发送邮件功能
        if MFMailComposeViewController.canSendMail(){
            let controller = MFMailComposeViewController()
            //设置代理
            controller.mailComposeDelegate = self
            //设置主题
            controller.setSubject(ChapelToolUtils.getLocalizedStr("key_MailTitle"))
            //设置收件人
            controller.setToRecipients(["wepray@126.com","wepray@126.com"])
            //设置邮件正文内容（支持html）
//            let countryStr = NSUserDefaults.standardUserDefaults().objectForKey("appLocationCountry") as! String
            controller.setMessageBody("\(cusTometextView.text) \n\n\n\n\n DeviceModel : \(getDeviceVersion())\n iOS : \(UIDevice.currentDevice().systemVersion)\n Name : WePray\n App Version : \(NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String)", isHTML: false)
            
            if let value = selectImg {
                let imageData = UIImagePNGRepresentation(selectImg)
                controller.addAttachmentData(imageData!, mimeType: "", fileName: "bug.png")
            }
            
            //打开界面
            self.presentViewController(controller, animated: true, completion: nil)
        }else{
            launchMailAppOnDevice() //打开邮箱app
        }
    }
    
    func launchMailAppOnDevice()
    {
        let recipients : String = "mailto://wepray@126.com";
        let url: NSURL = NSURL(string: recipients)!
        UIApplication.sharedApplication().openURL(url)
    }
    
    //发送邮件代理方法
    func mailComposeController(controller: MFMailComposeViewController,
                               didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        
        switch result{
        case .Sent:
            print("邮件已发送")
            SwiftNotice.showNoticeWithText(.success, text: ChapelToolUtils.getLocalizedStr("key_sendSuccess") , autoClear: true, autoClearTime: 1)
            self.navigationController?.popViewControllerAnimated(true)
        case .Cancelled:
            print("邮件已取消")
        case .Saved:
            print("邮件已保存")
        case .Failed:
            SwiftNotice.showNoticeWithText(.success, text: ChapelToolUtils.getLocalizedStr("key_sendFail") , autoClear: true, autoClearTime: 1)
            print("邮件发送失败")
        default:
            print("邮件没有发送")
            break
        }
    }
    
    func getDeviceVersion () -> String! {
        let name = UnsafeMutablePointer<utsname>.alloc(1)
        uname(name)
        let machine = withUnsafePointer(&name.memory.machine, { (ptr) -> String? in
            
            let int8Ptr = unsafeBitCast(ptr, UnsafePointer<CChar>.self)
            return String.fromCString(int8Ptr)
        })
        name.dealloc(1)
        if let deviceString = machine {
            switch deviceString {
            //iPhone
            case "iPhone1,1":                return "iPhone 1G"
            case "iPhone1,2":                return "iPhone 3G"
            case "iPhone2,1":                return "iPhone 3GS"
            case "iPhone3,1", "iPhone3,2":   return "iPhone 4"
            case "iPhone4,1":                return "iPhone 4S"
            case "iPhone5,1", "iPhone5,2":   return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":   return "iPhone 5C"
            case "iPhone6,1", "iPhone6,2":   return "iPhone 5S"
            case "iPhone7,1":                return "iPhone 6 Plus"
            case "iPhone7,2":                return "iPhone 6"
            case "iPhone8,1":                return "iPhone 6s"
            case "iPhone8,2":                return "iPhone 6s Plus"
            default:
                return deviceString
            }
        } else {
            return nil
        }
    }
    
    //MARK: - UITextViewDelegateMethod
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        return true
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        
    }
    
    func textViewDidChange(textView: UITextView) {
        
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        print("textViewDidChange",newFrame.size.height,newSize.width,fixedWidth)
        if newFrame.size.height > 135 {
            cellHeight = newFrame.size.height + 35
            textView.frame = newFrame
            tableView.reloadRowsAtIndexPaths([textViewIndexPath], withRowAnimation: .Automatic)
        }
    }

    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            cusTometextView.resignFirstResponder()
            return false
        }
        return true
    }
    
    //选取相册
    func fromAlbum() {
        //判断设置是否支持图片库
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary){
        //初始化图片控制器
        let picker = UIImagePickerController()
        //设置代理
        picker.delegate = self
        //指定图片控制器类型
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        //设置是否允许编辑
        picker.allowsEditing = false
        //弹出控制器，显示界面
        self.presentViewController(picker, animated: true, completion: {
            () -> Void in
        })
        }else{
            print("读取相册错误")
        }
    }

    //选择图片成功后代理
    func imagePickerController(picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        //查看info对象
        print(info)
        //获取选择的原图
        selectImg = info[UIImagePickerControllerOriginalImage] as! UIImage
        let cell = tableView.cellForRowAtIndexPath(imageAttachmentIndexPath)
        cell?.imageView?.image = selectImg
        tableView.reloadRowsAtIndexPaths([imageAttachmentIndexPath], withRowAnimation: .Automatic)
        //图片控制器退出
        picker.dismissViewControllerAnimated(true, completion: {
            () -> Void in
        })
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if imageAttachmentIndexPath == indexPath {
            fromAlbum()
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

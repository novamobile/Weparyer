//
//  CommentDetailViewController.swift
//  WeParyer
//
//  Created by Jeccy on 16/9/10.
//  Copyright © 2016年 Jeccy. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MJRefresh

class CommentDetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    
    var data = [
        ["name":"VIP1花千骨","time":"16:15","str":"杰伦最好听的还是老的那几张专辑，大爱东风破和龙拳！","headImg":"img_headImage1.png"],
        ["name":"九大山人","time":"18:15","str":"那是因为你听不懂明明就。","headImg":"img_headImage4.png"],
        ["name":"牛牛爱吃草","time":"20:15","str":"新专辑也不错啊！","headImg":"img_headImage4.png"],
        ]
    
    @IBOutlet var commentTableView: UITableView!
    @IBOutlet var keyBaordView: UIView!
    @IBOutlet var commentTextFiled: UITextField!
    
    var cdata = [Comment]()
    
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    // 底部刷新
    let footer = MJRefreshAutoNormalFooter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTextFiled.delegate = self
        commentTextFiled.returnKeyType = UIReturnKeyType.Send
        self.commentTableView.registerNib(UINib(nibName: "CommentTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "commentCell")
        
        self.automaticallyAdjustsScrollViewInsets = false
        //去掉TableView多余的分割线
        let footerView = UIView(frame: CGRectZero)
        self.commentTableView.tableFooterView = footerView
        
        header.setRefreshingTarget(self, refreshingAction: #selector(self.headerRefresh(_:)))
        footer.setRefreshingTarget(self, refreshingAction: #selector(self.footerRefresh(_:)))
        
        self.commentTableView.mj_footer = footer
        self.commentTableView.mj_header = header
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(CommentDetailViewController.handleTouches(_:)))
        tapGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGestureRecognizer)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(CommentDetailViewController.keyBoardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(CommentDetailViewController.keyBoardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil)
        
        keyBaordView.layer.borderWidth = 0.5
        keyBaordView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.9).CGColor
        print("keyBaordView1",keyBaordView)
    }
    
    // 顶部刷新
    func headerRefresh(_:AnyObject){
        print("下拉刷新")
//        self.pullDownLoadData()
        self.commentTableView.mj_header.endRefreshing()
    
    }
    
    // 顶部刷新
    func footerRefresh(_:AnyObject){
        print("上拉刷新")
//        self.loadMoreData()
        // 结束刷新
        self.commentTableView.mj_footer.endRefreshingWithNoMoreData()
    }
    
    func keyBoardWillShow(note:NSNotification)
    {
        print("keyBaordView2",self.keyBaordView)
        let userInfo  = note.userInfo as [NSObject : AnyObject]!
        let  keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let deltaY = keyBoardBounds.size.height
        let animations:(() -> Void) = {
            self.keyBaordView.transform = CGAffineTransformMakeTranslation(0,-deltaY)
            print("keyBaordView3",self.keyBaordView)
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue:UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
            UIView.animateWithDuration(duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            animations()
        }
    }
    func keyBoardWillHide(note:NSNotification)
    {
        let userInfo  = note.userInfo as [NSObject : AnyObject]!
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let animations:(() -> Void) = {
            self.keyBaordView.transform = CGAffineTransformIdentity
        }
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue:UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
            UIView.animateWithDuration(duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            animations()
        }
    }
    
    func handleTouches(sender:UITapGestureRecognizer){
        if sender.locationInView(self.view).y < self.view.bounds.height - 250{
            commentTextFiled.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        //        date
        if textField.text != "" {
            let date = NSDate()
            let timeFormatter = NSDateFormatter()
            timeFormatter.dateFormat = "HH:mm" //(格式可俺按自己需求修整)
            let strNowTime = timeFormatter.stringFromDate(date) as String
            data.append(["name":"小样","time":strNowTime,"str":textField.text!,"headImg":"img_headImage1.png"])
            self.commentTableView.reloadData()
            
            commentTextFiled.resignFirstResponder()
            commentTextFiled.text = ""
            
            var accessToken = ""
            if(AccountTool.sharedAccountTool().currentAccount != nil)
            {
                accessToken = AccountTool.sharedAccountTool().currentAccount.accessToken as String
            }
            
            let para : [String:AnyObject] = [
                "noteId ":14,
                "accessToken": accessToken,
                "comment" : "好事多磨"
            ]
            print("评论",para)
            Alamofire.request(.POST, COMMENT_PUBLISH_URL,parameters:para)
                .responseJSON { response in
                    if let recvied = response.result.value
                    {
                        print("get->returnJSON-Login: \(recvied)")
                        let json = JSON(recvied)
                        if(json["error_code"] == 10000)
                        {
                            print("json[].stringValue",json["data"].stringValue)
                        }
                        else{
                            SwiftNotice.showNoticeWithText(.error, text: "登录失败", autoClear: true, autoClearTime: 3)
                        }
                    }
            }
            
            
        }
        
        
        
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnClick(sender: AnyObject) {
//        for controllers : UIViewController in (self.navigationController?.viewControllers)!
//        {
//            if controllers is BBSMainViewController
//            {
//                self.navigationController?.popToViewController(controllers, animated: true)
//            }
//        }
//        self.navigationController?.popToViewController(controllers, animated: true)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func chatBtnClick(sender: AnyObject) {
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    //创建各单元显示内容(创建参数indexPath指定的单元）
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)-> UITableViewCell {
        let identify:String = "commentCell"
        //同一形式的单元格重复使用，在声明时已注册
        //        print(data[indexPath.row]["name"],data[indexPath.row]["str"],data[indexPath.row]["time"])
        let cell = tableView.dequeueReusableCellWithIdentifier(identify, forIndexPath: indexPath) as! CommentTableViewCell
        
        cell.nameLabel.text = data[indexPath.row]["name"]
        cell.bbsPostDetailLabel.text = data[indexPath.row]["str"]
        cell.postTimeLabel.text = data[indexPath.row]["time"]
        cell.imgHead.image = UIImage(named: data[indexPath.row]["headImg"]!)
        if indexPath.row == 0
        {
            cell.bbsPostDetailLabel.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.9)
            cell.bbsPostDetailLabel.layer.masksToBounds = true
            cell.bbsPostDetailLabel.layer.cornerRadius = 5
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCellWithIdentifier("commentCell") as! CommentTableViewCell
        return cell.calcHeight(data[indexPath.row]["str"]!)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.row == 0
        {
            return false
        }
        else
        {
            if data[indexPath.row]["name"] != "小样"
            {
                return false
            }
            else
            {
                return true
            }
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        if editingStyle == .Delete
        {
            data.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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

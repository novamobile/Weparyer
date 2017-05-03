//
//  fbViewController.swift
//  WeParyer
//
//  Created by Jeccy on 16/6/21.
//  Copyright © 2016年 Jeccy. All rights reserved.
//

import UIKit

class fbViewController: UIViewController,UIWebViewDelegate {

    //进度条计时器
    var ptimer:NSTimer!
    //进度条控件
    var progBar:UIProgressView!

    var loadIndicator:UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = ChapelToolUtils.getLocalizedStr("key_FaceBookSupport")
        
        loadIndicator = UIActivityIndicatorView(frame: CGRectMake(100.0, 100.0, 32.0, 32.0));
        loadIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(loadIndicator);
        
        let url = NSURL.init(string: "https://m.facebook.com/wepray.nova/")
        
        let fbWebView = UIWebView.init(frame: self.view.frame)
        fbWebView.delegate = self
        fbWebView.loadRequest(NSURLRequest.init(URL: url!))
        fbWebView.frame.origin.y = 64
        self.view.addSubview(fbWebView)
        
        progBar = UIProgressView(progressViewStyle:UIProgressViewStyle.Bar)
        progBar.frame = CGRectMake(0 , 65, self.view.frame.size.width, 10)
        progBar.progress = 0
        self.view.addSubview(progBar)
        
        ptimer = NSTimer.scheduledTimerWithTimeInterval(0.2,
                                                        target:self ,selector: #selector(self.loadProgress),
                                                        userInfo:nil,repeats:true);
        ptimer.invalidate()
        
        if IS_ARB {
            UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: CUSTOM_ARABIC_FONT, size: 18)!], forState: .Normal)
        }
    }

    func loadProgress()
    {
        // 如果进度满了，停止计时器
        if(progBar.progress >= 1.0)
        {
            // 停用计时器
            ptimer.invalidate();
        }
        else
        {
            // 改变进度条的进度值
            progBar.setProgress(progBar.progress + 0.02, animated:true);
        }
    }
    
    func webViewDidStartLoad(webView:UIWebView)
    {
        progBar.setProgress(0, animated:false);
        ptimer.fire();
        loadIndicator.startAnimating();
    }
    func webViewDidFinishLoad(webView:UIWebView)
    {
        loadIndicator.stopAnimating();
        progBar.setProgress(1, animated:true);
        ptimer.invalidate();
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?)
    {
//        let alertController = UIAlertController(title: "出错!",
//                                                message: error!.localizedDescription,
//                                                preferredStyle: UIAlertControllerStyle.Alert)
//        let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel,
//                                     handler: nil)
//        alertController.addAction(okAction)
//        self.presentViewController(alertController, animated: true, completion: nil)
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

//
//  NewGuiderViewController.swift
//  WeParyer
//
//  Created by Jeccy on 16/8/20.
//  Copyright © 2016年 Jeccy. All rights reserved.
//

import UIKit

class NewGuiderViewController: UIViewController {
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if IS_ARB {
//            doneBtn.setImage(UIImage(named: "newGuider_goBtn_ar"), forState: .Normal)
//            backGroundImg.image = UIImage(named: "newGuider_ar")
        }
        
        
//        let layer : CALayer = doneBtn.layer
//        layer.masksToBounds = true
//        layer.cornerRadius = 22
//        layer.borderWidth = 1
//        let btnBorderColor = UIColor.init(colorLiteralRed: 49.0/255.0, green: 114.0/255.0, blue: 183.0/255.0, alpha: 1.0)
//        layer.borderColor = btnBorderColor.CGColor
        
        // Do any additional setup after loading the view.
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

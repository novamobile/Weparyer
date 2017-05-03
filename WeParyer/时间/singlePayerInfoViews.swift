//
//  singlePayerInfoViews.swift
//  WeParyer
//
//  Created by 李轩霖 on 2017/4/27.
//  Copyright © 2017年 Jeccy. All rights reserved.
//

import UIKit
import AVFoundation

class singlePayerInfoViews: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    var payersNameLabel: UILabel!
    var payersTimeLabel: UILabel!
    //    @IBOutlet weak var payersSoundName: UILabel!
    
    var imageLayoutXPrecent: NSLayoutConstraint!
    var lineView: UIView!
    var grayView: UIView!
    
    var topLineView: UIView!
    var contentView: UIView!
    
    var spayerskey : String!
    var payersName : String!
    var paryerTime : String = ""
    var notice : UILocalNotification? = nil
    var isNextNoticeCell : Bool = false
    var willAddParyerTime : Int = 0
    var chapelToolUtils = ChapelToolUtils()
    //    var is12HoursStyle : Bool = false
    
    let soundShotName = [
        "key_Shot_Al-Affassi",
        "key_Shot_Fajr Malek Chebae",
        "key_Shot_Hamad Degheri",
        "key_Shot_Mansour-Az-Zahrani-Fajr-Intro",
        "key_Shot_Nasser Al Qatami",
        "key_Shot_Youssef Maati",
        "key_Shot_Egypt",
        "key_Shot_Fatih Seferagic",
        "key_Shot_Wadii Hamadi",
        "key_Shot_Bilal",
        "key_Shot_Bosnie",
        "key_Shot_Abdelmajid",
        "key_Shot_Maroc",
        ]
    let timeArab = [
        "0":"٠",
        "1":"١",
        "2":"٢",
        "3":"٣",
        "4":"٤",
        "5":"٥",
        "6":"٦",
        "7":"٧",
        "8":"٨",
        "9":"٩",
        ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        for var i = 0 ;i < 6; i+=1
        {
            let y:CGFloat = self.frame.height / 6 * CGFloat(i)
            let tWidth:CGFloat = 100
            
            let view = UIView.init(frame: CGRectMake(30, y, self.frame.width - 60, self.frame.height / 6))
            view.backgroundColor = UIColor.whiteColor()
            
            let nameLabel = UILabel.init(frame: CGRectMake(0, 0, 50, view.frame.height))
            nameLabel.text = "晨礼"
            self.addSubview(nameLabel)
            
            let timeLabel = UILabel.init(frame: CGRectMake(view.frame.width - tWidth, 0, tWidth, view.frame.height))
            timeLabel.text = "00:00"
            self.addSubview(timeLabel)
            
            
        }
    }
    
//        func setPayersInfo(key : String, name: String) {
//            spayerskey = key
//            payersName = name
//            payersNameLabel.text = payersName
//            
//            if spayerskey == "fajr" {
//                topLineView.hidden = false
//            }
//            else{
//                topLineView.hidden = true
//            }
//        }
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
}

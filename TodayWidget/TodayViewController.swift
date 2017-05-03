//
//  TodayViewController.swift
//  WePrayer-Today-Widget
//
//  Created by Jeccy on 16/11/23.
//  Copyright © 2016年 Jeccy. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreLocation


class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet var baseView: UIView!
    @IBOutlet var detailView: UIView!
    @IBOutlet var lineView: UIImageView!
    @IBOutlet var NodataView: UIView!
    @IBOutlet var cityName: UILabel!
    
    @IBOutlet var fajrTimeLabel: UILabel!
    @IBOutlet var dhuhrTimeLabel: UILabel!
    @IBOutlet var asrTimeLabel: UILabel!
    @IBOutlet var maghribTimeLabel: UILabel!
    @IBOutlet var ishaaTimeLabel: UILabel!
    var allTimes = [String:String]()
    @IBOutlet var nextPayer: UILabel!
    @IBOutlet var nextPayerTime: UILabel!
    @IBOutlet var nextPayerImg: UIImageView!
    
    @IBOutlet var fairNameLabel: UILabel!
    @IBOutlet var dhuhrNameLabel: UILabel!
    @IBOutlet var asrNameLabel: UILabel!
    @IBOutlet var maghribNameLabel: UILabel!
    @IBOutlet var ishaaNameLabel: UILabel!
    
    var isInit = false
    
    let allKeys = ["fajr","dhuhr","asr","maghrib","ishaa"]
    let allNames_ch = ["fajr":"晨礼","dhuhr":"晌礼","asr":"晡礼","maghrib":"昏礼","ishaa":"宵礼"]
    let allNames_en = ["fajr":"Fajr","dhuhr":"Dhuhr","asr":"Asr","maghrib":"Maghrib","ishaa":"Ishaa"]
    let allNames_ar = ["fajr":"الفجر","dhuhr":"الظهر","asr":"العصر","maghrib":"المغرب","ishaa":"العشاء"]
    
    let CUSTOM_ARABIC_FONT = "Neo Sans Arabic"//"AdobeArabic-Regular"//"GE SS"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        let os = NSProcessInfo().operatingSystemVersion
        print("系统版本 : ",os)
        switch  (os.majorVersion, os.minorVersion, os.patchVersion) {
        case  (10, _, _):
            if #available(iOSApplicationExtension 10.0, *) {
                self.extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.Expanded
                self.preferredContentSize = CGSizeMake(0, 120)
            } else {
                // Fallback on earlier versions
            }
            print( "iOS >= 10.0.0" )
//            lineView.hidden = true
            detailView.hidden = true
        default :
            self.preferredContentSize = CGSizeMake(0, 220)
            print( "iOS < 10.0.0" )
        }
        let city = getDataTodayByNSUserDefaults("TodayWidget-city")
        if city != ""
        {
            cityName.text = city
            baseView.hidden = false
            NodataView.hidden = true
            isInit = true
        }
        else{
            baseView.hidden = true
            NodataView.hidden = false
            isInit = false
        }
        if isInit {
            refreshTime()
            initTimeLabel()
            calcNextPayerTime()
        }

//        self.view.backgroundColor = UIColor(colorLiteralRed: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.35)
        
    }
    
    func refreshTime()  {
        let time1 = getParyersTimeByKey("fajr")
        allTimes["fajr"] = time1
        
        let time2 = getParyersTimeByKey("dhuhr")
        allTimes["dhuhr"] = time2
        
        let time3 = getParyersTimeByKey("asr")
        allTimes["asr"] = time3
        
        let time4 = getParyersTimeByKey("maghrib")
        allTimes["maghrib"] = time4
        
        let time5 = getParyersTimeByKey("ishaa")
        allTimes["ishaa"] = time5
        
        if NSLocale.preferredLanguages()[0].containsString("ar") {
            fairNameLabel.font = UIFont(name: CUSTOM_ARABIC_FONT, size: 18)
            dhuhrNameLabel.font = UIFont(name: CUSTOM_ARABIC_FONT, size: 18)
            asrNameLabel.font = UIFont(name: CUSTOM_ARABIC_FONT, size: 18)
            maghribNameLabel.font = UIFont(name: CUSTOM_ARABIC_FONT, size: 18)
            ishaaNameLabel.font = UIFont(name: CUSTOM_ARABIC_FONT, size: 18)
            fairNameLabel.text = allNames_ar["fajr"]
            dhuhrNameLabel.text = allNames_ar["dhuhr"]
            asrNameLabel.text = allNames_ar["asr"]
            maghribNameLabel.text = allNames_ar["maghrib"]
            ishaaNameLabel.text = allNames_ar["ishaa"]
        }
        else if NSLocale.preferredLanguages()[0].containsString("zh"){
            fairNameLabel.text = allNames_ch["fajr"]
            dhuhrNameLabel.text = allNames_ch["dhuhr"]
            asrNameLabel.text = allNames_ch["asr"]
            maghribNameLabel.text = allNames_ch["maghrib"]
            ishaaNameLabel.text = allNames_ch["ishaa"]
        }
        else{
            fairNameLabel.text = allNames_en["fajr"]
            dhuhrNameLabel.text = allNames_en["dhuhr"]
            asrNameLabel.text = allNames_en["asr"]
            maghribNameLabel.text = allNames_en["maghrib"]
            ishaaNameLabel.text = allNames_en["ishaa"]
        }
    }
    
    func initTimeLabel() {
        
        let allLabel = ["fajr":fajrTimeLabel,"dhuhr":dhuhrTimeLabel,"asr":asrTimeLabel,"maghrib":maghribTimeLabel,"ishaa":ishaaTimeLabel]
        
        for (key,value) in allLabel {
            if self.Is12HoursStyle() {
                let time_str = self.Handle12HoursStyle(allTimes[key]!)
                let stringCount = time_str.characters.count
                let attributeString = NSMutableAttributedString(string:time_str)
                let font_size = value.font.pointSize
                if NSLocale.preferredLanguages()[0].containsString("ar") {
//                    attributeString.addAttribute(NSFontAttributeName, value: UIFont(name: CUSTOM_ARABIC_FONT, size: 14)!,
//                                                 range: NSMakeRange(stringCount-2,2))
//                    attributeString.addAttribute(NSFontAttributeName, value: UIFont(name: CUSTOM_ARABIC_FONT, size: 18)!,
//                                                 range: NSMakeRange(0,stringCount-2))
                    attributeString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(14),
                                                 range: NSMakeRange(stringCount-2,2))
                    attributeString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(17),
                                                 range: NSMakeRange(0,stringCount-2))
                }
                else{
                    attributeString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(font_size/1.5),
                                             range: NSMakeRange(stringCount-2,2))
                }
                value.attributedText = attributeString
            }
            else{
                let time_str = self.Handle12HoursStyle(allTimes[key]!)
                if NSLocale.preferredLanguages()[0].containsString("ar") {
//                    value.font = UIFont(name: CUSTOM_ARABIC_FONT, size: 14)
                    value.font = UIFont.systemFontOfSize(14)
                    
                }
                value.text = time_str
            }
        }
    }
    
    func calcNextPayerTime() {
        let allTimesArray : [String] = [allTimes["fajr"]!,allTimes["dhuhr"]!,allTimes["asr"]!,allTimes["maghrib"]!,allTimes["ishaa"]!]
        var nextKey = self.calcLastParyerTime(allTimesArray)
        if nextKey == ""
        {
            nextKey = "ishaa"
        }
        
        if NSLocale.preferredLanguages()[0].containsString("ar") {
            nextPayer.font = UIFont(name: CUSTOM_ARABIC_FONT, size: 28)
            nextPayer.text = allNames_ar[nextKey]
        }
        else if NSLocale.preferredLanguages()[0].containsString("zh"){
            nextPayer.text = allNames_ch[nextKey]
        }
        else{
            nextPayer.text = allNames_en[nextKey]
        }
        
        if Is12HoursStyle() {
            nextPayerTime.text = self.Handle12HoursStyle(allTimes[nextKey]!)
        }
        else{
            nextPayerTime.text = allTimes[nextKey]
        }
        nextPayerImg.image = UIImage(named: nextKey+".png")
    }
    
    func getParyersTimeByKey(key:String) -> String {
        var result = ""
        result = getDataTodayByNSUserDefaults(key)
        return result
    }
    
    func calcLastParyerTime(times : [String]) ->String
    {
        var seconds_v : [Double] = [Double]()
        
        let  dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let prefixDate = dateFormatter.stringFromDate(NSDate()) as String
        for index in 0...4 {
            let sufixDate = times[index]
            let noticeTime = prefixDate + " \(sufixDate)"
            dateFormatter.dateFormat = "YYYY-MM-dd H:mm"
            let bori = dateFormatter.dateFromString(noticeTime)
            let seconds = (bori!.timeIntervalSince1970) as Double
            seconds_v.append(seconds)
        }
        
        dateFormatter.dateFormat = "YYYY-MM-dd H:mm"
        let nowTime = dateFormatter.stringFromDate(NSDate()) as String
        let nowSec = (dateFormatter.dateFromString(nowTime)?.timeIntervalSince1970)! as Double
        if nowSec < seconds_v[0] {
            return allKeys[0]
        }else if nowSec > seconds_v[0]  && nowSec <= seconds_v[1] {
            return allKeys[1]
        }else if nowSec > seconds_v[1]  && nowSec <= seconds_v[2] {
            return allKeys[2]
        }else if nowSec > seconds_v[2]  && nowSec <= seconds_v[3] {
            return allKeys[3]
        }else if nowSec > seconds_v[3]  && nowSec <= seconds_v[4] {
            return allKeys[4]
        }
        return ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.NewData)
    }
    
    @available(iOSApplicationExtension 10.0, *)
    func widgetActiveDisplayModeDidChange(activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        print("当前模式 : ",activeDisplayMode.rawValue)
        if isInit == false{
            return
        }
        if activeDisplayMode.rawValue == 0 {
            self.preferredContentSize = CGSizeMake(0, 320)
            
            self.detailView.alpha = 1
            UIView.animateWithDuration(0.5, animations: {
                self.detailView.alpha = 0
                self.detailView.hidden = true
            })

        }
        else if activeDisplayMode.rawValue == 1 {
            self.preferredContentSize = CGSizeMake(0, 220)
            detailView.hidden = false
            self.detailView.alpha = 0
            UIView.animateWithDuration(1, animations: {
                self.detailView.alpha = 1
            })
        }
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
    func getDataTodayByNSUserDefaults(key:String) -> String
    {
        let userDefaults = NSUserDefaults.init(suiteName: "group.com.nova.wepray")
        let arDic = userDefaults?.dictionaryRepresentation()
        print("当前存储",arDic)
        print("当前存储的长度",arDic?.count)
        let allKeys = arDic?.keys
        for key in allKeys! {
            if key == "TodayWidget-city" {
                isInit = true
            }
        }
        var result : String = ""
        if userDefaults != nil && isInit {
           result = userDefaults!.valueForKey(key) as! String
        }
        return result
    }

    func Is12HoursStyle() -> Bool {
        let h_String : NSString = NSDateFormatter.dateFormatFromTemplate("j", options: 0, locale: NSLocale.currentLocale())!
        let h_range = h_String.rangeOfString("a")
        return  (h_range.location != NSNotFound)
    }
    
    func Handle12HoursStyle(time : String) -> String {
        var finial_time_str : String = time
        if(Is12HoursStyle())
        {
            let dateFormatter = NSDateFormatter()
            if NSLocale.preferredLanguages()[0].containsString("ar") == false {
                dateFormatter.AMSymbol = " AM"
                dateFormatter.PMSymbol = " PM"
            }
            else{
                dateFormatter.AMSymbol = " ص"
                dateFormatter.PMSymbol = " م"
            }
            dateFormatter.dateFormat = "H:mm"
            let dateTime = dateFormatter.dateFromString(time)
            dateFormatter.dateFormat = "h:mma"
            finial_time_str = dateFormatter.stringFromDate(dateTime!) as String
        }
        return finial_time_str
    }

    
    @IBAction func jumpClick(sender: AnyObject) {
        self.extensionContext?.openURL(NSURL.init(string: "WeprayToday://action=aaaa")!, completionHandler: { (finished) in
                        print("open url result:",finished)
            })
    }
}

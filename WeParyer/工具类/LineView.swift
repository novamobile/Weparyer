//
//  LineView.swift
//  WeParyer
//
//  Created by Jeccy on 16/9/11.
//  Copyright © 2016年 Jeccy. All rights reserved.
//

import UIKit

class LineView: UIView {

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        self.backgroundColor = UIColor.clearColor()
        let context = UIGraphicsGetCurrentContext()
        CGContextSetStrokeColorWithColor(context!, UIColor.lightGrayColor().CGColor)
        CGContextSetLineWidth(context!, 1)
        CGContextMoveToPoint(context!,0,1)
        CGContextAddLineToPoint(context!,SCREEN_SIZE_WIDTH - 5,1)
        CGContextStrokePath(context!)
        self.alpha = 0.5
    }
}

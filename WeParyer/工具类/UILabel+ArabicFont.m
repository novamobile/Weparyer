//
//  UILabel+ArabicFont.m
//  WeParyer
//
//  Created by Jeccy on 16/11/30.
//  Copyright © 2016年 Jeccy. All rights reserved.
//

#import "UILabel+ArabicFont.h"
#import <objc/runtime.h>
#define CustomFontName @"AdobeArabic-Regular"
#define CustumFontName @"Neo Sans Arabic"

@implementation UILabel (ArabicFont)
+ (void)load {
    //方法交换应该被保证，在程序中只会执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //获得viewController的生命周期方法的selector
        SEL systemSel = @selector(willMoveToSuperview:);
        //自己实现的将要被交换的方法的selector
        SEL swizzSel = @selector(myWillMoveToSuperview:);
        //两个方法的Method
        Method systemMethod = class_getInstanceMethod([self class], systemSel);
        Method swizzMethod = class_getInstanceMethod([self class], swizzSel);
        //首先动态添加方法，实现是被交换的方法，返回值表示添加成功还是失败
        BOOL isAdd = class_addMethod(self, systemSel, method_getImplementation(swizzMethod), method_getTypeEncoding(swizzMethod));
        if (isAdd) {
            //如果成功，说明类中不存在这个方法的实现
            //将被交换方法的实现替换到这个并不存在的实现
            class_replaceMethod(self, swizzSel, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
        } else {
            //否则，交换两个方法的实现
            method_exchangeImplementations(systemMethod, swizzMethod);
        }
    });
}
- (void)myWillMoveToSuperview:(UIView *)newSuperview {
    if( newSuperview == NULL ){
        return;
    }
    /*
    NSArray *familyNames = [UIFont familyNames];
    for( NSString *familyName in familyNames )
    {
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        for( NSString *fontName in fontNames )
        {
            printf( "\tJeccyFont: %s ----%s \n", [familyName UTF8String],[fontName UTF8String] );
        }
    }
     */
    [self myWillMoveToSuperview:newSuperview];
    if (self) {
        if([[[NSLocale preferredLanguages] objectAtIndex:0] containsString:@"ar"]){
            NSLog(@"是阿语字体");
            if ([UIFont fontNamesForFamilyName:CustumFontName])
                self.font  = [UIFont fontWithName:CustumFontName size:self.font.pointSize];
        } else {
            self.font = [UIFont systemFontOfSize:self.font.pointSize];
            NSLog(@"不是阿语字体");
        }
    }
}
@end

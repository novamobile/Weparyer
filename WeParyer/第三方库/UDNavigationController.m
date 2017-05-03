//
//  UDNavigationController.m
//  test
//
//  Created by UDi on 15-1-7.
//  Copyright (c) 2015年 Mango Media Network Co.,Ltd. All rights reserved.
//

#import "UDNavigationController.h"

@implementation UDNavigationController
@synthesize alphaView;
-(id)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    alphaView = NULL;
    if (self) {
        CGRect frame = self.navigationBar.frame;
        alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height+20)];
//        alphaView.backgroundColor = [UIColor colorWithRed:77.0/255.0 green:168.0/255.0 blue:254.0/255.0 alpha:1.0];
        alphaView.backgroundColor = [UIColor whiteColor];
        
        UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height+20, frame.size.width ,0.5)];
        lineView.backgroundColor = [UIColor colorWithRed:178.0/255.0 green:178.0/255.0 blue:178.0/255.0 alpha:0.5];
        [alphaView addSubview:lineView];
        
        [self.view insertSubview:alphaView belowSubview:self.navigationBar];
//        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"bigShadow.png"] forBarMetrics:UIBarMetricsCompact];
//        self.navigationBar.layer.masksToBounds = YES;
    }
    return self;
}
-(void)setAlph{
    if (_changing == NO) {
        _changing = YES;
        if (alphaView.alpha == 0.0 ) {
            [UIView animateWithDuration:0.5 animations:^{
                alphaView.alpha = 1.0;
            } completion:^(BOOL finished) {
                 _changing = NO;
            }];
        }else{
            [UIView animateWithDuration:0.5 animations:^{
                alphaView.alpha = 0.0;
            } completion:^(BOOL finished) {
                _changing = NO;

            }];
        }
    }
    
}

-(void)setAlph:(float)alph
{
    if(alphaView)
        alphaView.alpha = alph;
}

@end

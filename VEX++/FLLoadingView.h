//
//  FLLoadingView.h
//  VEX++
//
//  Created by Michael Hulet on 3/4/15.
//  Copyright (c) 2015 Michael Hulet. All rights reserved.
//

@import UIKit;
@interface FLLoadingView : UIView
+(instancetype)createInView:(UIView *)view;
-(void)showInView:(UIView *)view;
-(void)hide;
@end
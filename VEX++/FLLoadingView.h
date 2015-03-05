//
//  FLLoadingView.h
//  VEX++
//
//  Created by Michael Hulet on 3/4/15.
//  Copyright (c) 2015 Michael Hulet. All rights reserved.
//

@import UIKit;
@interface FLLoadingView : UIView
+(nonnull instancetype)createInView:(nonnull UIView *)view;
-(void)showInView:(nonnull UIView *)view;
-(void)hide;
@end
//
//  AppDelegate.h
//  VEX++
//
//  Created by Michael Hulet on 2/24/15.
//  Copyright (c) 2015 Michael Hulet. All rights reserved.
//

@import UIKit;
@interface FLAppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic, nonnull) UIWindow *window;
-(nonnull UIView *)showLaunchScreenInView:(nonnull UIView *)view;
@end
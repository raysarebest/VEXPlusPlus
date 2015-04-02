//
//  AppDelegate.h
//  VEX++
//
//  Created by Michael Hulet on 2/24/15.
//  Copyright (c) 2015 Michael Hulet. All rights reserved.
//

@import UIKit;
static NSString * __nonnull const FLMostRecentVEXIDKey = @"lastVEXID";
static NSString * __nonnull const FLMostRecentPasswordKey = @"lastPassword";
@interface FLAppDelegate : UIResponder <UIApplicationDelegate, UISplitViewControllerDelegate>
@property (strong, nonatomic, nonnull) UIWindow *window;
-(void)saveAuthDataWithVEXID:(nonnull NSString *)VEXID password:(nonnull NSString *)password;
@end
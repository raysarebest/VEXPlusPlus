//
//  FLSignUpViewController.m
//  VEX++
//
//  Created by Michael Hulet on 3/4/15.
//  Copyright (c) 2015 Michael Hulet. All rights reserved.
//

#import "FLSignUpViewController.h"
#import "FLUIManager.h"
#import "FLAppDelegate.h"
@implementation FLSignUpViewController
#pragma mark - View Setup Code
-(void)viewDidLoad{
    [super viewDidLoad];
    UIView *launchScreen = [(FLAppDelegate *)[UIApplication sharedApplication].delegate showLaunchScreenInView:self.view];
    [self.view sendSubviewToBack:launchScreen];
    launchScreen.alpha = .5;
    //Make pretty parallax effect
    [FLUIManager addParallaxEffectToView:launchScreen withSway:nil];
    //Configure the background image
    [self.backgroundLogo removeFromSuperview];
    launchScreen.frame = self.view.frame;
    [self.view addSubview:launchScreen];
    [self.view sendSubviewToBack:launchScreen];
}
@end
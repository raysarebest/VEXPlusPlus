//
//  FLSplitViewController.m
//  VEX++
//
//  Created by Michael Hulet on 3/18/15.
//  Copyright (c) 2015 Michael Hulet. All rights reserved.
//

#import "FLSplitViewController.h"
#import "FLLoginViewController.h"
#import "FLMasterViewController.h"
#import "FLLoadingView.h"
#import "FLUIManager.h"
#import "FLAppDelegate.h"
@import Parse;
@interface FLSplitViewController()
@property (strong, nonatomic, nonnull) UIView *launchScreen;
@property (nonatomic) BOOL shouldHideStatusBar;
@end
@implementation FLSplitViewController
#pragma mark - View Setup Code
-(void)viewDidLoad{
    [super viewDidLoad];
    //Do any additional setup after loading the view.
    if(self.appLaunch && ![PFUser currentUser]){
        self.shouldHideStatusBar = YES;
        self.launchScreen = [FLUIManager showLaunchScreenInView:self.view];
    }
    else if([self.view.subviews containsObject:self.launchScreen]){
        [self.launchScreen removeFromSuperview];
        self.shouldHideStatusBar = NO;
        [self setNeedsStatusBarAppearanceUpdate];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if([PFUser currentUser]){
        self.appLaunch = self.shouldHideStatusBar = NO;
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(![PFUser currentUser]){
        [FLUIManager presentLoginSceneAnimated:!self.appLaunch inLaunchingState:self.appLaunch completion:nil];
    }
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(BOOL)prefersStatusBarHidden{
    return self.shouldHideStatusBar;
}
#pragma mark - View Teardown Code
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.launchScreen removeFromSuperview];
}
#pragma mark - Property Setters
-(void)setShouldHideStatusBar:(BOOL)shouldHideStatusBar{
    _shouldHideStatusBar = shouldHideStatusBar;
    [self setNeedsStatusBarAppearanceUpdate];
}
@end
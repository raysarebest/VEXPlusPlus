//
//  FLSplitViewController.m
//  VEX++
//
//  Created by Michael Hulet on 3/18/15.
//  Copyright (c) 2015 Michael Hulet. All rights reserved.
//

#import "FLSplitViewController.h"
#import "FLLoginViewController.h"
@import Parse;
@interface FLSplitViewController()
@property (strong, nonatomic, nonnull) UIView *launchScreen;
@end
@implementation FLSplitViewController
#pragma mark - View Setup Code
-(void)viewDidLoad {
    [super viewDidLoad];
    //Do any additional setup after loading the view.
    if(self.appLaunch && ![PFUser currentUser]){
        self.launchScreen.frame = [UIScreen mainScreen].bounds;
        [self.view addSubview:self.launchScreen];
        [self.view bringSubviewToFront:self.launchScreen];
    }
    else if([self.view.subviews containsObject:self.launchScreen]){
        [self.launchScreen removeFromSuperview];
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(![PFUser currentUser]){
        UINavigationController *login = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"auth"];
        ((FLLoginViewController *)login.viewControllers.firstObject).appLaunch = YES;
        [self presentViewController:login animated:!self.appLaunch completion:nil];
    }
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
#pragma mark - Property Lazy Instantiation
-(UIView *)launchScreen{
    if(!_launchScreen){
        _launchScreen = (UIView *)[[NSBundle mainBundle] loadNibNamed:@"LaunchScreen" owner:self options:nil].firstObject;
    }
    return _launchScreen;
}
@end
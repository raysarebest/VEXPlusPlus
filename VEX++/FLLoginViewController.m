//
//  FLLoginViewController.m
//  VEX++
//
//  Created by Michael Hulet on 3/4/15.
//  Copyright (c) 2015 Michael Hulet. All rights reserved.
//

#import "FLLoginViewController.h"
#import "FLUIManager.h"
#import "FLAppDelegate.h"
@interface FLLoginViewController()
@property (strong, nonatomic, nonnull) UIView *launchScreen;
@end
@implementation FLLoginViewController
#pragma mark - View Setup Code
-(void)viewDidLoad{
    [super viewDidLoad];
    [FLUIManager addParallaxEffectToView:self.backgroundLogo withSway:nil];
    [FLUIManager addParallaxEffectToView:self.launchScreen withSway:nil];
    if(self.appLaunch){
        self.signUpView.hidden = YES;
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        [self.backgroundLogo removeFromSuperview];
        self.launchScreen.frame = self.view.frame;
        [self.view addSubview:self.launchScreen];
        [self.view sendSubviewToBack:self.launchScreen];
        [UIView animateWithDuration:1 animations:^{
            self.launchScreen.alpha = .5;
        } completion:^(BOOL finished) {
            self.signUpView.layer.position = CGPointMake(self.signUpView.layer.position.x, self.signUpView.layer.position.y + self.signUpView.frame.size.height);
            self.signUpView.hidden = NO;
            [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [self.navigationController setNavigationBarHidden:NO animated:NO];
            } completion:nil];
        }];
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
- (IBAction)signUp {
}
@end
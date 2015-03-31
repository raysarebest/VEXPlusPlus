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
@interface FLSignUpViewController()
@property (strong, nonatomic, nonnull) NSTimer *animationTimer;
@property (strong, nonatomic, nonnull) UIView *launchScreen;
-(void)animateNextViewFromRight;
@end
@implementation FLSignUpViewController
#pragma mark - View Setup Code
-(void)viewDidLoad{
    [super viewDidLoad];
    self.launchScreen = [FLUIManager showLaunchScreenInView:self.view];
    //Make pretty parallax effect
    [FLUIManager addParallaxEffectToView:self.launchScreen withSway:nil];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //Set up animations
    if(self.shouldAnimateFromSide){
        for(UIView *view in self.animators){
            view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
        }
    }
    [self.backgroundLogo removeFromSuperview];
    [self.view sendSubviewToBack:self.launchScreen];
    [UIView animateWithDuration:.25 animations:^{
        self.launchScreen.alpha = .5;
    } completion:^(BOOL finished) {
        //Animate
        if(self.shouldAnimateFromSide){
            self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(animateNextViewFromRight) userInfo:nil repeats:YES];
        }
    }];
}
#pragma mark - UI Helper Methods
-(void)animateNextViewFromRight{
    if(self.shouldAnimateFromSide){
        static NSInteger index = 0;
        UIView *view = self.animators[index];
        [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            view.center = CGPointMake(self.view.center.x, view.center.y);
        } completion:nil];
        if(index == self.animators.count - 1){
            index = 0;
            [self.animationTimer invalidate];
            return;
        }
        else{
            index++;
        }
    }
}
@end
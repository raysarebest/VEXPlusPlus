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
#import "FLLoadingView.h"
#import "UITextField+FLElectricTextField.h"
@import Parse;
@interface FLLoginViewController()
@property (strong, nonatomic, nonnull) UIView *launchScreen;
@property (nonatomic) BOOL shouldHideStatusBar;
-(void)setStatusBarHidden:(BOOL)hidden animated:(BOOL)animated;
@end
@implementation FLLoginViewController
#pragma mark - View Setup Code
-(void)viewDidLoad{
    [super viewDidLoad];
    [self setStatusBarHidden:NO animated:NO];
    for(id object in self.animators){
        if([object isKindOfClass:[UITextField class]]){
            ((UITextField *)object).delegate = self;
        }
    }
    self.launchScreen = [(FLAppDelegate *)[UIApplication sharedApplication].delegate showLaunchScreenInView:self.view];
    //Make pretty parallax effect
    [FLUIManager addParallaxEffectToView:self.launchScreen withSway:nil];
    //Animate stuff
    if(self.appLaunch){
        self.signUpView.hidden = YES;
        [self setStatusBarHidden:YES animated:NO];
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //Literally I don't understand like any of the following because I coded it at like 3 AM and there's a lot of math, but it works
    NSInteger totalMovement = 0;
    if(self.appLaunch){
        for(UIView *object in self.animators){
            if([object isKindOfClass:[UIButton class]]){
                NSInteger original = object.center.y;
                object.center = CGPointMake(object.center.x, 0 - object.frame.size.height);
                totalMovement = original - object.center.y;
            }
        }
        for(UIView *object in self.animators){
            if(![object isKindOfClass:[UIButton class]]){
                UITextField *field = (UITextField *)object;
                field.center = CGPointMake(field.center.x, field.center.y - totalMovement);
            }
        }
        [self.view sendSubviewToBack:self.launchScreen];
        [UIView animateWithDuration:1 animations:^{
            self.launchScreen.alpha = .5;
        } completion:^(BOOL finished) {
            self.signUpView.layer.position = CGPointMake(self.signUpView.layer.position.x, self.signUpView.layer.position.y + self.signUpView.frame.size.height);
            self.signUpView.hidden = NO;
            [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [self.navigationController setNavigationBarHidden:NO animated:NO];
            } completion:^(BOOL finished){
                [UIView animateWithDuration:2 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    for(UIView *object in self.animators){
                        object.center = CGPointMake(object.center.x, object.center.y + totalMovement);
                    }
                } completion:^(BOOL finished){
                    [self setStatusBarHidden:NO animated:YES];
                }];
            }];
        }];
    }
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(BOOL)prefersStatusBarHidden{
    return self.shouldHideStatusBar;
}
#pragma mark - IBActions
-(IBAction)logIn{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.view endEditing:YES];
    NSString *VEXID = [((UITextField *)self.animators.firstObject).text.capitalizedString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [((UITextField *)[self.animators objectAtIndex:1]).text.capitalizedString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    FLLoadingView *loader = [FLLoadingView createInView:self.view];
    if(![VEXID isEqualToString:[NSString string]] && ![password isEqualToString:[NSString string]]){
        [PFCloud callFunctionInBackground:@"validateVEXID" withParameters:@{@"VEXID":VEXID} block:^(id result, NSError *error){
            if(error){
                [loader hide];
                NSString *reason;
                if(error.code == 100){
                    reason = @"You must connect to the internet";
                }
                else{
                    reason = error.userInfo[@"error"];
                }
                [self presentViewController:[FLUIManager alertControllerWithTitle:nil message:reason] animated:YES completion:nil];
            }
            //TODO: Actually log in the user
            [loader hide];
            [self presentViewController:[FLUIManager alertControllerWithTitle:@"Success" message:@"That VEX ID is valid"] animated:YES completion:nil];
        }];
    }
    else if([VEXID isEqualToString:[NSString string]] && ![password isEqualToString:[NSString string]]){
        [self presentViewController:[FLUIManager alertControllerWithTitle:nil message:@"You must provide a VEX ID"] animated:YES completion:nil];
        [loader hide];
    }
    else if(![VEXID isEqualToString:[NSString string]] && [password isEqualToString:[NSString string]]){
        [self presentViewController:[FLUIManager alertControllerWithTitle:nil message:@"You must enter a password"] animated:YES completion:nil];
        [loader hide];
    }
    else{
        [self presentViewController:[FLUIManager alertControllerWithTitle:nil message:@"You must supply a VEX ID and a password"] animated:YES completion:nil];
        [loader hide];
    }
}
#pragma mark - UI Helper Methods
-(void)setStatusBarHidden:(BOOL)hidden animated:(BOOL)animated{
    if(hidden != self.shouldHideStatusBar){
        self.shouldHideStatusBar = hidden;
        if(animated){
            [UIView animateWithDuration:1 animations:^{
                [self setNeedsStatusBarAppearanceUpdate];
            }];
        }
        else{
            [self setNeedsStatusBarAppearanceUpdate];
        }
    }
}
#pragma mark - UITextFieldDelegate Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == self.animators.firstObject){
        [[self.animators objectAtIndex:1] becomeFirstResponder];
    }
    else{
        [textField resignFirstResponder];
        [self logIn];
    }
    return NO;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField textFieldDidBeginEditing:textField];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [textField textFieldDidEndEditing:textField];
}
@end
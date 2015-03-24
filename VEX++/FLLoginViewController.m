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
-(void)showForgotButtonOnScreenSize:(CGSize)size animated:(BOOL)animated;
-(void)hideForgotButtonOnScreenSize:(CGSize)size animated:(BOOL)animated;
@end
@implementation FLLoginViewController
#pragma mark - View Setup Code
-(void)viewDidLoad{
    [super viewDidLoad];
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone && UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)){
        self.forgotSpace.constant = [UIScreen mainScreen].bounds.size.width;
    }
    else{
        self.forgotButton.hidden = YES;
    }
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
    else{
        [self setStatusBarHidden:NO animated:NO];
    }
    [self hideForgotButtonOnScreenSize:CGSizeZero animated:NO];
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
-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    NSLog(@"View rotated");
    if(self.forgotButton.hidden){
        //Keep the forgot password button hidden, but prepare it for animation in from the right
        [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            [self hideForgotButtonOnScreenSize:size animated:NO];
        } completion:nil];
    }
    else if(!self.forgotButton.hidden){
        //The forgot password button is showing, but we need to transition it to portrait mode
        [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            [self showForgotButtonOnScreenSize:size animated:NO];
        } completion:nil];
    }
}
#pragma mark - IBActions
-(IBAction)logIn{
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
            else{
                [PFUser logInWithUsernameInBackground:VEXID password:password block:^(PFUser *user, NSError *error){
                    [loader hide];
                    static int invocations = 0;
                    if(error){
                        invocations++;
                        NSString *reason;
                        if(error.code == 100){
                            reason = @"You must connect to the internet";
                        }
                        else if(error.code == 101){
                            reason = @"Your VEX ID or password is incorrect";
                        }
                        else{
                            reason = error.userInfo[@"error"];
                        }
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:reason preferredStyle:UIAlertControllerStyleAlert];
                        [alert addAction:[UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                            if(invocations >= 3){
                                [self showForgotButtonOnScreenSize:CGSizeZero animated:YES];
                            }
                        }]];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                    else{
                        invocations = 0;
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                }];
            }
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

- (IBAction)resetPassword {
}
#pragma mark - UI Helper Methods
-(void)setStatusBarHidden:(BOOL)hidden animated:(BOOL)animated{
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
-(void)showForgotButtonOnScreenSize:(CGSize)size animated:(BOOL)animated{
    if(CGSizeEqualToSize(size, CGSizeZero)){
        size = [UIScreen mainScreen].bounds.size;
    }
    if([FLUIManager sizeIsPortrait:size] && [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone){
        //Show Forgot Button by animating it in from the right
        self.forgotButton.alpha = 1;
        __block UITextField *const passwordField = [self.animators objectAtIndex:1];
        static const CGFloat forgotSpace = 8;
        const CGFloat sizes[3] = {passwordField.frame.size.width, self.forgotButton.frame.size.width, forgotSpace};
        CGFloat total = 0;
        for(int i = 0; i < sizeof(sizes)/sizeof(sizes[0]); i++){
            total += sizes[i];
        }
        const CGFloat negativeSpace = size.width - total;
        const CGFloat targetPosition = negativeSpace / 2;
        self.forgotButton.hidden = NO;
        if(animated){
            [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                passwordField.frame = CGRectMake(targetPosition, passwordField.frame.origin.y, passwordField.frame.size.width, passwordField.frame.size.height);
                self.forgotButton.frame = CGRectMake(targetPosition + passwordField.frame.size.width + forgotSpace, self.forgotButton.frame.origin.y, self.forgotButton.frame.size.width, self.forgotButton.frame.size.height);
            } completion:nil];
        }
        else{
            passwordField.frame = CGRectMake(targetPosition, passwordField.frame.origin.y, passwordField.frame.size.width, passwordField.frame.size.height);
            self.forgotButton.frame = CGRectMake(targetPosition + passwordField.frame.size.width + forgotSpace, self.forgotButton.frame.origin.y, self.forgotButton.frame.size.width, self.forgotButton.frame.size.height);
        }
    }
    else{
        self.forgotSpace.constant = 8;
        if(self.forgotButton.hidden){
            self.forgotButton.alpha = 0;
            self.forgotButton.hidden = NO;
        }
        [self.view layoutIfNeeded];
        if(animated){
            [UIView animateWithDuration:.5 animations:^{
                self.forgotButton.alpha = 1;
            }];
        }
        else{
            self.forgotButton.alpha = 1;
        }
    }
}
-(void)hideForgotButtonOnScreenSize:(CGSize)size animated:(BOOL)animated{
    if(CGSizeEqualToSize(size, CGSizeZero)){
        size = [UIScreen mainScreen].bounds.size;
    }
    if([FLUIManager sizeIsPortrait:size] && [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone){
        self.forgotSpace.constant = size.width;
        if(animated){
            [UIView animateWithDuration:1 animations:^{
                [self.view layoutIfNeeded];
            }];
        }
        else{
            [self.view layoutIfNeeded];
        }
    }
    else{
        if(animated){
            [UIView animateWithDuration:.5 animations:^{
                self.forgotButton.alpha = 0;
            }];
        }
        else{
            self.forgotButton.alpha = 0;
        }
    }
    self.forgotButton.hidden = YES;
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
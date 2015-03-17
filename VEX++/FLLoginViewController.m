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
#import "UITextField+FLElectricTextField.h"
@implementation FLLoginViewController
#pragma mark - View Setup Code
-(void)viewDidLoad{
    [super viewDidLoad];
    for(id object in self.animators){
        if([object isKindOfClass:[UITextField class]]){
            ((UITextField *)object).delegate = self;
        }
    }
    UIView *launchScreen = (UIView *)[[NSBundle mainBundle] loadNibNamed:@"LaunchScreen" owner:self options:nil].firstObject;
    //Make pretty parallax effect
    [FLUIManager addParallaxEffectToView:launchScreen withSway:nil];
    //Configure the background image properly
    launchScreen.frame = self.view.frame;
    [self.view addSubview:launchScreen];
    [self.view sendSubviewToBack:launchScreen];
    //Animate stuff
    if(self.appLaunch){
        self.signUpView.hidden = YES;
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        [UIView animateWithDuration:1 animations:^{
            launchScreen.alpha = .5;
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
#pragma mark - IBActions
-(IBAction)logIn{
    NSLog(@"Logged in");
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
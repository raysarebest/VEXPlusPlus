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
#import "FLLoadingView.h"
#import "UITextField+FLElectricTextField.h"
@import Parse;
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
    for(UIView *object in self.animators){
        if([object isKindOfClass:[UITextField class]]){
            ((UITextField *)object).delegate = self;
        }
    }
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
#pragma mark - UITextFieldDelegate Methods
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField textFieldDidBeginEditing:textField];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [textField textFieldDidEndEditing:textField];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    UIView *nextField = self.animators[[self.animators indexOfObject:textField] + 1];
    if([nextField isKindOfClass:[UITextField class]]){
        [nextField becomeFirstResponder];
    }
    else{
        //TODO: Implement the sign up method and call it here
    }
    return NO;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"%@", string);
    UITextField *otherField = nil;
    NSArray *const imageViews = @[self.passwordMatchImage, self.confirmPasswordMatchImage];
    for(UITextField *field in @[self.passwordField, self.confirmPasswordField]){
        if(textField != field){
            otherField = field;
            break;
        }
    }
    if(textField == self.passwordField || textField == self.confirmPasswordField){
        //This looks like the most violent if statement, but it works, so don't touch it
        if([[[textField.text stringByAppendingString:([string isEqualToString:@""] ? [textField.text stringByReplacingCharactersInRange:NSMakeRange(string.length, 1) withString:string] : string)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:[otherField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] && ![[[textField.text stringByAppendingString:string] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:[NSString string]]){
            for(UIImageView *imageView in imageViews){
                imageView.image = [UIImage imageNamed:@"checkmark"];
            }
        }
        else{
            self.passwordMatchImage.image = [UIImage imageNamed:@"checkmark"];
            self.confirmPasswordMatchImage.image = [UIImage imageNamed:@"x"];
        }
    }
    return YES;
}
#pragma mark - IBActions
-(IBAction)signUp{
    FLLoadingView *loader = [FLLoadingView createInView:self.view];
    //Make sure all the fields are filled out
    for(UIView *object in self.animators){
        if([object isKindOfClass:[UITextField class]]){
            if([((UITextField *)object).text isEqualToString:[NSString string]]){
                [loader hide];
                [self presentViewController:[FLUIManager alertControllerWithTitle:nil message:@"You need to fill out every field" defaultHandler:YES] animated:YES completion:nil];
                return;
            }
        }
    }
}
@end
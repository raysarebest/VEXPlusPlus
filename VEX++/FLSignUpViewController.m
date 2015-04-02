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
@property (strong, nonatomic, nonnull) NSMutableDictionary *hasEdited;
-(void)animateNextViewFromRight;
-(BOOL)password:(NSString *)password matchesPassword:(NSString *)otherPassword;
-(BOOL)passwordConformsToStandards:(NSString *)password;
void logBOOL(BOOL boolean);
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
    //Here's a little hack, because UITextField doesn't conform to NSCopying
    self.hasEdited[textField.placeholder] = @(YES);
    [textField textFieldDidEndEditing:textField];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    UIView *nextField = self.animators[[self.animators indexOfObject:textField] + 1];
    if([nextField isKindOfClass:[UITextField class]]){
        [nextField becomeFirstResponder];
    }
    else{
        [self signUp];
    }
    return NO;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *nextValue = nil;
    if(textField != self.VEXIDField || (int)(textField.text.length + ((string.length * 2) - 1)) <= 5){
        nextValue = [textField.text stringByReplacingCharactersInRange:range withString:string];
    }
    if(textField.secureTextEntry){
        if(((NSNumber *)self.hasEdited[textField.placeholder]).boolValue){
            self.hasEdited[textField.placeholder] = @(NO);
            nextValue = [NSString string];
        }
        UITextField *otherField = nil;
        NSArray *const imageViews = @[self.passwordMatchImage, self.confirmPasswordMatchImage];
        for(UITextField *field in @[self.passwordField, self.confirmPasswordField]){
            if(textField != field){
                otherField = field;
                break;
            }
        }
        if([self passwordConformsToStandards:nextValue] && [self password:nextValue matchesPassword:otherField.text]){
            for(UIImageView *imageView in imageViews){
                imageView.image = [UIImage imageNamed:@"checkmark"];
            }
        }
        else if(otherField == self.passwordField ? [otherField.text isEqualToString:[NSString string]] : [nextValue isEqualToString:[NSString string]]){
            for(UIImageView *imageView in imageViews){
                imageView.image = [UIImage imageNamed:@"x"];
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
    if([self password:self.passwordField.text matchesPassword:self.confirmPasswordField.text] && [self passwordConformsToStandards:self.passwordField.text]){
        if([[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"] evaluateWithObject:self.emailField.text]){
            [PFCloud callFunctionInBackground:@"validateVEXID" withParameters:@{@"VEXID":self.VEXIDField.text.uppercaseString} block:^(id result, NSError *error){
                if(error){
                    [loader hide];
                    [self presentViewController:[FLUIManager defaultParseErrorAlertControllerForError:error defaultHandler:YES] animated:YES completion:nil];
                }
                else{
                    PFUser *newUser = [PFUser user];
                    newUser.username = self.VEXIDField.text.uppercaseString;
                    newUser.password = self.passwordField.text;
                    newUser.email = self.emailField.text.lowercaseString;
                    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                        if(succeeded && !error){
                            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                                [loader hide];
                            }];
                        }
                        else{
                            [loader hide];
                            [self presentViewController:[FLUIManager defaultParseErrorAlertControllerForError:error defaultHandler:YES] animated:YES completion:nil];
                        }
                    }];
                }
            }];
        }
        else{
            [loader hide];
            [self presentViewController:[FLUIManager alertControllerWithTitle:nil message:@"Please make sure you enter a valid email address" defaultHandler:YES] animated:YES completion:nil];
        }
    }
    else{
        [loader hide];
        [self presentViewController:[FLUIManager alertControllerWithTitle:nil message:@"Make sure the passwords you entered are the same, and they exist" defaultHandler:YES] animated:YES completion:nil];
    }
}
#pragma mark - Password Utilities
-(BOOL)password:(NSString *)password matchesPassword:(NSString *)otherPassword{
    return [[password  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:[otherPassword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
}
-(BOOL)passwordConformsToStandards:(NSString *)password{
    //Right now, we just want the password to exist
    return ![[password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:[NSString string]];
}
#pragma mark - Property Lazy Instantiation
-(NSMutableDictionary *)hasEdited{
    if(!_hasEdited){
        _hasEdited = [NSMutableDictionary dictionary];
    }
    return _hasEdited;
}
@end
//
//  FLLoginViewController.m
//  VEX++
//
//  Created by Michael Hulet on 3/4/15.
//  Copyright (c) 2015 Michael Hulet. All rights reserved.
//

#import "FLLoginViewController.h"
#import "FLSignUpViewController.h"
#import "FLUIManager.h"
#import "FLAppDelegate.h"
#import "FLLoadingView.h"
#import "UITextField+FLElectricTextField.h"
#import "NSString+FLReversedString.h"
@import Parse;
@import LocalAuthentication;
@interface FLLoginViewController()
@property (strong, nonatomic, nonnull) UIView *launchScreen;
@property (nonatomic) NSInteger criticalMovement;
@property (nonatomic) BOOL shouldHideStatusBar;
@property (nonatomic) BOOL launching;
-(void)prepareCriticalUIForLaunch;
-(void)setStatusBarHidden:(BOOL)hidden animated:(BOOL)animated;
-(void)showForgotButtonOnScreenSize:(CGSize)size animated:(BOOL)animated duration:(CGFloat)duration;
-(void)hideForgotButtonOnScreenSize:(CGSize)size animated:(BOOL)animated duration:(CGFloat)duration;
-(void)showForgotButtonFromSelector;
-(void)hideForgotButtonFromSelector;
-(void)keyboardWillChangeFrame;
-(void)keyboardDidChangeFrame;
-(void)securelyCacheAuthData;
-(void)attemptBiometricLogin;
-(nullable NSString *)unencrypedPassword;
@end
@implementation FLLoginViewController
#pragma mark - View Setup Code
-(void)viewDidLoad{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame) name:UIKeyboardWillChangeFrameNotification object:nil];
    //Handle interface stuff
    UITextField *const passwordField = self.animators[1];
    UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showForgotButtonFromSelector)];
    left.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideForgotButtonFromSelector)];
    right.direction = UISwipeGestureRecognizerDirectionRight;
    [passwordField addGestureRecognizer:left];
    [passwordField addGestureRecognizer:right];
    NSString *VEXID = [[NSUserDefaults standardUserDefaults] stringForKey:FLMostRecentVEXIDKey];
    if(VEXID){
        self.VEXIDField.text = VEXID;
    }
    for(UIView *object in self.animators){
        if([object isKindOfClass:[UITextField class]]){
            ((UITextField *)object).delegate = self;
        }
    }
    self.launchScreen = [FLUIManager showLaunchScreenInView:self.view];
    //Make pretty parallax effect
    [FLUIManager addParallaxEffectToView:self.launchScreen withSway:nil];
    //Animate stuff
    if(self.appLaunch){
        self.signUpView.hidden = YES;
        [self setStatusBarHidden:YES animated:NO];
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    else{
        [self.view sendSubviewToBack:self.launchScreen];
        self.launchScreen.alpha = .5;
        [self setStatusBarHidden:NO animated:NO];
    }
    self.launching = self.appLaunch;
    [self hideForgotButtonOnScreenSize:CGSizeZero animated:NO duration:0];
    //Don't ask me why I have to do this twice. It just fixes a bug on launch
    self.forgotButton.hidden = YES;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //Literally I don't understand like any of the following because I coded it at like 3 AM and there's a lot of math, but it works
    if(self.appLaunch){
        [self prepareCriticalUIForLaunch];
        [self.view sendSubviewToBack:self.launchScreen];
        [UIView animateWithDuration:1 animations:^{
            self.launchScreen.alpha = .5;
        } completion:^(BOOL finished){
            self.signUpView.layer.position = CGPointMake(self.signUpView.layer.position.x, self.signUpView.layer.position.y + self.signUpView.frame.size.height);
            self.signUpView.hidden = NO;
            [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [self.navigationController setNavigationBarHidden:NO animated:NO];
            } completion:^(BOOL finished){
                [UIView animateWithDuration:2 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    for(UIView *object in self.animators){
                        object.center = CGPointMake(object.center.x, object.center.y + self.criticalMovement);
                    }
                } completion:^(BOOL finished){
                    [self setStatusBarHidden:NO animated:YES];
                    self.forgotButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, self.passwordField.frame.origin.y, self.forgotButton.frame.size.width, self.forgotButton.frame.size.height);
                    [self attemptBiometricLogin];
                    if(finished){
                        self.launching = NO;
                    }
                }];
            }];
        }];
    }
    else{
        [self attemptBiometricLogin];
    }
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(BOOL)prefersStatusBarHidden{
    return self.shouldHideStatusBar;
}
-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    if(!self.launching){
        if(self.forgotButton.hidden){
            //Keep the forgot password button hidden, but prepare it for animation in from the right
            [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
                [self hideForgotButtonOnScreenSize:size animated:NO duration:0];
            } completion:nil];
        }
        else if(!self.forgotButton.hidden){
            //The forgot password button is showing, but we need to transition it to portrait mode
            [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
                [self showForgotButtonOnScreenSize:size animated:NO duration:0];
            } completion:nil];
        }
    }
    else{
        [self prepareCriticalUIForLaunch];
    }
}
#pragma mark - View Teardown Code
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.appLaunch = NO;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"signUp"]){
        FLSignUpViewController *destination = segue.destinationViewController;
        destination.shouldAnimateFromSide = YES;
    }
    [super prepareForSegue:segue sender:sender];
}
#pragma mark - IBActions
-(IBAction)logIn:(id)context{
    [self.view endEditing:YES];
    NSString *VEXID = [self.VEXIDField.text.capitalizedString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    FLLoadingView *loader = [FLLoadingView createInView:self.view];
    if(![VEXID isEqualToString:[NSString string]] && ![password isEqualToString:[NSString string]]){
        [PFCloud callFunctionInBackground:@"validateVEXID" withParameters:@{@"VEXID":VEXID} block:^(id result, NSError *error){
            if(error){
                [loader hide];
                [self presentViewController:[FLUIManager defaultParseErrorAlertControllerForError:error defaultHandler:YES] animated:YES completion:nil];
            }
            else{
                [PFUser logInWithUsernameInBackground:VEXID password:password block:^(PFUser *user, NSError *error){
                    [loader hide];
                    static int invocations = 0;
                    if(error){
                        if([context isKindOfClass:[NSString class]] && error.code == kPFErrorObjectNotFound){
                            [self presentViewController:[FLUIManager alertControllerWithTitle:nil message:context defaultHandler:YES] animated:YES completion:nil];
                        }
                        else{
                            invocations++;
                            UIAlertController *alert = [FLUIManager defaultParseErrorAlertControllerForError:error defaultHandler:NO];
                            [alert addAction:[UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                if(invocations >= 3 && self.forgotButton.hidden){
                                    [self showForgotButtonOnScreenSize:CGSizeZero animated:YES duration:0];
                                }
                            }]];
                            [self presentViewController:alert animated:YES completion:nil];
                        }
                    }
                    else{
                        invocations = 0;
                        [self securelyCacheAuthData];
                        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    }
                }];
            }
        }];
    }
    else if([VEXID isEqualToString:[NSString string]] && ![password isEqualToString:[NSString string]]){
        [loader hide];
        [self presentViewController:[FLUIManager alertControllerWithTitle:nil message:@"You must provide a VEX ID" defaultHandler:YES] animated:YES completion:nil];
    }
    else if(![VEXID isEqualToString:[NSString string]] && [password isEqualToString:[NSString string]]){
        [loader hide];
        [self presentViewController:[FLUIManager alertControllerWithTitle:nil message:@"You must enter a password" defaultHandler:YES] animated:YES completion:nil];
    }
    else{
        [loader hide];
        [self presentViewController:[FLUIManager alertControllerWithTitle:nil message:@"You must supply a VEX ID and a password" defaultHandler:YES] animated:YES completion:nil];
    }
}
-(IBAction)resetPassword{
    NSString *const capitalVEXID = [self.VEXIDField.text.capitalizedString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    __block FLLoadingView *const loader = [FLLoadingView createInView:self.view];
    if(![capitalVEXID isEqualToString:[NSString string]]){
        [PFCloud callFunctionInBackground:@"validateVEXID" withParameters:@{@"VEXID":capitalVEXID} block:^(id result, NSError *error){
            if(error){
                [loader hide];
                [self presentViewController:[FLUIManager defaultParseErrorAlertControllerForError:error defaultHandler:YES] animated:YES completion:nil];
            }
            else{
                PFQuery *const query = [PFUser query];
                [query whereKey:@"username" equalTo:capitalVEXID];
                [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error){
                    if(error){
                        [loader hide];
                        [self presentViewController:[FLUIManager defaultParseErrorAlertControllerForError:error defaultHandler:YES] animated:YES completion:nil];
                    }
                    else{
                        if(users.firstObject){
                            [PFUser requestPasswordResetForEmailInBackground:((PFUser *)users.firstObject).email block:^(BOOL succeeded, NSError *error){
                                [loader hide];
                                if(error){
                                    [self presentViewController:[FLUIManager defaultParseErrorAlertControllerForError:error defaultHandler:YES] animated:YES completion:nil];
                                }
                                else if(succeeded){
                                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:FLMostRecentPasswordKey];
                                    UIAlertController *alert = [FLUIManager alertControllerWithTitle:@"Password Reset" message:@"An email with instructions to reset your team's password has been sent to the email address associated with your team" defaultHandler:NO];
                                    [alert addAction:[UIAlertAction actionWithTitle:@"Check Your Email" style:UIAlertActionStyleDefault handler:nil]];
                                    [self presentViewController:alert animated:YES completion:nil];
                                }
                                else{
                                    UIAlertController *const alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"An unknown error occurred" preferredStyle:UIAlertControllerStyleAlert];
                                    [alert addAction:[UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:nil]];
                                    [self presentViewController:alert animated:YES completion:nil];
                                }
                            }];
                        }
                        else{
                            [loader hide];
                            UIAlertController *const alert = [UIAlertController alertControllerWithTitle:@"Error" message:[NSString stringWithFormat:@"There's no team registered with the VEX ID \"%@\"", capitalVEXID] preferredStyle:UIAlertControllerStyleAlert];
                            [alert addAction:[UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleCancel handler:nil]];
                            [alert addAction:[UIAlertAction actionWithTitle:@"Sign Up!" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                [self performSegueWithIdentifier:@"signUp" sender:self];
                                [self presentViewController:alert animated:YES completion:nil];
                            }]];
                        }
                    }
                }];
            }
        }];
    }
    else{
        [loader hide];
        [self presentViewController:[FLUIManager alertControllerWithTitle:nil message:@"Please enter your team's VEX ID" defaultHandler:YES] animated:YES completion:nil];
    }
}
#pragma mark - Security
-(void)securelyCacheAuthData{
    //FIXME: THE ABSOLUTELY FUCKING HELLISHLY FUCKING DANGEROUS SECURITY IN THIS MOTHERFUCKING APP
    [(FLAppDelegate *)[UIApplication sharedApplication].delegate saveAuthDataWithVEXID:[self.VEXIDField.text.uppercaseString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] password:[self.passwordField.text.reversedString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
}
-(NSString *)unencrypedPassword{
    //FIXME: THIS FUCKING "SECURITY" OH MY FUCKING GOD
    return [[NSUserDefaults standardUserDefaults] stringForKey:FLMostRecentPasswordKey].reversedString;
}
-(void)attemptBiometricLogin{
    LAContext *const context = [LAContext new];
    NSError *authError = nil;
    if([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError] && [[NSUserDefaults standardUserDefaults] stringForKey:FLMostRecentPasswordKey]){
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"Please scan your fingerprint to sign into VEX++" reply:^(BOOL success, NSError *error){
            if(success){
                self.passwordField.text = [self unencrypedPassword];
                [self logIn:@"It looks like you've changed your password since you tried to log in with Touch ID. Log in with your new password to fix this."];
            }
        }];
    }
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
-(void)showForgotButtonOnScreenSize:(CGSize)size animated:(BOOL)animated duration:(CGFloat)duration{
    if(CGSizeEqualToSize(size, CGSizeZero)){
        size = [UIScreen mainScreen].bounds.size;
    }
    if([FLUIManager sizeIsPortrait:size] && [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone){
        //Show Forgot Button by animating it in from the right
        self.forgotButton.alpha = 1;
        __block UITextField *const passwordField = self.animators[1];
        static const CGFloat forgotSpace = 8;
        const CGFloat sizes[3] = {passwordField.frame.size.width, self.forgotButton.frame.size.width, forgotSpace};
        CGFloat total = 0;
        for(int i = 0; i < sizeof(sizes)/sizeof(sizes[0]); i++){
            total += sizes[i];
        }
        const CGFloat targetPosition = (size.width - total) / 2;
        self.forgotButton.hidden = NO;
        if(animated){
            if(duration == 0){
                duration = .25;
            }
            [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
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
            if(duration == 0){
                duration = .25;
            }
            [UIView animateWithDuration:duration animations:^{
                self.forgotButton.alpha = 1;
            }];
        }
        else{
            self.forgotButton.alpha = 1;
        }
    }
}
-(void)hideForgotButtonOnScreenSize:(CGSize)size animated:(BOOL)animated duration:(CGFloat)duration{
    if(CGSizeEqualToSize(size, CGSizeZero)){
        size = [UIScreen mainScreen].bounds.size;
    }
    if(!self.launching){
        UITextField *const passwordField = self.animators[1];
        if([FLUIManager sizeIsPortrait:size] && [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone){
            if(animated){
                if(duration == 0){
                    duration = .25;
                }
                [UIView animateWithDuration:duration animations:^{
                    passwordField.center = CGPointMake(self.view.center.x, passwordField.center.y);
                    self.forgotButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, passwordField.frame.origin.y, self.forgotButton.frame.size.width, self.forgotButton.frame.size.height);
                } completion:^(BOOL finished) {
                    self.forgotButton.hidden = YES;
                }];
            }
            else{
                passwordField.center = CGPointMake(self.view.center.x, passwordField.center.y);
                self.forgotButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, passwordField.frame.origin.y, self.forgotButton.frame.size.width, self.forgotButton.frame.size.height);
                self.forgotButton.hidden = YES;
            }
        }
        else{
            if(animated){
                if(duration == 0){
                    duration = .25;
                }
                [UIView animateWithDuration:duration animations:^{
                    self.forgotButton.alpha = 0;
                } completion:^(BOOL finished) {
                    self.forgotButton.hidden = YES;
                }];
            }
            else{
                self.forgotButton.alpha = 0;
                self.forgotButton.hidden = YES;
            }
        }
    }
}
-(void)showForgotButtonFromSelector{
    [self showForgotButtonOnScreenSize:CGSizeZero animated:YES duration:.25];
}
-(void)hideForgotButtonFromSelector{
    [self hideForgotButtonOnScreenSize:CGSizeZero animated:YES duration:.25];
}
-(void)prepareCriticalUIForLaunch{
    self.criticalMovement = 0;
    for(UIView *object in self.animators){
        if([object isKindOfClass:[UIButton class]]){
            NSInteger original = object.center.y;
            object.center = CGPointMake(object.center.x, 0 - object.frame.size.height);
            self.criticalMovement = original - object.center.y;
        }
    }
    for(UIView *object in self.animators){
        if(![object isKindOfClass:[UIButton class]]){
            UITextField *field = (UITextField *)object;
            field.center = CGPointMake(field.center.x, field.center.y - self.criticalMovement);
        }
    }
}
#pragma mark - UITextFieldDelegate Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == self.animators.firstObject){
        [self.animators[1] becomeFirstResponder];
    }
    else{
        [textField resignFirstResponder];
        [self logIn:nil];
    }
    return NO;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField textFieldDidBeginEditing:textField];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [textField textFieldDidEndEditing:textField];
}
#pragma mark - Keyboard Delegation Methods
-(void)keyboardWillChangeFrame{
    [self keyboardDidChangeFrame];
}
-(void)keyboardDidChangeFrame{
    if([FLUIManager sizeIsPortrait:[UIScreen mainScreen].bounds.size] && !self.forgotButton.hidden){
        [self showForgotButtonOnScreenSize:[UIScreen mainScreen].bounds.size animated:NO duration:0];
    }
}
@end
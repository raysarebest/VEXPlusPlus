//
//  FLLoginViewController.h
//  VEX++
//
//  Created by Michael Hulet on 3/4/15.
//  Copyright (c) 2015 Michael Hulet. All rights reserved.
//

@import UIKit;
@interface FLLoginViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic, nonnull) IBOutlet UIView *signUpView;
@property (weak, nonatomic, nonnull) IBOutlet UIButton *forgotButton;
@property (weak, nonatomic, nonnull) IBOutlet UIButton *logInButton;
@property (weak, nonatomic, nonnull) IBOutlet UITextField *VEXIDField;
@property (weak, nonatomic, nonnull) IBOutlet UITextField *passwordField;
@property (weak, nonatomic, nonnull) IBOutlet NSLayoutConstraint *forgotSpace;
@property (strong, nonatomic, nonnull) IBOutletCollection(UIView) NSArray *animators;
@property (nonatomic) BOOL appLaunch;
-(IBAction)logIn:(nullable id)context;
-(IBAction)resetPassword;
@end
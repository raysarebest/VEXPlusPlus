//
//  FLSignUpViewController.h
//  VEX++
//
//  Created by Michael Hulet on 3/4/15.
//  Copyright (c) 2015 Michael Hulet. All rights reserved.
//

@import UIKit;
@interface FLSignUpViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic, nonnull) IBOutlet UIImageView *backgroundLogo;
@property (weak, nonatomic, nonnull) IBOutlet UITextField *VEXIDField;
@property (weak, nonatomic, nonnull) IBOutlet UITextField *passwordField;
@property (weak, nonatomic, nonnull) IBOutlet UITextField *confirmPasswordField;
@property (weak, nonatomic, nonnull) IBOutlet UITextField *emailField;
@property (strong, nonatomic, nonnull) IBOutletCollection(id) NSArray *animators;
@property (nonatomic) BOOL shouldAnimateFromSide;
@end
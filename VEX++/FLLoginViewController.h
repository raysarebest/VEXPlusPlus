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
@property (weak, nonatomic, nonnull) IBOutlet NSLayoutConstraint *forgotSpace;
@property (weak, nonatomic, nonnull) IBOutlet NSLayoutConstraint *verticalCenter;
@property (strong, nonatomic, nonnull) IBOutletCollection(UIView) NSArray *animators;
@property (nonatomic) BOOL appLaunch;
-(IBAction)logIn;
-(IBAction)resetPassword;
@end
//
//  DetailViewController.h
//  VEX++
//
//  Created by Michael Hulet on 2/24/15.
//  Copyright (c) 2015 Michael Hulet. All rights reserved.
//

@import UIKit;
@class FLTeam;
@class TPKeyboardAvoidingScrollView;
@class LPlaceholderTextView;
@interface FLDetailViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>
@property (strong, nonatomic, nonnull) FLTeam *team;
@property (strong, nonatomic, nonnull) IBOutletCollection(NSLayoutConstraint) NSArray *dynamicConstraints;
@property (strong, nonatomic, nonnull) IBOutletCollection(UILabel) NSArray *staticLabels;
@property (strong, nonatomic, nonnull) IBOutletCollection(UILabel) NSArray *numberLabels;
@property (strong, nonatomic, nonnull) IBOutletCollection(UIView) NSArray *editors;
@property (strong, nonatomic, nonnull) IBOutletCollection(UIView) NSArray *alignmentViews;
@property (strong, nonatomic, nonnull) IBOutletCollection(UIView) NSArray *potentialMovers;
@property (weak, nonatomic, nonnull) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property (weak, nonatomic, nonnull) IBOutlet UILabel *instructionLabel;
@property (weak, nonatomic, nonnull) IBOutlet UITextField *VEXIDField;
@property (weak, nonatomic, nonnull) IBOutlet UITextField *nameField;
@property (weak, nonatomic, nonnull) IBOutlet UITextField *orgField;
@property (weak, nonatomic, nonnull) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic, nonnull) IBOutlet UISlider *ratingSlider;
@property (weak, nonatomic, nonnull) IBOutlet UIButton *driveButton;
@property (weak, nonatomic, nonnull) IBOutlet UIButton *liftButton;
@property (weak, nonatomic, nonnull) IBOutlet UILabel *maxSkyriseLabel;
@property (weak, nonatomic, nonnull) IBOutlet UIStepper *maxSkyriseStepper;
@property (weak, nonatomic, nonnull) IBOutlet UILabel *maxCubesLabel;
@property (weak, nonatomic, nonnull) IBOutlet UIStepper *maxCubesStepper;
@property (weak, nonatomic, nonnull) IBOutlet UILabel *maxRedAutonLabel;
@property (weak, nonatomic, nonnull) IBOutlet UIStepper *maxRedAutonStepper;
@property (weak, nonatomic, nonnull) IBOutlet UILabel *consistentRedAutonLabel;
@property (weak, nonatomic, nonnull) IBOutlet UIStepper *consistentRedAutonStepper;
@property (weak, nonatomic, nonnull) IBOutlet UILabel *maxBlueAutonLabel;
@property (weak, nonatomic, nonnull) IBOutlet UIStepper *maxBlueAutonStepper;
@property (weak, nonatomic, nonnull) IBOutlet UILabel *consistentBlueAutonLabel;
@property (weak, nonatomic, nonnull) IBOutlet UIStepper *consistentBlueAutonStepper;
@property (weak, nonatomic, nonnull) IBOutlet LPlaceholderTextView *textView;
@property (weak, nonatomic, nonnull) IBOutlet UIView *textAnimationView;
@end
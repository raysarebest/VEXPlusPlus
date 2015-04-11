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
@interface FLDetailViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>
@property (strong, nonatomic, nonnull) FLTeam *team;
@property (strong, nonatomic, nonnull) IBOutletCollection(UILabel) NSArray *staticLabels;
@property (strong, nonatomic, nonnull) IBOutletCollection(UILabel) NSArray *numberLabels;
@property (strong, nonatomic, nonnull) IBOutletCollection(UIView) NSArray *editors;
@property (weak, nonatomic, nonnull) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property (weak, nonatomic, nonnull) IBOutlet UILabel *instructionLabel;
@end
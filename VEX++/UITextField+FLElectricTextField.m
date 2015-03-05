//
//  UITextField+FLElectricTextField.m
//  VEX++
//
//  Created by Michael Hulet on 3/4/15.
//  Copyright (c) 2015 Michael Hulet. All rights reserved.
//

#import "UITextField+FLElectricTextField.h"
#import "FLColorScheme.h"
@import QuartzCore;
IB_DESIGNABLE
@implementation UITextField (FLElectricTextField)
#pragma mark - Text View Setup
-(void)awakeFromNib{
    [super awakeFromNib];
    self.delegate = self;
    self.backgroundColor = [FLColorScheme backgroundColor];
    self.tintColor = [FLColorScheme accentColor];
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName:[FLColorScheme textColor]}];
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 5;
    self.layer.borderColor = [FLColorScheme accentColor].CGColor;
    self.layer.shadowColor = self.layer.borderColor;
    self.layer.shadowRadius = 5;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowOpacity = 0;
    self.layer.masksToBounds = NO;
}
#pragma mark - UITextViewDelegate Methods
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.layer addAnimation:[FLColorScheme glowAnimationToEnabledState:YES] forKey:@"shadowOpacity"];
    self.layer.shadowOpacity = 1;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self.layer addAnimation:[FLColorScheme glowAnimationToEnabledState:NO] forKey:@"shadowOpacity"];
    self.layer.shadowOpacity = 0;
}
@end
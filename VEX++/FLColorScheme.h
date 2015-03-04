//
//  FLColorScheme.h
//  VEX++
//
//  Created by Michael Hulet on 3/3/15.
//  Copyright (c) 2015 Michael Hulet. All rights reserved.
//

@import Foundation;
@import UIKit;
@interface FLColorScheme : NSObject
@property (strong, nonatomic) UIColor *accentColor;
@property (strong, nonatomic) UIColor *backgroundColor;
@property (strong, nonatomic) UIColor *textColor;
+(UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
+(instancetype)sharedColorScheme;
+(CABasicAnimation *)glowAnimationToEnabledState:(BOOL)enabling;
@end
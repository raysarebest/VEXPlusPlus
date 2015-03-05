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
+(nonnull UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
+(nonnull UIColor *)colorWithWhite:(CGFloat)white alpha:(CGFloat)alpha;
+(nonnull UIColor *)accentColor;
+(nonnull UIColor *)backgroundColor;
+(nonnull UIColor *)textColor;
+(nonnull CABasicAnimation *)glowAnimationToEnabledState:(BOOL)enabling;
@end
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
+(UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
+(UIColor *)colorWithWhite:(CGFloat)white alpha:(CGFloat)alpha;
+(UIColor *)accentColor;
+(UIColor *)backgroundColor;
+(UIColor *)textColor;
+(CABasicAnimation *)glowAnimationToEnabledState:(BOOL)enabling;
@end
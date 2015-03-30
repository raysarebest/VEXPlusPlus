//
//  FLUIManager.h
//  VEX++
//
//  Created by Michael Hulet on 3/3/15.
//  Copyright (c) 2015 Michael Hulet. All rights reserved.
//

@import Foundation;
@import UIKit;
@interface FLUIManager : NSObject
+(nonnull UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
+(nonnull UIColor *)colorWithWhite:(CGFloat)white alpha:(CGFloat)alpha;
+(nonnull UIColor *)accentColor;
+(nonnull UIColor *)backgroundColor;
+(nonnull UIColor *)textColor;
+(nonnull CABasicAnimation *)glowAnimationToEnabledState:(BOOL)enabling;
+(nonnull UIAlertController *)alertControllerWithTitle:(nullable NSString*)title message:(nullable NSString *)message defaultHandler:(BOOL)shouldCreateDefaultHandler;
+(nonnull UIAlertController *)defaultParseErrorAlertControllerForError:(nonnull NSError *)error defaultHandler:(BOOL)shouldCreateDefaultAction;
+(void)addParallaxEffectToView:(nonnull UIView *)view withSway:(nullable NSNumber *)sway;
+(BOOL)sizeIsPortrait:(CGSize)size;
+(BOOL)sizeIsLandscape:(CGSize)size;
@end
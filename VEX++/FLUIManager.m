//
//  FLUIManager.m
//  VEX++
//
//  Created by Michael Hulet on 3/3/15.
//  Copyright (c) 2015 Michael Hulet. All rights reserved.
//

#import "FLUIManager.h"
@import QuartzCore;
@implementation FLUIManager
#pragma mark - Color Creation Helpers
+(UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha{
    return [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:alpha];
}
+(UIColor *)colorWithWhite:(CGFloat)white alpha:(CGFloat)alpha{
    return [UIColor colorWithWhite:white/100 alpha:alpha];
}
#pragma mark - Animations
+(CABasicAnimation *)glowAnimationToEnabledState:(BOOL)enabling{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    animation.duration = .1;
    if(enabling){
        //NSNumber...?
        animation.fromValue = @0;
        animation.toValue = @1;
    }
    else{
        animation.fromValue = @1;
        animation.toValue = @0;
    }
    return animation;
}
+(void)addParallaxEffectToView:(nonnull UIView *)view withSway:(nullable NSNumber *)sway{
    if(!sway){
        sway = @(20);
    }
    UIInterpolatingMotionEffect *horizontal = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontal.minimumRelativeValue = @(-sway.intValue);
    horizontal.maximumRelativeValue = sway;
    UIInterpolatingMotionEffect *vertical = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    vertical.minimumRelativeValue = @(-sway.intValue);
    vertical.maximumRelativeValue = sway;
    [view addMotionEffect:horizontal];
    [view addMotionEffect:vertical];
}
#pragma mark - Default Color Scheme
+(UIColor *)accentColor{
    return [FLUIManager colorWithRed:255 green:247 blue:0 alpha:1];
}
+(UIColor *)backgroundColor{
    return [FLUIManager colorWithWhite:12 alpha:1];
}
+(UIColor *)textColor{
    return [FLUIManager colorWithWhite:48 alpha:1];
}
@end
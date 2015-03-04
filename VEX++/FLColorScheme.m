//
//  FLColorScheme.m
//  VEX++
//
//  Created by Michael Hulet on 3/3/15.
//  Copyright (c) 2015 Michael Hulet. All rights reserved.
//

#import "FLColorScheme.h"
@import QuartzCore;
@implementation FLColorScheme
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
#pragma mark - Default Color Scheme
+(UIColor *)accentColor{
    return [FLColorScheme colorWithRed:1 green:247 blue:0 alpha:1];
}
+(UIColor *)backgroundColor{
    return [FLColorScheme colorWithWhite:12 alpha:1];
}
+(UIColor *)textColor{
    return [FLColorScheme colorWithWhite:48 alpha:1];
}
@end
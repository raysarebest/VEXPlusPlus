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
#pragma mark - Object Initialization
+(instancetype)sharedColorScheme{
    static FLColorScheme *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
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
#pragma mark - Property Lazy Instantiation
-(UIColor *)accentColor{
    if(!_accentColor){
        _accentColor = [FLColorScheme colorWithRed:1 green:247 blue:0 alpha:1];
    }
    return _accentColor;
}
-(UIColor *)backgroundColor{
    if(!_backgroundColor){
        _backgroundColor = [UIColor colorWithWhite:.12 alpha:1];
    }
    return _backgroundColor;
}
-(UIColor *)textColor{
    if(!_textColor){
        _textColor = [UIColor colorWithWhite:.48 alpha:1];
    }
    return _textColor;
}
@end
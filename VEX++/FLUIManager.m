//
//  FLUIManager.m
//  VEX++
//
//  Created by Michael Hulet on 3/3/15.
//  Copyright (c) 2015 Michael Hulet. All rights reserved.
//

#import "FLUIManager.h"
@import QuartzCore;
@import Parse;
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
#pragma mark - UIAlertController Factories
+(UIAlertController *)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message defaultHandler:(BOOL)shouldCreateDefaultHandler{
    if(!title){
        title = @"Error";
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if(shouldCreateDefaultHandler){
        [alert addAction:[UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:nil]];
    }
    return alert;
}
+(UIAlertController *)defaultParseErrorAlertControllerForError:(NSError *)error defaultHandler:(BOOL)shouldCreateDefaultAction{
    NSString *reason;
    switch(error.code){
        case 208:
            reason = @"That Facebook account is already linked to another team";
            break;
        case 100:
            reason = @"Please check your internet connection";
            break;
        case 140:
            reason = @"A server error occurred. Please try again later";
            break;
        case 1:
            return [self defaultParseErrorAlertControllerForError:error defaultHandler:shouldCreateDefaultAction];
        case 114:
            reason = @"That isn't a valid email address";
            break;
        case 101:
            reason = @"Your VEX ID or password is incorrect";
            break;
        case 155:
            return [self defaultParseErrorAlertControllerForError:error defaultHandler:shouldCreateDefaultAction];
        case 203:
            reason = @"That email address is already linked to another team";
            break;
        case 202:
            reason = @"That VEX ID is already registered";
            break;
        default:
            reason = error.userInfo[@"error"];
            break;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:reason preferredStyle:UIAlertControllerStyleAlert];
    if(shouldCreateDefaultAction){
        [alert addAction:[UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:nil]];
    }
    return  alert;
}
#pragma mark - Orientation Detection
+(BOOL)sizeIsPortrait:(CGSize)size{
    if(size.height > size.width){
        return YES;
    }
    else{
        return NO;
    }
}
+(BOOL)sizeIsLandscape:(CGSize)size{
    return ![self sizeIsPortrait:size];
}
#pragma mark - Miscellaneous Helper Methods
+(UIView *)showLaunchScreenInView:(nonnull UIView *)view{
    UIView *launchScreen = [[NSBundle mainBundle] loadNibNamed:@"LaunchScreen" owner:self options:nil].firstObject;
    launchScreen.frame = [UIScreen mainScreen].bounds;
    [view addSubview:launchScreen];
    [view bringSubviewToFront:launchScreen];
    return launchScreen;
}
@end
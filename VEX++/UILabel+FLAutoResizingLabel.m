//
//  UILabel+FLAutoResizingLabel.m
//  VEX++
//
//  Created by Michael Hulet on 3/3/15.
//  Copyright (c) 2015 Michael Hulet. All rights reserved.
//

#import "UILabel+FLAutoResizingLabel.h"
@import ObjectiveC;
IB_DESIGNABLE
@implementation UILabel(FLAutoResizingLabel)
#pragma mark - Runtime Resizing
-(void)resizeLabelWithText:(NSString *)text{
    self.lineBreakMode = NSLineBreakByWordWrapping;
    self.numberOfLines = 0;
    //Thanks to the fact that I'm fucking magic, this won't cause a stack overflow
    [self resizeLabelWithText:text];
    [self sizeToFit];
}
#pragma mark - Root Level Magic
+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        SEL originalSelector = @selector(setText:);
        SEL resizingSelector = @selector(resizeLabelWithText:);
        Method originalMethod = class_getInstanceMethod([self class], originalSelector);
        Method resizingMethod = class_getInstanceMethod([self class], resizingSelector);
        if(class_addMethod([self class], originalSelector, method_getImplementation(resizingMethod), method_getTypeEncoding(resizingMethod))){
            class_replaceMethod([self class], resizingSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        }
        else{
            method_exchangeImplementations(originalMethod, resizingMethod);
        }
    });
}
@end
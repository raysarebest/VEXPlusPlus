//
//  FLLoginViewController.m
//  VEX++
//
//  Created by Michael Hulet on 3/4/15.
//  Copyright (c) 2015 Michael Hulet. All rights reserved.
//

#import "FLLoginViewController.h"
#import "FLColorScheme.h"
@implementation FLLoginViewController
#pragma mark - View Setup Code
-(void)viewDidLoad{
    [FLColorScheme addParallaxEffectToView:self.backgroundLogo withSway:nil];
}
@end
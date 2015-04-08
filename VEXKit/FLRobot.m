//
//  FLRobot.m
//  VEX++
//
//  Created by Michael Hulet on 3/4/15.
//  Copyright (c) 2015 Michael Hulet. All rights reserved.
//

#import "FLRobot.h"
#import "FLTeam.h"
@implementation FLRobot
#pragma mark - Property Synthesization
@dynamic lift;
@dynamic drive;
@dynamic cubeCapacity;
@dynamic maxSkyrise;
@dynamic autonValues;
@dynamic notes;
@dynamic images;
#pragma mark - Enumeration Stringification
+(nonnull NSString *)stringForDriveStyle:(FLDriveStyle)style{
    switch(style){
        case FLDriveStyleFourMotorTank:
            return @"4 Motor Tank";
            break;
        case FLDriveStyleSixMotorTank:
            return @"6 Motor Tank";
            break;
        case FLDriveStyleX:
            return @"X-Drive";
            break;
        case FLDriveStyleHolonomic:
            return @"Holonomic (H-Drive)";
            break;
        case FLDriveStyleKiwi:
            return @"Kiwi";
            break;
        case FLDriveStyleMecanum:
            return @"Mecanum";
            break;
        case FLDriveStyleUnknown:
            return @"Unknown";
            break;
        case FLDriveStyleNone:
            return @"None";
            break;
        case FLDriveStyleOther:
            return @"Other";
            break;
        default:
            return @"Unknown";
            break;
    }
}
+(nonnull NSString *)stringForLiftStyle:(FLLiftStyle)style{
    switch(style){
        case FLLiftStyleScissor:
            return @"Scissor";
            break;
        case FLLiftStyleElevator:
            return @"Elevator";
            break;
        case FLLiftStyleChainBar:
            return @"Chain Bar";
            break;
        case FLLiftStyleFourBar:
            return @"4 Bar";
            break;
        case FLLiftStyleDoubleFourBar:
            return @"Doube 4 Bar";
            break;
        case FLLiftStyleDoubleReverseFourBar:
            return @"Double Reverse 4 Bar";
            break;
        case FLLiftStyleSixBar:
            return @"6 Bar";
            break;
        case FLLiftStyleDoubleSixBar:
            return @"Double 6 Bar";
            break;
        case FLLiftStyleDoubleReverseSixBar:
            return @"Double Reverse 6 Bar";
            break;
        case FLLiftStyleEightBar:
            return @"8 Bar";
            break;
        case FLLiftStyleTenBar:
            return @"10 Bar";
            break;
        case FLLiftStyleTwelveBar:
            return @"12 Bar";
            break;
        case FLLiftStyleUnknown:
            return @"Unknown";
            break;
        case FLLiftStyleNone:
            return @"None";
            break;
        case FLLiftStyleOther:
            return @"Other";
            break;
        default:
            return @"Unknown";
            break;
    }
}
#pragma mark - Initialization
-(instancetype)initWithClassName:(NSString * __nonnull)newClassName{
    if(self = [super initWithClassName:newClassName]){
        //These dynamic properties are guaranteed nonnull, so they must be initialized here
        self.autonValues = [NSMutableArray array];
        self.images = [NSMutableArray array];
        self.notes = [NSString string];
        return self;
    }
    else{
        return nil;
    }
}
+(instancetype)new{
    return [[self alloc] initWithClassName:[FLRobot parseClassName]];
}
#pragma mark - PFSubclassing Methods
+(NSString *)parseClassName{
    return @"Robot";
}
+(void)load{
    [self registerSubclass];
}
@end
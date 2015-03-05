//
//  FLRobot.h
//  VEX++
//
//  Created by Michael Hulet on 3/4/15.
//  Copyright (c) 2015 Michael Hulet. All rights reserved.
//

@import Parse;
@import Foundation;
static NSString *const __nonnull FLAutonMostConsistentKey = @"consistent";
static NSString *const __nonnull FLAutonMaxKey = @"max";
static NSString *const __nonnull FLAutonRedColorKey = @"red";
static NSString *const __nonnull FLAutonBlueColorKey = @"blue";
typedef NS_ENUM(NSInteger, FLLiftStyle){
    FLLiftStyleScissor,
    FLLiftStyleElevator,
    FLLiftStyleChainBar,
    FLLiftStyleFourBar,
    FLLiftStyleDoubleFourBar,
    FLLiftStyleDoubleReverseFourBar,
    FLLiftStyleSixBar,
    FLLiftStyleDoubleSixBar,
    FLLiftStyleDoubleReverseSixBar,
    FLLiftStyleEightBar,
    FLLiftStyleTenBar,
    FLLiftStyleTwelveBar,
    FLLiftStyleNone,
    FLLiftStyleUnknown,
    FLLiftStyleOther
};
typedef NS_ENUM(NSInteger, FLDriveStyle){
    FLDriveStyleFourMotorTank,
    FLDriveStyleSixMotorTank,
    FLDriveStyleX,
    FLDriveStyleHolonomic,
    FLDriveStyleKiwi,
    FLDriveStyleMecanum,
    FLDriveStyleNone,
    FLDriveStyleUnknown,
    FLDriveStyleOther
};
@interface FLRobot : PFObject <PFSubclassing>
@property (nonatomic) FLLiftStyle lift;
@property (nonatomic) FLDriveStyle drive;
@property (nonatomic) int cubeCapacity;
@property (nonatomic) int maxSkyrise;
@property (strong, nonatomic, nonnull) NSMutableArray *autonValues;
@property (strong, nonatomic, nonnull) NSString *notes;
@property (strong, nonatomic, nonnull) NSMutableArray *images;
+(nonnull NSString *)stringForLiftStyle:(FLLiftStyle)style;
+(nonnull NSString *)stringForDriveStyle:(FLDriveStyle)style;
@end
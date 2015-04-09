//
//  FLTeam.h
//  VEX++
//
//  Created by Michael Hulet on 3/4/15.
//  Copyright (c) 2015 Michael Hulet. All rights reserved.
//

@import Parse;
@import Foundation;
@class FLRobot;
@interface FLTeam : PFObject <PFSubclassing>
@property (strong, nonatomic, nullable) FLRobot *robot;
@property (strong, nonatomic, nonnull) NSString *VEXID;
@property (strong, nonatomic, nonnull) NSString *nickname;
@property (strong, nonatomic, nullable) NSString *organization;
@property (nonatomic) NSInteger abilityScaleIndex;
@property (nonatomic, readonly) BOOL complete;
@end
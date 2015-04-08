//
//  FLTeam.m
//  VEX++
//
//  Created by Michael Hulet on 3/4/15.
//  Copyright (c) 2015 Michael Hulet. All rights reserved.
//

#import "FLTeam.h"
#import "FLRobot.h"
@implementation FLTeam
#pragma mark - Property Synthesization
@synthesize robot;
@dynamic VEXID;
@dynamic nickname;
@dynamic organization;
@dynamic abilityScaleIndex;
#pragma mark - PFSubclassing Methods
+(NSString *)parseClassName{
    return @"Team";
}
+(void)load{
    [self registerSubclass];
}
#pragma mark - Initialization
-(instancetype)initWithClassName:(NSString * __nonnull)newClassName{
    if(self = [super initWithClassName:newClassName]){
        //This guarantees that the nonnull self.VEXID & self.nickname will always have a value assigned
        self.VEXID = @"????";
        self.nickname = @"????";
        return self;
    }
    else{
        return nil;
    }
}
+(instancetype)new{
    return [[self alloc] initWithClassName:[FLTeam parseClassName]];
}
#pragma mark - Custom Getters
-(BOOL)complete{
    if(self.robot != nil && self.organization != nil && self.abilityScaleIndex != 0){
        return YES;
    }
    else{
        return NO;
    }
}
-(FLRobot *)robot{
    return self[@"robot"];
}
-(NSString *)description{
    return [NSString stringWithFormat:@"%@ (%@)", self.VEXID, self.nickname, nil];
}
#pragma mark - Custom Setters
-(void)setRobot:(FLRobot * __nullable)newRobot{
    if(newRobot){
        newRobot.team = self;
    }
    self[@"robot"] = newRobot;
}
@end
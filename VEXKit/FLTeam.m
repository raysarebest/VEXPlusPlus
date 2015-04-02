//
//  FLTeam.m
//  VEX++
//
//  Created by Michael Hulet on 3/4/15.
//  Copyright (c) 2015 Michael Hulet. All rights reserved.
//

#import "FLTeam.h"
@implementation FLTeam
#pragma mark - Property Synthesization
@dynamic robot;
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
        //This guarantees that the nonnull self.VEXID will always have a value assigned
        self.VEXID = @"????";
        return self;
    }
    else{
        return nil;
    }
}
-(instancetype)init{
    if(self = [self initWithClassName:@"Team"]){
        return self;
    }
    else{
        return nil;
    }
}
#pragma mark - Custom Getters
-(BOOL)complete{
    if(self.robot != nil && self.nickname != nil && self.organization != nil && self.abilityScaleIndex != 0){
        return YES;
    }
    else{
        return NO;
    }
}
@end
//
//  PFObject+FLEqualObject.m
//  VEX++
//
//  Created by Michael Hulet on 4/8/15.
//  Copyright (c) 2015 Michael Hulet. All rights reserved.
//

#import "PFObject+FLEqualObject.h"
@implementation PFObject (FLEqualObject)
#pragma mark - Custom Additions
-(BOOL)isEqual:(id)object{
    if([object isKindOfClass:[PFObject class]]){
        return [self.objectId isEqualToString:((PFObject *)object).objectId];
    }
    else{
        return NO;
    }
}
-(NSUInteger)hash{
    return self.objectId.hash;
}
@end
//
//  NSString+FLReversedString.m
//  VEX++
//
//  Created by Michael Hulet on 3/29/15.
//  Copyright (c) 2015 Michael Hulet. All rights reserved.
//

#import "NSString+FLReversedString.h"

@implementation NSString (FLReversedString)
#pragma mark - Calculated Properties
-(NSString *)reversedString{
    if(self.length < 2){
        return self;
    }
    else{
        NSStringEncoding encoding = NSHostByteOrder() == NS_BigEndian ? NSUTF32BigEndianStringEncoding : NSUTF32LittleEndianStringEncoding;
        NSUInteger byteCount = [self lengthOfBytesUsingEncoding:encoding];
        uint32_t *characters = (uint32_t *)malloc(byteCount);
        if(!characters){
            return nil;
        }
        else{
            [self getBytes:characters maxLength:byteCount usedLength:NULL encoding:encoding options:0 range:NSMakeRange(0, self.length) remainingRange:NULL];
            NSUInteger length = byteCount / sizeof(uint32_t);
            for(NSInteger i = 0; i < length / 2; i++){
                uint32_t charachter = characters[length - i - 1];
                characters[length - i - 1] = characters[i];
                characters[i] = charachter;
            }
            return [[NSString alloc] initWithBytesNoCopy:characters length:byteCount encoding:encoding freeWhenDone:YES];
        }
    }
}
@end
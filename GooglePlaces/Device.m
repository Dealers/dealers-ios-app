//
//  Device.m
//  Dealers
//
//  Created by Gilad Lumbroso on 1/20/15.
//
//

#import "Device.h"

@implementation Device

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _dealerID = nil;
        _token = nil;
        _iOS = YES;
        _arn = nil;
        _badge = [NSNumber numberWithInteger:0];
        _lastUpdateDate = [NSDate date];
        _creationDate = [NSDate date];
    }
    return self;
}

@end

//
//  DealAttrib.m
//  Dealers
//
//  Created by Gilad Lumbroso on 10/13/14.
//
//

#import "DealAttrib.h"

@implementation DealAttrib

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _likeCounter = [NSNumber numberWithInt:0];
        _shareCounter = [NSNumber numberWithInt:0];
        _objectiveRank = [NSNumber numberWithInt:0];
        _dealReliability = nil;
    }
    return self;
}

@end

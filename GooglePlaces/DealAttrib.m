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
        
        _dealAttribID = nil;
        _dealID = nil;
        
        _objectiveRank = [NSNumber numberWithInt:0];
        _dealReliability = [NSNumber numberWithInt:100];
        
        _dealersThatLiked = [[NSMutableArray alloc] init];
        _dealersThatShared = [[NSMutableArray alloc] init];
    }
    return self;
}

@end

//
//  screenCounter.m
//  Dealers
//
//  Created by Gilad Lumbroso on 8/20/15.
//
//

#import "ScreenCounter.h"

@implementation ScreenCounters

- (instancetype)init
{
    self = [self initWithDealer:nil];
    return self;
}

- (instancetype)initWithDealer:(NSNumber *)dealerID
{
    self = [super init];
    if (self) {
        _dealerID = dealerID;
        _myFeed = @(0);
        _explore = @(0);
        _profile = @(0);
        _activity = @(0);
        _whereIsTheDealLocal = @(0);
        _whereIsTheDealOnline = @(0);
        _whatIsTheDealLocal = @(0);
        _whatIsTheDealOnline = @(0);
        _haveMoreDetails = @(0);
        _viewDeal = @(0);
    }
    return self;
}

@end

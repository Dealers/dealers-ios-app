//
//  screenCounter.h
//  Dealers
//
//  Created by Gilad Lumbroso on 8/20/15.
//
//

#import <Foundation/Foundation.h>

@interface ScreenCounters : NSObject

@property NSNumber *screenCountersID;
@property NSNumber *dealerID;
@property NSNumber *myFeed;
@property NSNumber *explore;
@property NSNumber *profile;
@property NSNumber *activity;
@property NSNumber *whereIsTheDealLocal;
@property NSNumber *whereIsTheDealOnline;
@property NSNumber *whatIsTheDealLocal;
@property NSNumber *whatIsTheDealOnline;
@property NSNumber *haveMoreDetails;
@property NSNumber *viewDeal;

- (instancetype)initWithDealer:(NSNumber *)dealerID;

@end

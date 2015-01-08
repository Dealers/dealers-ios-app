//
//  Notification.m
//  Dealers
//
//  Created by Gilad Lumbroso on 10/11/14.
//
//

#import "Notification.h"

@implementation Notification

- (instancetype)init
{
    self = [self initWithType:nil recipients:nil dealer:nil deal:nil date:nil];
    return self;
}

- (instancetype)initWithType:(NSString *)type recipients:(NSArray *)recipients dealer:(Dealer *)dealer deal:(NSNumber *)dealID date:(NSDate *)date
{
    self = [super init];
    if (self) {
        _recipients = recipients;
        _type = type;
        _dealer = dealer;
        _dealID = dealID;
        _date = date;
        _wasRead = NO;
    }
    return self;
}

@end

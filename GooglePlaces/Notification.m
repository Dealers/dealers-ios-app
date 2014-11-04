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
    self = [self initWithRecipient:nil type:nil dealer:nil deal:nil date:nil];
    return self;
}

- (instancetype)initWithRecipient:(NSString *)recipient type:(NSString *)type dealer:(Dealer *)dealer deal:(Deal *)deal date:(NSDate *)date
{
    self = [super init];
    if (self) {
        _recipient = recipient;
        _type = type;
        _dealer = dealer;
        _deal = deal;
        _date = date;
        _wasRead = NO;
    }
    return self;
}

@end

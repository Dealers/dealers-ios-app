//
//  Notification.h
//  Dealers
//
//  Created by Gilad Lumbroso on 10/11/14.
//
//

#import <Foundation/Foundation.h>
#import "Deal.h"

@interface Notification : NSObject

@property NSString *recipient; // Recipient's email
@property NSString *type; // Like, Comment, Share or Edit Deal
@property Dealer *dealer;
@property Deal *deal;
@property BOOL wasRead;
@property NSDate *date;

- (instancetype)initWithRecipient:(NSString *)recipient type:(NSString *)type dealer:(Dealer *)dealer deal:(Deal *)deal date:(NSDate *)date;

@end


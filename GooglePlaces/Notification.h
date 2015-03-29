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

@property NSNumber *notificationID;
@property NSArray *recipients; // Recipient's id
@property NSString *type; // Like, Comment, Also Commented, Share or Edit
@property Dealer *dealer;
@property NSNumber *dealID;
@property NSString *subjectTitle;
@property NSDate *date;

@property BOOL wasRead;
@property BOOL noDuplicates;
@property BOOL grouped;

- (instancetype)initWithType:(NSString *)type recipients:(NSArray *)recipients dealer:(Dealer *)dealer deal:(NSNumber *)dealID date:(NSDate *)date;

@end


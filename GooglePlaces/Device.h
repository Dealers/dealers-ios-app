//
//  Device.h
//  Dealers
//
//  Created by Gilad Lumbroso on 1/20/15.
//
//

#import <Foundation/Foundation.h>

@interface Device : NSObject

@property NSNumber *deviceID;
@property NSNumber *dealerID;
@property NSString *token;
@property BOOL iOS;
@property NSString *arn;
@property NSNumber *badge;
@property NSDate *lastUpdateDate;
@property NSDate *creationDate;

@end

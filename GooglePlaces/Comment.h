//
//  Comment.h
//  Dealers-testbeta
//
//  Created by Gilad Lumbroso on 8/27/14.
//
//

#import <Foundation/Foundation.h>

@class Deal;
@class Dealer;

@interface Comment : NSObject

@property NSString *text;
@property Deal *deal;
@property Dealer *dealer;
@property NSDate *uploadDate;
@property NSString *type; // Deal or Post. Currently only Deal type exists.

@end

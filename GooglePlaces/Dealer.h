//
//  dealerClass.h
//  Dealers-testbeta
//
//  Created by itzik berrebi on 6/4/14.
//
//

#import <Foundation/Foundation.h>

@interface Dealer : NSObject

@property NSString *dealerID;
@property NSString *url;
@property NSString *email;
@property NSString *userPassword;

@property NSString *fullName;
@property NSDate *dateOfBirth;
@property NSString *gender;
@property NSString *about;
@property NSString *location;

@property NSMutableArray *userLikesList;
@property NSString *photoID;
@property UIImage *photo;
@property NSDate *registerDate;

@property NSMutableArray *notifications;

-(int) dealerEmpty: (NSString *) check;

@end

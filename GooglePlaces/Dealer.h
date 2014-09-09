//
//  dealerClass.h
//  Dealers-testbeta
//
//  Created by itzik berrebi on 6/4/14.
//
//

#import <Foundation/Foundation.h>

@interface Dealer : NSObject

@property NSString *userID;
@property NSString *fullName;
@property NSString *userPassword;
@property NSString *email;
@property NSDate *dateOfBirth;
@property NSString *gender;
@property NSString *about;
@property NSString *location;
@property NSString *userLikesList;
@property NSString *photoID;
@property UIImage *photo;
@property NSDate *registerDate;

-(int) dealerEmpty: (NSString *) check;

@end

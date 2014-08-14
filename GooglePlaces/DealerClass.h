//
//  dealerClass.h
//  Dealers-testbeta
//
//  Created by itzik berrebi on 6/4/14.
//
//

#import <Foundation/Foundation.h>

@interface DealerClass : NSObject

@property NSString *userID;
@property NSString *userName;
@property NSString *userPassword;
@property NSString *userEmail;
@property NSString *userDateofBirth;
@property NSString *userGender;
@property NSString *userAbout;
@property NSString *userLocation;
@property NSString *userLikesList;
@property NSString *userPhotoID;
@property UIImage *userPhoto;

-(int) dealerEmpty: (NSString *) check;

@end

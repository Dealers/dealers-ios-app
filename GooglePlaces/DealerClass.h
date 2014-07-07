//
//  dealerClass.h
//  Dealers-testbeta
//
//  Created by itzik berrebi on 6/4/14.
//
//

#import <Foundation/Foundation.h>

@interface DealerClass : NSObject
{
    NSString *userID;
    NSString *userName;
    NSString *userPassword;
    NSString *userEmail;
    NSString *userDateofBirth;
    NSString *userGender;
    NSString *userPhotoID;
    NSString *userAbout;
    NSString *userLocation;
}

-(void) setUserID:(NSString*)idd;
-(void) setUserName:(NSString*)name;
-(void) setUserPassword:(NSString*)password;
-(void) setUserEmail:(NSString*)email;
-(void) setUserDateofBirth:(NSString*)dateofBirth;
-(void) setUserGender:(NSString*)gender;
-(void) setUserPhotoID:(NSString*)photoID;
-(void) setUserAbout:(NSString*)about;
-(void) setUserLocation:(NSString*)location;

-(NSString*) getUserID;
-(NSString*) getUserName;
-(NSString*) getUserPassword;
-(NSString*) getUserEmail;
-(NSString*) getUserDateofBirth;
-(NSString*) getUserGender;
-(NSString*) getUserPhotoID;
-(NSString*) getUserAbout;
-(NSString*) getUserLocation;

-(int) dealerEmpty: (NSString *) check;

@end

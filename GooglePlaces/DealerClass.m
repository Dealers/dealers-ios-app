//
//  dealerClass.m
//  Dealers-testbeta
//
//  Created by itzik berrebi on 6/4/14.
//
//

#import "DealerClass.h"

@implementation DealerClass

-(void) setUserID:(NSString*)idd{
    userID=idd;
}
-(void) setUserName:(NSString*)name{
    userName=name;
}
-(void) setUserPassword:(NSString*)password{
    userPassword=password;
}
-(void) setUserEmail:(NSString*)email{
    userEmail=email;
}
-(void) setUserDateofBirth:(NSString*)dateofBirth{
    userDateofBirth=dateofBirth;
}
-(void) setUserGender:(NSString*)gender{
    userGender=gender;
}
-(void) setUserPhotoID:(NSString*)photoID{
    userPhotoID=photoID;
}
-(void) setUserAbout:(NSString*)about{
    userAbout=about;
}
-(void) setUserLocation:(NSString*)location{
    userLocation=location;
}

-(NSString*) getUserID{
    return userID;
}
-(NSString*) getUserName{
    return userName;
}
-(NSString*) getUserPassword{
    return userPassword;
}
-(NSString*) getUserEmail{
    return userEmail;
}
-(NSString*) getUserDateofBirth{
    return userDateofBirth;
}
-(NSString*) getUserGender{
    return userGender;
}
-(NSString*) getUserPhotoID{
    return userPhotoID;
}
-(NSString*) getUserAbout{
    return userAbout;
}
-(NSString*) getUserLocation{
    return userLocation;
}

-(int) dealerEmpty: (NSString *) check{
    if ([check isEqualToString:@"0"]) return 0;
    else return 1;
}
@end

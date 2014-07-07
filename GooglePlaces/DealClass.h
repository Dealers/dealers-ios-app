//
//  DealClass.h
//  Dealers-testbeta
//
//  Created by itzik berrebi on 6/2/14.
//
//

#import <Foundation/Foundation.h>

@interface DealClass : NSObject
{
    NSString *dealID;
    NSString *dealTitle;
    NSString *dealDescription;
    NSString *dealStore;
    NSString *dealPrice;
    NSString *dealDiscount;
    NSString *dealExpireDate;
    NSString *dealLikesCount;
    NSString *dealCommentCount;
    NSString *dealPhotoID1;
    NSString *dealPhotoID2;
    NSString *dealPhotoID3;
    NSString *dealPhotoID4;
    NSString *dealPhotoSum;
    NSString *dealCategory;
    NSString *dealUserID;
    NSString *dealCurrency;
    NSString *dealUploadDate;
    NSString *dealOnlineOrLocal;
    NSString *dealUrlSite;
    NSString *dealStoreAddress;
    NSString *dealStoreLatitude;
    NSString *dealStoreLongitude;
}

-(void) setDealID:(NSString*)dealid;
-(void) setDealTitle:(NSString*)title;
-(void) setDealDescription:(NSString*)description;
-(void) setDealStore:(NSString*)store;
-(void) setDealPrice:(NSString*)price;
-(void) setDealDiscount:(NSString*)discount;
-(void) setDealExpireDate:(NSString*)expiredate;
-(void) setDealLikesCount:(NSString*)likescount;
-(void) setDealCommentCount:(NSString*)commentcount;
-(void) setDealPhotoID1:(NSString*)photoid1;
-(void) setDealPhotoID2:(NSString*)photoid2;
-(void) setDealPhotoID3:(NSString*)photoid3;
-(void) setDealPhotoID4:(NSString*)photoid4;
-(void) setDealPhotoSum:(NSString*)photosum;
-(void) setDealCategory:(NSString*)category;
-(void) setDealUserID:(NSString*)userid;
-(void) setDealCurrency:(NSString*)currency;
-(void) setDealUploadDate:(NSString*)uploaddate;
-(void) setDealOnlineOrLocal:(NSString*)onlineOrlocal;
-(void) setDealUrlSite:(NSString*)urlsite;
-(void) setDealStoreAddress:(NSString*)storeaddress;
-(void) setDealStoreLatitude:(NSString*)storelatitude;
-(void) setDealStoreLongitude:(NSString*)storelongitude;
-(NSString*) getDealID;
-(NSString*) getDealTitle;
-(NSString*) getDealDescription;
-(NSString*) getDealStore;
-(NSString*) getDealPrice;
-(NSString*) getDealDiscount;
-(NSString*) getDealExpireDate;
-(NSString*) getDealLikesCount;
-(NSString*) getDealCommentCount;
-(NSString*) getDealPhotoID1;
-(NSString*) getDealPhotoID2;
-(NSString*) getDealPhotoID3;
-(NSString*) getDealPhotoID4;
-(NSString*) getDealPhotoSum;
-(NSString*) getDealCategory;
-(NSString*) getDealUserID;
-(NSString*) getDealCurrency;
-(NSString*) getDealUploadDate;
-(NSString*) getDealOnlineOrLocal;
-(NSString*) getDealUrlSite;
-(NSString*) getDealStoreAddress;
-(NSString*) getDealStoreLatitude;
-(NSString*) getDealStoreLongitude;
-(void) printClass;

@end

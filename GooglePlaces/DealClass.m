//
//  DealClass.m
//  Dealers-testbeta
//
//  Created by itzik berrebi on 6/2/14.
//
//

#import "DealClass.h"
#import "Functions.h"

@implementation DealClass
-(id)init {
    self = [super init];
    if (self) {
        dealID=@"";
        dealTitle=@"";
        dealDescription=@"";
        dealStore=@"";
        dealPrice=@"";
        dealDiscount=@"";
        dealExpireDate=@"";
        dealLikesCount=@"";
        dealCommentCount=@"";
        dealPhotoID1=@"";
        dealPhotoID2=@"";
        dealPhotoID3=@"";
        dealPhotoID4=@"";
        dealPhotoSum=@"";
        dealCategory=@"";
        dealUserID=@"";
        dealCurrency=@"";
        dealUploadDate=@"";
        dealOnlineOrLocal=@"";
        dealUrlSite=@"";
        dealStoreAddress=@"";
        dealStoreLatitude=@"";
        dealStoreLongitude=@"";
    }
    
    return self;
}

-(void) setDealID:(NSString*)dealid{
    dealID=dealid;
}
-(void) setDealTitle:(NSString*)title{
    Functions *func = [[Functions alloc]init];
    dealTitle= [func removeUniqueSigns:title];
}
-(void) setDealDescription:(NSString*)description{
    Functions *func = [[Functions alloc]init];
    dealDescription=[func removeUniqueSigns:description];
}
-(void) setDealStore:(NSString*)store{
    Functions *func = [[Functions alloc]init];
    dealStore=[func removeUniqueSigns:store];
}
-(void) setDealPrice:(NSString*)price{
    Functions *func = [[Functions alloc]init];
    if ([price intValue]>=10000) {
        dealPrice=[func priceAdaptation:price];
    } else dealPrice=price;
    if (![price isEqualToString:@"0"]) {
        dealPrice = [dealPrice stringByAppendingString:dealCurrency];
    }
}
-(void) setDealDiscount:(NSString*)discount{
    dealDiscount=discount;
}
-(void) setDealExpireDate:(NSString*)expiredate{
    dealExpireDate=expiredate;
}
-(void) setDealLikesCount:(NSString*)likescount{
    dealLikesCount=likescount;
}
-(void) setDealCommentCount:(NSString*)commentcount{
    dealCommentCount=commentcount;
}
-(void) setDealPhotoID1:(NSString*)photoid1{
    dealPhotoID1=photoid1;
}
-(void) setDealPhotoID2:(NSString*)photoid2{
    dealPhotoID2=photoid2;
}
-(void) setDealPhotoID3:(NSString*)photoid3{
    dealPhotoID3=photoid3;
}
-(void) setDealPhotoID4:(NSString*)photoid4{
    dealPhotoID4=photoid4;
}
-(void) setDealPhotoSum:(NSString*)photosum{
    dealPhotoSum=photosum;
}
-(void) setDealCategory:(NSString*)category{
    Functions *func = [[Functions alloc]init];
    dealCategory=[func removeUniqueSigns:category];
}
-(void) setDealUserID:(NSString*)userid{
    dealUserID=userid;
}
-(void) setDealCurrency:(NSString*)currency{
    Functions *func = [[Functions alloc]init];
    dealCurrency=[func currencySymbol:currency];
}
-(void) setDealUploadDate:(NSString*)uploaddate{
    dealUploadDate=uploaddate;
}
-(void) setDealOnlineOrLocal:(NSString*)onlineOrlocal{
    dealOnlineOrLocal=onlineOrlocal;
}
-(void) setDealUrlSite:(NSString*)urlsite{
    dealUrlSite=urlsite;
}
-(void) setDealStoreAddress:(NSString*)storeaddress{
    Functions *func = [[Functions alloc]init];
    dealStoreAddress=[func removeUniqueSigns:storeaddress];
}
-(void) setDealStoreLatitude:(NSString*)storelatitude{
    dealStoreLatitude=storelatitude;
}
-(void) setDealStoreLongitude:(NSString*)storelongitude{
    dealStoreLongitude=storelongitude;
}
-(NSString*) getDealID{
    return dealID;
}
-(NSString*) getDealTitle{
    return dealTitle;
}
-(NSString*) getDealDescription{
    return dealDescription;
}
-(NSString*) getDealStore{
    return dealStore;
}
-(NSString*) getDealPrice{
    return dealPrice;
}
-(NSString*) getDealDiscount{
    return dealDiscount;
}
-(NSString*) getDealExpireDate{
    return dealExpireDate;
}
-(NSString*) getDealLikesCount{
    return dealLikesCount;
}
-(NSString*) getDealCommentCount{
    return dealCommentCount;
}
-(NSString*) getDealPhotoID1{
    return dealPhotoID1;
}
-(NSString*) getDealPhotoID2{
    return dealPhotoID2;
}
-(NSString*) getDealPhotoID3{
    return dealPhotoID3;
}
-(NSString*) getDealPhotoID4{
    return dealPhotoID4;
}
-(NSString*) getDealPhotoSum{
    return dealPhotoSum;
}
-(NSString*) getDealCategory{
    return dealCategory;
}
-(NSString*) getDealUserID{
    return dealUserID;
}
-(NSString*) getDealCurrency{
    return dealCurrency;
}
-(NSString*) getDealUploadDate{
    return dealUploadDate;
}
-(NSString*) getDealOnlineOrLocal{
    return dealOnlineOrLocal;
}
-(NSString*) getDealUrlSite{
    return dealUrlSite;
}
-(NSString*) getDealStoreAddress{
    return dealStoreAddress;
}
-(NSString*) getDealStoreLatitude{
    return dealStoreLatitude;
}
-(NSString*) getDealStoreLongitude{
    return dealStoreLongitude;
}

-(void)printClass{
    NSLog(@"my class is=%@,%@,%@,%@",dealTitle,dealStore,dealID,dealUserID);
}

@end

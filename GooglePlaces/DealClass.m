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
/*
-(id)init {
    self = [super init];
    if (self) {
        _dealID=@"";
        _dealTitle=@"";
        _dealDescription=@"";
        _dealStore=@"";
        _dealPrice=@"";
        _dealDiscount=@"";
        _dealExpireDate=@"";
        _dealLikesCount=@"";
        _dealCommentCount=@"";
        _dealPhotoID1=@"";
        _dealPhotoID2=@"";
        _dealPhotoID3=@"";
        _dealPhotoID4=@"";
        _dealPhotoSum=@"";
        _dealCategory=@"";
        _dealUserID=@"";
        _dealCurrency=@"";
        _dealUploadDate=@"";
        _dealOnlineOrLocal=@"";
        _dealUrlSite=@"";
        _dealStoreAddress=@"";
        _dealStoreLatitude=@"";
        _dealStoreLongitude=@"";
    }
    
    return self;
}
 */

- (void)setDealTitle:(NSString*)title {
    Functions *func = [[Functions alloc]init];
    _dealTitle = [func removeUniqueSigns:title];
}

-(void) setDealDescription:(NSString*)description {
    Functions *func = [[Functions alloc]init];
    _dealDescription = [func removeUniqueSigns:description];
}

-(void) setDealStore:(NSString*)store{
    Functions *func = [[Functions alloc]init];
    _dealStore=[func removeUniqueSigns:store];
}

-(void) setDealPrice:(NSString*)price{
    _dealPrice = price;
    
    /*
    Functions *func = [[Functions alloc]init];
    if ([price intValue] >= 10000) {
        _dealPrice = [func priceAdaptation:price];
    } else _dealPrice = price;
    */
}

-(void) setDealCategory:(NSString*)category{
    Functions *func = [[Functions alloc]init];
    _dealCategory=[func removeUniqueSigns:category];
}

-(void) setDealCurrency:(NSString*)currency{
    Functions *func = [[Functions alloc]init];
    _dealCurrency = [func currencySymbol:currency];
}

-(void) setDealStoreAddress:(NSString*)storeAddress{
    Functions *func = [[Functions alloc]init];
    _dealStoreAddress = [func removeUniqueSigns:storeAddress];
}

-(void)printClass{
    NSLog(@"my class is=%@,%@,%@,%@",self.dealTitle,self.dealStore,self.dealID,self.dealUserID);
}

- (id)copyWithZone:(NSZone *)zone
{
    DealClass *dealCopy = [[DealClass allocWithZone:zone]init];
    
    dealCopy = [dealCopy mutableCopyWithZone:zone];
    
    return dealCopy;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    DealClass *dealCopy = [[DealClass allocWithZone:zone]init];
    
    dealCopy.dealID = [self.dealID mutableCopy];
    dealCopy.dealDescription = [self.dealDescription mutableCopy];
    dealCopy.dealTitle = [self.dealTitle mutableCopy];
    dealCopy.dealStore = [self.dealStore mutableCopy];
    dealCopy.dealPrice = [self.dealPrice mutableCopy];
    dealCopy.dealDiscount = [self.dealDiscount mutableCopy];
    dealCopy.dealExpireDate = [self.dealExpireDate mutableCopy];
    dealCopy.dealLikesCount = [self.dealLikesCount mutableCopy];
    dealCopy.dealCommentCount = [self.dealCommentCount mutableCopy];
    dealCopy.dealPhotoID1 = [self.dealPhotoID1 mutableCopy];
    dealCopy.dealPhotoID2 = [self.dealPhotoID2 mutableCopy];
    dealCopy.dealPhotoID3 = [self.dealPhotoID3 mutableCopy];
    dealCopy.dealPhotoID4 = [self.dealPhotoID4 mutableCopy];
    dealCopy.dealPhotoSum = [self.dealPhotoSum mutableCopy];
    dealCopy.dealCategory = [self.dealCategory mutableCopy];
    dealCopy.dealUserID = [self.dealUserID mutableCopy];
    dealCopy.dealCurrency = [self.dealCurrency mutableCopy];
    dealCopy.dealDiscountType = [self.dealDiscountType mutableCopy];
    dealCopy.dealUploadDate = [self.dealUploadDate mutableCopy];
    dealCopy.dealOnlineOrLocal = [self.dealOnlineOrLocal mutableCopy];
    dealCopy.dealUrlSite = [self.dealUrlSite mutableCopy];
    dealCopy.dealStoreAddress = [self.dealStoreAddress mutableCopy];
    dealCopy.dealStoreLatitude = [self.dealStoreLatitude mutableCopy];
    dealCopy.dealStoreLongitude = [self.dealStoreLongitude mutableCopy];
    
    
    return dealCopy;
}

@end

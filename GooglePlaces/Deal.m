//
//  DealClass.m
//  Dealers-testbeta
//
//  Created by itzik berrebi on 6/2/14.
//
//

#import "Deal.h"
#import "Functions.h"

#define offSetShortCell 109
#define imageViewTag -10
#define imageViewBackgroundTag 10
#define titleBackgroundTag 1000
#define loadingIndicatorTag 100000
#define spinningWheelTag 4444

@implementation Deal
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

- (void)setTitle:(NSString*)title {
    Functions *func = [[Functions alloc]init];
    _title = [func removeUniqueSigns:title];
}

-(void) setMoreDescription:(NSString*)description {
    Functions *func = [[Functions alloc]init];
    _moreDescription = [func removeUniqueSigns:description];
}

-(void) setStore:(NSString*)store{
    Functions *func = [[Functions alloc]init];
    _store=[func removeUniqueSigns:store];
}

-(void) setCategory:(NSString*)category{
    Functions *func = [[Functions alloc]init];
    _category=[func removeUniqueSigns:category];
}

-(void) setCurrency:(NSString*)currency{
    Functions *func = [[Functions alloc]init];
    _currency = [func currencySymbol:currency];
}

-(void) setDealStoreAddress:(NSString*)storeAddress{
    Functions *func = [[Functions alloc]init];
    _dealStoreAddress = [func removeUniqueSigns:storeAddress];
}

-(void)printClass{
    NSLog(@"my class is=%@,%@,%@,%@",self.title,self.store,self.dealID,self.dealUserID);
}

- (id)copyWithZone:(NSZone *)zone
{
    Deal *dealCopy = [[Deal allocWithZone:zone]init];
    
    dealCopy = [dealCopy mutableCopyWithZone:zone];
    
    return dealCopy;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    Deal *dealCopy = [[Deal allocWithZone:zone]init];
    
    dealCopy.dealID = [self.dealID mutableCopy];
    dealCopy.moreDescription = [self.moreDescription mutableCopy];
    dealCopy.title = [self.title mutableCopy];
    dealCopy.store = [self.store mutableCopy];
    dealCopy.price = [self.price mutableCopy];
    dealCopy.discountValue = [self.discountValue mutableCopy];
    dealCopy.expiration = [self.expiration mutableCopy];
    dealCopy.likeCounter = [self.likeCounter mutableCopy];
    dealCopy.commentCounter = [self.commentCounter mutableCopy];
    dealCopy.photoID1 = [self.photoID1 mutableCopy];
    dealCopy.photoID2 = [self.photoID2 mutableCopy];
    dealCopy.photoID3 = [self.photoID3 mutableCopy];
    dealCopy.photoID4 = [self.photoID4 mutableCopy];
    dealCopy.photoSum = [self.photoSum mutableCopy];
    dealCopy.category = [self.category mutableCopy];
    dealCopy.dealUserID = [self.dealUserID mutableCopy];
    dealCopy.currency = [self.currency mutableCopy];
    dealCopy.discountType = [self.discountType mutableCopy];
    dealCopy.uploadDate = [self.uploadDate mutableCopy];
    dealCopy.type = [self.type mutableCopy];
    dealCopy.dealUrlSite = [self.dealUrlSite mutableCopy];
    dealCopy.dealStoreAddress = [self.dealStoreAddress mutableCopy];
    dealCopy.dealStoreLatitude = [self.dealStoreLatitude mutableCopy];
    dealCopy.dealStoreLongitude = [self.dealStoreLongitude mutableCopy];
    
    
    return dealCopy;
}


@end

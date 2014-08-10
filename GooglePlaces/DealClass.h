//
//  DealClass.h
//  Dealers-testbeta
//
//  Created by itzik berrebi on 6/2/14.
//
//

#import <Foundation/Foundation.h>

@interface DealClass : NSObject <NSCopying>

@property (nonatomic) NSString *dealID;
@property (nonatomic) NSString *dealTitle;
@property (nonatomic) NSString *dealDescription;
@property (nonatomic) NSString *dealStore;
@property (nonatomic) NSString *dealPrice;
@property (nonatomic) NSString *dealDiscount;
@property (nonatomic) NSString *dealExpireDate;
@property (nonatomic) NSString *dealLikesCount;
@property (nonatomic) NSString *dealCommentCount;
@property (nonatomic) NSString *dealPhotoID1;
@property (nonatomic) NSString *dealPhotoID2;
@property (nonatomic) NSString *dealPhotoID3;
@property (nonatomic) NSString *dealPhotoID4;
@property (nonatomic) NSString *dealPhotoSum;
@property (nonatomic) NSString *dealCategory;
@property (nonatomic) NSString *dealUserID;
@property (nonatomic) NSString *dealCurrency;
@property (nonatomic) NSString *dealDiscountType;
@property (nonatomic) NSString *dealUploadDate;
@property (nonatomic) NSString *dealOnlineOrLocal;
@property (nonatomic) NSString *dealUrlSite;
@property (nonatomic) NSString *dealStoreAddress;
@property (nonatomic) NSString *dealStoreLatitude;
@property (nonatomic) NSString *dealStoreLongitude;

@property (nonatomic) UIImage *dealPhoto1;
@property (nonatomic) UIImage *dealPhoto2;
@property (nonatomic) UIImage *dealPhoto3;
@property (nonatomic) UIImage *dealPhoto4;


// Only our setters which override the default ones are mentioned here:

- (void)setDealTitle:(NSString *)title;
- (void)setDealDescription:(NSString *)description;
- (void)setDealStore:(NSString *)store;
- (void)setDealPrice:(NSString *)price;
- (void)setDealCategory:(NSString *)category;
- (void)setDealCurrency:(NSString *)currency;
- (void)setDealStoreAddress:(NSString *)storeaddress;

- (void)printClass;

- (id)copyWithZone:(NSZone *)zone;
- (id)mutableCopyWithZone:(NSZone *)zone;

@end

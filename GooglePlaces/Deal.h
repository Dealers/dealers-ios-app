//
//  DealClass.h
//  Dealers-testbeta
//
//  Created by itzik berrebi on 6/2/14.
//
//

#import <Foundation/Foundation.h>

@class Dealer;
@class Store;

@interface Deal : NSObject <NSCopying> 

@property (nonatomic) NSString *dealID;
@property (nonatomic) NSString *url;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *store;
@property (nonatomic) NSNumber *price;
@property (nonatomic) NSString *currency;
@property (nonatomic) NSNumber *discountValue;
@property (nonatomic) NSString *discountType;
@property (nonatomic) NSString *category;
@property (nonatomic) NSDate *expiration;
@property (nonatomic) NSString *moreDescription;

@property (nonatomic) NSNumber *likeCounter;
@property (nonatomic) NSNumber *commentCounter;

@property (nonatomic) NSString *type;
@property (nonatomic) NSString *dealUrlSite;
@property (nonatomic) NSString *dealStoreAddress;
@property (nonatomic) NSString *dealStoreLatitude;
@property (nonatomic) NSString *dealStoreLongitude;

@property (nonatomic) NSString *photoID1;
@property (nonatomic) NSString *photoID2;
@property (nonatomic) NSString *photoID3;
@property (nonatomic) NSString *photoID4;
@property (nonatomic) UIImage *photo1;
@property (nonatomic) UIImage *photo2;
@property (nonatomic) UIImage *photo3;
@property (nonatomic) UIImage *photo4;
@property (nonatomic) NSString *photoSum;

@property (nonatomic) NSString *dealUserID;

@property (nonatomic) NSDate *uploadDate;
@property (nonatomic) Dealer *dealer;
@property (nonatomic) NSMutableArray *comments;

// Only our setters which override the default ones are mentioned here:

- (void)setTitle:(NSString *)title;
- (void)setMoreDescription:(NSString *)description;
- (void)setStore:(NSString *)store;
- (void)setCategory:(NSString *)category;
- (void)setCurrency:(NSString *)currency;
- (void)setDealStoreAddress:(NSString *)storeaddress;

- (void)printClass;

- (id)copyWithZone:(NSZone *)zone;
- (id)mutableCopyWithZone:(NSZone *)zone;


@end

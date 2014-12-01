//
//  DealClass.h
//  Dealers-testbeta
//
//  Created by itzik berrebi on 6/2/14.
//
//

#import <Foundation/Foundation.h>

@class Store;
@class Dealer;
@class DealAttrib;

@interface Deal : NSObject 

@property (nonatomic) NSNumber *dealID;
@property (nonatomic) NSString *title;
@property (nonatomic) Store *store;
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

@property (nonatomic) NSString *photoURL1;
@property (nonatomic) NSString *photoURL2;
@property (nonatomic) NSString *photoURL3;
@property (nonatomic) NSString *photoURL4;
@property (nonatomic) UIImage *photo1;
@property (nonatomic) UIImage *photo2;
@property (nonatomic) UIImage *photo3;
@property (nonatomic) UIImage *photo4;
@property (nonatomic) NSNumber *photoSum;

@property (nonatomic) NSDate *uploadDate;
@property DealAttrib *dealAttrib;
@property Dealer *dealer;

@property (nonatomic) NSMutableArray *comments;

@property (nonatomic) NSString *dealUserID;

@end

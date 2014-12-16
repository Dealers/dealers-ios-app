//
//  AppDelegate.h
//  GooglePlaces
//
//  Created by van Lint Jason on 28/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "Deal.h"
#import "Store.h"
#import "Dealer.h"
#import "DealAttrib.h"
#import "Comment.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    int picsNumbers;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) UIStoryboard *storyboard;
@property (nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic)  NSString *Animate_first;
@property (strong, nonatomic)  NSString *UserID;
@property (strong, nonatomic)  NSString *AfterAddDeal;
@property (strong, nonatomic)  NSString *onlineOrLocal;
@property (strong, nonatomic)  NSString *previousViewControllerAddDeal;
@property (strong, nonatomic)  NSString *previousViewController;
@property (strong, nonatomic)  NSString *dealerName;
@property (strong, nonatomic)  UIImage *dealerProfileImage;
@property (strong, nonatomic)  Dealer *dealer;
@property BOOL shouldUpdateMyFeed;
@property BOOL shouldUpdateProfile;

@property (weak) UIImage *screenShot;


- (void)setTabBarController;
- (void)showPlusButton;
- (void)hidePlusButton;

- (void)saveUserDetailsOnDevice;
- (void)removeUserDetailsFromDevice;
- (NSData *)loadProfilePic;
- (void)updateUserInfo;
- (UIImage *)myProfilePic;
- (void)otherProfilePic:(NSString *)photoURL forTarget:(NSString *)target notificationName:(NSString *)notificationName inCell:(id)cell;
- (void)downloadPhotosForDeal:(Deal *)deal notificationName:(NSString *)notificationName atIndexPath:(NSIndexPath *)indexPath mode:(NSString *)mode;
- (UIColor *)ourPurple;
- (UIColor *)textGrayColor;
- (UIColor *)darkTextGrayColor;
- (UIColor *)blackColor;
- (UIButton *)actionButton;
- (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)newSize;
- (NSNumber *)setPhotoSum:(Deal *)deal;
- (NSString *)connectOldCategoryToNewCategory:(NSString *)string;

- (UIImageView *)loadingAnimationWhite;
- (UIImageView *)loadingAnimationPurple;

- (NSDictionary *)getCurrenciesDictionary;
- (NSString *)getCurrencySign:(NSString *)currencyKey;
- (NSString *)getCurrencyKey:(NSString *)currencySign;

- (NSDictionary *)getDiscountTypesDictionary;
- (NSString *)getDiscountType:(NSString *)discountKey;
- (NSString *)getDiscountKey:(NSString *)discountType;

- (NSArray *)getCategories;
- (NSArray *)getCategoriesIcons;
- (NSDictionary *)getCategoriesDictionary;
- (NSString *)getCategoryKeyForValue:(NSString *)value;
- (NSString *)getCategoryValueForKey:(NSString *)key;

- (RKObjectMapping *)dealMapping;
- (RKObjectMapping *)addDealMapping;
- (RKObjectMapping *)dealerMapping;
- (RKObjectMapping *)storeMapping;
- (RKObjectMapping *)dealAttribMapping;
- (RKObjectMapping *)commentMapping;
- (void)setHTTPClientUsername:(NSString *)username andPassword:(NSString *)password;
- (void)resetHTTPClientUsernameAndPassword;

- (void)openActiveSessionWithPermissions:(NSArray *)permissions allowLoginUI:(BOOL)allowLoginUI;
- (BOOL)isFacebookConnected;

@end

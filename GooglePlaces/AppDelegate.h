//
//  AppDelegate.h
//  GooglePlaces
//
//  Created by van Lint Jason on 28/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dealer.h"

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
@property (strong, nonatomic)  Dealer *dealerClass;

@property (nonatomic) NSString *token;

@property (weak) UIImage *screenShot;

- (void)setTabBarController;
- (NSArray *)getCategories;
- (NSArray *)getCategoriesIcons;
- (void)openActiveSessionWithPermissions:(NSArray *)permissions allowLoginUI:(BOOL)allowLoginUI;

@end

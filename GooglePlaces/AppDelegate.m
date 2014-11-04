//
//  AppDelegate.m
//  GooglePlaces
//
//  Created by van Lint Jason on 28/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
//itzik
//itzikb

#import "AppDelegate.h"
#import "WhereIsTheDeal.h"
#import "KeychainItemWrapper.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize storyboard;
@synthesize tabBarController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    int cacheSizeMemory = 4*1024*1024; // 4MB
    int cacheSizeDisk = 32*1024*1024; // 32MB
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
    [NSURLCache setSharedURLCache:sharedCache];
    
    // Customizing the Navigation Bar:
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:150.0/255.0 green:0/255.0 blue:180.0/255.0 alpha:1.0]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"Navigation Bar Background"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage imageNamed:@"Navigation Bar Shade"]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor colorWithRed:150.0/255.0 green:0.0/255.0 blue:180.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                          [UIFont fontWithName:@"Avenir-Roman" size:20.0], NSFontAttributeName, nil]];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
        
    // Customizing the Tab Bar:
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:150.0/255.0 green:0/255.0 blue:180.0/255.0 alpha:1.0]];
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:150.0/255.0 green:0/255.0 blue:180.0/255.0 alpha:1.0]];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIFont fontWithName:@"Avenir-Roman" size:11.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    // Customizing other elements:
    [[UIPickerView appearance] setBackgroundColor: [UIColor groupTableViewBackgroundColor]];
    [[UIDatePicker appearance] setBackgroundColor: [UIColor groupTableViewBackgroundColor]];
    
    // For showing the network activity indicator whenever communicating with the web:
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    // For printing in the log info about the outputs and inputs via RestKit:
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    
    return YES;
}

- (void)setTabBarController
{
    storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    tabBarController = [[UITabBarController alloc]init];
    
    UINavigationController *navigationControllerFeed = [storyboard instantiateViewControllerWithIdentifier:@"feedNavController"];
    UINavigationController *navigationControllerExplore = [storyboard instantiateViewControllerWithIdentifier:@"exploreNavController"];
    UINavigationController *navigationControllerProfile = [storyboard instantiateViewControllerWithIdentifier:@"profileNavController"];
    UINavigationController *navigationControllerMore = [storyboard instantiateViewControllerWithIdentifier:@"activityNavController"];
    UIViewController *dummyViewController = [[UIViewController alloc]init]; // Just to create room for the Add Deal button in the middle of the tab bar.
    
    NSArray* controllers = [NSArray arrayWithObjects:navigationControllerFeed, navigationControllerExplore, dummyViewController, navigationControllerProfile, navigationControllerMore, nil];
    tabBarController.viewControllers = controllers;
    
    self.window.rootViewController = tabBarController;
    
    UITabBar *tabBar = tabBarController.tabBar;
    UITabBarItem *myFeed = [tabBar.items objectAtIndex:0];
    UITabBarItem *explore = [tabBar.items objectAtIndex:1];
    UITabBarItem *profile = [tabBar.items objectAtIndex:3];
    UITabBarItem *activity = [tabBar.items objectAtIndex:4];
    
    myFeed.title = @"My Feed";
    myFeed.image = [UIImage imageNamed:@"My Feed Tab"];
    myFeed.selectedImage = [UIImage imageNamed:@"My Feed Tab Selected"];
    explore.title = @"Explore";
    explore.image = [UIImage imageNamed:@"Explore Tab"];
    explore.selectedImage = [UIImage imageNamed:@"Explore Tab Selected"];
    explore.titlePositionAdjustment = UIOffsetMake(-6, 0);
    profile.title = @"Profile";
    profile.image = [UIImage imageNamed:@"Profile Tab"];
    profile.selectedImage = [UIImage imageNamed:@"Profile Tab Selected"];
    profile.titlePositionAdjustment = UIOffsetMake(6, 0);
    activity.title = @"Activity";
    activity.image = [UIImage imageNamed:@"More Tab"];
    activity.selectedImage = [UIImage imageNamed:@"More Tab Selected"];
    
    // Adding the Add Deal button to the UITabBarController:
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(tabBarController.tabBar.center.x-30.5,tabBarController.tabBar.center.y-30.5, 61, 61);
    [button setImage:[UIImage imageNamed:@"Add Deal"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"Add Deal Highlighted"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(addDealVC:) forControlEvents:UIControlEventTouchUpInside];
    button.userInteractionEnabled = YES;
    button.tag = 123;
    [tabBarController.view addSubview:button];
}

- (void)hidePlusButton
{
    UIButton *plusButton = (UIButton *)[tabBarController.view viewWithTag:123];
    [UIView animateWithDuration:0.3
                     animations:^{
                         plusButton.alpha = 0; }];
}

- (void)showPlusButton
{
    UIButton *plusButton = (UIButton *)[tabBarController.view viewWithTag:123];
    [UIView animateWithDuration:0.52
                     animations:^{
                         plusButton.alpha = 1.0; }
                     completion:^(BOOL finished){
                         [tabBarController.view bringSubviewToFront:plusButton];
                     }];
}

- (void)addDealVC: (id) sender {
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"addDealNavController"];
    WhereIsTheDeal *tvc = (WhereIsTheDeal *)[navigationController topViewController];
    tvc.cameFrom = @"Add Deal";
    [tabBarController presentViewController:navigationController animated:YES completion:nil];
}

- (UIImageView *)loadingAnimationWhite
{
    UIImageView *loadingAnimationView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30.0, 30.0)];
    
    loadingAnimationView.animationImages = [NSArray arrayWithObjects:
                                    [UIImage imageNamed:@"Loadingwhite"],
                                    [UIImage imageNamed:@"Loading5white"],
                                    [UIImage imageNamed:@"Loading10white"],
                                    [UIImage imageNamed:@"Loading15white"],
                                    [UIImage imageNamed:@"Loading20white"],
                                    [UIImage imageNamed:@"Loading25white"],
                                    [UIImage imageNamed:@"Loading30white"],
                                    [UIImage imageNamed:@"Loading35white"],
                                    [UIImage imageNamed:@"Loading40white"],
                                    [UIImage imageNamed:@"Loading45white"],
                                    [UIImage imageNamed:@"Loading50white"],
                                    [UIImage imageNamed:@"Loading55white"],
                                    [UIImage imageNamed:@"Loading60white"],
                                    [UIImage imageNamed:@"Loading65white"],
                                    [UIImage imageNamed:@"Loading70white"],
                                    [UIImage imageNamed:@"Loading75white"],
                                    [UIImage imageNamed:@"Loading80white"],
                                    [UIImage imageNamed:@"Loading85white"],
                                    nil];
    loadingAnimationView.animationDuration = 0.3;
    
    return loadingAnimationView;
}

- (NSDictionary *)getCurrenciesDictionary
{
    NSDictionary *currencies = @{
                                 @"SH" : @"₪",
                                 @"DO" : @"$",
                                 @"PO" : @"£",
                                 @"YE" : @"¥",
                                 @"EU" : @"€"
                                 };
    return currencies;
}

- (NSString *)getCurrencySign:(NSString *)currencyKey
{
    NSDictionary *currenciesDictionary = [self getCurrenciesDictionary];
    return [currenciesDictionary valueForKey:currencyKey];
}

- (NSString *)getCurrencyKey:(NSString *)currencySign
{
    NSDictionary *currenciesDictionary = [self getCurrenciesDictionary];
    NSArray *temp = [currenciesDictionary allKeysForObject:currencySign];
    return temp.firstObject;
}

- (NSDictionary *)getDiscountTypesDictionary
{
    NSDictionary *discountTypes = @{
                                 @"PP" : @"lastPrice",
                                 @"PE" : @"%"
                                 };
    return discountTypes;
}

- (NSString *)getDiscountType:(NSString *)discountKey
{
    NSDictionary *discountTypes = [self getDiscountTypesDictionary];
    return [discountTypes valueForKey:discountKey];
}

- (NSString *)getDiscountKey:(NSString *)discountType
{
    NSDictionary *discountTypes = [self getDiscountTypesDictionary];
    NSArray *temp = [discountTypes allKeysForObject:discountType];
    return temp.firstObject;
}

- (NSArray *)getCategories
{
    NSArray *categories = [[NSMutableArray alloc] initWithObjects:@"Art",@"Automotive",@"Beauty & Personal Care",@"Books & Magazines",@"Electronics",@"Entertainment & Events",@"Fashion",@"Food & Groceries",@"Home & Furniture",@"Kids & Babies",@"Music",@"Pets",@"Restaurants & Bars",@"Sports & Outdoor",@"Travel",@"Other",nil];
    
    return categories;
}

- (NSArray *)getCategoriesIcons
{
    NSArray *icons = [[NSMutableArray alloc] initWithObjects:@"Art",@"Automotive",@"Beauty & Personal Care",@"Books & Magazines",@"Electronics",@"Amusment & Entertainment",@"Fashion",@"Food & Groceries",@"Home & Furniture",@"Kids & Babies",@"Music",@"Pets",@"Restaurants & Bars",@"Sports & Outdoor",@"Travel",@"Other",nil];
    
    return icons;
}

- (NSDictionary *)getCategoriesDictionary
{
    NSDictionary *categories = @{
                                 @"Fa" : @"Fashion",
                                 @"Au" : @"Automotive",
                                 @"Ar" : @"Art",
                                 @"Be" : @"Beauty & Personal Care",
                                 @"Bo" : @"Books & Magazines",
                                 @"El" : @"Electronics",
                                 @"En" : @"Entertainment & Events",
                                 @"Fa" : @"Fashion",
                                 @"Fo" : @"Food & Groceries",
                                 @"Ho" : @"Home & Furniture",
                                 @"Ki" : @"Kids & Babies",
                                 @"Mu" : @"Music",
                                 @"Pe" : @"Pets",
                                 @"Re" : @"Restaurants & Bars",
                                 @"Sp" : @"Sports & Outdoor",
                                 @"Tr" : @"Travel",
                                 @"Ot" : @"Other"
                                 };
    return categories;
}

- (NSString *)getCategoryKeyForValue:(NSString *)value
{
    NSDictionary *categories = [self getCategoriesDictionary];
    
    NSArray *tempArray = [categories allKeysForObject:value];
    
    return tempArray.firstObject;
}

- (NSString *)getCategoryValueForKey:(NSString *)key
{
    NSDictionary *categories = [self getCategoriesDictionary];
    
    return [categories valueForKey:key];
}

- (RKObjectMapping *)getTempDealMapping
{
    RKObjectMapping *dealMapping = [RKObjectMapping mappingForClass:[Deal class]];
    [dealMapping addAttributeMappingsFromDictionary: @{
                                                       @"url" : @"url",
                                                       @"type" : @"type",
                                                       @"title" : @"title",
                                                       @"price" : @"price",
                                                       @"currency" : @"currency",
                                                       @"discount_value" : @"discountValue",
                                                       @"discount_type" : @"discountType",
                                                       @"category" : @"category",
                                                       @"expiration" : @"expiration",
                                                       @"more_description" : @"moreDescription",
                                                       @"upload_date" : @"uploadDate",
                                                       @"photo1" : @"photoID1",
                                                       @"photo2" : @"photoID2",
                                                       @"photo3" : @"photoID3",
                                                       @"photo4" : @"photoID4"
                                                       }];
    
    return dealMapping;
}

- (RKObjectMapping *)getDealMapping
{
    RKObjectMapping *dealMapping = [RKObjectMapping mappingForClass:[Deal class]];
    [dealMapping addAttributeMappingsFromDictionary: @{
                                                       @"url" : @"url",
                                                       @"type" : @"type",
                                                       @"title" : @"title",
                                                       @"price" : @"price",
                                                       @"currency" : @"currency",
                                                       @"discount_value" : @"discountValue",
                                                       @"discount_type" : @"discountType",
                                                       @"category" : @"category",
                                                       @"expiration" : @"expiration",
                                                       @"more_description" : @"moreDescription",
                                                       @"upload_date" : @"uploadDate",
                                                       @"photo1" : @"photoID1",
                                                       @"photo2" : @"photoID2",
                                                       @"photo3" : @"photoID3",
                                                       @"photo4" : @"photoID4"
                                                       }];
    
    RKObjectMapping *storeMapping = [RKObjectMapping mappingForClass:[Store class]];
    [storeMapping addAttributeMappingsFromDictionary: @{
                                                        @"store_id" : @"storeID",
                                                        @"name" : @"name",
                                                        @"latitude" : @"latitude",
                                                        @"longitude" : @"longitude",
                                                        @"address" : @"address",
                                                        @"cc" :@"cc",
                                                        @"city" : @"city",
                                                        @"state" : @"state",
                                                        @"country" : @"country",
                                                        @"category_id" : @"categoryID",
                                                        @"url" : @"url",
                                                        @"phone" : @"phone",
                                                        @"verified_by_foursquare" : @"verifiedByFoursquare"
                                                        }];
    
    [dealMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"store"
                                                                                toKeyPath:@"store"
                                                                              withMapping:storeMapping]];
    
        RKObjectMapping *dealerMapping = [RKObjectMapping mappingForClass:[Dealer class]];
    [dealerMapping addAttributeMappingsFromDictionary: @{
                                                         @"id" : @"dealerID",
                                                         @"email" : @"email",
                                                         @"full_Name" : @"fullName",
                                                         @"date_of_birth" : @"dateOfBirth",
                                                         @"gender" : @"gender",
                                                         @"location" : @"location",
                                                         @"about" : @"about",
                                                         @"photo" : @"photoID",
                                                         @"register_date" : @"registerDate"
                                                         }];
    
    [dealMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"dealer"
                                                                                toKeyPath:@"dealer"
                                                                              withMapping:dealerMapping]];
    
    RKObjectMapping *dealAttribMapping = [RKObjectMapping mappingForClass:[DealAttrib class]];
    [dealAttribMapping addAttributeMappingsFromDictionary: @{
                                                             @"id" : @"dealAttribID",
                                                             @"url" : @"url",
                                                             @"like_counter" : @"likeCounter",
                                                             @"share_counter" : @"shareCounter",
                                                             @"deal_reliability" : @"dealReliability",
                                                             @"objective_rank" : @"objectiveRank"
                                                             }];
    
    [dealMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"dealattrib"
                                                                                toKeyPath:@"dealAttrib"
                                                                              withMapping:dealAttribMapping]];
    
    
    return dealMapping;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*_Animate_first= [[NSString alloc]init];
     _Animate_first= [[NSString alloc]init];
     _UserID = [[NSString alloc]init];
     _AfterAddDeal = [[NSString alloc]init];
     _onlineOrLocal = [[NSString alloc]init];*/
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}
@end

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
#import <FacebookSDK/FacebookSDK.h>
#import <AWSiOSSDKv2/S3.h>
#import <AWSiOSSDKv2/AWSCore.h>
#import "WhereIsTheDeal.h"
#import "KeychainItemWrapper.h"

#define AWS_ACCESS_KEY_ID @"AKIAIWJFJX72FWKD2LYQ"
#define AWS_SECRET_ACCESS_KEY @"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"
#define AWS_S3_BUCKET_NAME @"dealers-app"

@implementation AppDelegate

@synthesize window = _window;
@synthesize storyboard;
@synthesize tabBarController;

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication];
}

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
    
    // Configuring RestKit:
    [self configureRestKit];
    
    // Configuting Amazon Web Service SDK:
    AWSStaticCredentialsProvider *credentialsProvider = [AWSStaticCredentialsProvider credentialsWithAccessKey:AWS_ACCESS_KEY_ID
                                                                                                     secretKey:AWS_SECRET_ACCESS_KEY];
    AWSServiceConfiguration *configuration = [AWSServiceConfiguration configurationWithRegion:AWSRegionEUWest1
                                                                          credentialsProvider:credentialsProvider];
    [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;
    
    
    // For showing the network activity indicator whenever communicating with the web:
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    // For printing in the log info about the outputs and inputs via RestKit:
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    
    return YES;
}


#pragma mark - Tab Bar Controller

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

- (UIImageView *)loadingAnimationPurple
{
    UIImageView *loadingAnimationView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30.0, 30.0)];
    
    loadingAnimationView.animationImages = [NSArray arrayWithObjects:
                                            [UIImage imageNamed:@"loading.png"],
                                            [UIImage imageNamed:@"loading5.png"],
                                            [UIImage imageNamed:@"loading10.png"],
                                            [UIImage imageNamed:@"loading15.png"],
                                            [UIImage imageNamed:@"loading20.png"],
                                            [UIImage imageNamed:@"loading25.png"],
                                            [UIImage imageNamed:@"loading30.png"],
                                            [UIImage imageNamed:@"loading35.png"],
                                            [UIImage imageNamed:@"loading40.png"],
                                            [UIImage imageNamed:@"loading45.png"],
                                            [UIImage imageNamed:@"loading50.png"],
                                            [UIImage imageNamed:@"loading55.png"],
                                            [UIImage imageNamed:@"loading60.png"],
                                            [UIImage imageNamed:@"loading65.png"],
                                            [UIImage imageNamed:@"loading70.png"],
                                            [UIImage imageNamed:@"loading75.png"],
                                            [UIImage imageNamed:@"loading80.png"],
                                            [UIImage imageNamed:@"loading85.png"],
                                            nil];
    loadingAnimationView.animationDuration = 0.3;
    
    return loadingAnimationView;
}


#pragma mark - Helper Methods

- (void)saveUserDetailsOnDevice
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:self.dealer.dealerID forKey:@"dealerID"];
    [defaults setObject:self.dealer.email forKey:@"email"];
    [defaults setObject:self.dealer.fullName forKey:@"fullName"];
    [defaults setObject:self.dealer.dateOfBirth forKey:@"dateOfBirth"];
    [defaults setObject:self.dealer.gender forKey:@"gender"];
    [defaults setObject:self.dealer.registerDate forKey:@"registerDate"];
    [defaults setObject:self.dealer.location forKey:@"location"];
    [defaults setObject:self.dealer.about forKey:@"about"];
    [defaults setObject:self.dealer.photoURL forKey:@"photoURL"];
    [defaults setObject:self.dealer.photo forKey:@"photo"];
    [defaults setObject:self.dealer.uploadedDeals forKey:@"uploadedDeals"];
    [defaults setObject:self.dealer.likedDeals forKey:@"likedDeals"];
    [defaults setObject:self.dealer.sharedDeals forKey:@"sharedDeals"];
    [defaults setObject:self.dealer.followedBy forKey:@"followedBy"];
    [defaults setObject:self.dealer.followings forKey:@"followings"];
    [defaults setObject:self.dealer.badReportsCounter forKey:@"badReportsCounter"];
    [defaults setObject:self.dealer.score forKey:@"score"];
    [defaults setObject:self.dealer.rank forKey:@"rank"];
    [defaults setObject:self.dealer.reliability forKey:@"reliability"];

    [defaults synchronize];
}

- (void)removeUserDetailsFromDevice
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:@"dealerID"];
    [defaults removeObjectForKey:@"email"];
    [defaults removeObjectForKey:@"fullName"];
    [defaults removeObjectForKey:@"dateOfBirth"];
    [defaults removeObjectForKey:@"gender"];
    [defaults removeObjectForKey:@"registerDate"];
    [defaults removeObjectForKey:@"location"];
    [defaults removeObjectForKey:@"about"];
    [defaults removeObjectForKey:@"photoURL"];
    [defaults removeObjectForKey:@"photo"];
    [defaults removeObjectForKey:@"uploadedDeals"];
    [defaults removeObjectForKey:@"likedDeals"];
    [defaults removeObjectForKey:@"sharedDeals"];
    [defaults removeObjectForKey:@"followedBy"];
    [defaults removeObjectForKey:@"followings"];
    [defaults removeObjectForKey:@"badReportsCounter"];
    [defaults removeObjectForKey:@"score"];
    [defaults removeObjectForKey:@"rank"];
    [defaults removeObjectForKey:@"reliability"];
    
    [defaults synchronize];
    
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc]initWithIdentifier:@"DealersKeychain" accessGroup:nil];
    [keychain resetKeychainItem];
}

- (UIImage *)myProfilePic
{
    if (self.dealer.photo) {
        
        return [UIImage imageWithData:self.dealer.photo];
        
    } else {
        
        return [UIImage imageNamed:@"Profile Pic Placeholder"];
    }
}

- (void)otherProfilePic:(NSString *)photoURL forTarget:(NSString *)target inViewController:(NSString *)notificationCenterName inCell:(id)cell
{
    if (photoURL.length > 1) {
        
        AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
        
        
        NSString *downloadingFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:
                                         [NSString stringWithFormat:@"profile_pic_tmp_%@_%i.jpg", target, arc4random_uniform(100000)]];
        
        NSURL *downloadingFileURL = [NSURL fileURLWithPath:downloadingFilePath];
        
        AWSS3TransferManagerDownloadRequest *downloadRequest = [AWSS3TransferManagerDownloadRequest new];
        
        downloadRequest.bucket = AWS_S3_BUCKET_NAME;
        downloadRequest.key = photoURL;
        downloadRequest.downloadingFileURL = downloadingFileURL;
        
        [[transferManager download:downloadRequest] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
            
            if (task.error){
                if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
                    switch (task.error.code) {
                        case AWSS3TransferManagerErrorCancelled:
                        case AWSS3TransferManagerErrorPaused:
                            break;
                            
                        default:
                            NSLog(@"Error: %@", task.error);
                            return nil;
                            break;
                    }
                } else {
                    // Unknown error.
                    NSLog(@"Error: %@", task.error);
                    
                }
            }
            
            if (task.result) {
                
                __block UIImage *image = [UIImage imageWithContentsOfFile:downloadingFilePath];
                __block NSDictionary *userInfo = [[NSDictionary alloc]initWithObjectsAndKeys:
                                                  target, @"target",
                                                  image, @"image",
                                                  cell, @"cell",
                                                  nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:notificationCenterName
                                                                    object:nil
                                                                  userInfo:userInfo];
            }
            
            return nil;
        }];
        
    } else {
        
        NSDictionary *userInfo = [[NSDictionary alloc]initWithObjectsAndKeys:
                                  target, @"target",
                                  [UIImage imageNamed:@"Profile Pic Placeholder"], @"image",
                                  cell, @"cell",
                                  nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationCenterName
                                                            object:nil
                                                          userInfo:userInfo];;
    }
}

- (UIColor *)ourPurple
{
    UIColor *ourPurple = [UIColor colorWithRed:150.0/255.0 green:0/255.0 blue:180.0/255.0 alpha:1.0];
    
    return ourPurple;
}

- (UIColor *)textGrayColor
{
    UIColor *textGrayColor = [UIColor colorWithRed:155.0/255.0 green:155.0/255.0 blue:170.0/255.0 alpha:1.0];
    
    return textGrayColor;
}

- (UIColor *)darkTextGrayColor
{
    UIColor *darkTextGrayColor = [UIColor colorWithRed:110.0/255.0 green:110.0/255.0 blue:125.0/255.0 alpha:1.0];
    
    return darkTextGrayColor;
}

- (UIButton *)actionButton
{
    UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    CGFloat x = 20;
    CGFloat y = 20;
    CGFloat width = self.window.frame.size.width - x * 2;
    CGFloat height = 44;
    
    [actionButton setFrame:CGRectMake(x, y, width, height)];
    [[actionButton layer] setCornerRadius:8.0];
    [[actionButton layer] setMasksToBounds:YES];
    [[actionButton titleLabel] setFont:[UIFont fontWithName:@"Avenir-Medium" size:18.0]];
    
    return actionButton;
}

- (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, YES, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


#pragma mark - Dictionaries & Arrays

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


#pragma mark - RestKit

- (RKObjectMapping *)dealMapping
{
    RKObjectMapping *dealMapping = [RKObjectMapping mappingForClass:[Deal class]];
    [dealMapping addAttributeMappingsFromDictionary: @{
                                                       @"id" : @"dealID",
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
                                                       @"photo1" : @"photoURL1",
                                                       @"photo2" : @"photoURL2",
                                                       @"photo3" : @"photoURL3",
                                                       @"photo4" : @"photoURL4"
                                                       }];
    
    RKObjectMapping *storeMapping = [self storeMapping];
    [dealMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"store"
                                                                                toKeyPath:@"store"
                                                                              withMapping:storeMapping]];
    
    RKObjectMapping *dealerMapping = [RKObjectMapping mappingForClass:[Dealer class]];
    [dealerMapping addAttributeMappingsFromDictionary: @{
                                                         @"id" : @"dealerID",
                                                         @"email" : @"email",
                                                         @"full_name" : @"fullName",
                                                         @"date_of_birth" : @"dateOfBirth",
                                                         @"gender" : @"gender",
                                                         @"location" : @"location",
                                                         @"about" : @"about",
                                                         @"photo" : @"photoURL",
                                                         @"register_date" : @"registerDate",
                                                         @"uploaded_deals" : @"uploadedDeals",
                                                         @"bad_reports_counter" : @"badReportsCounter",
                                                         @"score" : @"score",
                                                         @"rank" : @"rank",
                                                         @"reliability" : @"reliability",
                                                         @"uploaded_deals" : @"uploadedDeals",
                                                         @"liked_deals" : @"likedDeals",
                                                         @"shared_deals" : @"sharedDeals",
                                                         @"followings" : @"followings",
                                                         @"followed_by" : @"followedBy"
                                                         }];
    
    [dealMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"dealer"
                                                                                toKeyPath:@"dealer"
                                                                              withMapping:dealerMapping]];
    
    RKObjectMapping *dealAttribMapping = [self dealAttribMapping];
    
    [dealMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"dealattribs"
                                                                                toKeyPath:@"dealAttrib"
                                                                              withMapping:dealAttribMapping]];
    
    RKObjectMapping *commentMapping = [self commentMapping];
    
    [dealMapping addRelationshipMappingWithSourceKeyPath:@"comments" mapping:commentMapping];
    
    return dealMapping;
}

- (RKObjectMapping *)addDealMapping
{
    RKObjectMapping *addDealMapping = [RKObjectMapping mappingForClass:[Deal class]];
    [addDealMapping addAttributeMappingsFromDictionary: @{
                                                          @"id" : @"dealID",
                                                          @"type" : @"type",
                                                          @"title" : @"title",
                                                          @"dealer" : @"dealer.dealerID",
                                                          @"price" : @"price",
                                                          @"currency" : @"currency",
                                                          @"discount_value" : @"discountValue",
                                                          @"discount_type" : @"discountType",
                                                          @"category" : @"category",
                                                          @"expiration" : @"expiration",
                                                          @"more_description" : @"moreDescription",
                                                          @"upload_date" : @"uploadDate",
                                                          @"photo1" : @"photoURL1",
                                                          @"photo2" : @"photoURL2",
                                                          @"photo3" : @"photoURL3",
                                                          @"photo4" : @"photoURL4"
                                                          }];
    
    RKObjectMapping *dealAttribMapping = [self dealAttribMapping];
    [addDealMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"dealattribs"
                                                                                   toKeyPath:@"dealAttrib"
                                                                                 withMapping:dealAttribMapping]];
    
    RKObjectMapping *storeMapping = [self storeMapping];
    [addDealMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"store"
                                                                                   toKeyPath:@"store"
                                                                                 withMapping:storeMapping]];
    
    return addDealMapping;
}

- (RKObjectMapping *)dealerMapping
{
    RKObjectMapping *dealerMapping = [RKObjectMapping mappingForClass:[Dealer class]];
    [dealerMapping addAttributeMappingsFromDictionary: @{
                                                         @"id" : @"dealerID",
                                                         @"email" : @"email",
                                                         @"full_name" : @"fullName",
                                                         @"date_of_birth" : @"dateOfBirth",
                                                         @"gender" : @"gender",
                                                         @"about" : @"about",
                                                         @"location" : @"location",
                                                         @"register_date" : @"registerDate",
                                                         @"user.username" : @"username",
                                                         @"user.password" : @"userPassword",
                                                         @"photo" : @"photoURL",
                                                         @"bad_reports_counter" : @"badReportsCounter",
                                                         @"score" : @"score",
                                                         @"rank" : @"rank",
                                                         @"reliability" : @"reliability",
                                                         @"uploaded_deals" : @"uploadedDeals",
                                                         @"liked_deals" : @"likedDeals",
                                                         @"shared_deals" : @"sharedDeals",
                                                         @"followings" : @"followings",
                                                         @"followed_by" : @"followedBy"
                                                         }];
    return dealerMapping;
}

- (RKObjectMapping *)storeMapping
{
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
    return storeMapping;
}

- (RKObjectMapping *)dealAttribMapping
{
    RKObjectMapping *dealAttribMapping = [RKObjectMapping mappingForClass:[DealAttrib class]];
    
    [dealAttribMapping addAttributeMappingsFromDictionary: @{
                                                             @"id" : @"dealAttribID",
                                                             @"deal" : @"dealID",
                                                             @"dealers_that_liked" : @"dealersThatLiked",
                                                             @"dealers_that_shared" : @"dealersThatShared",
                                                             @"deal_reliability" : @"dealReliability",
                                                             @"objective_rank" : @"objectiveRank"
                                                             }];
    
    return dealAttribMapping;
}

- (RKObjectMapping *)commentMapping
{
    RKObjectMapping *commentMapping = [RKObjectMapping mappingForClass:[Comment class]];
    [commentMapping addAttributeMappingsFromDictionary: @{
                                                          @"id" : @"commentID",
                                                          @"text" : @"text",
                                                          @"deal" : @"dealID",
                                                          @"dealer.id" : @"dealerID",
                                                          @"dealer.full_name" : @"dealerFullName",
                                                          @"dealer.photo" : @"dealerPhotoURL",
                                                          @"upload_date" : @"uploadDate",
                                                          @"type" : @"type"
                                                          }];
    
    return commentMapping;
}

- (RKObjectMapping *)addCommentMapping
{
    RKObjectMapping *addCommentMapping = [RKObjectMapping mappingForClass:[Comment class]];
    [addCommentMapping addAttributeMappingsFromDictionary: @{
                                                             @"id" : @"commentID",
                                                             @"text" : @"text",
                                                             @"deal" : @"dealID",
                                                             @"dealer" : @"dealerID",
                                                             @"upload_date" : @"uploadDate",
                                                             @"type" : @"type"
                                                             }];
    
    return addCommentMapping;
}

- (void)setHTTPClientUsername:(NSString *)username andPassword:(NSString *)password
{
    [[RKObjectManager sharedManager].HTTPClient setAuthorizationHeaderWithUsername:username password:password];
}

- (void)resetHTTPClientUsernameAndPassword
{
    [[RKObjectManager sharedManager].HTTPClient setAuthorizationHeaderWithUsername:@"ubuntu" password:@"09"];
}

- (void)configureRestKit
{
    // initialize AFNetworking HTTPClient
    NSURL *baseURL = [NSURL URLWithString:@"http://54.77.168.152"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // initialize RestKit
    RKObjectManager *manager = [[RKObjectManager alloc] initWithHTTPClient:client];
    manager.requestSerializationMIMEType = RKMIMETypeJSON;
    
    // validate with username and password
    NSString *username = @"ubuntu";
    NSString *password = @"09";
    [manager.HTTPClient setAuthorizationHeaderWithUsername:username password:password];
    
    // other modifications to the object manager
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    // register mappings with the provider using response descriptors
    RKResponseDescriptor *dealsResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:[self dealMapping]
                                                 method:RKRequestMethodAny
                                            pathPattern:@"/deals/"
                                                keyPath:@"results"
                                            statusCodes:statusCodes];
    
    RKResponseDescriptor *addDealResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:[self addDealMapping]
                                                 method:RKRequestMethodAny
                                            pathPattern:@"/adddeals/"
                                                keyPath:nil
                                            statusCodes:statusCodes];
    
    RKResponseDescriptor *specificDealResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:[self addDealMapping]
                                                 method:RKRequestMethodAny
                                            pathPattern:@"/adddeals/:adddealID/"
                                                keyPath:nil
                                            statusCodes:statusCodes];
    
    RKResponseDescriptor *dealersResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:[self dealerMapping]
                                                 method:RKRequestMethodAny
                                            pathPattern:@"/dealers/"
                                                keyPath:nil
                                            statusCodes:statusCodes];
    
    RKResponseDescriptor *specificDealerResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:[self dealerMapping]
                                                 method:RKRequestMethodAny
                                            pathPattern:@"/dealers/:dealerID/"
                                                keyPath:nil
                                            statusCodes:statusCodes];
    
    RKResponseDescriptor *dealAttribResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:[self dealAttribMapping]
                                                 method:RKRequestMethodAny
                                            pathPattern:@"/dealattribs/:dealattribID/"
                                                keyPath:nil
                                            statusCodes:statusCodes];
    
    RKResponseDescriptor *commentsResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:[self commentMapping]
                                                 method:RKRequestMethodAny
                                            pathPattern:@"/comments/"
                                                keyPath:nil
                                            statusCodes:statusCodes];
    
    RKResponseDescriptor *addCommentResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:[self addCommentMapping]
                                                 method:RKRequestMethodAny
                                            pathPattern:@"/addcomments/"
                                                keyPath:nil
                                            statusCodes:statusCodes];
    
    // register mappings with the provider using respnose discriptors for errors
    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[RKErrorMessage class]];
    [errorMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user"
                                                                                 toKeyPath:@"errorMessage"
                                                                               withMapping:errorMapping]];
    
    RKResponseDescriptor *errorResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:errorMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError)];
    
    // register mappings with the provider using request descriptors
    
    // for user registration
    RKRequestDescriptor *signUpRequestDescriptor =
    [RKRequestDescriptor requestDescriptorWithMapping:[[self dealerMapping] inverseMapping]
                                          objectClass:[Dealer class]
                                          rootKeyPath:nil
                                               method:RKRequestMethodAny];
    
    // for Add Deal & Edit Deal
    RKRequestDescriptor *addDealRequestDescriptor =
    [RKRequestDescriptor requestDescriptorWithMapping:[[self addDealMapping] inverseMapping]
                                          objectClass:[Deal class]
                                          rootKeyPath:nil
                                               method:RKRequestMethodAny];
    
    // for Deal Attrib Update
    RKRequestDescriptor *dealAttribRequestDescriptor =
    [RKRequestDescriptor requestDescriptorWithMapping:[[self dealAttribMapping] inverseMapping]
                                          objectClass:[DealAttrib class]
                                          rootKeyPath:nil
                                               method:RKRequestMethodAny];
    
    // for adding comment
    RKRequestDescriptor *addCommentRequestDescriptor =
    [RKRequestDescriptor requestDescriptorWithMapping:[[self addCommentMapping] inverseMapping]
                                          objectClass:[Comment class]
                                          rootKeyPath:nil
                                               method:RKRequestMethodAny];
    
    [manager addResponseDescriptorsFromArray:@[dealsResponseDescriptor,
                                               addDealResponseDescriptor,
                                               specificDealResponseDescriptor,
                                               dealersResponseDescriptor,
                                               specificDealerResponseDescriptor,
                                               dealAttribResponseDescriptor,
                                               commentsResponseDescriptor,
                                               addCommentResponseDescriptor,
                                               errorResponseDescriptor
                                               ]];
    
    [manager addRequestDescriptorsFromArray:@[
                                              signUpRequestDescriptor,
                                              addDealRequestDescriptor,
                                              dealAttribRequestDescriptor,
                                              addCommentRequestDescriptor
                                              ]];
}


#pragma mark - Facebook

- (void)openActiveSessionWithPermissions:(NSArray *)permissions allowLoginUI:(BOOL)allowLoginUI
{
    [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:allowLoginUI
                                  completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                      
                                      if (!error) {
                                          
                                          // Create a NSDictionary object and set the parameter values.
                                          NSDictionary *sessionStateInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                                            session, @"session",
                                                                            [NSNumber numberWithInteger:status], @"state",
                                                                            error, @"error",
                                                                            nil];
                                          
                                          // Create a new notification, add the sessionStateInfo dictionary to it and post it.
                                          [[NSNotificationCenter defaultCenter] postNotificationName:@"SessionStateChangeNotification"
                                                                                              object:nil
                                                                                            userInfo:sessionStateInfo];
                                          
                                      } else {
                                          
                                          NSLog(@"Error: %@", [error localizedDescription]);
                                          UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Can't connect Facebook"
                                                                                         message:nil
                                                                                        delegate:nil
                                                                               cancelButtonTitle:@"Ok"
                                                                               otherButtonTitles:nil];
                                          [alert show];
                                      }
                                  }];
}

- (BOOL)isFacebookConnected
{
    if ([FBSession activeSession].state == FBSessionStateOpen || [FBSession activeSession].state == FBSessionStateOpenTokenExtended) {
        return YES;
    }
    return NO;
}


#pragma mark - Other App Delegate Methods

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
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    if ([FBSession activeSession].state == FBSessionStateCreatedTokenLoaded) {
        
        [self openActiveSessionWithPermissions:nil allowLoginUI:NO];
    }
    
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}
@end

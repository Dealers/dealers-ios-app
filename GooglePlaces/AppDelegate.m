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
    
    tabBarController = [[DealersTabBarController alloc]init];
    
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
    activity.image = [UIImage imageNamed:@"Activity Tab"];
    activity.selectedImage = [UIImage imageNamed:@"Activity Tab Selected"];
    
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


#pragma mark - Helper Methods

- (void)saveUserDetailsOnDevice
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:self.dealer.dealerID forKey:@"dealerID"];
    [defaults setObject:self.dealer.email forKey:@"email"];
    [defaults setObject:self.dealer.username forKey:@"username"];
    [defaults setObject:self.dealer.fullName forKey:@"fullName"];
    [defaults setObject:self.dealer.dateOfBirth forKey:@"dateOfBirth"];
    [defaults setObject:self.dealer.gender forKey:@"gender"];
    [defaults setObject:self.dealer.registerDate forKey:@"registerDate"];
    [defaults setObject:self.dealer.location forKey:@"location"];
    [defaults setObject:self.dealer.about forKey:@"about"];
    [defaults setObject:self.dealer.photoURL forKey:@"photoURL"];
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
    
    if (self.dealer.photoURL.length > 1 && ![self.dealer.photoURL isEqualToString:@"None"]) {
        [self saveProfilePic:self.dealer.photo];
    }
}

- (void)removeUserDetailsFromDevice
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:@"dealerID"];
    [defaults removeObjectForKey:@"email"];
    [defaults removeObjectForKey:@"username"];
    [defaults removeObjectForKey:@"fullName"];
    [defaults removeObjectForKey:@"dateOfBirth"];
    [defaults removeObjectForKey:@"gender"];
    [defaults removeObjectForKey:@"registerDate"];
    [defaults removeObjectForKey:@"location"];
    [defaults removeObjectForKey:@"about"];
    [defaults removeObjectForKey:@"photoURL"];
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
    
    [self removeProfilePic];
    
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc]initWithIdentifier:@"DealersKeychain" accessGroup:nil];
    [keychain setObject:@"DealersKeychain" forKey:(__bridge id)kSecAttrService];
    [keychain resetKeychainItem];
}

- (void)saveProfilePic:(NSData *)image
{
    if (image != nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"profile_pic_%@.jpg", self.dealer.email]];
        [image writeToFile:path atomically:YES];
    }
}

- (NSData *)loadProfilePic
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                      [NSString stringWithFormat:@"profile_pic_%@.jpg", self.dealer.email]];
    NSData *profilePic = [NSData dataWithContentsOfFile:path];
    
    return profilePic;
}

- (void)removeProfilePic
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"profile_pic_%@.jpg", self.dealer.email]];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    if (success) {
        NSLog(@"Profile photo successfuly removed");
    }
    else {
        NSLog(@"Could not delete file - %@. Error:\n%@ \n%@ \n%@ \n%@ ", filePath, [error localizedDescription], [error localizedFailureReason],[error localizedRecoveryOptions],[error localizedRecoverySuggestion]);
    }
}

- (void)updateUserInfo
{
    NSString *path = [NSString stringWithFormat:@"/dealers/%@/", self.dealer.dealerID];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  NSLog(@"Dealer updated successfuly...");
                                                  self.dealer = mappingResult.firstObject;
                                                  self.dealer.photo = [self loadProfilePic];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  
                                                  NSLog(@"Dealer couldn't be updated...");
                                              }];
}

- (UIImage *)myProfilePic
{
    if (self.dealer.photo) {
        
        return [UIImage imageWithData:self.dealer.photo];
        
    } else {
        
        return [UIImage imageNamed:@"Profile Pic Placeholder"];
    }
}

- (void)otherProfilePic:(Dealer *)dealer forTarget:(NSString *)target notificationName:(NSString *)notificationName atIndexPath:(NSIndexPath *)indexPath
{
    if (dealer.photoURL.length > 1 && ![dealer.photoURL isEqualToString:@"None"]) {
        
        AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
        
        NSString *downloadingFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:
                                         [NSString stringWithFormat:@"profile_pic_tmp_%@_%@.jpg", target, dealer.dealerID]];
        
        NSURL *downloadingFileURL = [NSURL fileURLWithPath:downloadingFilePath];
        
        AWSS3TransferManagerDownloadRequest *downloadRequest = [AWSS3TransferManagerDownloadRequest new];
        
        downloadRequest.bucket = AWS_S3_BUCKET_NAME;
        downloadRequest.key = dealer.photoURL;
        downloadRequest.downloadingFileURL = downloadingFileURL;
        
        [[transferManager download:downloadRequest] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
            
            if (task.error) {
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
                
                dealer.photo = [NSData dataWithContentsOfFile:downloadingFilePath];
                dealer.downloadingPhoto = NO;
                __block NSDictionary *userInfo = [[NSDictionary alloc]initWithObjectsAndKeys:
                                                  [UIImage imageWithData:dealer.photo], @"image",
                                                  notificationName, @"notificationName",
                                                  target, @"target",
                                                  indexPath, @"indexPath",
                                                  nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:notificationName
                                                                    object:nil
                                                                  userInfo:userInfo];
            }
            
            return nil;
        }];
        
    } else {
        
        dealer.downloadingPhoto = NO;
        NSDictionary *userInfo = [[NSDictionary alloc]initWithObjectsAndKeys:
                                  [UIImage imageNamed:@"Profile Pic Placeholder"], @"image",
                                  notificationName, @"notificationName",
                                  target, @"target",
                                  indexPath, @"indexPath",
                                  nil];
        // We need to delay the post of the notification so the cell will have sufficient time to be created.
        [self performSelector:@selector(sendNotificationAfterDelay:) withObject:userInfo afterDelay:0.1];
    }
}

- (void)sendNotificationAfterDelay:(NSDictionary *)userInfo
{
    [[NSNotificationCenter defaultCenter] postNotificationName:[userInfo objectForKey:@"notificationName"]
                                                        object:nil
                                                      userInfo:userInfo];
}

- (void)downloadPhotosForDeal:(Deal *)deal notificationName:(NSString *)notificationName atIndexPath:(NSIndexPath *)indexPath mode:(NSString *)mode
{
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    
    NSString *downloadingFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:
                                     [NSString stringWithFormat:@"deal_photo_tmp_%@.jpg", deal.dealID]];
    
    NSURL *downloadingFileURL = [NSURL fileURLWithPath:downloadingFilePath];
    
    AWSS3TransferManagerDownloadRequest *downloadRequest = [AWSS3TransferManagerDownloadRequest new];
    
    downloadRequest.bucket = AWS_S3_BUCKET_NAME;
    downloadRequest.key = deal.photoURL1;
    downloadRequest.downloadingFileURL = downloadingFileURL;
    
    [[transferManager download:downloadRequest] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
        
        if (task.error) {
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
            
            deal.photo1 = [UIImage imageWithContentsOfFile:downloadingFilePath];
            deal.downloadingPhoto = NO;
            __block NSDictionary *userInfo = [[NSDictionary alloc]initWithObjectsAndKeys:
                                              deal.photo1, @"image",
                                              indexPath, @"indexPath",
                                              mode, @"mode",
                                              nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName
                                                                object:nil
                                                              userInfo:userInfo];
        }
        
        return nil;
    }];
}

- (UIColor *)ourPurple
{
    UIColor *ourPurple = [UIColor colorWithRed:150.0/255.0 green:0/255.0 blue:180.0/255.0 alpha:1.0];
    
    return ourPurple;
}

- (UIColor *)textGrayColor
{
    UIColor *textGrayColor = [UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:160.0/255.0 alpha:1.0];
    
    return textGrayColor;
}

- (UIColor *)darkTextGrayColor
{
    UIColor *darkTextGrayColor = [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:115.0/255.0 alpha:1.0];
    
    return darkTextGrayColor;
}

- (UIColor *)blackColor
{
    UIColor *blackColor = [UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:65.0/255.0 alpha:1.0];
    
    return blackColor;
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
    [[actionButton titleLabel] setFont:[UIFont fontWithName:@"Avenir-Medium" size:19.0]];
    
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

- (NSNumber *)setPhotoSum:(Deal *)deal {
    
    if (deal.photoURL1.length > 1 && ![deal.photoURL1 isEqualToString:@"None"])
        deal.photoSum = @(deal.photoSum.intValue + 1);
    else
        return [NSNumber numberWithInt:0];
    
    if (deal.photoURL2.length > 1 && ![deal.photoURL2 isEqualToString:@"None"])
        deal.photoSum = @(deal.photoSum.intValue + 1);
    else
        return [NSNumber numberWithInt:1];
    
    if (deal.photoURL3.length > 1 && ![deal.photoURL3 isEqualToString:@"None"])
        deal.photoSum = @(deal.photoSum.intValue + 1);
    else
        return [NSNumber numberWithInt:2];
    
    if (deal.photoURL4.length > 1 && ![deal.photoURL4 isEqualToString:@"None"])
        deal.photoSum = @(deal.photoSum.intValue + 1);
    else
        return [NSNumber numberWithInt:3];
    
    return [NSNumber numberWithInt:4];
}

- (Dealer *)updateDealer:(Dealer *)dealer withFacebookInfo:(FBGraphObject *)facebookInfo withPhoto:(BOOL)withPhoto
{
    if (!dealer) {
        dealer = [[Dealer alloc]init];
        dealer.fullName = [NSString stringWithFormat:@"%@ %@",
                           [facebookInfo objectForKey:@"first_name"],
                           [facebookInfo objectForKey:@"last_name"]];
        dealer.email = [facebookInfo objectForKey:@"email"];
        dealer.username = dealer.email;
        dealer.userPassword = [NSString stringWithFormat:@"facebook_user_%@", dealer.email];
        dealer.registerDate = [NSDate date];
    }
    
    if (!dealer.dateOfBirth) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"MM/dd/yyyy";
        dealer.dateOfBirth = [dateFormatter dateFromString:[facebookInfo objectForKey:@"birthday"]];
    }
    
    if (!dealer.gender || [dealer.gender isEqualToString:@"Unspecified"]) {
        dealer.gender = [facebookInfo objectForKey:@"gender"];
        if ([dealer.gender isEqualToString:@"male"] || [self.dealer.gender isEqualToString:@"female"]) {
            
            NSString *capitalisedGender = [self.dealer.gender stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                                      withString:[[self.dealer.gender substringToIndex:1] capitalizedString]];
            dealer.gender = capitalisedGender;
        } else {
            dealer.gender = nil;
        }
    }
    
    if (!(dealer.location.length > 1) || [dealer.location isEqualToString:@"None"]) {
        NSString *location = [[facebookInfo objectForKey:@"location"] objectForKey:@"name"];
        dealer.location = location;
    }
    
    if (withPhoto) {
        if (!(dealer.photoURL.length > 1) || [dealer.photoURL isEqualToString:@"None"]) {
            NSURL *pictureURL = [NSURL URLWithString:[[[facebookInfo objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]];
            dealer.photo = [NSData dataWithContentsOfURL:pictureURL];
        }
    }
    
    return dealer;
}

- (NSString *)connectOldCategoryToNewCategory:(NSString *)string
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"Entertainment & Events_hot_spring.png",@"4bf58dd8d48988d160941735",
                         @"Entertainment & Events_vineyard.png",@"4bf58dd8d48988d1de941735",
                         @"Entertainment & Events_Auditorium.png",@"4bf58dd8d48988d173941735",
                         @"Entertainment & Events_conference.png",@"4bf58dd8d48988d1ff931735",
                         @"Entertainment & Events_conference.png",@"4bf58dd8d48988d100941735",
                         @"Entertainment & Events_amusement_park.png",@"4bf58dd8d48988d171941735",
                         @"Entertainment & Events_amusement_park.png",@"4eb1daf44b900d56c88a4600",
                         @"Entertainment & Events_conference.png",@"4bf58dd8d48988d127941735",
                         @"Entertainment & Events_arcade.png",@"4bf58dd8d48988d18d941735",
                         @"Entertainment & Events_spa.png",@"4bf58dd8d48988d1ed941735",
                         @"Entertainment & Events_movie_rental.png",@"4bf58dd8d48988d126951735",
                         @"Entertainment & Events_arcade.png",@"4bf58dd8d48988d10b951735",
                         @"Sports & Outdoor_outdoor.png",@"5032829591d4c4b30a586d5e",
                         @"Fashion_bridal_shop.png",@"4bf58dd8d48988d11a951735",
                         @"Fashion_clothing_store.png",@"4bf58dd8d48988d103951735",
                         @"Fashion_accessories_store.png",@"4bf58dd8d48988d102951735",
                         @"Fashion_clothing_store.png",@"4bf58dd8d48988d104951735",
                         @"Fashion_lingerie.png",@"4bf58dd8d48988d109951735",
                         @"Fashion_mens_store.png",@"4bf58dd8d48988d106951735",
                         @"Fashion_shoe_store.png",@"4bf58dd8d48988d107951735",
                         @"Fashion_womens_store.png",@"4bf58dd8d48988d108951735",
                         @"Fashion_jewelry.png",@"4bf58dd8d48988d111951735",
                         @"Fashion_clothing_store.png",@"5032781d91d4c4b30a586d5b",
                         @"Food & Groceries_candy_store",@"4bf58dd8d48988d117951735",
                         @"Food & Groceries_market.png",@"4d954b0ea243a5684a65b473",
                         @"Food & Groceries_groceries.png",@"4bf58dd8d48988d1f9941735",
                         @"Food & Groceries_butcher.png",@"4bf58dd8d48988d11d951735",
                         @"Food & Groceries_cheese_shop.png",@"4bf58dd8d48988d11e951735",
                         @"Food & Groceries_farmers_market.png",@"4bf58dd8d48988d1fa941735",
                         @"Food & Groceries_fish_market.png",@"4bf58dd8d48988d10e951735",
                         @"Food & Groceries_market.png",@"4bf58dd8d48988d1f5941735",
                         @"Food & Groceries_market.png",@"4bf58dd8d48988d118951735",
                         @"Food & Groceries_market.png",@"50aa9e744b90af0d42d5de0e",
                         @"Food & Groceries_liquor.png",@"4bf58dd8d48988d186941735",
                         @"Food & Groceries_liquor.png",@"4bf58dd8d48988d119951735",
                         @"Food & Groceries_smoke_shop.png",@"4bf58dd8d48988d123951735",
                         @"Food & Groceries_bakery.png",@"4bf58dd8d48988d16a941735",
                         @"Home & Furniture_flower_shop.png",@"4bf58dd8d48988d11b951735",
                         @"Home & Furniture_furniture_store.png",@"4bf58dd8d48988d1f8941735",
                         @"Home & Furniture_flower_shop.png",@"4eb1c0253b7b52c0e1adc2e9",
                         @"Home & Furniture_hardware_store.png",@"4bf58dd8d48988d112951735",
                         @"Home & Furniture_office.png",@"4bf58dd8d48988d121951735",
                         @"Home & Furniture_locksmith.png",@"4f04b1572fb6e1c99f3db0bf",
                         @"Home & Furniture_laundry.png",@"4bf58dd8d48988d1fc941735",
                         @"Kids & Babies_kids_store.png",@"4bf58dd8d48988d105951735",
                         @"Kids & Babies_daycare.png",@"4f4532974b9074f6e4fb0104",
                         @"Kids & Babies_toys.png",@"4bf58dd8d48988d1f3941735",
                         @"Automotive_automotive_shop.png",@"4bf58dd8d48988d124951735",
                         @"Automotive_car_dealer.png", @"4eb1c1623b7b52c0e1adc2ec",
                         @"Automotive_car_wash.png",@"4f04ae1f2fb6e1c99f3db0ba",
                         @"Automotive_EV_charging_station.png",@"5032872391d4c4b30a586d64",
                         @"Automotive_gas_station.png",@"4bf58dd8d48988d113951735",
                         @"Automotive_motorcycle_shop.png",@"5032833091d4c4b30a586d60",
                         @"Art_art_gallery.png",@"4bf58dd8d48988d1e2931735",
                         @"Art_art_museum.png",@"4bf58dd8d48988d18f941735",
                         @"Art_art_museum.png",@"4bf58dd8d48988d1f2931735",
                         @"Art_art_gallery.png",@"07c8c4091d498d9fc8c67a9",
                         @"Art_antique_shop.png",@"4bf58dd8d48988d116951735",
                         @"Art_arts&craft_store.png",@"4bf58dd8d48988d127951735",
                         @"Art_design_studio.png",@"4bf58dd8d48988d1f4941735",
                         @"Art_photography_lab.png",@"4eb1bdde3b7b55596b4a7490",
                         @"Art_art_museum.png",@"4bf58dd8d48988d166941735",
                         @"Beauty & Personal Care_cosmetics.png",@"4bf58dd8d48988d10c951735",
                         @"Beauty & Personal Care_drug_store-pharmacy.png",@"4bf58dd8d48988d10f951735",
                         @"Beauty & Personal Care_beauty_salon.png",@"4f04aa0c2fb6e1c99f3db0b8",
                         @"Beauty & Personal Care_beauty_salon.png",@"4bf58dd8d48988d110951735",
                         @"Beauty & Personal Care_tanning_salon.png",@"4d1cf8421a97d635ce361c31",
                         @"Books & Magazines_books.png",@"4bf58dd8d48988d1b1941735",
                         @"Books & Magazines_books.png",@"4bf58dd8d48988d1a7941735",
                         @"Books & Magazines_books.png",@"4bf58dd8d48988d12f941735",
                         @"Books & Magazines_books.png",@"4bf58dd8d48988d114951735",
                         @"Books & Magazines_news_stand.png",@"4f04ad622fb6e1c99f3db0b9",
                         @"Electronics_camera_store.png",@"4eb1bdf03b7b55596b4a7491",
                         @"Electronics_electronics_store.png",@"4bf58dd8d48988d122951735",
                         @"Electronics_mobile_phone_store.png",@"4f04afc02fb6e1c99f3db0bc",
                         @"Entertainment & Events_aquarium.png",@"4fceea171983d5d06c3e9823",
                         @"Entertainment & Events_arcade.png",@"4bf58dd8d48988d1e1931735",
                         @"Entertainment & Events_bowling_alley.png",@"4bf58dd8d48988d1e4931735",
                         @"Entertainment & Events_casino.png",@"4bf58dd8d48988d17c941735",
                         @"Entertainment & Events_entertainment.png",@"4bf58dd8d48988d18e941735",
                         @"Entertainment & Events_entertainment.png",@"4bf58dd8d48988d1f1931735",
                         @"Entertainment & Events_museum.png",@"4deefb944765f83613cdba6e",
                         @"Entertainment & Events_movie_theater.png",@"4bf58dd8d48988d17f941735",
                         @"Entertainment & Events_movie_theater.png",@"4bf58dd8d48988d17e941735",
                         @"Entertainment & Events_movie_theater.png",@"4bf58dd8d48988d180941735",
                         @"Entertainment & Events_museum.png",@"4bf58dd8d48988d181941735",
                         @"Entertainment & Events_museum.png",@"4bf58dd8d48988d190941735",
                         @"Entertainment & Events_science.png",@"4bf58dd8d48988d191941735",
                         @"Entertainment & Events_dance_studio.png",@"4bf58dd8d48988d134941735",
                         @"Entertainment & Events_entertainment.png",@"4bf58dd8d48988d135941735",
                         @"Entertainment & Events_entertainment.png",@"4bf58dd8d48988d137941735",
                         @"Entertainment & Events_pool_hall.png",@"4bf58dd8d48988d1e3931735",
                         @"Entertainment & Events_racetrack.png",@"4bf58dd8d48988d1f4931735",
                         @"Entertainment & Events_amusement_park.png",@"4bf58dd8d48988d182941735",
                         @"Entertainment & Events_amusement_park.png",@"5109983191d435c0d71c2bb1",
                         @"Entertainment & Events_water_park.png",@"4bf58dd8d48988d193941735",
                         @"Entertainment & Events_zoo.png",@"4bf58dd8d48988d17b941735",
                         @"Entertainment & Events_auditorium.png",@"4bf58dd8d48988d1af941735",
                         @"Entertainment & Events_student_center.png",@"4bf58dd8d48988d1ab941735",
                         @"Entertainment & Events_entertainment.png",@"4bf58dd8d48988d1ac941735",
                         @"Entertainment & Events_conference.png",@"5267e4d9e4b0ec79466e48c6",
                         @"Entertainment & Events_event.png",@"5267e4d9e4b0ec79466e48c9",
                         @"Entertainment & Events_amusement_park.png",@"5267e4d9e4b0ec79466e48c7",
                         @"Entertainment & Events_event.png",@"5267e4d9e4b0ec79466e48c8",
                         @"Entertainment & Events_event.png",@"52741d85e4b0d5d1e3c6a6d9",
                         @"Entertainment & Events_event.png",@"5267e4d8e4b0ec79466e48c5",
                         @"Entertainment & Events_gay_bar.png",@"4bf58dd8d48988d1d8941735",
                         @"Entertainment & Events_karaoke_bar.png",@"4bf58dd8d48988d120941735",
                         @"Entertainment & Events_night_club.png",@"4bf58dd8d48988d11f941735",
                         @"Entertainment & Events_night_club.png",@"4bf58dd8d48988d11a941735",
                         @"Entertainment & Events_adults.png",@"4bf58dd8d48988d1d6941735",
                         @"Entertainment & Events_adults.png",@"5267e446e4b0ec79466e48c4",
                         @"Music_music.png",@"5032792091d4c4b30a586d5c",
                         @"Music_music.png",@"4bf58dd8d48988d1e5931735",
                         @"Music_music.png",@"4bf58dd8d48988d1e7931735",
                         @"Music_music.png",@"4bf58dd8d48988d1e8931735",
                         @"Music_rock.png",@"4bf58dd8d48988d1e9931735",
                         @"Music_opera.png",@"4bf58dd8d48988d136941735",
                         @"Music_music.png",@"5267e4d9e4b0ec79466e48d1",
                         @"Music_music_school.png",@"4f04b10d2fb6e1c99f3db0be",
                         @"Music_music.png",@"4bf58dd8d48988d10d951735",
                         @"Pets_pets_store.png",@"4e52d2d203646f7c19daa8ae",
                         @"Pets_veterinary_care.png",@"4d954af4a243a5684765b473",
                         @"Pets_pets_store.png",@"5032897c91d4c4b30a586d69",
                         @"Pets_pets_store.png",@"4bf58dd8d48988d100951735",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d1a1941735",
                         @"Restaurants & Bars_restaurant.png",@"503288ae91d4c4b30a586d67",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d1c8941735",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d14e941735",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d152941735",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d107941735",
                         @"Restaurants & Bars_asian_food.png",@"4bf58dd8d48988d142941735",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d169941735",
                         @"Restaurants & Bars_bbq.png",@"4bf58dd8d48988d1df931735",
                         @"Restaurants & Bars_bagel_shop.png",@"4bf58dd8d48988d179941735",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d16b941735",
                         @"Restaurants & Bars_restaurant.png",@"5294c7523cf9994f4e043a62",
                         @"Restaurants & Bars_restaurant.png",@"52939ae13cf9994f4e043a3b",
                         @"Restaurants & Bars_restaurant.png",@"52939a9e3cf9994f4e043a36",
                         @"Restaurants & Bars_restaurant.png",@"52939a643cf9994f4e043a33",
                         @"Restaurants & Bars_restaurant.png",@"5294c55c3cf9994f4e043a61",
                         @"Restaurants & Bars_restaurant.png",@"52939af83cf9994f4e043a3d",
                         @"Restaurants & Bars_restaurant.png",@"52939aed3cf9994f4e043a3c",
                         @"Restaurants & Bars_restaurant.png",@"52939aae3cf9994f4e043a37",
                         @"Restaurants & Bars_restaurant.png",@"52939ab93cf9994f4e043a38",
                         @"Restaurants & Bars_restaurant.png",@"5294cbda3cf9994f4e043a63",
                         @"Restaurants & Bars_restaurant.png",@"52939ac53cf9994f4e043a39",
                         @"Restaurants & Bars_restaurant.png",@"52939ad03cf9994f4e043a3a",
                         @"Restaurants & Bars_restaurant.png",@"52939a7d3cf9994f4e043a34",
                         @"Restaurants & Bars_breakfast_spot.png",@"4bf58dd8d48988d143941735",
                         @"Restaurants & Bars_burger_joint.png",@"4bf58dd8d48988d16c941735",
                         @"Restaurants & Bars_mexican.png",@"4bf58dd8d48988d153941735",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d128941735",
                         @"Restaurants & Bars_café.png",@"4bf58dd8d48988d16d941735",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d17a941735",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d144941735",
                         @"Restaurants & Bars_restaurant.png",@"5293a7d53cf9994f4e043a45",
                         @"Restaurants & Bars_asian_food.png",@"4bf58dd8d48988d145941735",
                         @"Restaurants & Bars_café.png",@"4bf58dd8d48988d1e0931735",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d154941735",
                         @"Restaurants & Bars_cupcake.png",@"4bf58dd8d48988d1bc941735",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d146941735",
                         @"Restaurants & Bars_cupcake.png",@"4bf58dd8d48988d1d0941735",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d1f5931735",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d147941735",
                         @"Restaurants & Bars_bars.png",@"4e0e22f5a56208c4ea9a85a0",
                         @"Restaurants & Bars_donut_shop.png",@"4bf58dd8d48988d148941735",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d108941735",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d109941735",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d10a941735",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d10b941735",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d16e941735",
                         @"Restaurants & Bars_restaurant.png",@"4eb1bd1c3b7b55596b4a748f",
                         @"Restaurants & Bars_restaurant.png",@"4edd64a0c7ddd24ca188df1a",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d1cb941735",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d10c941735",
                         @"Restaurants & Bars_fried_chicken.png",@"4d4ae6fc7a7b7dea34424761",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d155941735",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d10d941735",
                         @"Restaurants & Bars_restaurant.png",@"4c2cd86ed066bed06c3c5209",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d10e941735",
                         @"Restaurants & Bars_hot_dog.png",@"4bf58dd8d48988d16f941735",
                         @"Restaurants & Bars_ice_cream.png",@"4bf58dd8d48988d1c9941735",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d10f941735",
                         @"Restaurants & Bars_restaurant.png",@"4deefc054765f83613cdba6f",
                         @"Restaurants & Bars_restaurant.png",@"52960eda3cf9994f4e043ac9",
                         @"Restaurants & Bars_restaurant.png",@"52960eda3cf9994f4e043acb",
                         @"Restaurants & Bars_restaurant.png",@"52960eda3cf9994f4e043aca",
                         @"Restaurants & Bars_restaurant.png",@"52960eda3cf9994f4e043ac7",
                         @"Restaurants & Bars_restaurant.png",@"52960eda3cf9994f4e043ac8",
                         @"Restaurants & Bars_restaurant.png",@"52960eda3cf9994f4e043acc",
                         @"Restaurants & Bars_restaurant.png",@"52960eda3cf9994f4e043ac5",
                         @"Restaurants & Bars_restaurant.png",@"52960eda3cf9994f4e043ac6",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d110941735",
                         @"Restaurants & Bars_asian_food.png",@"4bf58dd8d48988d111941735",
                         @"Restaurants & Bars_juice_bar.png",@"4bf58dd8d48988d112941735",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d113941735",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d1be941735",
                         @"Restaurants & Bars_restaurant.png",@"52939a8c3cf9994f4e043a35",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d1bf941735",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d156941735",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d1c0941735",
                         @"Restaurants & Bars_mexican.png",@"4bf58dd8d48988d1c1941735",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d115941735",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d1c2941735",
                         @"Restaurants & Bars_restaurant.png",@"4eb1d5724b900d56c88a45fe",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d1c3941735",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d157941735",
                         @"Restaurants & Bars_restaurant.png",@"4eb1bfa43b7b52c0e1adc2e8",
                         @"Restaurants & Bars_pizza.png",@"4bf58dd8d48988d1ca941735",
                         @"Restaurants & Bars_restaurant.png",@"4def73e84765ae376e57713a",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d1d1941735",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d1c4941735",
                         @"Restaurants & Bars_restaurant.png",@"52960bac3cf9994f4e043ac4",
                         @"Restaurants & Bars_restaurant.png",@"5293a7563cf9994f4e043a44",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d1bd941735",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d1c5941735",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d1c6941735",
                         @"Restaurants & Bars_sea_food.png",@"4bf58dd8d48988d1ce941735",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d1c7941735",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d1dd931735",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d1cd941735",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d14f941735",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d150941735",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d14d941735",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d1cc941735",
                         @"Restaurants & Bars_sushi.png",@"4bf58dd8d48988d1d2941735",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d158941735",
                         @"Restaurants & Bars_mexican.png",@"4bf58dd8d48988d151941735",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d1db931735",
                         @"Restaurants & Bars_tea_room.png",@"4bf58dd8d48988d1dc931735",
                         @"Restaurants & Bars_asian_food.png",@"4bf58dd8d48988d149941735",
                         @"Restaurants & Bars_restaurant.png",@"4f04af1f2fb6e1c99f3db0bb",
                         @"Restaurants & Bars_restaurant.png",@"5283c7b4e4b094cb91ec88d8",
                         @"Restaurants & Bars_restaurant.png",@"5283c7b4e4b094cb91ec88d9",
                         @"Restaurants & Bars_restaurant.png",@"5283c7b4e4b094cb91ec88d4",
                         @"Restaurants & Bars_restaurant.png",@"5283c7b4e4b094cb91ec88d7",
                         @"Restaurants & Bars_restaurant.png",@"5283c7b4e4b094cb91ec88db",
                         @"Restaurants & Bars_restaurant.png",@"5283c7b4e4b094cb91ec88d6",
                         @"Restaurants & Bars_restaurant.png",@"5283c7b4e4b094cb91ec88d5",
                         @"Restaurants & Bars_restaurant.png",@"5283c7b4e4b094cb91ec88da",
                         @"Restaurants & Bars_vegeterian.png",@"4bf58dd8d48988d1d3941735",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d14a941735",
                         @"Restaurants & Bars_winery.png",@"4bf58dd8d48988d14b941735",
                         @"Restaurants & Bars_fried_chicken.png",@"4bf58dd8d48988d14c941735",
                         @"Restaurants & Bars_restaurant.png",@"512e7cae91d4cbb4e5efe0af",
                         @"Restaurants & Bars_bars.png",@"4bf58dd8d48988d116941735",
                         @"Restaurants & Bars_bars.png",@"4bf58dd8d48988d117941735",
                         @"Restaurants & Bars_bars.png",@"50327c8591d4c4b30a586d5d",
                         @"Restaurants & Bars_Cocktail.png",@"4bf58dd8d48988d11e941735",
                         @"Restaurants & Bars_bars.png",@"4bf58dd8d48988d118941735",
                         @"Restaurants & Bars_bars.png",@"4bf58dd8d48988d119941735",
                         @"Restaurants & Bars_Cocktail.png",@"4bf58dd8d48988d1d5941735",
                         @"Restaurants & Bars_bars.png",@"4bf58dd8d48988d11b941735",
                         @"Restaurants & Bars_tea_room.png",@"4bf58dd8d48988d11c941735",
                         @"Restaurants & Bars_bars.png",@"4bf58dd8d48988d1d4941735",
                         @"Restaurants & Bars_bars.png",@"4bf58dd8d48988d11d941735",
                         @"Restaurants & Bars_bars.png",@"4bf58dd8d48988d122941735",
                         @"Restaurants & Bars_winery.png",@"4bf58dd8d48988d123941735",
                         @"Restaurants & Bars_bars.png",@"4bf58dd8d48988d1ea941735",
                         @"Restaurants & Bars_café.png",@"4bf58dd8d48988d1f0941735",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d1ef931735",
                         @"Restaurants & Bars_restaurant.png",@"4bf58dd8d48988d120951735",
                         @"Restaurants & Bars_restaurant.png",@"4eb1bc533b7b2c5b1d4306cb",
                         @"Restaurants & Bars_restaurant.png",@"4f04b25d2fb6e1c99f3db0c0",
                         @"Sports & Outdoor_stadium.png",@"4bf58dd8d48988d184941735",
                         @"Sports & Outdoor_baseball.png",@"4bf58dd8d48988d18c941735",
                         @"Sports & Outdoor_basketball.png",@"4bf58dd8d48988d18b941735",
                         @"Sports & Outdoor_sport_field.png",@"4bf58dd8d48988d18a941735",
                         @"Sports & Outdoor_football.png",@"4bf58dd8d48988d189941735",
                         @"Sports & Outdoor_hockey.png",@"4bf58dd8d48988d185941735",
                         @"Sports & Outdoor_soccer.png",@"4bf58dd8d48988d188941735",
                         @"Sports & Outdoor_tennis.png",@"4e39a891bd410d7aed40cbc2",
                         @"Sports & Outdoor_track.png",@"4bf58dd8d48988d187941735",
                         @"Sports & Outdoor_gym.png",@"4bf58dd8d48988d1b2941735",
                         @"Sports & Outdoor_rec.png",@"4bf58dd8d48988d1a9941735",
                         @"Sports & Outdoor_stadium.png",@"4bf58dd8d48988d1b4941735",
                         @"Sports & Outdoor_baseball.png",@"4bf58dd8d48988d1bb941735",
                         @"Sports & Outdoor_basketball.png",@"4bf58dd8d48988d1ba941735",
                         @"Sports & Outdoor_sport_field.png",@"4bf58dd8d48988d1b9941735",
                         @"Sports & Outdoor_football.png",@"4bf58dd8d48988d1b8941735",
                         @"Sports & Outdoor_hockey.png",@"4bf58dd8d48988d1b5941735",
                         @"Sports & Outdoor_soccer.png",@"4bf58dd8d48988d1b7941735",
                         @"Sports & Outdoor_tennis.png",@"4e39a9cebd410d7aed40cbc4",
                         @"Sports & Outdoor_track.png",@"4bf58dd8d48988d1b6941735",
                         @"Sports & Outdoor_gym.png",@"4f4528bc4b90abdf24c9de85",
                         @"Sports & Outdoor_baseball.png",@"4bf58dd8d48988d1e8941735",
                         @"Sports & Outdoor_basketball.png",@"4bf58dd8d48988d1e1941735",
                         @"Sports & Outdoor_golf.png",@"4bf58dd8d48988d1e6941735",
                         @"Sports & Outdoor_hockey.png",@"4f452cd44b9081a197eba860",
                         @"Sports & Outdoor_skateboard.png",@"4bf58dd8d48988d167941735",
                         @"Sports & Outdoor_skate.png",@"4bf58dd8d48988d168941735",
                         @"Sports & Outdoor_soccer.png",@"4cce455aebf7b749d5e191f5",
                         @"Sports & Outdoor_tennis.png",@"4e39a956bd410d7aed40cbc3",
                         @"Sports & Outdoor_volleyball.png",@"4eb1bf013b7b6f98df247e07",
                         @"Sports & Outdoor_beach.png",@"4bf58dd8d48988d1e2941735",
                         @"Sports & Outdoor_beach.png",@"4bf58dd8d48988d1e3941735",
                         @"Sports & Outdoor_outdoor.png",@"4bf58dd8d48988d1e4941735",
                         @"Sports & Outdoor_outdoor.png",@"50aaa49e4b90af0d42d5de11",
                         @"Sports & Outdoor_marina.png",@"4bf58dd8d48988d1e0941735",
                         @"Sports & Outdoor_swimming_pool.png",@"4bf58dd8d48988d15e941735",
                         @"Sports & Outdoor_outdoor.png",@"50328a4b91d4c4b30a586d6b",
                         @"Sports & Outdoor_ski.png",@"4bf58dd8d48988d1e9941735",
                         @"Sports & Outdoor_ski.png",@"4bf58dd8d48988d1ec941735",
                         @"Sports & Outdoor_outdoor.png",@"4eb1baf03b7b2c5b1d4306ca",
                         @"Sports & Outdoor_outdoor.png",@"4bf58dd8d48988d159941735",
                         @"Sports & Outdoor_bike.png",@"4bf58dd8d48988d115951735",
                         @"Sports & Outdoor_beach.png",@"4bf58dd8d48988d1f1941735",
                         @"Sports & Outdoor_gym.png",@"4bf58dd8d48988d175941735",
                         @"Sports & Outdoor_gym.png",@"503289d391d4c4b30a586d6a",
                         @"Sports & Outdoor_swimming_pool.png",@"4bf58dd8d48988d105941735",
                         @"Sports & Outdoor_gym.png",@"4bf58dd8d48988d176941735",
                         @"Sports & Outdoor_gym.png",@"4bf58dd8d48988d101941735",
                         @"Sports & Outdoor_track.png",@"4bf58dd8d48988d106941735",
                         @"Sports & Outdoor_gym.png",@"4bf58dd8d48988d102941735",
                         @"Sports & Outdoor_basketball.png",@"4bf58dd8d48988d1f2941735",
                         @"Sports & Outdoor_bike.png",@"4e4c9077bd41f78e849722f9",
                         @"Travel_hotel.png",@"4bf58dd8d48988d1eb941735",
                         @"Travel_travel_agent.png",@"4f04b08c2fb6e1c99f3db0bd",
                         @"Travel_airport.png",@"4bf58dd8d48988d1ed931735",
                         @"Travel_airport.png",@"4bf58dd8d48988d1f7931735",
                         @"Travel_ferry.png",@"4bf58dd8d48988d12d951735",
                         @"Travel_bus.png",@"4bf58dd8d48988d1fe931735",
                         @"Travel_bus.png",@"4bf58dd8d48988d12b951735",
                         @"Travel_airport.png",@"4bf58dd8d48988d1f6931735",
                         @"Travel_hotel.png",@"4bf58dd8d48988d1fa931735",
                         @"Travel_hotel.png",@"4bf58dd8d48988d1f8931735",
                         @"Travel_hotel.png",@"4f4530a74b9074f6e4fb0100",
                         @"Travel_hotel.png",@"4bf58dd8d48988d1ee931735",
                         @"Sports & Outdoor_swimming_pool.png",@"4bf58dd8d48988d132951735",
                         @"Travel_hotel.png",@"4bf58dd8d48988d1fb931735",
                         @"Travel_hotel.png",@"4bf58dd8d48988d12f951735",
                         @"Travel_train.png",@"4bf58dd8d48988d1fc931735",
                         @"Travel_ferry.png",@"4e74f6cabd41c4836eac4c31",
                         @"Automotive_car_dealer.png",@"4bf58dd8d48988d1ef941735",
                         @"Travel_train.png",@"4bf58dd8d48988d1fd931735",
                         @"Automotive_automotive_shop.png",@"4bf58dd8d48988d130951735",
                         @"Travel_tourist_infospot.png",@"4f4530164b9074f6e4fb00ff",
                         @"Travel_train.png",@"4bf58dd8d48988d129951735",
                         @"Travel_train.png",@"4f4531504b9074f6e4fb0102",
                         @"Travel_train.png",@"4bf58dd8d48988d12a951735",
                         @"Other_academy.png",@"4bf58dd8d48988d1a2941735",
                         @"Other_academy.png",@"4bf58dd8d48988d1a8941735",
                         @"Other_academy.png",@"4bf58dd8d48988d1a6941735",
                         @"Other_academy.png",@"4bf58dd8d48988d1b3941735",
                         @"Other_academy.png",@"4bf58dd8d48988d1ad941735",
                         @"Other_academy.png",@"4bf58dd8d48988d1ae941735",
                         @"Other_general.png",@"4f4534884b9074f6e4fb0174",
                         @"Other_health.png",@"4bf58dd8d48988d104941735",
                         @"Other_health.png",@"4bf58dd8d48988d178941735",
                         @"Other_health.png",@"4bf58dd8d48988d177941735",
                         @"Other_health.png",@"4bf58dd8d48988d196941735",
                         @"Other_health.png",@"4f4531b14b9074f6e4fb0103",
                         @"Other_parking.png",@"4c38df4de52ce0d596b336e1",
                         @"Other_post_office.png",@"4bf58dd8d48988d172941735",
                         @"Other_academy.png",@"4f4533814b9074f6e4fb0107",
                         @"Other_general.png",@"4bf58dd8d48988d131941735",
                         @"Other_real_estate.png",@"4e67e38e036454776db1fb3a",
                         @"Other_real_estate.png",@"5032891291d4c4b30a586d68",
                         @"Other_real_estate.png",@"4bf58dd8d48988d103941735",
                         @"Other_real_estate.png",@"4f2a210c4b9023bd5841ed28",
                         @"Other_real_estate.png",@"4d954b06a243a5684965b473",
                         @"Other_bank.png",@"4bf58dd8d48988d10a951735",
                         @"Other_financial.png",@"5032850891d4c4b30a586d62",
                         @"Other_financial.png",@"503287a291d4c4b30a586d65",
                         @"Other_optics.png",@"4d954afda243a5684865b473",
                         @"Other_real_estate_agent.png",@"5032885091d4c4b30a586d66",
                         @"Other_general.png",@"4bf58dd8d48988d1de931735",
                         @"Fashion_department_store.png",@"4bf58dd8d48988d1f6941735",
                         @"Fashion_shopping_mall.png",@"4bf58dd8d48988d1f7941735",
                         @"Fashion_gift_shop.png",@"4bf58dd8d48988d128951735",
                         @"Fashion_gift_shop.png",@"4bf58dd8d48988d1fb941735",
                         @"Fashion_shopping_mall.png",@"4bf58dd8d48988d1fd941735",
                         @"Fashion_shopping_mall.png",@"50be8ee891d4fa8dcc7199a7",
                         @"Fashion_shopping_mall.png",@"4bf58dd8d48988d1ff941735",
                         @"Fashion_shopping_mall.png",@"4bf58dd8d48988d101951735",
                         
                         nil];
    
    NSString *CategoryPicture = [dic objectForKey:[NSString stringWithFormat:@"%@",string]];
    return CategoryPicture;
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

- (RKObjectMapping *)editProfileMapping
{
    RKObjectMapping *editProfileMapping = [RKObjectMapping requestMapping];
    [editProfileMapping addAttributeMappingsFromDictionary: @{
                                                              @"email" : @"email",
                                                              @"fullName" : @"full_name",
                                                              @"dateOfBirth" : @"date_of_birth",
                                                              @"gender" : @"gender",
                                                              @"about" : @"about",
                                                              @"location" : @"location",
                                                              @"username" : @"user.username",
                                                              @"photoURL" : @"photo"
                                                              }];
    return editProfileMapping;
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
                                                          @"upload_date" : @"uploadDate",
                                                          @"type" : @"type"
                                                          }];
    
    [commentMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"dealer"
                                                                                   toKeyPath:@"dealer"
                                                                                 withMapping:[self dealerMapping]]];
    
    return commentMapping;
}

- (RKObjectMapping *)addCommentMapping
{
    RKObjectMapping *addCommentMapping = [RKObjectMapping mappingForClass:[Comment class]];
    [addCommentMapping addAttributeMappingsFromDictionary: @{
                                                             @"id" : @"commentID",
                                                             @"text" : @"text",
                                                             @"deal" : @"dealID",
                                                             @"dealer" : @"dealer.dealerID",
                                                             @"upload_date" : @"uploadDate",
                                                             @"type" : @"type"
                                                             }];
    
    return addCommentMapping;
}

- (RKObjectMapping *)likedDealsMapping
{
    RKObjectMapping *likedDealsMapping = [RKObjectMapping mappingForClass:[DealAttrib class]];
    [likedDealsMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"deal"
                                                                                      toKeyPath:@"deal"
                                                                                    withMapping:[self dealMapping]]];
    
    return likedDealsMapping;
}
- (RKObjectMapping *)paginationMapping
{
    RKObjectMapping *paginationMapping = [RKObjectMapping mappingForClass:[RKPaginator class]];
    
    [paginationMapping addAttributeMappingsFromDictionary:@{
                                                            @"per_page": @"perPage",
                                                            @"total_pages": @"pageCount",
                                                            @"count": @"objectCount",
                                                            }];
    
    return paginationMapping;
}

- (RKObjectMapping *)errorMapping
{
    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[Error class]];
    
    [errorMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"email" toKeyPath:@"emailFormat"]];
    [errorMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"user" toKeyPath:@"emailExists"]];
    [errorMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"detail" toKeyPath:@"detail"]];
    
    return errorMapping;
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
    
    // adding pagination mapping
    manager.paginationMapping = [self paginationMapping];
    
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
    
    RKResponseDescriptor *signInResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:[self dealerMapping]
                                                 method:RKRequestMethodAny
                                            pathPattern:@"/dealerlogins/"
                                                keyPath:@"results"
                                            statusCodes:statusCodes];
    
    RKResponseDescriptor *uploadedDealsResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:[self dealMapping]
                                                 method:RKRequestMethodGET
                                            pathPattern:@"/uploadeddeals/:uploadeddealID/"
                                                keyPath:@"uploaded_deals"
                                            statusCodes:statusCodes];
    
    RKResponseDescriptor *likedDealsResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:[self likedDealsMapping]
                                                 method:RKRequestMethodGET
                                            pathPattern:@"/likeddeals/:likeddealID/"
                                                keyPath:@"liked_deals"
                                            statusCodes:statusCodes];
    
    RKResponseDescriptor *specificDealerResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:[self dealerMapping]
                                                 method:RKRequestMethodAny
                                            pathPattern:@"/dealers/:dealerID/"
                                                keyPath:nil
                                            statusCodes:statusCodes];
    
    RKResponseDescriptor *likersResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:[self dealerMapping]
                                                 method:RKRequestMethodAny
                                            pathPattern:@"/dealerslikeddeals/:dealerslikeddealID/"
                                                keyPath:@"dealers_that_liked"
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
    
    RKResponseDescriptor *signUpErrorResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:[self errorMapping]
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
                                               signInResponseDescriptor,
                                               uploadedDealsResponseDescriptor,
                                               likedDealsResponseDescriptor,
                                               specificDealerResponseDescriptor,
                                               likersResponseDescriptor,
                                               dealAttribResponseDescriptor,
                                               commentsResponseDescriptor,
                                               addCommentResponseDescriptor,
                                               signUpErrorResponseDescriptor
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
                                          
                                          if (permissions) {
                                              
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
                                              
                                          }
                                          
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
    
    [self saveUserDetailsOnDevice];
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
    
    [self saveUserDetailsOnDevice];
}

-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}
@end

//
//  MainViewController.m
//  GooglePlaces
//
//  Created by itzik berrebi on 9/26/13.
//
//

#import "MainViewController.h"
#import "SignUpTableViewController.h"
#import "SignInTableViewController.h"
#import "KeychainItemWrapper.h"

#define AWS_S3_BUCKET_NAME @"dealers-app"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize appDelegate;
@synthesize facebookicon;
@synthesize emailicon;
@synthesize i;
@synthesize backwhite,dealershead,dealersWhiteHead,already,signin;


- (void)viewDidLoad
{
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    firstSlogen = YES;
    
    if ([self checkIfUserLoggedIn]) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleFBSessionStateChangeWithNotification:)
                                                 name:@"SessionStateChangeNotification"
                                               object:nil];
    
    [self setProgressIndicator];
    [self createToggleSlogenButton];
    
    if (([appDelegate.Animate_first isEqualToString:@"first"]) || (appDelegate.Animate_first == nil))  {
        appDelegate.Animate_first = @"notfirst";
        signin.alpha=0.0;
        already.alpha=0.0;
        backwhite.alpha=1.0;
        dealershead.alpha=1.0;
        dealersWhiteHead.alpha = 1.0;
        dealershead.center = CGPointMake(160,(CGRectGetMidY(appDelegate.window.bounds)-dealershead.frame.size.height/2-16));
        dealersWhiteHead.center = CGPointMake(160,(CGRectGetMidY(appDelegate.window.bounds)-dealershead.frame.size.height/2-16));
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(anim2) userInfo:nil repeats:NO];
        
    } else {
        [self objectInPlace];
    }
    
    [appDelegate resetHTTPClientUsernameAndPassword];
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self stylesTransitionButton];
    
    if (appDelegate.screenShot) {
        [self.screenShot setImage:appDelegate.screenShot];
        [self setScreenShot];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.screenShot setImage:nil];
    [[self.navigationController.view viewWithTag:321321321] removeFromSuperview];
}


- (void)stylesTransitionButton {
    
    UIButton *switchStyles = [UIButton buttonWithType:UIButtonTypeCustom];
    switchStyles.tag = 321321321;
    [switchStyles setFrame:CGRectMake(0, 0, 150, 150)];
    [switchStyles addTarget:self action:@selector(switchStyle) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:switchStyles];
}

- (void)switchStyle
{
    if (self.regularView.hidden) {
        
        [UIView animateWithDuration:0.5
                         animations:^{
                             
                             self.darkCollageView.alpha = 0;
                             
                         }
                         completion:^(BOOL finished) {
                             
                             self.darkCollageView.hidden = YES;
                             self.regularView.hidden = NO;
                             self.regularView.alpha = 0;
                             [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
                             [UIView animateWithDuration:0.5 animations:^{
                                 
                                 self.regularView.alpha = 1.0;
                             }];
                         }];
        
    } else {
        
        [UIView animateWithDuration:0.5
                         animations:^{
                             
                             self.regularView.alpha = 0;
                             
                         }
                         completion:^(BOOL finished) {
                             
                             self.regularView.hidden = YES;
                             self.darkCollageView.hidden = NO;
                             self.darkCollageView.alpha = 0;
                             [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
                             [UIView animateWithDuration:0.5 animations:^{
                                 
                                 self.darkCollageView.alpha = 1.0;
                             }];
                         }];
    }
}

- (void)createToggleSlogenButton
{
    UIButton *toggleSlogen = [UIButton buttonWithType:UIButtonTypeCustom];
    [toggleSlogen setFrame:self.slogen.frame];
    [toggleSlogen addTarget:self action:@selector(toggleSlogen) forControlEvents:UIControlEventTouchUpInside];
    [self.regularView addSubview:toggleSlogen];
}

- (void)toggleSlogen
{
    if (firstSlogen) {
        
        [UIView animateWithDuration:0.3
                         animations:^{ self.slogen.alpha = 0; }
                         completion:^(BOOL finished) {
                             self.slogen.text = @"Share deals with others \nHelp reduce prices";
                             [UIView animateWithDuration:0.3
                                              animations:^{ self.slogen.alpha = 1.0;
                                              }];
                         }];
        firstSlogen = NO;
        
    } else {
        
        [UIView animateWithDuration:0.3
                         animations:^{ self.slogen.alpha = 0; }
                         completion:^(BOOL finished) {
                             self.slogen.text = @"Find great deals \nShared by people like you";
                             [UIView animateWithDuration:0.3
                                              animations:^{ self.slogen.alpha = 1.0;
                                              }];
                         }];
        firstSlogen = YES;
    }
}


#pragma mark - Opening View & Animations

- (void)objectInPlace {
    dealershead.center = CGPointMake(160, 55);
    dealersWhiteHead.center = CGPointMake(160, 75);
    facebookicon.alpha=1.0;
    emailicon.alpha=1.0;
    already.alpha=1.0;
    signin.alpha=1.0;
    backwhite.hidden = YES;
}

-(void) anim2 {
    
    [UIView animateWithDuration:1.0 animations:^{
        dealershead.center = CGPointMake(160, 55);
        dealersWhiteHead.center = CGPointMake(160, 75);
    }];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(anim) userInfo:nil repeats:NO];
}

-(void) anim {
    
    [UIView animateWithDuration:0.5 animations:^{backwhite.alpha=0.0;}];
    facebookicon.alpha=0.0;
    emailicon.alpha=0.0;
    [UIView animateWithDuration:0.5 animations:^{facebookicon.alpha=1.0;}];
    [UIView animateWithDuration:0.5 animations:^{emailicon.alpha=1.0;}];
    [UIView animateWithDuration:0.5 animations:^{already.alpha=1.0;}];
    [UIView animateWithDuration:0.5 animations:^{signin.alpha=1.0;}];
}

- (void)setScreenShot {
    self.screenShot.hidden = NO;
    [self performSelector:@selector(fadeAway) withObject:nil afterDelay:0];
}

- (void)fadeAway {
    [UIView animateWithDuration:1.0 animations:^{
        self.screenShot.center = CGPointMake(self.screenShot.center.x, self.screenShot.center.y + self.screenShot.bounds.size.height);
    } completion:^(BOOL finished) {
        self.screenShot.hidden = YES;
        self.screenShot.center = self.view.center;
    }];
}


#pragma mark - General methods

- (IBAction)EmailimageButton:(id)sender{
    SignUpTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpID"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)SigninButton:(id)sender{
    SignInTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SignInID"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)facebookButtonClicked:(id)sender{
    
    if (![appDelegate isFacebookConnected]) {
        
        [appDelegate openActiveSessionWithPermissions:@[@"public_profile", @"user_friends", @"email", @"user_birthday", @"user_location"] allowLoginUI:YES];
    }
    
    else {
        
        NSLog(@"Error - connected to facebook when suppose to be disconnected");
    }
}


- (void)setProgressIndicator
{
    UIImageView *customView = [appDelegate loadingAnimationWhite];
    [customView startAnimating];
    
    loggingInFacebook = [[MBProgressHUD alloc]initWithView:self.view];
    loggingInFacebook.delegate = self;
    loggingInFacebook.customView = customView;
    loggingInFacebook.mode = MBProgressHUDModeCustomView;
    loggingInFacebook.labelText = @"Logging In";
    loggingInFacebook.labelFont = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    loggingInFacebook.animationType = MBProgressHUDAnimationZoomIn;
    
    noConnection = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    noConnection.delegate = self;
    noConnection.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Error"]];
    noConnection.mode = MBProgressHUDModeCustomView;
    noConnection.labelText = @"Can't connect the server";
    noConnection.labelFont = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    noConnection.detailsLabelText = @"Check your connection";
    noConnection.detailsLabelFont = [UIFont fontWithName:@"Avenir-Light" size:15.0];
    noConnection.animationType = MBProgressHUDAnimationZoomIn;
    
    [self.navigationController.view addSubview:loggingInFacebook];
    [self.navigationController.view addSubview:noConnection];
}

- (BOOL)checkIfUserLoggedIn
{
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"DealersKeychain" accessGroup:nil];
    [keychain setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
    [keychain setObject:@"DealersKeychain" forKey:(__bridge id)kSecAttrService];
    
    NSString *token = [keychain objectForKey:(__bridge id)(kSecAttrAccount)];
    NSString *password = [keychain objectForKey:(__bridge id)(kSecValueData)];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *fullName = [userDefaults objectForKey:@"fullName"];
    
    if (token.length > 0 && password.length > 0 && fullName.length > 0) {
        
        [[RKObjectManager sharedManager].HTTPClient setAuthorizationHeaderWithToken:token];
        
        appDelegate.dealer = [[Dealer alloc]init];
        
        appDelegate.dealer.dealerID = [userDefaults objectForKey:@"dealerID"];
        appDelegate.dealer.email = [userDefaults objectForKey:@"email"];
        appDelegate.dealer.username = [userDefaults objectForKey:@"username"];
        appDelegate.dealer.fullName = [userDefaults objectForKey:@"fullName"];
        appDelegate.dealer.dateOfBirth = [userDefaults objectForKey:@"dateOfBirth"];
        appDelegate.dealer.gender = [userDefaults objectForKey:@"gender"];
        appDelegate.dealer.registerDate = [userDefaults objectForKey:@"registerDate"];
        appDelegate.dealer.location = [userDefaults objectForKey:@"location"];
        appDelegate.dealer.about = [userDefaults objectForKey:@"about"];
        appDelegate.dealer.photoURL = [userDefaults objectForKey:@"photoURL"];
        appDelegate.dealer.uploadedDeals = [NSMutableArray arrayWithArray:[userDefaults objectForKey:@"uploadedDeals"]];
        appDelegate.dealer.likedDeals = [NSMutableArray arrayWithArray:[userDefaults objectForKey:@"likedDeals"]];
        appDelegate.dealer.sharedDeals = [NSMutableArray arrayWithArray:[userDefaults objectForKey:@"sharedDeals"]];
        appDelegate.dealer.followedBy = [NSMutableArray arrayWithArray:[userDefaults objectForKey:@"followedBy"]];
        appDelegate.dealer.followings = [NSMutableArray arrayWithArray:[userDefaults objectForKey:@"followings"]];
        appDelegate.dealer.badReportsCounter = [userDefaults objectForKey:@"badReportsCounter"];
        appDelegate.dealer.score = [userDefaults objectForKey:@"score"];
        appDelegate.dealer.rank = [userDefaults objectForKey:@"rank"];
        appDelegate.dealer.reliability = [userDefaults objectForKey:@"reliability"];
        appDelegate.dealer.facebookPseudoUserID = [userDefaults objectForKey:@"facebookPseudoUserID"];
        
        if (appDelegate.dealer.photoURL.length > 1 && ![appDelegate.dealer.photoURL isEqualToString:@"None"]) {
            appDelegate.dealer.photo = [appDelegate loadProfilePic];
        }
        
        [appDelegate setTabBarController];
        
        return YES;
        
    } else {
        
        if ([appDelegate isFacebookConnected] || [FBSession activeSession].state == FBSessionStateCreatedTokenLoaded) {
            [[FBSession activeSession] closeAndClearTokenInformation];
        }
        
        return NO;
    }
}


#pragma mark - Facebook

- (void)handleFBSessionStateChangeWithNotification:(NSNotification *)notification
{
    // Get the session, state and error values from the notification's userInfo dictionary.
    NSDictionary *userInfo = [notification userInfo];
    
    FBSessionState sessionState = [[userInfo objectForKey:@"state"] integerValue];
    NSError *error = [userInfo objectForKey:@"error"];
    
    [loggingInFacebook show:YES];
    
    if (!error) {
        
        // In case that there's not any error, then check if the session is opened or closed.
        
        if ([appDelegate isFacebookConnected]) {
            
            // The session is open. Get the user information and check if the user already exists by signing him up.
            
            [FBRequestConnection startWithGraphPath:@"me"
                                         parameters:@{@"fields": @"first_name, last_name, gender, birthday, picture.type(large), location, email"}
                                         HTTPMethod:@"GET"
                                  completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                      
                                      if (!error) {
                                          
                                          FBSession *session = [userInfo objectForKey:@"session"];
                                          facebookToken = session.accessTokenData.accessToken;
                                          facebookInfo = (FBGraphObject *)result;
                                          facebookUserEmail = [result objectForKey:@"email"];
                                          
                                          [self signUpUser];
                                          
                                      } else {
                                          
                                          NSLog(@"%@", [error localizedDescription]);
                                          [loggingInFacebook hide:YES];
                                      }
                                  }];
            
        } else if (sessionState == FBSessionStateClosed || sessionState == FBSessionStateClosedLoginFailed){
            
            // A session was closed or the login was failed or canceled. Update the UI accordingly.
            
            [loggingInFacebook hide:YES];
        }
        
    } else {
        
        // In case an error has occured, then just log the error and update the UI accordingly.
        NSLog(@"Error: %@", [error localizedDescription]);
        [loggingInFacebook hide:YES];
    }
}

- (void)signUpUser
{
    self.dealer = [appDelegate updateDealer:nil withFacebookInfo:facebookInfo withPhoto:YES];
    
    [[RKObjectManager sharedManager].HTTPClient setAuthorizationHeaderWithUsername:@"ubuntu" password:@"09"];
    [[RKObjectManager sharedManager] postObject:self.dealer
                                           path:@"/dealers/"
                                     parameters:nil
                                        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                            
                                            NSLog(@"Dealer signed up with Facebook successfuly!");
                                            
                                            appDelegate.dealer = mappingResult.firstObject;
                                            appDelegate.dealer.photo = self.dealer.photo;
                                            
                                            if (appDelegate.dealer.photo) {
                                                [self uploadPhoto];
                                            } else {
                                                [self enterDealers];
                                            }
                                        }
     
                                        failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                            
                                            Error *errors = [[[error userInfo] objectForKey:RKObjectMapperErrorObjectsKey] lastObject];
                                            NSLog(@"%@", [errors messagesString]);
                                            
                                            if ([[errors messagesString] isEqualToString:@"Email already exists!"]) {
                                                
                                                // User already exists, need to get him a token, download his info and get him in
                                                [self createPseudoUserForToken];
                                                
                                            } else {
                                                
                                                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Couldn't sign up..."
                                                                                               message:[NSString stringWithFormat:@"\n%@", [errors messagesString]]
                                                                                              delegate:nil
                                                                                     cancelButtonTitle:@"OK"
                                                                                     otherButtonTitles:nil];
                                                [alert show];
                                                [loggingInFacebook hide:YES];
                                            }
                                        }];
}

- (void)createPseudoUserForToken
{
    self.pseudoUser = [[User alloc]init];
    self.pseudoUser.username = [NSString stringWithFormat:@"fb_%@", self.dealer.email];
    self.pseudoUser.userPassword = [NSString stringWithFormat:@"pass_%@_key", self.dealer.fullName];
    
    if (triedAddingNumber) {
        self.pseudoUser.username = [NSString stringWithFormat:@"fb_2_%@", self.dealer.email];
    }
    
    if (self.pseudoUser.username.length > 30) {
        self.pseudoUser.username = [self.pseudoUser.username substringToIndex:30];
    }
    
    [[RKObjectManager sharedManager] postObject:self.pseudoUser
                                           path:@"/users/"
                                     parameters:nil
                                        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                            
                                            NSLog(@"Pseudo user created successfully!");
                                            [self getTokenForUser:self.pseudoUser];
                                            User *user = mappingResult.firstObject;
                                            pseudoUserID = user.userID;
                                        }
                                        failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                            
                                            NSLog(@"Pseudo user couldn't be created...");
                                            Error *errors = [[[error userInfo] objectForKey:RKObjectMapperErrorObjectsKey] lastObject];
                                            
                                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Couldn't sign in with facebook"
                                                                                           message:@"Pleae try again later"
                                                                                          delegate:nil
                                                                                 cancelButtonTitle:@"OK"
                                                                                 otherButtonTitles:nil];
                                            
                                            if ([[errors messagesString] isEqualToString:@"Pseudo user already exists"]) {
                                                
                                                if (!triedAddingNumber) {
                                                    triedAddingNumber = YES;
                                                    [self createPseudoUserForToken];
                                                } else {
                                                    [alert show];
                                                    [loggingInFacebook hide:YES];
                                                    [[FBSession activeSession] closeAndClearTokenInformation];
                                                }
                                                
                                            } else {
                                                
                                                [alert show];
                                                [loggingInFacebook hide:YES];
                                                [[FBSession activeSession] closeAndClearTokenInformation];
                                            }
                                        }];
}

- (void)uploadPhoto
{
    NSString *photoFileName = [NSString stringWithFormat:@"%@_%@.jpg", appDelegate.dealer.email, [NSDate date]];
    
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    
    NSString *key = appDelegate.dealer.photoURL;
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:photoFileName];
    [appDelegate.dealer.photo writeToFile:filePath atomically:YES];
    
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
    uploadRequest.bucket = AWS_S3_BUCKET_NAME;
    uploadRequest.key = key;
    uploadRequest.body = fileURL;
    
    [[transferManager upload:uploadRequest] continueWithExecutor:[BFExecutor mainThreadExecutor]
                                                       withBlock:^id(BFTask *task) {
                                                           if (task.error) {
                                                               if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
                                                                   switch (task.error.code) {
                                                                           
                                                                       case AWSS3TransferManagerErrorCancelled:
                                                                           NSLog(@"Profile photo upload cancelled");
                                                                           break;
                                                                           
                                                                       case AWSS3TransferManagerErrorPaused:
                                                                           NSLog(@"Profile photo upload paused");
                                                                           break;
                                                                           
                                                                       default:
                                                                           NSLog(@"Error: %@", task.error);
                                                                           break;
                                                                   }
                                                               } else {
                                                                   // Unknown error. Try again at least once
                                                                   NSLog(@"Error: %@", task.error);
                                                                   if (!triedUploadingPhoto) {
                                                                       triedUploadingPhoto = YES;
                                                                       [self uploadPhoto];
                                                                   }
                                                               }
                                                           }
                                                           
                                                           if (task.result) {
                                                               
                                                               NSLog(@"Profile photo uploaded successfuly!");
                                                               didPhotoFinishedUploading = YES;
                                                               if (gotToken) {
                                                                   [self enterDealers];
                                                               } else {
                                                                   [self getTokenForUser:appDelegate.dealer];
                                                               }
                                                           }
                                                           return nil;
                                                       }];
}

- (void)downloadUesrPhoto
{
    NSString *downloadingFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"downloaded_image_%@.jpg", appDelegate.dealer.dealerID]];
    NSURL *downloadingFileURL = [NSURL fileURLWithPath:downloadingFilePath];
    
    AWSS3TransferManagerDownloadRequest *downloadRequest = [AWSS3TransferManagerDownloadRequest new];
    
    downloadRequest.bucket = AWS_S3_BUCKET_NAME;
    downloadRequest.key = appDelegate.dealer.photoURL;
    downloadRequest.downloadingFileURL = downloadingFileURL;
    
    [[[AWSS3TransferManager defaultS3TransferManager] download:downloadRequest] continueWithExecutor:[BFExecutor mainThreadExecutor]
                                                                                           withBlock:^id(BFTask *task) {
                                                                                               
                                                                                               if (task.error){
                                                                                                   if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
                                                                                                       switch (task.error.code) {
                                                                                                           case AWSS3TransferManagerErrorCancelled:
                                                                                                           case AWSS3TransferManagerErrorPaused:
                                                                                                               break;
                                                                                                               
                                                                                                           default:
                                                                                                               NSLog(@"Error: %@", task.error);
                                                                                                               break;
                                                                                                       }
                                                                                                   } else {
                                                                                                       // Unknown error.
                                                                                                       NSLog(@"Error: %@", task.error);
                                                                                                       
                                                                                                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't Sign In" message:@"Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                                                                       [alert show];
                                                                                                       
                                                                                                       [[FBSession activeSession] closeAndClearTokenInformation];
                                                                                                       [appDelegate deletePseudoUser];
                                                                                                       
                                                                                                       [loggingInFacebook hide:YES];
                                                                                                   }
                                                                                               }
                                                                                               
                                                                                               if (task.result) {
                                                                                                   
                                                                                                   appDelegate.dealer.photo = [NSData dataWithContentsOfFile:downloadingFilePath];
                                                                                                   appDelegate.dealer = [appDelegate updateDealer:appDelegate.dealer withFacebookInfo:facebookInfo withPhoto:YES];
                                                                                                   [self enterDealers];
                                                                                                   
                                                                                               }
                                                                                               return nil;
                                                                                           }];
}

- (void)getTokenForUser:(id)user
{
    NSString *username;
    NSString *password;
    BOOL newDealer;
    
    if ([user isMemberOfClass:[Dealer class]]) {
        username = appDelegate.dealer.username;
        password = appDelegate.dealer.userPassword;
        newDealer = YES;
        
    } else {
        username = self.pseudoUser.username;
        password = self.pseudoUser.userPassword;
        newDealer = NO;
    }
    
    NSDictionary *parameters = @{@"username": username,
                                 @"password": password
                                 };
    
    AFHTTPClient* client = [AFHTTPClient clientWithBaseURL:[RKObjectManager sharedManager].baseURL];
    [client setAuthorizationHeaderWithUsername:username password:password];
    [client postPath:@"/dealers-token-auth/"
          parameters:parameters
             success:^(AFHTTPRequestOperation *operation, id result) {

                 
                 NSError *error;
                 NSDictionary *tokenDictionary = [NSJSONSerialization JSONObjectWithData:result
                                                                                 options:kNilOptions
                                                                                   error:&error];
                 NSString *token = [tokenDictionary objectForKey:@"token"];
                 [[RKObjectManager sharedManager].HTTPClient setAuthorizationHeaderWithToken:token];
                 
                 KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc]initWithIdentifier:@"DealersKeychain" accessGroup:nil];
                 [keychain setObject:@"DealersKeychain" forKey:(__bridge id)kSecAttrService];
                 [keychain setObject:token forKey:(__bridge id)(kSecAttrAccount)];
                 [keychain setObject:password forKey:(__bridge id)(kSecValueData)];
                 
                 gotToken = YES;
                 
                 if (newDealer) {
                     [self enterDealers];
                 } else {
                     [self getDealerInfo];
                 }
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 
                 NSLog(@"\n\nFailed to fetch token. Error: %@", error.localizedDescription);
             }];
}

- (void)getDealerInfo
{
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/dealerfbs/"
                                           parameters:@{@"email" : self.dealer.email}
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  NSLog(@"Dealer's info downloaded successfully!");
                                                  
                                                  self.appDelegate.dealer = mappingResult.firstObject;
                                                  
                                                  self.appDelegate.dealer.facebookPseudoUserID = pseudoUserID;
                                                  
                                                  if (appDelegate.dealer.photoURL.length > 2 && ![appDelegate.dealer.photoURL isEqualToString:@"None"]) {
                                                      [self downloadUesrPhoto];
                                                  } else {
                                                      appDelegate.dealer = [appDelegate updateDealer:appDelegate.dealer withFacebookInfo:facebookInfo withPhoto:YES];
                                                      [self uploadPhoto];
                                                  }
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  
                                                  NSLog(@"Dealer's info downloaded couldn't be downloaded...");
                                                  [[FBSession activeSession] closeAndClearTokenInformation];
                                                  [appDelegate deletePseudoUser];
                                              }];
}

- (void)enterDealers
{
    [loggingInFacebook hide:YES];
    [appDelegate saveUserDetailsOnDevice];
    [appDelegate setTabBarController];
}


@end

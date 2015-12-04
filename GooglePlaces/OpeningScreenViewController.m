//
//  MainViewController.m
//  GooglePlaces
//
//  Created by itzik berrebi on 9/26/13.
//
//

#import "OpeningScreenViewController.h"
#import "SignUpTableViewController.h"
#import "SignInTableViewController.h"
#import "KeychainItemWrapper.h"

#define AWS_S3_BUCKET_NAME @"dealers-app"

@interface OpeningScreenViewController ()

@end

@implementation OpeningScreenViewController

@synthesize appDelegate;
@synthesize i;
@synthesize logo,alreadyHaveAccount;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    if ([self checkIfUserLoggedIn]) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleFBSessionStateChangeWithNotification:)
                                                 name:@"SessionStateChangeNotification"
                                               object:nil];
    
    self.authorized = [self isAuthorized];
    [self setProgressIndicator];
    [self styleButtons];
    [self setCenterYConstraint];
    
    if (([appDelegate.Animate_first isEqualToString:@"first"]) || (appDelegate.Animate_first == nil))  {
        appDelegate.Animate_first = @"notfirst";
        self.slogen.alpha = 0;
        self.facebook.alpha = 0;
        self.email.alpha = 0;
        alreadyHaveAccount.alpha = 0;
        [self.view removeConstraint:self.topLogoConstraint];
        [self.view addConstraint:self.centerYLogoConstraint];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(anim2) userInfo:nil repeats:NO];
    }
    
    [appDelegate resetHTTPClientUsernameAndPassword];
    self.screenName = @"Opening Screen";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (appDelegate.screenShot) {
        screenshot = appDelegate.screenShot;
        [self setScreenShot];
    }
    
    [appDelegate removeTabBar];
}

- (void)styleButtons
{
    self.facebook.layer.cornerRadius = 8.0;
    self.facebook.layer.masksToBounds = YES;
    self.email.layer.cornerRadius = 8.0;
    self.email.layer.masksToBounds = YES;
    
    if (![[[NSBundle mainBundle] preferredLocalizations].firstObject isEqualToString:@"en"]) {
        
        NSDictionary *attributesFirstPart = @{ NSFontAttributeName: [UIFont fontWithName:@"Avenir-Roman" size:17.0] };
        NSDictionary *attributesSecondPart = @{ NSFontAttributeName: [UIFont fontWithName:@"Avenir-Heavy" size:17.0] };
        
        NSString *already = NSLocalizedString(@"Already have an account? ", nil);
        NSString *signIn = NSLocalizedString(@"Sign in", nil);
        
        NSAttributedString *attrAlready = [[NSAttributedString alloc] initWithString:already attributes:attributesFirstPart];
        NSAttributedString *attrSignIn = [[NSAttributedString alloc] initWithString:signIn attributes:attributesSecondPart];
        
        NSMutableAttributedString *signInTitleAttrString = [[NSMutableAttributedString alloc] initWithAttributedString:attrAlready];
        [signInTitleAttrString appendAttributedString:attrSignIn];
        
        [self.alreadyHaveAccount setAttributedTitle:signInTitleAttrString forState:UIControlStateNormal];
    }
}

- (void)setCenterYConstraint
{
    self.centerYLogoConstraint = [NSLayoutConstraint constraintWithItem:self.logo
                                                              attribute:NSLayoutAttributeCenterY
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeCenterY
                                                             multiplier:1.0
                                                               constant:-40.0];
}


#pragma mark - Opening View & Animations

- (void)anim2
{
    [self.view layoutIfNeeded];
    
    [self.view removeConstraint:self.centerYLogoConstraint];
    [self.view addConstraint:self.topLogoConstraint];
    
    [UIView animateWithDuration:1.0
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.5 animations:^{
                             self.slogen.alpha = 1.0;
                             self.facebook.alpha = 1.0;
                             self.email.alpha = 1.0;
                             alreadyHaveAccount.alpha = 1.0;
                         }];
                     }];
}

- (void)setScreenShot {
    [self.view addSubview:screenshot];
    [self performSelector:@selector(fadeAway) withObject:nil afterDelay:0];
}

- (void)fadeAway {
    [UIView animateWithDuration:1.0
                     animations:^{
                         CGRect screenshotFrame = screenshot.frame;
                         screenshotFrame.origin.y = [UIScreen mainScreen].bounds.size.height;
                         screenshot.frame = screenshotFrame;
                     }
                     completion:^(BOOL finished) {
                         [screenshot removeFromSuperview];
                     }];
}


#pragma mark - General methods

- (IBAction)continueWithFacebook:(id)sender
{
    [appDelegate logButtonPress:@"Continue with Facebook"];
    [self startFacebookLogin];
}

- (IBAction)signUpWithEmail:(id)sender
{
    SignUpTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpID"];
    
    if (self.authorized) {
        [self.navigationController pushViewController:controller animated:YES];
        
    } else {
        EnterPasscodeViewController *epvc = [self.storyboard instantiateViewControllerWithIdentifier:@"EnterPasscode"];
        epvc.navigationControllerDelegate = self.navigationController;
        epvc.signUp = YES;
        [self.navigationController presentViewController:epvc animated:YES completion:nil];
    }
}

- (IBAction)signIn:(id)sender
{
    SignInTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SignInID"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)startFacebookLogin
{
    if (![appDelegate isFacebookConnected]) {
        [appDelegate openActiveSessionWithPermissions:@[@"public_profile", @"user_friends", @"email", @"user_birthday", @"user_location"] allowLoginUI:YES];
        
    } else {
        NSLog(@"Error - connected to facebook when suppose to be disconnected");
    }
}

- (void)cancelFacebookLogin
{
    [loggingInFacebook hide:YES];
    [[FBSession activeSession] closeAndClearTokenInformation];
    facebookInfo = nil;
    facebookUserEmail = nil;
    facebookUserID = nil;
}

- (BOOL)isAuthorized
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL authorized = [userDefaults boolForKey:@"authorized"];
    return authorized;
}

- (void)setProgressIndicator
{
    UIImageView *customView = [appDelegate loadingAnimationWhite];
    [customView startAnimating];
    
    loggingInFacebook = [[MBProgressHUD alloc] initWithView:self.view];
    loggingInFacebook.delegate = self;
    loggingInFacebook.customView = customView;
    loggingInFacebook.mode = MBProgressHUDModeCustomView;
    loggingInFacebook.labelText = NSLocalizedString(@"Logging In", nil);
    loggingInFacebook.labelFont = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    loggingInFacebook.animationType = MBProgressHUDAnimationZoomIn;
    
    noConnection = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    noConnection.delegate = self;
    noConnection.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Error"]];
    noConnection.mode = MBProgressHUDModeCustomView;
    noConnection.labelText = NSLocalizedString(@"Can't connect the server", nil);
    noConnection.labelFont = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    noConnection.detailsLabelText = NSLocalizedString(@"Check your connection", nil);
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
        
        appDelegate.userWasLoggedIn = YES;
        
        [[RKObjectManager sharedManager].HTTPClient setAuthorizationHeaderWithToken:token];
        
        appDelegate.dealer = [[Dealer alloc] init];
        
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
        appDelegate.dealer.invitationCounter = [userDefaults objectForKey:@"invitationCounter"];
        appDelegate.dealer.screenCounters = [self screenCounters:userDefaults];
        
        if (appDelegate.dealer.photoURL.length > 1 && ![appDelegate.dealer.photoURL isEqualToString:@"None"]) {
            appDelegate.dealer.photo = [appDelegate loadProfilePic];
        }
        
        [appDelegate intercomSuccessfulLogin];
        [appDelegate setTabBarController];
        
        return YES;
        
    } else {
        
        appDelegate.userWasLoggedIn = NO;
        
        if ([appDelegate isFacebookConnected] || [FBSession activeSession].state == FBSessionStateCreatedTokenLoaded) {
            [[FBSession activeSession] closeAndClearTokenInformation];
        }
        
        return NO;
    }
}

- (ScreenCounters *)screenCounters:(NSUserDefaults *)userDefaults
{
    ScreenCounters *counters = [[ScreenCounters alloc] initWithDealer:appDelegate.dealer.dealerID];
    counters.screenCountersID = [userDefaults objectForKey:@"screenCountersID"];
    counters.myFeed = [userDefaults objectForKey:@"myFeedCounter"];
    counters.explore = [userDefaults objectForKey:@"exploreCounter"];
    counters.profile = [userDefaults objectForKey:@"profileCounter"];
    counters.activity = [userDefaults objectForKey:@"activityCounter"];
    counters.whereIsTheDealLocal = [userDefaults objectForKey:@"whereIsTheDealLocalCounter"];
    counters.whereIsTheDealOnline = [userDefaults objectForKey:@"whereIsTheDealOnlineCounter"];
    counters.whatIsTheDealLocal = [userDefaults objectForKey:@"whatIsTheDealLocalCounter"];
    counters.whatIsTheDealOnline = [userDefaults objectForKey:@"whatIsTheDealOnlineCounter"];
    counters.haveMoreDetails = [userDefaults objectForKey:@"haveMoreDetailsCounter"];
    counters.viewDeal = [userDefaults objectForKey:@"viewDealCounter"];
    
    return counters;
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
                                         parameters:@{@"fields": @"first_name, last_name, email, gender, birthday, picture.type(large), location"}
                                         HTTPMethod:@"GET"
                                  completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                      
                                      if (!error) {
                                          facebookInfo = (FBGraphObject *)result;
                                          if ([result objectForKey:@"email"]) {
                                              facebookUserEmail = [result objectForKey:@"email"];
                                          } else {
                                              facebookUserID = [result objectForKey:@"id"];
                                          }
                                          
                                          [self checkIfUserExists];
                                          
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

- (void)checkIfUserExists
{
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [manager.HTTPClient setAuthorizationHeaderWithUsername:@"ubuntu" password:@"090909deal"];
    NSString *path = @"/dealerfbs/";
    NSDictionary *parameters;
    if (facebookUserEmail) {
        parameters = @{ @"user__username" : facebookUserEmail };
    } else {
        parameters = @{ @"user__username" : facebookUserID };
    }
    
    
    [manager getObjectsAtPath:path
                   parameters:parameters
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          
                          Dealer *dealer = mappingResult.firstObject;
                          
                          if (dealer.dealerID) {
                              
                              // User exists. Save his details, create a pseudo user and sign him in.
                              
                              appDelegate.dealer = dealer;
                              
                              if (appDelegate.dealer.photoURL.length > 2 && ![appDelegate.dealer.photoURL isEqualToString:@"None"]) {
                                  [self downloadUserPhoto];
                              } else {
                                  appDelegate.dealer = [appDelegate updateDealer:appDelegate.dealer withFacebookInfo:facebookInfo withPhoto:YES];
                                  [self uploadPhoto];
                              }
                              
                              [self createPseudoUserForToken];
                              
                          } else {
                              
                              // User does not exist. Check if he is authorized, if so sign him up.
                              if (self.authorized) {
                                  [self signUpUser];
                              } else {
                                  EnterPasscodeViewController *epvc = [self.storyboard instantiateViewControllerWithIdentifier:@"EnterPasscode"];
                                  epvc.navigationControllerDelegate = self.navigationController;
                                  epvc.facebook = YES;
                                  [self.navigationController presentViewController:epvc animated:YES completion:nil];
                              }
                          }
                      }
                      failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          
                          NSLog(@"Couldn't check if user exists...");
                          [loggingInFacebook hide:YES];
                          [[FBSession activeSession] closeAndClearTokenInformation];
                      }];
}

- (void)signUpUser
{
    self.dealer = [appDelegate updateDealer:nil withFacebookInfo:facebookInfo withPhoto:YES];
    
    [[RKObjectManager sharedManager] postObject:self.dealer
                                           path:@"/dealers/"
                                     parameters:nil
                                        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                            
                                            NSLog(@"Dealer signed up with Facebook successfuly!");
                                            signedUp = YES;
                                            
                                            appDelegate.dealer = mappingResult.firstObject;
                                            appDelegate.dealer.photo = self.dealer.photo;
                                            
                                            if (appDelegate.dealer.photo) {
                                                [self uploadPhoto];
                                            }
                                            
                                            [self getTokenForUser:appDelegate.dealer];
                                        }
     
                                        failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                            
                                            Error *errors = [[[error userInfo] objectForKey:RKObjectMapperErrorObjectsKey] lastObject];
                                            NSLog(@"%@", [errors messagesString]);
                                            
                                            if ([[errors messagesString] isEqualToString:NSLocalizedString(@"Email already exists!", nil)]) {
                                                
                                                // User already exists, and for some reason it wasn't been detected earlier...
                                                [self createPseudoUserForToken];
                                                
                                            } else {
                                                
                                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Couldn't sign up...", nil)
                                                                                                message:[NSString stringWithFormat:@"\n%@", [errors messagesString]]
                                                                                               delegate:nil
                                                                                      cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                                                      otherButtonTitles:nil];
                                                [alert show];
                                                [loggingInFacebook hide:YES];
                                            }
                                        }];
}

- (void)createPseudoUserForToken
{
    self.pseudoUser = [[User alloc] init];
    self.pseudoUser.username = [self setUsernameString];
    if (facebookUserEmail) {
        self.pseudoUser.userPassword = [NSString stringWithFormat:@"pass_%@_key", facebookUserEmail];
    } else {
        self.pseudoUser.userPassword = [NSString stringWithFormat:@"pass_%@_key", facebookUserID];
    }
    
    [[RKObjectManager sharedManager] postObject:self.pseudoUser
                                           path:@"/users/"
                                     parameters:nil
                                        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                            
                                            NSLog(@"Pseudo user created successfully!");
                                            User *user = mappingResult.firstObject;
                                            appDelegate.dealer.facebookPseudoUserID = user.userID;
                                            [self getTokenForUser:self.pseudoUser];
                                        }
                                        failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                            
                                            NSLog(@"Pseudo user couldn't be created...");
                                            Error *errors = [[[error userInfo] objectForKey:RKObjectMapperErrorObjectsKey] lastObject];
                                            NSLog(@"Error: %@", errors);
                                            
                                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Couldn't sign in with facebook", nil)
                                                                                           message:NSLocalizedString(@"Pleae try again later", nil)
                                                                                          delegate:nil
                                                                                 cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                                                 otherButtonTitles:nil];
                                            
                                            [alert show];
                                            [loggingInFacebook hide:YES];
                                            appDelegate.dealer = nil;
                                            [[FBSession activeSession] closeAndClearTokenInformation];
                                        }];
}

- (NSString *)setUsernameString
{
    NSString *usernameString;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.timeStyle = NSDateFormatterMediumStyle;
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    dateString = [dateString stringByReplacingOccurrencesOfString:@" " withString:@""];
    dateString = [dateString stringByReplacingOccurrencesOfString:@"/" withString:@""];
    dateString = [dateString stringByReplacingOccurrencesOfString:@":" withString:@""];
    dateString = [dateString stringByReplacingOccurrencesOfString:@"," withString:@"_"];
    if (facebookUserEmail) {
        NSString *emailFirstPart = [facebookUserEmail componentsSeparatedByString:@"@"].firstObject;
        usernameString = [NSString stringWithFormat:@"%@_%@", dateString, emailFirstPart];
    } else {
        usernameString = [NSString stringWithFormat:@"%@_%@", dateString, facebookUserID];
    }
    
    if (usernameString.length > 30) {
        usernameString = [usernameString substringToIndex:30];
    }
    
    return usernameString;
}

- (void)uploadPhoto
{
    NSString *photoFileName = [NSString stringWithFormat:@"%@_%f.jpg", appDelegate.dealer.email, [[NSDate date] timeIntervalSince1970]];
    
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    
    NSString *key = appDelegate.dealer.photoURL;
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:photoFileName];
    [appDelegate.dealer.photo writeToFile:filePath atomically:YES];
    
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
    uploadRequest.bucket = AWS_S3_BUCKET_NAME;
    uploadRequest.key = key;
    uploadRequest.body = fileURL;
    
    [[transferManager upload:uploadRequest] continueWithExecutor:[AWSExecutor mainThreadExecutor]
                                                       withBlock:^id(AWSTask *task) {
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
                                                               }
                                                           }
                                                           return nil;
                                                       }];
}

- (void)downloadUserPhoto
{
    NSString *downloadingFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"downloaded_image_%@.jpg", appDelegate.dealer.dealerID]];
    NSURL *downloadingFileURL = [NSURL fileURLWithPath:downloadingFilePath];
    
    AWSS3TransferManagerDownloadRequest *downloadRequest = [AWSS3TransferManagerDownloadRequest new];
    
    downloadRequest.bucket = AWS_S3_BUCKET_NAME;
    downloadRequest.key = appDelegate.dealer.photoURL;
    downloadRequest.downloadingFileURL = downloadingFileURL;
    
    [[[AWSS3TransferManager defaultS3TransferManager] download:downloadRequest] continueWithExecutor:[AWSExecutor mainThreadExecutor]
                                                                                           withBlock:^id(AWSTask *task) {
                                                                                               
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
                                                                                                       
                                                                                                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Couldn't Sign In", nil) message:NSLocalizedString(@"Please try again", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
                                                                                                       [alert show];
                                                                                                       
                                                                                                       [[FBSession activeSession] closeAndClearTokenInformation];
                                                                                                       [appDelegate deletePseudoUser];
                                                                                                       
                                                                                                       [loggingInFacebook hide:YES];
                                                                                                   }
                                                                                               }
                                                                                               
                                                                                               if (task.result) {
                                                                                                   
                                                                                                   didPhotoFinishedDownloading = YES;
                                                                                                   
                                                                                                   appDelegate.dealer.photo = [NSData dataWithContentsOfFile:downloadingFilePath];
                                                                                                   appDelegate.dealer = [appDelegate updateDealer:appDelegate.dealer withFacebookInfo:facebookInfo withPhoto:YES];
                                                                                                   if (gotToken) {
                                                                                                       [self enterDealers];
                                                                                                   }
                                                                                               }
                                                                                               return nil;
                                                                                           }];
}

- (void)getTokenForUser:(id)user
{
    NSString *username;
    NSString *password;
    
    if ([user isMemberOfClass:[Dealer class]]) {
        username = appDelegate.dealer.username;
        password = appDelegate.dealer.userPassword;
        
    } else {
        username = self.pseudoUser.username;
        password = self.pseudoUser.userPassword;
    }
    
    NSDictionary *parameters = @{@"username": username,
                                 @"password": password
                                 };
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[RKObjectManager sharedManager].baseURL];
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
                 [keychain setObject:token forKey:(__bridge id)(kSecAttrAccount)];
                 [keychain setObject:password forKey:(__bridge id)(kSecValueData)];
                 
                 gotToken = YES;
                 
                 if (appDelegate.dealer.photoURL.length > 2 && ![appDelegate.dealer.photoURL isEqualToString:@"None"] && didPhotoFinishedDownloading) {
                     [self enterDealers];
                 } else if (didPhotoFinishedUploading) {
                     [self enterDealers];
                 }
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 
                 NSLog(@"\n\nFailed to fetch token. Error: %@", error.localizedDescription);
             }];
}

- (void)enterDealers
{
    [loggingInFacebook hide:YES];
    [appDelegate intercomSuccessfulLogin];
    
    if (signedUp) {
        PersonalizeTableViewController *ptvc = [self.storyboard instantiateViewControllerWithIdentifier:@"Personalize"];
        ptvc.afterSignUp = YES;
        [self.navigationController pushViewController:ptvc animated:YES];

    } else {
        [appDelegate setTabBarController];
        [appDelegate saveUserDetailsOnDevice];
    }
}


@end

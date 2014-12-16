//
//  MainViewController.m
//  GooglePlaces
//
//  Created by itzik berrebi on 9/26/13.
//
//

#import "MainViewController.h"
#import "Signup2ViewController.h"
#import "SignInTableViewController.h"
#import "KeychainItemWrapper.h"

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
    
    if ([self checkIfUserLoggedIn]) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleFBSessionStateChangeWithNotification:)
                                                 name:@"SessionStateChangeNotification"
                                               object:nil];
    
    [self setProgressIndicator];
    
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

-(IBAction)EmailimageButton:(id)sender{
    Signup2ViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Signup2ViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

-(IBAction)SigninButton:(id)sender{
    SignInTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SignInID"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)facebookButtonClicked:(id)sender{
    
    if (![appDelegate isFacebookConnected]) {
        
        [appDelegate openActiveSessionWithPermissions:@[@"public_profile", @"user_friends", @"email"] allowLoginUI:YES];
    }
    
    else {
        
        NSLog(@"Error - connected to facebook when suppose to be disconnected");
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.screenShot setImage:nil];
    [[self.navigationController.view viewWithTag:321321321] removeFromSuperview];
}

-(int) isIphone5 {
    if ([[UIScreen mainScreen] bounds].size.height == 568) return 1;
    return 0;
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
        
        if (appDelegate.dealer.photoURL.length > 1 && ![appDelegate.dealer.photoURL isEqualToString:@"None"]) {
            appDelegate.dealer.photo = [appDelegate loadProfilePic];
        }
        
        [appDelegate setTabBarController];
        
        return YES;
        
    } else {
        
        return NO;
    }
}

- (void)handleFBSessionStateChangeWithNotification:(NSNotification *)notification
{
    // Get the session, state and error values from the notification's userInfo dictionary.
    NSDictionary *userInfo = [notification userInfo];
    
    FBSessionState sessionState = [[userInfo objectForKey:@"state"] integerValue];
    NSError *error = [userInfo objectForKey:@"error"];
    
    [loggingInFacebook show:YES];
    
    if (!error) {
        
        // In case that there's not any error, then check if the session opened or closed.
        
        if ([appDelegate isFacebookConnected]) {
            
            // The session is open. Get the user information and check if the user already exists.
            
            [FBRequestConnection startWithGraphPath:@"me"
                                         parameters:@{@"fields": @"first_name, last_name, gender, birthday, picture.type(normal), location, email"}
                                         HTTPMethod:@"GET"
                                  completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                      
                                      if (!error) {
                                          
                                          FBSession *session = [userInfo objectForKey:@"session"];
                                          facebookToken = session.accessTokenData.accessToken;
                                          facebookInfo = (FBGraphObject *)result;
                                          facebookUserEmail = [result objectForKey:@"email"];
                                          
                                          [self signInWithToken];
                                          
                                      } else {
                                          
                                          NSLog(@"%@", [error localizedDescription]);
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

- (void)signInWithToken
{
    [[RKObjectManager sharedManager].HTTPClient setAuthorizationHeaderWithToken:facebookToken];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/dealerlogins/"
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  // The user is an existing user at Dealer. Need to save his info and update it if necessary
                                                  didDownloadUserData = YES;
                                                  self.appDelegate.dealer = mappingResult.firstObject;
                                                  [self updateInfoReceivedByFacebook];
                                                  
                                                  if (appDelegate.dealer.photoURL.length > 1) {
                                                      hasPhoto = YES;
                                                      [self downloadUesrPhoto];
                                                  }
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  
                                                  if (error.code == -1004) {
                                                      
                                                      // No connection to the server error
                                                      [noConnection show:YES];
                                                      [noConnection hide:YES afterDelay:2.0];
                                                      
                                                  } else if ([error.localizedDescription isEqualToString:@"Invalid username/password"]) {
                                                      
                                                      // The user is not an existing user at Dealers. Need to add him as a dealer
                                                      [self addAsNewDealer];
                                                      
                                                  } else {
                                                      
                                                      UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Couldn't sign in" message:@"Sorry for that, please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                      [alert show];
                                                  }
                                                  
                                                  [loggingInFacebook hide:YES];
                                              }];
}

- (void)addAsNewDealer
{
    
}

- (void)updateInfoReceivedByFacebook
{
    
    self.dealer = [[Dealer alloc]init];
    
    self.dealer.email = [facebookInfo objectForKey:@"email"];
    
    self.dealer.fullName = [NSString stringWithFormat:@"%@ %@",
                            [facebookInfo objectForKey:@"first_name"],
                            [facebookInfo objectForKey:@"last_name"]
                            ];
    

    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"MM/dd/yyyy";
    self.dealer.dateOfBirth = [dateFormatter dateFromString:[facebookInfo objectForKey:@"birthday"]];
    
    self.dealer.gender = [facebookInfo objectForKey:@"gender"];
    
    self.dealer.location = [facebookInfo objectForKey:@"loaction"];
    
    NSURL *pictureURL = [NSURL URLWithString:[[[facebookInfo objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]];
    self.dealer.photo = [NSData dataWithContentsOfURL:pictureURL];
    
    self.appDelegate.dealer = self.dealer;
    
    // Upload all the data to Dealers database.
    
    // Enter the user to Dealers.
    
    [loggingInFacebook hide:YES];
    
    [appDelegate setTabBarController];
}

- (void)downloadUesrPhoto
{
    NSString *downloadingFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"downloaded_image_%@.jpg", appDelegate.dealer.dealerID]];
    NSURL *downloadingFileURL = [NSURL fileURLWithPath:downloadingFilePath];
    
    AWSS3TransferManagerDownloadRequest *downloadRequest = [AWSS3TransferManagerDownloadRequest new];
    
    downloadRequest.bucket = @"dealers-app";
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
                                                                                                   }
                                                                                               }
                                                                                               
                                                                                               if (task.result) {
                                                                                                   
                                                                                                   didPhotoFinishedDownloading = YES;
                                                                                                   if (didDownloadUserData) {
                                                                                                       [self updateInfoReceivedByFacebook];
                                                                                                       [self enterDealers];
                                                                                                   }
                                                                                               }
                                                                                               return nil;
                                                                                           }];
}

- (void)enterDealers
{
    [appDelegate saveUserDetailsOnDevice];
    [appDelegate setTabBarController];
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
    loggingInFacebook.labelFont = [UIFont fontWithName:@"Avenir-Light" size:19.0];
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

@end

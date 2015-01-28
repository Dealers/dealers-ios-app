//
//  MainViewController.m
//  GooglePlaces
//
//  Created by itzik berrebi on 9/26/13.
//
//

#import "OpeningScreen.h"
#import "SignUpTableViewController.h"
#import "SignInTableViewController.h"
#import "KeychainItemWrapper.h"

#define AWS_S3_BUCKET_NAME @"dealers-app"

@interface OpeningScreen ()

@end

@implementation OpeningScreen

@synthesize appDelegate;
@synthesize i;
@synthesize backwhite,dealershead,dealersWhiteHead,alreadyHaveAccount;


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
    
    self.authorized = [self isAuthorized];
    [self setProgressIndicator];
    [self setButtons];
    
    if (([appDelegate.Animate_first isEqualToString:@"first"]) || (appDelegate.Animate_first == nil))  {
        appDelegate.Animate_first = @"notfirst";
        self.facebook.alpha = 0;
        self.email.alpha = 0;
        alreadyHaveAccount.alpha=0.0;
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
    
    if (appDelegate.screenShot) {
        [self.screenShot setImage:appDelegate.screenShot];
        [self setScreenShot];
    }
    
    if (appDelegate.tabBarController) {
        appDelegate.tabBarController = nil;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.screenShot setImage:nil];
    [[self.navigationController.view viewWithTag:321321321] removeFromSuperview];
}

- (void)setButtons
{
    self.facebook = [appDelegate actionButton];
    
    CGFloat emailButtonOriginY = self.alreadyHaveAccount.frame.origin.y - 6 - self.facebook.frame.size.height;
    
    CGRect frame = self.facebook.frame;
    frame.origin.y = emailButtonOriginY - 15 - frame.size.height;
    self.facebook.frame = frame;
    
    [self.facebook setBackgroundColor:[UIColor colorWithRed:58.0/255.0 green:86.0/255.0 blue:156.0/255.0 alpha:1.0]];
    [self.facebook setTitle:NSLocalizedString(@"Continue with Facebook", nil) forState:UIControlStateNormal];
    [[self.facebook titleLabel] setFont:[UIFont fontWithName:@"Avenir-Medium" size:17.0]];
    [self.facebook setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.facebook addTarget:self action:@selector(facebookButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:self.facebook belowSubview:self.screenShot];
    
    UIImageView *facebookIcon = [[UIImageView alloc] initWithFrame:CGRectMake(4.0, 2.0, 40.0, 40.0)];
    facebookIcon.image = [UIImage imageNamed:@"Facebook Button Icon"];
    [self.facebook addSubview:facebookIcon];
    
    
    self.email = [appDelegate actionButton];
    
    frame = self.email.frame;
    frame.origin.y = emailButtonOriginY;
    self.email.frame = frame;
    
    [self.email setBackgroundColor:[appDelegate ourPurple]];
    [self.email setTitle:NSLocalizedString(@"Sign up with email", nil) forState:UIControlStateNormal];
    [[self.email titleLabel] setFont:[UIFont fontWithName:@"Avenir-Medium" size:17.0]];
    [self.email setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.email addTarget:self action:@selector(EmailimageButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:self.email belowSubview:self.screenShot];
    
    UIImageView *emailIcon = [[UIImageView alloc] initWithFrame:CGRectMake(4.0, 2.0, 40.0, 40.0)];
    emailIcon.image = [UIImage imageNamed:@"Email White Button Icon"];
    [self.email addSubview:emailIcon];
    
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
                             self.slogen.text = NSLocalizedString(@"Share deals with others\nHelp reduce prices", @"The slogan");
                             [UIView animateWithDuration:0.3
                                              animations:^{ self.slogen.alpha = 1.0;
                                              }];
                         }];
        firstSlogen = NO;
        
    } else {
        
        [UIView animateWithDuration:0.3
                         animations:^{ self.slogen.alpha = 0; }
                         completion:^(BOOL finished) {
                             self.slogen.text = NSLocalizedString(@"Find great deals\nShared by people like you", @"The slogan");
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
    self.facebook.alpha=1.0;
    self.email.alpha=1.0;
    alreadyHaveAccount.alpha=1.0;
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
    self.facebook.alpha=0.0;
    self.email.alpha=0.0;
    [UIView animateWithDuration:0.5 animations:^{self.facebook.alpha=1.0;}];
    [UIView animateWithDuration:0.5 animations:^{self.email.alpha=1.0;}];
    [UIView animateWithDuration:0.5 animations:^{alreadyHaveAccount.alpha=1.0;}];
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

- (IBAction)EmailimageButton:(id)sender
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

- (IBAction)SigninButton:(id)sender
{
    SignInTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SignInID"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)facebookButtonClicked:(id)sender{
    
    [self startFacebookLogin];
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
    
    loggingInFacebook = [[MBProgressHUD alloc]initWithView:self.view];
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
                
        if (appDelegate.dealer.photoURL.length > 1 && ![appDelegate.dealer.photoURL isEqualToString:@"None"]) {
            appDelegate.dealer.photo = [appDelegate loadProfilePic];
        }
        
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
                                          
                                          facebookInfo = (FBGraphObject *)result;
                                          facebookUserEmail = [result objectForKey:@"email"];
                                          
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
    [[RKObjectManager sharedManager].HTTPClient setAuthorizationHeaderWithUsername:@"ubuntu" password:@"090909deal"];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/dealerfbs/"
                                           parameters:@{ @"email" : facebookUserEmail }
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
    self.pseudoUser.username = [NSString stringWithFormat:@"fb_%@", facebookUserEmail];
    self.pseudoUser.userPassword = [NSString stringWithFormat:@"pass_%@_key", facebookUserEmail];
    
    if (triedAddingNumber) {
        self.pseudoUser.username = [NSString stringWithFormat:@"fb_2_%@", facebookUserEmail];
    }
    
    if (self.pseudoUser.username.length > 30) {
        self.pseudoUser.username = [self.pseudoUser.username substringToIndex:30];
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
                                            
                                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Couldn't sign in with facebook", nil)
                                                                                           message:NSLocalizedString(@"Pleae try again later", nil)
                                                                                          delegate:nil
                                                                                 cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                                                 otherButtonTitles:nil];
                                            
                                            if ([[errors messagesString] isEqualToString:@"Pseudo user already exists"]) {
                                                
                                                if (!triedAddingNumber) {
                                                    triedAddingNumber = YES;
                                                    [self createPseudoUserForToken];
                                                } else {
                                                    [alert show];
                                                    [loggingInFacebook hide:YES];
                                                    appDelegate.dealer = nil;
                                                    [[FBSession activeSession] closeAndClearTokenInformation];
                                                }
                                                
                                            } else {
                                                
                                                [alert show];
                                                [loggingInFacebook hide:YES];
                                                appDelegate.dealer = nil;
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
    [appDelegate setTabBarController];
    [appDelegate saveUserDetailsOnDevice];
}


@end

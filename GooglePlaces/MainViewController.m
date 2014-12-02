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
@synthesize twittericon;
@synthesize emailicon;
@synthesize i;
@synthesize backwhite,dealershead,already,signin;


- (void)viewDidLoad
{
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    if ([self checkIfUserLoggedIn]) {
        return;
    }
    
    ScreenHeight = self.view.frame.size.height/10;
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
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
        dealershead.center = CGPointMake(160,(CGRectGetMidY(appDelegate.window.bounds)-dealershead.frame.size.height/2-16));
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
}

- (void)objectInPlace {
    dealershead.center = CGPointMake(160, 55);
    facebookicon.alpha=1.0;
    twittericon.alpha=1.0;
    emailicon.alpha=1.0;
    already.alpha=1.0;
    signin.alpha=1.0;
    backwhite.hidden = YES;
}

-(void) anim2 {
    
    [UIView animateWithDuration:1.0 animations:^{dealershead.center = CGPointMake(160, 55);}];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(anim) userInfo:nil repeats:NO];
}

-(void) anim {
    
    [UIView animateWithDuration:0.1 animations:^{backwhite.alpha=0.0;}];
    facebookicon.alpha=0.0;
    twittericon.alpha=0.0;
    emailicon.alpha=0.0;
    [UIView animateWithDuration:0.5 animations:^{facebookicon.alpha=1.0;}];
    [UIView animateWithDuration:0.5 animations:^{twittericon.alpha=1.0;}];
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

- (IBAction)getInWithoutSigning:(id)sender {
    
    Dealer *dealer = [[Dealer alloc]init];
    
    dealer.dealerID = [NSNumber numberWithInt:1234];
    dealer.email = @"gullumbroso@gmail.com";
    dealer.fullName = @"Gilad Lumbroso";
    dealer.dateOfBirth = [NSDate date];
    dealer.gender = @"Male";
    dealer.photo = nil;
    dealer.userLikesList = nil;
    
    appDelegate.dealer = dealer;
        
    [appDelegate setTabBarController];
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
    
    NSString *username = [keychain objectForKey:(__bridge id)(kSecAttrAccount)];
    NSString *password = [keychain objectForKey:(__bridge id)(kSecValueData)];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *fullName = [userDefaults objectForKey:@"fullName"];

    if (username.length > 0 && password.length > 0 && fullName.length > 0) {
        
        [appDelegate setHTTPClientUsername:username andPassword:password];
        
        self.appDelegate.dealer = [[Dealer alloc]init];
        
        self.appDelegate.dealer.dealerID = [userDefaults objectForKey:@"dealerID"];
        self.appDelegate.dealer.email = [userDefaults objectForKey:@"email"];
        self.appDelegate.dealer.fullName = [userDefaults objectForKey:@"fullName"];
        self.appDelegate.dealer.dateOfBirth = [userDefaults objectForKey:@"dateOfBirth"];
        self.appDelegate.dealer.gender = [userDefaults objectForKey:@"gender"];
        self.appDelegate.dealer.registerDate = [userDefaults objectForKey:@"registerDate"];
        self.appDelegate.dealer.location = [userDefaults objectForKey:@"location"];
        self.appDelegate.dealer.about = [userDefaults objectForKey:@"about"];
        self.appDelegate.dealer.photoURL = [userDefaults objectForKey:@"photoURL"];
        self.appDelegate.dealer.photo = [userDefaults objectForKey:@"photo"];
        self.appDelegate.dealer.uploadedDeals = [NSMutableArray arrayWithArray:[userDefaults objectForKey:@"uploadedDeals"]];
        self.appDelegate.dealer.likedDeals = [NSMutableArray arrayWithArray:[userDefaults objectForKey:@"likedDeals"]];
        self.appDelegate.dealer.sharedDeals = [NSMutableArray arrayWithArray:[userDefaults objectForKey:@"sharedDeals"]];
        self.appDelegate.dealer.followedBy = [NSMutableArray arrayWithArray:[userDefaults objectForKey:@"followedBy"]];
        self.appDelegate.dealer.followings = [NSMutableArray arrayWithArray:[userDefaults objectForKey:@"followings"]];
        self.appDelegate.dealer.badReportsCounter = [userDefaults objectForKey:@"badReportsCounter"];
        self.appDelegate.dealer.score = [userDefaults objectForKey:@"score"];
        self.appDelegate.dealer.rank = [userDefaults objectForKey:@"rank"];
        self.appDelegate.dealer.reliability = [userDefaults objectForKey:@"reliability"];
        
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
            
            // The session is open. Get the user information and update the UI.
            
            [FBRequestConnection startWithGraphPath:@"me"
                                         parameters:@{@"fields": @"first_name, last_name, gender, birthday, picture.type(normal), location, email"}
                                         HTTPMethod:@"GET"
                                  completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                      
                                      if (!error) {

                                          self.dealer = [[Dealer alloc]init];
                                          
                                          self.dealer.fullName = [NSString stringWithFormat:@"%@ %@",
                                                                   [result objectForKey:@"first_name"],
                                                                   [result objectForKey:@"last_name"]
                                                                   ];
                                          
                                          self.dealer.email = [result objectForKey:@"email"];
                                          
                                          
                                          NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                                          dateFormatter.dateFormat = @"MM/dd/yyyy";
                                          self.dealer.dateOfBirth = [dateFormatter dateFromString:[result objectForKey:@"birthday"]];
                                          
                                          self.dealer.gender = [result objectForKey:@"gender"];
                                          
                                          self.dealer.location = [result objectForKey:@"loaction"];
                                          
                                          NSURL *pictureURL = [NSURL URLWithString:[[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]];
                                          self.dealer.photo = [NSData dataWithContentsOfURL:pictureURL];
                                          
                                          self.appDelegate.dealer = self.dealer;
                                          
                                          // Upload all the data to Dealers database.
                                          
                                          // Enter the user to Dealers.
                                          
                                          [loggingInFacebook hide:YES];
                                          
                                          [appDelegate setTabBarController];
                                      
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
    
    [self.view addSubview:loggingInFacebook];
}

@end

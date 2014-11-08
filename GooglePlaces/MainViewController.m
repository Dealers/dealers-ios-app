//
//  MainViewController.m
//  GooglePlaces
//
//  Created by itzik berrebi on 9/26/13.
//
//

#import "MainViewController.h"
#import "Signup2ViewController.h"
#import "SigninViewController.h"

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
    SigninViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"signin"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)facebookButtonClicked:(id)sender{
    
    if ([FBSession activeSession].state != FBSessionStateOpen &&
        [FBSession activeSession].state != FBSessionStateOpenTokenExtended) {
        
        [self.appDelegate openActiveSessionWithPermissions:@[@"public_profile", @"user_friends", @"email"] allowLoginUI:YES];
    }
    
    else {
        
        [[FBSession activeSession] closeAndClearTokenInformation];
        [loggingInFacebook show:YES];
        [loggingInFacebook hide:YES afterDelay:1.5];
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

- (void)handleFBSessionStateChangeWithNotification:(NSNotification *)notification
{
    // Get the session, state and error values from the notification's userInfo dictionary.
    NSDictionary *userInfo = [notification userInfo];
    
    FBSessionState sessionState = [[userInfo objectForKey:@"state"] integerValue];
    NSError *error = [userInfo objectForKey:@"error"];
    
    [loggingInFacebook show:YES];
    
    if (!error) {
        
        // In case that there's not any error, then check if the session opened or closed.
        
        if (sessionState == FBSessionStateOpen) {
            
            // The session is open. Get the user information and update the UI.
            
            [FBRequestConnection startWithGraphPath:@"me"
                                         parameters:@{@"fields": @"first_name, last_name, gender, birthday, picture.type(normal), email"}
                                         HTTPMethod:@"GET"
                                  completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                      
                                      if (!error) {

                                          self.dealer = [[Dealer alloc]init];
                                          
                                          self.dealer.fullName = [NSString stringWithFormat:@"%@ %@",
                                                                   [result objectForKey:@"first_name"],
                                                                   [result objectForKey:@"last_name"]
                                                                   ];
                                          
                                          self.dealer.email = [result objectForKey:@"email"];
                                          
                                          self.dealer.dateOfBirth = [result objectForKey:@"birthday"];
                                          
                                          self.dealer.gender = [result objectForKey:@"gender"];
                                          
                                          NSURL *pictureURL = [NSURL URLWithString:[[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]];
                                          self.dealer.photo = [UIImage imageWithData:[NSData dataWithContentsOfURL:pictureURL]];
                                          
                                          // Upload all the data to Dealers database.
                                          
                                          [loggingInFacebook hide:YES];
                                      
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
    loggingInFacebook = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    loggingInFacebook.delegate = self;
    loggingInFacebook.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Complete"]];
    loggingInFacebook.mode = MBProgressHUDModeCustomView;
    loggingInFacebook.labelText = @"Logging In";
    loggingInFacebook.labelFont = [UIFont fontWithName:@"Avenir-Light" size:19.0];
    loggingInFacebook.animationType = MBProgressHUDAnimationZoomIn;
    
    [self.navigationController.view addSubview:loggingInFacebook];
}

@end

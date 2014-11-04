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

-(void) ObjectInPlace {
    dealershead.center = CGPointMake(160, 55);
    facebookicon.alpha=1.0;
    twittericon.alpha=1.0;
    emailicon.alpha=1.0;
    already.alpha=1.0;
    signin.alpha=1.0;
    backwhite.hidden = YES;
}
- (void)viewDidLoad
{
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    [self checkIfUserLoggedIn];
    
    ScreenHeight = self.view.frame.size.height/10;
    
    
    if (([appDelegate.Animate_first isEqualToString:@"first"]) || (appDelegate.Animate_first == nil))  {
        appDelegate.Animate_first = @"notfirst";
        signin.alpha=0.0;
        already.alpha=0.0;
        backwhite.alpha=1.0;
        dealershead.alpha=1.0;
        dealershead.center = CGPointMake(160,(CGRectGetMidY(appDelegate.window.bounds)-dealershead.frame.size.height/2-16));
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(anim2) userInfo:nil repeats:NO];
    } else {
        [self ObjectInPlace];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)EmailimageButton:(id)sender{
    Signup2ViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Signup2ViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

-(IBAction)SigninButton:(id)sender{
    SigninViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"signin"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)getInWithoutSigning:(id)sender {
    
    Dealer *dealer = [[Dealer alloc]init];
    
    dealer.url = @"1234";
    dealer.email = @"gullumbroso@gmail.com";
    dealer.fullName = @"Gilad Lumbroso";
    dealer.dateOfBirth = [NSDate date];
    dealer.gender = @"Male";
    dealer.photo = nil;
    dealer.userLikesList = nil;
    
    appDelegate.dealer = dealer;
        
    [appDelegate setTabBarController];
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

- (void)checkIfUserLoggedIn
{
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"DealersKeychain" accessGroup:nil];
    [keychain setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
    
    NSString *email = [keychain objectForKey:(__bridge id)(kSecAttrAccount)];
    NSString *password = [keychain objectForKey:(__bridge id)(kSecValueData)];
    
    if (email.length > 0 && password.length > 0) {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        self.appDelegate.dealer = [[Dealer alloc]init];
        
        self.appDelegate.dealer.fullName = [userDefaults objectForKey:@"fullName"];
        self.appDelegate.dealer.dateOfBirth = [userDefaults objectForKey:@"dateOfBirth"];
        self.appDelegate.dealer.gender = [userDefaults objectForKey:@"gender"];
        self.appDelegate.dealer.photo = [UIImage imageWithData:[userDefaults objectForKey:@"image"]];

        [appDelegate setTabBarController];
    }
}

-(void) deallocMemory
{
    NSLog(@"dealloc main");
    NSArray *viewsToRemove = [self.view subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    [self.view removeFromSuperview];
    self.view=nil;
}
@end

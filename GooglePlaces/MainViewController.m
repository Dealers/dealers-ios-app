//
//  MainViewController.m
//  GooglePlaces
//
//  Created by itzik berrebi on 9/26/13.
//
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import "Signup2ViewController.h"
#import "SigninViewController.h"

@interface MainViewController () 
@end

@implementation MainViewController
@synthesize bagimage;
@synthesize facebookicon;
@synthesize twittericon;
@synthesize emailicon;
@synthesize i;
@synthesize backwhite,dealershead,via,already,signin;

-(void) ObjectInPlace {
    signin.alpha=1.0;
    already.alpha=1.0;
    via.alpha=1.0;
    backwhite.alpha=0.0;
    dealershead.alpha=1.0;
    dealershead.center = CGPointMake(160, 55);
    bagimage.center = CGPointMake(218, 261);
    facebookicon.center = CGPointMake(90, 178);
    twittericon.center = CGPointMake(58, 256);
    emailicon.center = CGPointMake(86, 334);
}
- (void)viewDidLoad
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];

    if (([app.Animate_first isEqualToString:@"first"]) || (app.Animate_first == NULL))  {
        app.Animate_first=@"notfirst";
        signin.alpha=0.0;
        already.alpha=0.0;
        via.alpha=0.0;
        backwhite.alpha=1.0;
        dealershead.alpha=1.0;
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(anim2) userInfo:nil repeats:NO];
    } else {
        [self ObjectInPlace];
    }
[super viewDidLoad];
}

-(void) anim2 {
    [UIView animateWithDuration:1.0 animations:^{dealershead.center = CGPointMake(160, 55);}];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(anim) userInfo:nil repeats:NO];
}
-(void) anim {
    [UIView animateWithDuration:0.1 animations:^{backwhite.alpha=0.0;}];
    bagimage.alpha=0.0;
    facebookicon.alpha=0.0;
    twittericon.alpha=0.0;
    emailicon.alpha=0.0;
    [UIView animateWithDuration:0.5 animations:^{bagimage.center = CGPointMake(218, 261);}];
    [UIView animateWithDuration:0.5 animations:^{facebookicon.center = CGPointMake(90, 178);}];
    [UIView animateWithDuration:0.5 animations:^{twittericon.center = CGPointMake(58, 256);}];
    [UIView animateWithDuration:0.5 animations:^{emailicon.center = CGPointMake(86, 334);}];
    [UIView animateWithDuration:0.5 animations:^{bagimage.alpha=1.0;}];
    [UIView animateWithDuration:0.5 animations:^{facebookicon.alpha=1.0;}];
    [UIView animateWithDuration:0.5 animations:^{twittericon.alpha=1.0;}];
    [UIView animateWithDuration:0.5 animations:^{emailicon.alpha=1.0;}];
    [UIView animateWithDuration:0.5 animations:^{via.alpha=1.0;}];
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
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navi animated:YES completion:nil];
}

-(IBAction)SigninButton:(id)sender{
    SigninViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"signin"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end

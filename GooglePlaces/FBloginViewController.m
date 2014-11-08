//
//  FBloginViewController.m
//  Dealers
//
//  Created by itzik berrebi on 9/14/14.
//
//

#import "FBloginViewController.h"
#import "Functions.h"
#import "AppDelegate.h"
#import "Dealer.h"

@interface FBloginViewController ()

@end

@implementation FBloginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.loginButton.delegate = self;
    [self toggleHiddenState:YES];
    self.lblLoginStatus.text = @"";
    self.loginButton.readPermissions = @[@"public_profile", @"email", @"user_birthday",@"user_friends",@"user_likes"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)toggleHiddenState:(BOOL)shouldHide{
    self.lblUsername.hidden = shouldHide;
    self.lblEmail.hidden = shouldHide;
    self.profilePicture.hidden = shouldHide;
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView{
    self.lblLoginStatus.text = @"You are logged in.";
    
    [self toggleHiddenState:NO];
}

- (void)updateDealerClass :(id<FBGraphUser>)user{
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    Dealer *dealer = [[Dealer alloc]init];
    
    NSString *findURL = [NSString stringWithFormat:@"http://www.dealers.co.il/emailTOid.php?email=%@",[user objectForKey:@"email"]];
    NSData *urlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:findURL]];
    NSString *dataResult = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];

    NSString *findURL2 = [NSString stringWithFormat:@"http://www.dealers.co.il/emailTOphotoid.php?email=%@",[user objectForKey:@"email"]];
    NSData *urlData2 = [NSData dataWithContentsOfURL:[NSURL URLWithString:findURL2]];
    NSString *dataResult2 = [[NSString alloc] initWithData:urlData2 encoding:NSUTF8StringEncoding];

    dealer.userID = dataResult;
    dealer.fullName = user.name;
    dealer.email = [user objectForKey:@"email"];
    dealer.dateOfBirth = [user objectForKey:@"birthday"];
    dealer.gender = @"unknown";
    dealer.photoID = dataResult2;
    app.dealerClass = dealer;
}

- (void) mainFunction : (id<FBGraphUser>)user {
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    Functions *func = [[Functions alloc]init];
    if ([func checkIfUserExist:self.lblEmail.text]) {
        if ([func isFacebookAccount:self.lblEmail.text]) {
            [self updateDealerClass:user];
            [app setTabBarController];
        } else {
            [func dbAsFacebookAccount:user];
            [self updateDealerClass:user];
            [app setTabBarController];
        }
    } else {
        [func dataTOdb:user];
        [self updateDealerClass:user];
        [app setTabBarController];
    }
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user{
    NSLog(@"%@", user);

    self.profilePicture.profileID = user.objectID;
    self.lblUsername.text = user.name;
    self.lblEmail.text = [user objectForKey:@"email"];
    
    [self performSelector:@selector(mainFunction:) withObject:user afterDelay:5];

}

-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView{
    self.lblLoginStatus.text = @"You are logged out";
    
    [self toggleHiddenState:YES];
}

-(void)loginView:(FBLoginView *)loginView handleError:(NSError *)error{
    NSLog(@"%@", [error localizedDescription]);
}

@end

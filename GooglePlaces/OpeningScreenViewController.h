//
//  MainViewController.h
//  GooglePlaces
//
//  Created by itzik berrebi on 9/26/13.
//
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import "EnterPasscodeViewController.h"
#import "MBProgressHUD.h"
#import "User.h"
#import "GAITrackedViewController.h"

@interface OpeningScreenViewController : GAITrackedViewController <UINavigationBarDelegate, UINavigationBarDelegate, MBProgressHUDDelegate>
{
    MBProgressHUD *loggingInFacebook, *noConnection;
    FBGraphObject *facebookInfo;
    NSString *facebookUserEmail, *facebookToken;
    NSNumber *pseudoUserID;
    BOOL gotToken, didPhotoFinishedDownloading, didPhotoFinishedUploading, triedUploadingPhoto, signedUp;
    UIView *screenshot;
}

@property AppDelegate *appDelegate;

@property Dealer *dealer;
@property User *pseudoUser;

@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topLogoConstraint;
@property NSLayoutConstraint *centerYLogoConstraint;
@property (weak, nonatomic) IBOutlet UILabel *slogen;
@property (weak, nonatomic) IBOutlet UIButton *facebook;
@property (weak, nonatomic) IBOutlet UIButton *email;
@property (weak, nonatomic) NSString *i;
@property (weak, nonatomic) IBOutlet UIButton *alreadyHaveAccount;

@property BOOL authorized;
@property BOOL didComeFromLogOut;


- (IBAction)continueWithFacebook:(id)sender;
- (IBAction)signUpWithEmail:(id)sender;
- (IBAction)signIn:(id)sender;
- (void)signUpUser;
- (void)cancelFacebookLogin;

@end

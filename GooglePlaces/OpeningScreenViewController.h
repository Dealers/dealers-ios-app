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

@interface OpeningScreenViewController : UIViewController <UINavigationBarDelegate, UINavigationBarDelegate, MBProgressHUDDelegate>
{
    float ScreenHeight;
    MBProgressHUD *loggingInFacebook, *noConnection;
    FBGraphObject *facebookInfo;
    NSString *facebookUserEmail, *facebookToken;
    NSNumber *pseudoUserID;
    BOOL gotToken, didPhotoFinishedDownloading, didPhotoFinishedUploading, firstSlogen, triedUploadingPhoto, signedUp;
    
}

@property AppDelegate *appDelegate;

@property Dealer *dealer;
@property User *pseudoUser;

@property (weak, nonatomic) IBOutlet UIScrollView *regularView;
@property (weak, nonatomic) IBOutlet UIScrollView *darkCollageView;

@property (weak, nonatomic) IBOutlet UIImageView *dealershead;
@property (weak, nonatomic) IBOutlet UIImageView *dealersWhiteHead;
@property (weak, nonatomic) IBOutlet UIImageView *backwhite;

@property (weak, nonatomic) IBOutlet UILabel *slogen;
@property (weak, nonatomic) IBOutlet UILabel *slogenDark;

@property (nonatomic) UIButton *facebook;
@property (nonatomic) UIButton *email;

@property (weak, nonatomic) NSString *i;

@property (weak, nonatomic) IBOutlet UIButton *alreadyHaveAccount;

@property (weak, nonatomic) IBOutlet UIImageView *screenShot;

@property BOOL authorized;
@property BOOL didComeFromLogOut;


- (IBAction)EmailimageButton:(id)sender;
- (IBAction)SigninButton:(id)sender;
- (IBAction)facebookButtonClicked:(id)sender;

- (void)signUpUser;
- (void)cancelFacebookLogin;

@end

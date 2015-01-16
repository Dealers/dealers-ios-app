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

@interface MainViewController : UIViewController <UINavigationBarDelegate, UINavigationBarDelegate, MBProgressHUDDelegate>
{
    float ScreenHeight;
    MBProgressHUD *loggingInFacebook, *noConnection;
    FBGraphObject *facebookInfo;
    NSString *facebookUserEmail, *facebookToken;
    NSNumber *pseudoUserID;
    BOOL didDownloadUserData, didPhotoFinishedDownloading, didPhotoFinishedUploading, firstSlogen, triedAddingNumber, triedUploadingPhoto, gotToken;
    
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

@property (weak, nonatomic) IBOutlet UIButton *facebookicon;
@property (weak, nonatomic) IBOutlet UIButton *emailicon;
@property (weak, nonatomic) NSString *i;

@property (weak, nonatomic) IBOutlet UILabel *already;
@property (weak, nonatomic) IBOutlet UILabel *signin;

@property (weak, nonatomic) IBOutlet UIImageView *screenShot;

@property BOOL authorized;
@property BOOL enteredPasscode;
@property BOOL didComeFromLogOut;


- (IBAction)EmailimageButton:(id)sender;
- (IBAction)SigninButton:(id)sender;
- (IBAction)facebookButtonClicked:(id)sender;


@end

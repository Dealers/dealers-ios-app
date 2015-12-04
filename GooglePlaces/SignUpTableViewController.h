//
//  SignUpTableViewController.h
//  Dealers
//
//  Created by Gilad Lumbroso on 12/17/14.
//
//

#import <UIKit/UIKit.h>
//#import <AWSiOSSDKv2/S3.h>
#import <AWSS3/AWSS3.h>
#import "AppDelegate.h"
#import "KeychainItemWrapper.h"
#import "PersonalizeTableViewController.h"
#import "MBProgressHUD.h"
#import "Dealer.h"
#import "Device.h"
#import "Error.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@interface SignUpTableViewController : UITableViewController <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UIScrollViewDelegate, MBProgressHUDDelegate> {
    
    UIImageView *loadingAnimation;
    MBProgressHUD *blankFullName, *blankEmail, *blankPassword, *noConnection;
    BOOL didUploadUserData, didPhotoFinishedUploading, hasPhoto;
    NSString *photoFileName;
}

@property AppDelegate *appDelegate;

@property Dealer *dealer;

@property (weak, nonatomic) IBOutlet UIButton *changeProfilePicButton;

@property (weak, nonatomic) IBOutlet UITextField *fullNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *dateOfBirthLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;

@property (weak, nonatomic) IBOutlet UITableViewCell *datePickerCell;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property BOOL datePickerIsShowing;
@property BOOL didCancelDate;
@property NSDateFormatter *dateFormatter;

@property (weak, nonatomic) IBOutlet UIView *profilePicView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *privacyPolicyAgreement;
@property (weak, nonatomic) IBOutlet UIView *signUpButtonBackground;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

- (IBAction)changeProfilePic:(id)sender;
- (IBAction)dateChanged:(id)sender;
- (IBAction)signUp:(id)sender;
- (IBAction)privacyPolicy:(id)sender;


@end

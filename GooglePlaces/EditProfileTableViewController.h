//
//  EditProfileTableViewController.h
//  Dealers-testbeta
//
//  Created by Gilad Lumbroso on 8/18/14.
//
//

#import <UIKit/UIKit.h>
#import <AWSiOSSDKv2/S3.h>
#import "AppDelegate.h"
#import "PasswordTableViewController.h"
#import "ProfileTableViewController.h"
#import "MBProgressHUD.h"
#import "KeychainItemWrapper.h"

@interface EditProfileTableViewController : UITableViewController <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, MBProgressHUDDelegate>
{
    BOOL userHaveProfilePic;
    BOOL didUploadUserData;
    BOOL didPhotoFinishedUploading;
    BOOL shouldUploadPhoto;
    MBProgressHUD *blankFullName, *blankEmail, *uploading, *saved, *couldntUpload;
    NSString *photoFileName;
}

@property AppDelegate *appDelegate;

@property RKObjectManager *editProfileManager;

@property Dealer *editedDealer;

@property id delegate;

@property (weak, nonatomic) IBOutlet UIView *profilePicView;
@property (weak, nonatomic) IBOutlet UIButton *profilePicButton;
@property (nonatomic) NSData *profilePicData;

@property (weak, nonatomic) IBOutlet UITextField *fullName;
@property (weak, nonatomic) IBOutlet UITextField *about;
@property (weak, nonatomic) IBOutlet UITextField *location;
@property (weak, nonatomic) IBOutlet UITextField *email;

@property (weak, nonatomic) IBOutlet UILabel *dateOfBirth;
@property (weak, nonatomic) IBOutlet UILabel *gender;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property NSDateFormatter *dateFormatter;
@property (weak, nonatomic) IBOutlet UIButton *noDateButton;

@property NSString *originalPhotoURL;
@property NSData *originalPhotoData;
@property NSString *originalFullName;
@property NSString *originalAbout;
@property NSString *originalLocation;
@property NSDate *originalDateOfBirth;
@property NSString *originalGender;
@property NSString *originalEmail;
@property NSString *originalUsername;

@property NSString *password;

@property BOOL datePickerIsShowing;
@property BOOL didCancelDate;
@property BOOL didChangeProfilePic;
@property BOOL didChangeEmail;


- (IBAction)changeProfilePic:(id)sender;
- (IBAction)noDate:(id)sender;

@end

//
//  Signup2ViewController.h
//  GooglePlaces
//
//  Created by itzik berrebi on 10/6/13.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AWSiOSSDKv2/S3.h>
#import "AppDelegate.h"

@interface Signup2ViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate,UINavigationBarDelegate,UINavigationControllerDelegate>
{
    NSString *Photoid;
    NSString *photoFileName;
    BOOL didUploadUserData;
    BOOL didPhotoFinishedUploading;
    BOOL hasPhoto;
    BOOL isPopping;
    CGPoint scrollOriginOffset;
}
@property (nonatomic) UIApplication *app;
@property (nonatomic) AppDelegate *appDelegate;

@property (strong, nonatomic) NSMutableArray *list;

@property Dealer *dealer;

@property (weak, nonatomic) IBOutlet UIButton *SignupButton;

@property (weak, nonatomic) IBOutlet UITextField *fullNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateOfBirthTextField;
@property (weak, nonatomic) IBOutlet UITextField *genderTextField;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesturePressed;
- (IBAction)tapGesturePressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UIImageView *LoadingImage;
@property (weak, nonatomic) IBOutlet UIImageView *PurpImage;
@property (weak, nonatomic) IBOutlet UIImageView *textFieldsFrame;

@property (weak, nonatomic) IBOutlet UIDatePicker *datepick;
@property (nonatomic) NSDate *selectedDate;
@property (nonatomic) NSDateFormatter *dateFormatter;
@property (weak, nonatomic) IBOutlet UINavigationBar *NavBar;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UIPickerView *GenderPicker;
@property (weak, nonatomic) IBOutlet UINavigationBar *GenderNavBar;

@property NSData *profilePicData;

- (IBAction)SignUpButton:(id)sender;
- (IBAction)AddphotoButton:(id)sender;
- (IBAction)HideDatePicker;
- (IBAction)ShowDatePicker;
- (IBAction)GenderButton:(id)sender;
- (IBAction)GenderDoneButton:(id)sender;

@end

//
//  Signup2ViewController.h
//  GooglePlaces
//
//  Created by itzik berrebi on 10/6/13.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface Signup2ViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate,UINavigationBarDelegate,UINavigationControllerDelegate>
{
    NSString *Photoid;
    BOOL didAddPhoto;
    BOOL registerAgain;
}
@property (strong, nonatomic) NSMutableArray *list;

@property (weak, nonatomic) IBOutlet UIButton *ReturnButton;
@property (weak, nonatomic) IBOutlet UIButton *ReturnButtonFull;
@property (weak, nonatomic) IBOutlet UIButton *addphotobutton;
@property (weak, nonatomic) IBOutlet UIButton *SignupButton;

@property (weak, nonatomic) IBOutlet UITextField *Fullname;
@property (weak, nonatomic) IBOutlet UITextField *Email;
@property (weak, nonatomic) IBOutlet UITextField *Password;
@property (weak, nonatomic) IBOutlet UITextField *Datebirth;
@property (weak, nonatomic) IBOutlet UITextField *Genger;

- (IBAction)SingupButton:(id)sender;
- (IBAction)AddphotoButton:(id)sender;
- (IBAction)HideDatePicker;
- (IBAction)ShowDatePicker;
- (IBAction)GenderButton:(id)sender;
- (IBAction)ReturnButtonAction:(id)sender;
- (IBAction)GenderDoneButton:(id)sender;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesturePressed;
- (IBAction)tapGesturePressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *ImageAdded;
@property (weak, nonatomic) IBOutlet UIImageView *ImageFrame;
@property (weak, nonatomic) IBOutlet UIImageView *LoadingImage;
@property (weak, nonatomic) IBOutlet UIImageView *PurpImage;

@property (weak, nonatomic) IBOutlet UIDatePicker *datepick;
@property (weak, nonatomic) IBOutlet UINavigationBar *NavBar;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UIPickerView *GenderPicker;
@property (weak, nonatomic) IBOutlet UINavigationBar *GenderNavBar;

@property (weak, nonatomic) IBOutlet UILabel *optional_date;
@property (weak, nonatomic) IBOutlet UILabel *optional_gender;

@end

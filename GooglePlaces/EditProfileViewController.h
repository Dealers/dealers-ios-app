//
//  EditProfileViewController.h
//  Dealers-testbeta
//
//  Created by itzik berrebi on 6/4/14.
//
//

#import <UIKit/UIKit.h>
#import "Dealer.h"

@interface EditProfileViewController : UIViewController <UIActionSheetDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate, UINavigationControllerDelegate, UITextFieldDelegate>
{
    BOOL allocDatePicker;
    BOOL allocGenderPicker;
    BOOL photoFlag;
}

@property (weak, nonatomic) IBOutlet UIImageView *LoadingImage;
@property (weak, nonatomic) IBOutlet UINavigationBar *dateNavBar;
@property (weak, nonatomic) IBOutlet UINavigationBar *genderNavBar;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIPickerView *genderPicker;
@property (strong, nonatomic) Dealer *dealerClass;

@property (weak, nonatomic) IBOutlet UIView *scrollEnd;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *userAboutTF;
@property (weak, nonatomic) IBOutlet UITextField *userLocationTF;
@property (weak, nonatomic) IBOutlet UITextField *userBirthTF;
@property (weak, nonatomic) IBOutlet UITextField *userGenderTF;
@property (weak, nonatomic) IBOutlet UITextField *userEmailTF;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordTF;

@property (strong, nonatomic) NSMutableArray *genderList;

- (IBAction)userBirthButtonClicked:(id)sender;
- (IBAction)userGenderButtonClicked:(id)sender;
- (IBAction)dataDoneButtonClicked:(id)sender;
- (IBAction)dateCancleButtonClicked:(id)sender;
- (IBAction)genderDoneButtonClicked:(id)sender;
- (IBAction)returnButtonClicked:(id)sender;
- (IBAction)updateButtonClicked:(id)sender;
- (IBAction)editButtonClicked:(id)sender;

@end

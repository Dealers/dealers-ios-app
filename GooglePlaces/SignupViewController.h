//
//  SignupViewController.h
//  GooglePlaces
//
//  Created by itzik berrebi on 9/26/13.
//
//
#import <UIKit/UIKit.h>

@interface SignupViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIAlertViewDelegate>
{
    NSString *Photoid;
    NSString *firstornot;
    
}
@property (weak, nonatomic) IBOutlet UITextField *Fullname;
@property (weak, nonatomic) IBOutlet UITextField *Email;
@property (weak, nonatomic) IBOutlet UITextField *Password;
@property (weak, nonatomic) IBOutlet UITextField *Datebirth;
@property (weak, nonatomic) IBOutlet UITextField *Genger;

- (IBAction)SingupButton:(id)sender;
- (IBAction)AddphotoButton:(id)sender;
- (IBAction)secondimageButton:(id)sender;
- (IBAction)thirdimageButton:(id)sender;
- (IBAction)fourthimageButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *ImageAdded;
@property (nonatomic, strong) NSMutableArray *PASSWORDMARRAY;

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UIButton *addphotobutton;
@property (weak, nonatomic) IBOutlet UIImageView *secondimage;
@property (weak, nonatomic) IBOutlet UIImageView *thirdimage;
@property (weak, nonatomic) IBOutlet UIImageView *fourth;
@property (weak, nonatomic) IBOutlet UIButton *secondimageB;
@property (weak, nonatomic) IBOutlet UIButton *thirdimageB;
@property (weak, nonatomic) IBOutlet UIButton *fourthimageB;

@end

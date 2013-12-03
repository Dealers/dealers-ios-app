//
//  SigninViewController.h
//  GooglePlaces
//
//  Created by itzik berrebi on 9/26/13.
//
//

#import <UIKit/UIKit.h>

@interface SigninViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UINavigationBarDelegate>

@property (weak, nonatomic) IBOutlet UITextField *EmailText;
@property (weak, nonatomic) IBOutlet UITextField *PasswordText;
- (IBAction)SinginButton:(id)sender;
@property (nonatomic, strong) NSMutableArray *PASSWORDMARRAY;
@property (weak, nonatomic) IBOutlet UIButton *Signinbutton;
- (IBAction)ReturnButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *ReturnButton;
@property (weak, nonatomic) IBOutlet UIButton *ReturnButtonFull;

@property (weak, nonatomic) IBOutlet UIImageView *LoadingImage;
@property (weak, nonatomic) IBOutlet UIImageView *PurpImage;

@end

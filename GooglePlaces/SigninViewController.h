//
//  SigninViewController.h
//  GooglePlaces
//
//  Created by itzik berrebi on 9/26/13.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface SigninViewController : UIViewController <UITextFieldDelegate, UINavigationControllerDelegate,UINavigationBarDelegate>
{
    //sqlite3 *db;
    BOOL error, isPopping;
}

@property AppDelegate *appDelegate;

@property (weak, nonatomic) IBOutlet UITextField *EmailText;
@property (weak, nonatomic) IBOutlet UITextField *PasswordText;
- (IBAction)SigninButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *Signinbutton;
- (IBAction)ReturnButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *ReturnButton;
@property (weak, nonatomic) IBOutlet UIButton *ReturnButtonFull;
@property (weak, nonatomic) IBOutlet UIImageView *LoadingImage;
@property (weak, nonatomic) IBOutlet UIImageView *PurpImage;
@property (nonatomic) UIApplication *app;


@end

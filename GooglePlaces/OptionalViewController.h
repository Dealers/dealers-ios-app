//
//  OptionalViewController.h
//  GooglePlaces
//
//  Created by itzik berrebi on 9/25/13.
//
//

#import <UIKit/UIKit.h>

@interface OptionalViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
   NSString *dealphotoid;
    NSString *sign;
}
@property (weak, nonatomic) IBOutlet UIImageView *dealphoto;
@property (weak, nonatomic) IBOutlet UITextField *categorylabel;
@property (weak, nonatomic) IBOutlet UITextField *pricelabel;
@property (weak, nonatomic) IBOutlet UITextField *discountlabel;
@property (weak, nonatomic) IBOutlet UITextField *expirationlabel;
@property (weak, nonatomic) IBOutlet UITextField *descriptionlabel;
- (IBAction)adddealbutton:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *groupbefore;
@property (weak, nonatomic) IBOutlet UIImageView *groupafter;
@property (weak, nonatomic) IBOutlet UIImageView *facebookbefore;
@property (weak, nonatomic) IBOutlet UIImageView *facebookafter;
@property (weak, nonatomic) IBOutlet UIImageView *twittbefore;
@property (weak, nonatomic) IBOutlet UIImageView *twittafter;
@property (weak, nonatomic) IBOutlet UIButton *groupicon;
@property (weak, nonatomic) IBOutlet UIButton *facebookicon;
@property (weak, nonatomic) IBOutlet UIButton *twiiticon;
- (IBAction)groupbutton:(id)sender;
- (IBAction)facebookbutton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *twittbutton;

@property (weak, nonatomic) NSString *group;
@property (weak, nonatomic) NSString *facebook;
@property (weak, nonatomic) NSString *twitter;
- (IBAction)twittbutton:(id)sender;
- (IBAction)whatappButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIPickerView *CategoryPicker;
@property (weak, nonatomic) IBOutlet UINavigationBar *CategoryNavBar;
- (IBAction)CateoryButtonAction:(id)sender;
- (IBAction)Cateory_DoneButtonAction:(id)sender;
- (IBAction)ExpireButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) NSMutableArray *list;
@property (weak, nonatomic) IBOutlet UIImageView *PriceNavBar;
- (IBAction)DollarButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *DollarButton;
@property (weak, nonatomic) IBOutlet UIButton *ShekelButton;
- (IBAction)ShekelButtonAction:(id)sender;
- (IBAction)PoundButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *PoundButton;
@property (weak, nonatomic) IBOutlet UIButton *PoundButtonFull;
@property (weak, nonatomic) IBOutlet UIButton *ShekelButtonFull;
@property (weak, nonatomic) IBOutlet UIButton *DollarButtonFull;
@property (weak, nonatomic) IBOutlet UIButton *PersentButtonFull;
@property (weak, nonatomic) IBOutlet UIButton *PersentButton;
- (IBAction)PersentButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIDatePicker *DatePicker;
@property (weak, nonatomic) IBOutlet UINavigationBar *DateNavBar;
- (IBAction)Date_DoneButtonAction:(id)sender;
- (IBAction)ChagrtoDateAction:(id)sender;
- (IBAction)ChagrtoTimeAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *ChagrtoDate;
@property (weak, nonatomic) IBOutlet UIButton *ChagrtoTime;

@property (weak, nonatomic) IBOutlet UIButton *ReturnButton;
@property (weak, nonatomic) IBOutlet UIButton *ReturnButtonFull;
- (IBAction)ReturnButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *ChangetotimeFull;
- (IBAction)ChangetotimeFullAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *ChangetodateFull;
- (IBAction)ChangetodateFullAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *LoadingDeal;
@property (weak, nonatomic) IBOutlet UIImageView *Coverblack;
@property (weak, nonatomic) IBOutlet UIImageView *LoadingImage;

@property (weak, nonatomic) IBOutlet UIButton *DoneButton;
- (IBAction)DoneButtonAction:(id)sender;

@end

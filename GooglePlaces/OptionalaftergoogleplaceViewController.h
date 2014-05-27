//
//  OptionalViewController.h
//  GooglePlaces
//
//  Created by itzik berrebi on 20/3/2014.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import "GKImagePicker.h"

@interface OptionalaftergoogleplaceViewController : UIViewController <UITextFieldDelegate,UINavigationControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,GKImagePickerDelegate>
{
    NSString *dealphotoid;
    NSString *timeorday;
    NSString *sign;
    int numofpics;
    int currentpage;
    BOOL Flag;
    BOOL FrontCamera;
    BOOL haveImage;
    BOOL isMoreOptionViewHidden;
    NSString *segcategorey;
    NSString *timeOrDate;
    NSString *resultFromDb;
    BOOL allocDatePicker;
    BOOL allocCategoryPicker;
}
@property (strong) AVCaptureSession *captureSession;

@property (strong,nonatomic) NSString *urlSite;
@property (strong,nonatomic) NSString *storeName;
@property (strong,nonatomic) NSString *segcategory;
@property (strong,nonatomic) NSString *seglat;
@property (strong,nonatomic) NSString *seglong;
@property (strong,nonatomic) NSString *segstoreAddress;

@property (strong,nonatomic) NSString *titleText;
@property (strong,nonatomic) NSString *descriptionText;
@property (strong,nonatomic) NSString *priceText;
@property (strong,nonatomic) NSString *discountText;

@property (weak, nonatomic) IBOutlet UILabel *whatIsTheDealLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dealphoto;
@property (weak, nonatomic) IBOutlet UITextView *titlelabel;
@property (weak, nonatomic) IBOutlet UILabel *countlabel;
@property (weak, nonatomic) IBOutlet UITextField *categorylabel;
@property (weak, nonatomic) IBOutlet UITextField *pricelabel;
@property (weak, nonatomic) IBOutlet UITextField *discountlabel;
@property (weak, nonatomic) IBOutlet UITextField *expirationlabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionlabel;
@property (weak, nonatomic) IBOutlet UITextView *DescriptionTextView;

- (IBAction)adddealbutton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *AddDealButton;

@property (weak, nonatomic) IBOutlet UIButton *groupicon;
@property (weak, nonatomic) IBOutlet UIButton *facebookicon;
@property (weak, nonatomic) IBOutlet UIButton *twiiticon;
@property (weak, nonatomic) IBOutlet UIButton *whatsappicon;

- (IBAction)groupbutton:(id)sender;
- (IBAction)facebookbutton:(id)sender;
- (IBAction)whatsappbutton:(id)sender;

@property (weak, nonatomic) NSString *whatsapp;
@property (weak, nonatomic) NSString *group;
@property (weak, nonatomic) NSString *facebook;
@property (weak, nonatomic) NSString *twitter;
@property (weak, nonatomic) NSString *morebutton;

- (IBAction)twittbutton:(id)sender;
//- (IBAction)whatappButton:(id)sender;
@property (retain, nonatomic) UIPickerView *CategoryPicker;
@property (weak, nonatomic) IBOutlet UINavigationBar *CategoryNavBar;
@property (weak, nonatomic) IBOutlet UINavigationBar *priceNavBar;

- (IBAction)CateoryButtonAction:(id)sender;
- (IBAction)Cateory_DoneButtonAction:(id)sender;
- (IBAction)ExpireButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollcamera;

@property (strong, nonatomic) NSMutableArray *categoryListArray;
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

@property (strong, nonatomic) UIDatePicker *DatePicker;
@property (weak, nonatomic) IBOutlet UINavigationBar *DateNavBar;
- (IBAction)Date_DoneButtonAction:(id)sender;
- (IBAction)ChagrtoDateAction:(id)sender;
- (IBAction)ChagrtoTimeAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *ChagrtoDate;
@property (weak, nonatomic) IBOutlet UIButton *ChagrtoTime;
@property (weak, nonatomic) IBOutlet UIButton *ChangetotimeFull;
- (IBAction)ChangetotimeFullAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *ChangetodateFull;
- (IBAction)ChangetodateFullAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *LoadingDeal;

@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountSignLable;

- (IBAction)ReturnButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *ReturnButton;
@property (weak, nonatomic) IBOutlet UIButton *ReturnButtonFull;
@property (weak, nonatomic) IBOutlet UIImageView *Coverblack;
@property (weak, nonatomic) IBOutlet UIImageView *LoadingImage;

@property (weak, nonatomic) IBOutlet UIButton *DoneButton;
- (IBAction)DoneButtonAction:(id)sender;

@property(nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;
@property (weak, nonatomic) IBOutlet UIView *imagePreview;
- (IBAction)snapImage:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *captureImage;
@property (weak, nonatomic) IBOutlet UIImageView *captureImage2;
@property (weak, nonatomic) IBOutlet UIImageView *captureImage3;
@property (weak, nonatomic) IBOutlet UIImageView *captureImage4;
@property (weak, nonatomic) IBOutlet UIImageView *BlackCoverImage;
@property (weak, nonatomic) IBOutlet UIButton *ExitCameraButton;
- (IBAction)ExitCameraButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *RotateCamButton;
- (IBAction)RotateCamButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *PicFromLibButton;
- (IBAction)PicFromLibButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *AddAnotherPicButton;
- (IBAction)AddAnotherPicButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *TrashButton;
- (IBAction)TrashButtonAction:(id)sender;
- (IBAction)MoreButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *MoreView;
@property (weak, nonatomic) IBOutlet UIView *SocialView;
@property (weak, nonatomic) IBOutlet UIButton *SnapButton;
@property (weak, nonatomic) IBOutlet UIButton *SnapButton2;

@property (strong, nonatomic) NSMutableArray *StoreSearchArray;
@property (weak, nonatomic) IBOutlet UIButton *MoreButtonButton;
@property (weak, nonatomic) IBOutlet UIView *GrayCoverView;
@property (weak, nonatomic) IBOutlet UIView *FlashView;
@property (nonatomic, strong) GKImagePicker *imagePicker;
@property (weak, nonatomic) IBOutlet UIPageControl *PageControl;
- (IBAction)cancelDatePickerPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *hideCameraImage;
@property (weak, nonatomic) IBOutlet UIImageView *loadingIconCameraImage;

@end

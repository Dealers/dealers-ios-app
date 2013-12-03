//
//  OptionalViewController.h
//  GooglePlaces
//
//  Created by itzik berrebi on 9/25/13.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import <MapKit/MapKit.h>


@interface OptionalaftergoogleplaceViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate,UINavigationBarDelegate,UINavigationControllerDelegate,MKMapViewDelegate,CLLocationManagerDelegate>
{
    NSString *dealphotoid;
    NSString *timeorday;
    NSString *sign;
    BOOL FrontCamera;
    BOOL haveImage;
    CLLocationManager *locationManager;
    CLLocationCoordinate2D currentCentre;



}
@property (strong,nonatomic) NSString *segstore;

@property (weak, nonatomic) IBOutlet UIImageView *dealphoto;
@property (weak, nonatomic) IBOutlet UITextField *titlelabel;
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
@property (weak, nonatomic) IBOutlet UIImageView *whatsappbefore;
@property (weak, nonatomic) IBOutlet UIImageView *whatsappafter;

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
- (IBAction)twittbutton:(id)sender;
//- (IBAction)whatappButton:(id)sender;
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
@property (weak, nonatomic) IBOutlet UIButton *ChangetotimeFull;
- (IBAction)ChangetotimeFullAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *ChangetodateFull;
- (IBAction)ChangetodateFullAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *LoadingDeal;


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
@property (retain, nonatomic) IBOutlet MKMapView *mapView;

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

@end

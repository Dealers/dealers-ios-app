
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>


@interface ViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIAlertViewDelegate,MKMapViewDelegate,CLLocationManagerDelegate,UIActionSheetDelegate>
{
    NSString *Photoid;
    CLLocationManager *locationManager;
    CLLocationCoordinate2D currentCentre;
    NSString *didaddphoto;
    NSString *firstornot;

}

- (IBAction)Addphotobutton:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *addedphoto;
@property (weak, nonatomic) IBOutlet UITextField *titlelabel;
@property (weak, nonatomic) IBOutlet UITextField *storelabel;
@property (weak, nonatomic) IBOutlet UIButton *AddPhotoButton_noaction;
@property (weak, nonatomic) IBOutlet UIButton *OKbutton;
@property (weak, nonatomic) IBOutlet UIButton *OKButtonFull;

- (IBAction)OKbutton:(id)sender;

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *BackButton;
@property (weak, nonatomic) IBOutlet UIButton *BackButtonSelected;
- (IBAction)BackButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *Scroll;
@property (weak, nonatomic) IBOutlet UILabel *AreYouThere;
@property (weak, nonatomic) IBOutlet UIButton *YesButton;
@property (weak, nonatomic) IBOutlet UIButton *YesButtonSelected;
@property (weak, nonatomic) IBOutlet UIButton *NoButton;
@property (weak, nonatomic) IBOutlet UIButton *NoButtonSelected;

- (IBAction)NoButton:(id)sender;
- (IBAction)YesButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *CoverButton;
@property (weak, nonatomic) IBOutlet UIImageView *FillBox;
@property (weak, nonatomic) IBOutlet UIImageView *CoverBlack;

@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *StoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *Shade;
@property (weak, nonatomic) IBOutlet UIImageView *Shade2;
@property (weak, nonatomic) IBOutlet UIButton *WhiteButton;
@property (weak, nonatomic) IBOutlet UILabel *WhereistheDeal;
@property (weak, nonatomic) IBOutlet UILabel *WhatisheDeal;
@property (weak, nonatomic) IBOutlet UIImageView *NoFill;
@property (weak, nonatomic) IBOutlet UILabel *Add_deal_text;
@property (weak, nonatomic) IBOutlet UIView *MapView2;
@property (weak, nonatomic) IBOutlet UIView *AreyouthereView;


@property (weak, nonatomic) IBOutlet UIImageView *StarImage;
@property (weak, nonatomic) IBOutlet UIImageView *Secondary2Image;
@property (weak, nonatomic) IBOutlet UIImageView *Secondary3Image;
@property (weak, nonatomic) IBOutlet UIImageView *Secondary4Image;
@property (weak, nonatomic) IBOutlet UIImageView *secondimage;
@property (weak, nonatomic) IBOutlet UIImageView *thirdimage;
@property (weak, nonatomic) IBOutlet UIImageView *fourth;
@property (weak, nonatomic) IBOutlet UIButton *secondimageB;
@property (weak, nonatomic) IBOutlet UIButton *thirdimageB;
@property (weak, nonatomic) IBOutlet UIButton *fourthimageB;
@property (weak, nonatomic) IBOutlet UIButton *secondimageBFull;
@property (weak, nonatomic) IBOutlet UIButton *thirdimageBFull;
@property (weak, nonatomic) IBOutlet UIButton *fourthimageBFull;
@property (weak, nonatomic) IBOutlet UIButton *thirdimageBS;
@property (weak, nonatomic) IBOutlet UIButton *secondimageBS;
@property (weak, nonatomic) IBOutlet UIButton *fourthimageBS;
- (IBAction)secondimageButton:(id)sender;
- (IBAction)thirdimageButton:(id)sender;
- (IBAction)fourthimageButton:(id)sender;
- (IBAction)secondimageSquare:(id)sender;
- (IBAction)fourthimagesSquare:(id)sender;
- (IBAction)thirdimagrSquare:(id)sender;
@end

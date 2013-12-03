//
//  ResaftergoogleplaceViewController.h
//  GooglePlaces
//
//  Created by itzik berrebi on 9/25/13.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ResaftergoogleplaceViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIAlertViewDelegate,MKMapViewDelegate,CLLocationManagerDelegate,UIActionSheetDelegate>
{
    NSString *firstornot;
    CLLocationManager *locationManager;
    CLLocationCoordinate2D currentCentre;


    
}

@property (strong,nonatomic) NSString *segtitle;
@property (strong,nonatomic) NSString *segstore;

@property (weak, nonatomic) IBOutlet UITextField *titlelabel;
@property (weak, nonatomic) IBOutlet UILabel *storelabel;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *StoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *WhereistheDeal;
@property (weak, nonatomic) IBOutlet UILabel *WhatisheDeal;

@property (weak, nonatomic) IBOutlet UIButton *OKbutton;
@property (weak, nonatomic) IBOutlet UIButton *OKButtonFull;
@property (weak, nonatomic) IBOutlet UIButton *Returnbutton;
@property (weak, nonatomic) IBOutlet UIButton *ReturnButtonFull;
- (IBAction)ReturnButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *addedphotobutton;
- (IBAction)OKbutton:(id)sender;
- (IBAction)Addphotobutton:(id)sender;
- (IBAction)secondimageButton:(id)sender;
- (IBAction)thirdimageButton:(id)sender;
- (IBAction)fourthimageButton:(id)sender;
- (IBAction)secondimageSquare:(id)sender;
- (IBAction)fourthimagesSquare:(id)sender;
- (IBAction)thirdimagrSquare:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *thirdimageBS;
@property (weak, nonatomic) IBOutlet UIButton *secondimageBS;
@property (weak, nonatomic) IBOutlet UIButton *fourthimageBS;


@property (weak, nonatomic) IBOutlet UIImageView *addedphoto;
@property (weak, nonatomic) IBOutlet UIImageView *secondimage;
@property (weak, nonatomic) IBOutlet UIImageView *thirdimage;
@property (weak, nonatomic) IBOutlet UIImageView *fourth;
@property (weak, nonatomic) IBOutlet UIButton *secondimageB;
@property (weak, nonatomic) IBOutlet UIButton *thirdimageB;
@property (weak, nonatomic) IBOutlet UIButton *fourthimageB;
@property (weak, nonatomic) IBOutlet UIButton *secondimageBFull;
@property (weak, nonatomic) IBOutlet UIButton *thirdimageBFull;
@property (weak, nonatomic) IBOutlet UIButton *fourthimageBFull;
@property (weak, nonatomic) IBOutlet UIButton *ShadowButton;
@property (weak, nonatomic) IBOutlet UIImageView *ShadowImage;

@property (weak, nonatomic) IBOutlet UIImageView *StarImage;
@property (weak, nonatomic) IBOutlet UIImageView *Secondary2Image;
@property (weak, nonatomic) IBOutlet UIImageView *Secondary3Image;
@property (weak, nonatomic) IBOutlet UIImageView *Secondary4Image;

@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIScrollView *Scroll;

@end

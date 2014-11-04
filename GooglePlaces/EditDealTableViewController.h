//
//  EditDealTableViewController.h
//  Dealers-testbeta
//
//  Created by Gilad Lumbroso on 7/20/14.
//
//

#import <UIKit/UIKit.h>
#import "Deal.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "ViewonedealViewController.h"
#import "EditTextModeViewController.h"
#import "WhereIsTheDeal.h"
#import "ChooseCategoryTableViewController.h"
#import "MBProgressHUD.h"

@interface EditDealTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, MBProgressHUDDelegate> {
    
    BOOL isFrontCamera, isSessionRunning, shouldDealloc;
    MBProgressHUD *illogicalPercentage, *uploadingDeal;
    UIColor *placeholderColor;
}

@property AppDelegate *appDelegate;

@property id delegate;

@property Deal *deal;

@property Store *store;

@property (weak, nonatomic) IBOutlet UILabel *dealTitle;
@property (weak, nonatomic) IBOutlet UILabel *dealStore;
@property (weak, nonatomic) IBOutlet UILabel *dealPrice;
@property (weak, nonatomic) IBOutlet UILabel *dealDiscount;

@property NSString *selectedCurrency;
@property NSString *selectedDiscountType;

@property (weak, nonatomic) IBOutlet UILabel *dealCategory;
@property (weak, nonatomic) IBOutlet UILabel *dealExpirationDate;
@property (weak, nonatomic) IBOutlet UILabel *dealDescription;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITableViewCell *datePickerCell;
@property (weak, nonatomic) IBOutlet UIButton *noDateButton;
@property (nonatomic) NSDateFormatter *dateFormatter;
@property (nonatomic) NSDateFormatter *dateFormatterDataBase;
@property BOOL datePickerIsShowing;
@property BOOL didCancelDate;

@property (nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;
@property AVCaptureSession *session;
@property AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (weak, nonatomic) IBOutlet UITableViewCell *cameraCell;
@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (weak, nonatomic) IBOutlet UIView *cameraSection;
@property (weak, nonatomic) IBOutlet UIView *flash;

@property (weak, nonatomic) IBOutlet UIScrollView *cameraScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *captureImage;
@property (weak, nonatomic) IBOutlet UIImageView *captureImage2;
@property (weak, nonatomic) IBOutlet UIImageView *captureImage3;
@property (weak, nonatomic) IBOutlet UIImageView *captureImage4;
@property (weak, nonatomic) IBOutlet UIView *capturedImagesSection;
@property (weak, nonatomic) IBOutlet UIButton *addAnotherPhoto;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UIButton *addPhoto;
@property (nonatomic) NSMutableArray *photosArray;

@property BOOL didChangeOriginalDeal;


- (IBAction)snap:(id)sender;
- (IBAction)addPhoto:(id)sender;
- (IBAction)rotateCamera:(id)sender;
- (IBAction)exitCameraMode:(id)sender;

@end

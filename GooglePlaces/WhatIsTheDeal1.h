//
//  WhatIsTheDeal1.h
//  Dealers
//
//  Created by Gilad Lumbroso on 10/2/14.
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "WhatIsTheDeal2.h"
#import "Deal.h"
#import "Store.h"
#import "Dealer.h"
#import "MBProgressHUD.h"

@interface WhatIsTheDeal1 : UITableViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UITextViewDelegate, UITextFieldDelegate, MBProgressHUDDelegate> {
    
    BOOL isFrontCamera, isSessionRunning, shouldDealloc;
    MBProgressHUD *blankTitleIndicator, *tooMuchIndicator, *illogicalPercentage;
    
}

@property AppDelegate *appDelegate;

@property Deal *deal;
@property Store *store;

@property (weak, nonatomic) IBOutlet UITextView *dealTitle;
@property (weak, nonatomic) IBOutlet UILabel *titlePlaceholder;
@property (nonatomic) UILabel *countLabel;
@property (nonatomic) UIView *countContainer;

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
@property (weak, nonatomic) IBOutlet UIView *cameraBlackCover;

@property (weak, nonatomic) IBOutlet UIButton *addPhoto;
@property (nonatomic) NSMutableArray *photosArray;

@property BOOL tooMuchText;


- (IBAction)snap:(id)sender;
- (IBAction)addPhoto:(id)sender;
- (IBAction)rotateCamera:(id)sender;
- (IBAction)exitCameraMode:(id)sender;

@end

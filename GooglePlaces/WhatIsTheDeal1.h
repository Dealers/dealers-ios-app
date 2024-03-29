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
#import "GKImagePicker.h"
#import "FullScreenCameraViewController.h"
#import "Deal.h"
#import "Store.h"
#import "Dealer.h"
#import "ElasticLabel.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

#import "MBProgressHUD.h"

@interface WhatIsTheDeal1 : UITableViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UITextViewDelegate, UITextFieldDelegate, MBProgressHUDDelegate, GKImagePickerDelegate> {
    
    BOOL isFrontCamera, isSessionRunning, shouldDealloc;
    AVCaptureDeviceInput *frontCameraInput, *backCameraInput;
    CGFloat titleHeight;
    MBProgressHUD *blankTitleIndicator, *tooMuchIndicator, *illogicalPercentage;
    
}

@property AppDelegate *appDelegate;

@property Deal *deal;
@property Store *store;
@property NSString *cashedCategory;

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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthContentViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpaceCapturedImagesSectionContentViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpaceAddPhotoContentViewConstraint;

@property (weak, nonatomic) IBOutlet UIButton *snapButton;
@property (weak, nonatomic) IBOutlet UIButton *rotateCameraButton;
@property (weak, nonatomic) IBOutlet UIButton *exitCameraModeButton;

@property (nonatomic, strong) GKImagePicker *imagePicker;

@property (weak, nonatomic) IBOutlet UIButton *addPhoto;
@property (nonatomic) NSMutableArray *photosArray;
@property (nonatomic) NSMutableArray *photosFileName;

@property (weak, nonatomic) IBOutlet UILabel *hintLabel;

@property WhatIsTheDeal2 *cashedInstance;

@property BOOL tooMuchText;
@property BOOL isShowingFullScreenCamera;

- (IBAction)snap:(id)sender;
- (IBAction)addPhoto:(id)sender;
- (IBAction)rotateCamera:(id)sender;
- (IBAction)exitCameraMode:(id)sender;
- (IBAction)addFromLibrary:(id)sender;

@end

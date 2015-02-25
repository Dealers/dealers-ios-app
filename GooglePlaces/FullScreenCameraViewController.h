//
//  FullScreenCameraViewController.h
//  Dealers
//
//  Created by Gilad Lumbroso on 2/23/15.
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "GKImagePicker.h"

@interface FullScreenCameraViewController : UIViewController <UIAlertViewDelegate, UIScrollViewDelegate, GKImagePickerDelegate> {
    
    BOOL isSessionRunning, shouldDealloc;
}

@property AppDelegate *appDelegate;
@property id delegate;

@property BOOL isFrontCamera;
@property BOOL isCameraActive;

@property (nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;
@property AVCaptureSession *session;
@property AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (weak, nonatomic) IBOutlet UIView *liveCameraView;
@property (weak, nonatomic) IBOutlet UIView *blackCoverView;
@property (weak, nonatomic) IBOutlet UIButton *snapButton;
@property (weak, nonatomic) IBOutlet UIButton *rotateCamera;
@property (weak, nonatomic) IBOutlet UIButton *exitCameraMode;

@property (weak, nonatomic) IBOutlet UIView *capturedImagesView;
@property (weak, nonatomic) IBOutlet UIScrollView *cameraScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *capturedImage1;
@property (weak, nonatomic) IBOutlet UIImageView *capturedImage2;
@property (weak, nonatomic) IBOutlet UIImageView *capturedImage3;
@property (weak, nonatomic) IBOutlet UIImageView *capturedImage4;
@property (weak, nonatomic) IBOutlet UIButton *anotherPhotoButton;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIView *flash;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *capturedImagesViewTopConstraint;

@property NSMutableArray *photosArray;

@property (nonatomic, strong) GKImagePicker *imagePicker;

- (IBAction)takePhoto:(id)sender;
- (IBAction)addFromLibrary:(id)sender;
- (IBAction)takeAnotherPhoto:(id)sender;
- (IBAction)rotateCamera:(id)sender;
- (IBAction)exitCameraMode:(id)sender;
- (IBAction)trash:(id)sender;

@end

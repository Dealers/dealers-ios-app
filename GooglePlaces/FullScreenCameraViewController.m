//
//  FullScreenCameraViewController.m
//  Dealers
//
//  Created by Gilad Lumbroso on 2/23/15.
//
//

#import "FullScreenCameraViewController.h"

#define DegreesToRadians(x) ((x) * M_PI / 180.0)

@interface FullScreenCameraViewController ()

@end

@implementation FullScreenCameraViewController

@synthesize appDelegate, session, captureVideoPreviewLayer, isFrontCamera;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)initializeCamera
{
    session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetPhoto;
    
    captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        captureVideoPreviewLayer.frame = self.cameraView.bounds;
        [self.cameraView.layer addSublayer:captureVideoPreviewLayer];
        self.cameraView.layer.masksToBounds = YES;
    });
    
    NSArray *devices = [AVCaptureDevice devices];
    AVCaptureDevice *frontCamera;
    AVCaptureDevice *backCamera;
    
    for (AVCaptureDevice *device in devices) {
        
        NSLog(@"Device name: %@", [device localizedName]);
        
        if ([device hasMediaType:AVMediaTypeVideo]) {
            
            if ([device position] == AVCaptureDevicePositionBack) {
                NSLog(@"Device position : back");
                backCamera = device;
            }
            else {
                NSLog(@"Device position : front");
                frontCamera = device;
            }
        }
    }
    
    if (!isFrontCamera) {
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:&error];
        if (!input) {
            NSLog(@"ERROR: trying to open camera: %@", error);
        }
        [session addInput:input];
    }
    
    if (isFrontCamera) {
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:frontCamera error:&error];
        if (!input) {
            NSLog(@"ERROR: trying to open camera: %@", error);
        }
        [session addInput:input];
    }
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    [session addOutput:self.stillImageOutput];
    
    [session startRunning];
    
    isSessionRunning = YES;
}

- (void)deallocCameraSession
{
    [captureVideoPreviewLayer removeFromSuperlayer];
    AVCaptureInput* input = [session.inputs objectAtIndex:0];
    [session removeInput:input];
    AVCaptureVideoDataOutput* output = [session.outputs objectAtIndex:0];
    [session removeOutput:output];
    [session stopRunning];
    session = nil;
    captureVideoPreviewLayer = nil;
    isSessionRunning = NO;
}

- (void)initializeCameraSection {
    
    // First checking if there is any photo at all (shouldn't be here in WhatIsTheDeal1):
    
    if (!self.photosArray) {
        
        self.cameraView.hidden = NO;
        self.capturedImagesView.hidden = YES;
        
    } else {
        
        self.cameraView.hidden = YES;
        self.capturedImagesView.hidden = NO;
        
        for (int i = 0; i < [self.photosArray count]; i++) {
            
            // Creating an imageView object in every 'page' of our scrollView:
            
            CGRect frame;
            frame.origin.x = self.cameraScrollView.frame.size.width * i;
            frame.origin.y = 0;
            frame.size = self.cameraScrollView.frame.size;
            
            int tag = i + 1;
            UIImageView *captureImageView = (UIImageView *)[self.cameraScrollView viewWithTag: tag];
            captureImageView.image = [self.photosArray objectAtIndex:i];
            captureImageView.frame = frame;
        }
    }
    
    // Setting the content size of the camera scroll view
    
    self.cameraScrollView.contentSize = CGSizeMake(self.cameraScrollView.frame.size.width * [self.photosArray count], self.cameraScrollView.frame.size.height - 1);
    
    if (self.photosArray.count == 4) {
        self.anotherPhotoButton.hidden = YES;
    }
    
    // Finally, setting camera in the background (if exists in the device)
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Camera", nil)
                                                              message:NSLocalizedString(@"Your device has no camera. You can still add photos from your library", nil)
                                                             delegate:nil
                                                    cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                    otherButtonTitles: nil];
        [myAlertView show];
        self.snapButton.hidden = YES;
        self.exitCameraMode.hidden = YES;
        self.rotateCamera.hidden = YES;
        
        return;
    }
    
    dispatch_queue_t queue = dispatch_queue_create("com.MyQueue", NULL);
    dispatch_async(queue, ^{
        
        [self initializeCamera];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.3
                             animations:^{ self.blackCoverView.alpha = 0; }
                             completion:^(BOOL finished) { self.blackCoverView.hidden = YES; }];
        });
    });
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = self.cameraScrollView.frame.size.width;
    int page = floor((self.cameraScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

- (IBAction)takePhoto:(id)sender {
    
    [UIView animateWithDuration: 0.1 animations:^{ self.flash.alpha = 1.0; }];
    [self capImage];
}

- (void)hideFlash {
    [UIView animateWithDuration: 1.0 animations:^{ self.flash.alpha = 0; }];
}

- (IBAction)takeAnotherPhoto:(id)sender {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Camera", nil)
                                                              message:NSLocalizedString(@"Your device has no camera. You can still add photos from your library", nil)
                                                             delegate:nil
                                                    cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                    otherButtonTitles: nil];
        [myAlertView show];
        self.snapButton.hidden = YES;
        self.exitCameraMode.hidden = YES;
        self.rotateCamera.hidden = YES;
        
        return;
    }
    
    if (!isSessionRunning) {
        dispatch_queue_t queue = dispatch_queue_create("com.MyQueue", NULL);
        dispatch_async(queue, ^{
            [self initializeCamera];
        });
    }
    
    [self hideCapturedImagesView];
}

- (IBAction)rotateCamera:(id)sender {
    
    dispatch_queue_t queue = dispatch_queue_create("com.MyQueue", NULL);
    dispatch_async(queue, ^{
        if (isFrontCamera == NO) {
            isFrontCamera = YES;
            [self initializeCamera];
        } else {
            isFrontCamera = NO;
            [self initializeCamera];
        }
    });
}

- (IBAction)exitCameraMode:(id)sender {
    
    if (self.photosArray.count == 0) {
        [self.delegate dismissViewControllerAnimated:YES completion:nil];
        NSNotification *notification = [[NSNotification alloc] initWithName:@"CameraModeDismissed" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
    } else {
        [self showCapturedImagesView];
    }
}

- (void)showCapturedImagesView
{
    self.capturedImagesView.hidden = NO;
    self.capturedImagesView.alpha = 0;
    self.capturedImagesViewTopConstraint.constant = 0;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
        self.capturedImagesView.alpha = 1.0;
    }];
}

- (void)hideCapturedImagesView
{
    self.capturedImagesViewTopConstraint.constant = -(self.cameraView.frame.size.height);
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view layoutIfNeeded];
                         self.capturedImagesView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         self.capturedImagesView.hidden = YES;
                     }];
}

- (IBAction)trash:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Delete Photo", nil)
                                                    message:NSLocalizedString(@"Are you sure want to delete this photo?", nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                          otherButtonTitles:NSLocalizedString(@"Yes", nil), nil];
    alert.tag = 22;
    [alert show];
}

- (void)capImage // Method to capture image from AVCaptureSession video feed
{
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.stillImageOutput.connections) {
        
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        
        if (videoConnection) {
            break;
        }
    }
    
    NSLog(@"about to request a capture from: %@", self.stillImageOutput);
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        
        if (imageSampleBuffer != NULL) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
            [self processImage:[UIImage imageWithData:imageData]];
        }
    }];
}

- (void)processImage:(UIImage *)image // Process captured image, crop, resize and rotate
{
    // Photo Handling Process Explination:
    
    // The "Image Divider" is the number determining how many times smaller the resized photo
    // will be after shrinking it. The smaller it'll be, the faster it will be downloaded.
    // After the shrinking, the photo is still too big to fit the iPhone screen, so we need
    // to modify the croping rect so it'll fit the size of the resized photo, that's being done by
    // the "Image Mulitplier". The Image Multiplier needs to be multiplied by 2, probably
    // because of the retina display.
    
    CGFloat imageSizeMultiplier = 2;
    CGFloat imageSizeDivider = image.size.width / 414.0;
    
    UIImage *resizedImage = [appDelegate resizeImage:image toSize:CGSizeMake(image.size.width / imageSizeDivider, image.size.height / imageSizeDivider)];
    
    NSLog(@"\n\nThe size of the resized photo is: %f, %f", resizedImage.size.width, resizedImage.size.height);
    
    CGFloat originX = self.cameraView.frame.origin.x * imageSizeMultiplier;
    CGFloat originY = self.cameraView.frame.origin.y * imageSizeMultiplier;
    CGFloat sizeWidth = self.capturedImage1.frame.size.width * imageSizeMultiplier;
    CGFloat sizeHeight = self.capturedImage1.frame.size.height * imageSizeMultiplier;
    
    CGRect cropRect = CGRectMake(originX, originY, sizeWidth, sizeHeight);
    
    UIImage *finalImage = [UIImage imageWithCGImage:(__bridge CGImageRef)(CFBridgingRelease(CGImageCreateWithImageInRect([resizedImage CGImage], cropRect)))];
    
    [self addNewPhotoToList:finalImage];
    
    //  [self deallocCameraSession];
    /*
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) {
        NSLog(@"landscape left image");
        
        [UIView beginAnimations:@"rotate" context:nil];
        [UIView setAnimationDuration:0.5];
        self.capturedImagesView.transform = CGAffineTransformMakeRotation(DegreesToRadians(-90));
        [UIView commitAnimations];
    }
    
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
        NSLog(@"landscape right");
        
        [UIView beginAnimations:@"rotate" context:nil];
        [UIView setAnimationDuration:0.5];
        captureImage.transform = CGAffineTransformMakeRotation(DegreesToRadians(90));
        [UIView commitAnimations];
    }
    
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) {
        NSLog(@"upside down");
        [UIView beginAnimations:@"rotate" context:nil];
        [UIView setAnimationDuration:0.5];
        captureImage.transform = CGAffineTransformMakeRotation(DegreesToRadians(180));
        [UIView commitAnimations];
    }
    
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait) {
        NSLog(@"upside upright");
        [UIView beginAnimations:@"rotate" context:nil];
        [UIView setAnimationDuration:0.5];
        captureImage.transform = CGAffineTransformMakeRotation(DegreesToRadians(0));
        [UIView commitAnimations];
    }
     */
}

- (void)addNewPhotoToList:(UIImage *)image
{
    if (!self.photosArray) {
        self.capturedImage1.image = image;
        self.photosArray = [NSMutableArray arrayWithObjects:self.capturedImage1.image, nil];
        self.pageControl.numberOfPages = 1;
        
    } else {
        [self.photosArray addObject:image];
        [self setCapturedSectionAfterSnap];
    }
    
    self.cameraView.hidden = YES;
    self.capturedImagesView.hidden = NO;
    self.capturedImagesViewTopConstraint.constant = 0;
    [self.view layoutIfNeeded];
    [self hideFlash];
    
    if (shouldDealloc) {
        [self deallocCameraSession];
        shouldDealloc = NO;
    }
}

- (void)setCapturedSectionAfterSnap
{
    CGRect frame;
    NSUInteger i = self.photosArray.count - 1;
    frame.origin.x = self.cameraScrollView.frame.size.width * i;
    frame.origin.y = 0;
    frame.size = self.cameraScrollView.frame.size;
    
    unsigned long tag = i + 1;
    UIImageView *capturedImageView = (UIImageView *)[self.cameraScrollView viewWithTag:tag];
    capturedImageView.image = [self.photosArray objectAtIndex:i];
    capturedImageView.frame = frame;
    
    self.cameraScrollView.contentSize = CGSizeMake(self.cameraScrollView.frame.size.width * [self.photosArray count], self.cameraScrollView.frame.size.height - 1);
    self.cameraScrollView.contentOffset = frame.origin;
    
    self.pageControl.numberOfPages++;
    self.pageControl.currentPage = i;
    
    if (self.photosArray.count == 4) {
        self.anotherPhotoButton.hidden = YES;
    } else {
        self.anotherPhotoButton.hidden = NO;
    }
}

- (void)setCapturedSectionAfterDelete
{
    NSInteger currentPage = self.pageControl.currentPage;
    
    if (currentPage == 0) {
        
        switch (self.photosArray.count) {
            case 1:
                self.capturedImage1.image = nil;
                break;
            case 2:
                self.capturedImage1.image = self.capturedImage2.image;
                self.capturedImage2.image = nil;
                break;
            case 3:
                self.capturedImage1.image = self.capturedImage2.image;
                self.capturedImage2.image = self.capturedImage3.image;
                self.capturedImage3.image = nil;
                break;
            case 4:
                self.capturedImage1.image = self.capturedImage2.image;
                self.capturedImage2.image = self.capturedImage3.image;
                self.capturedImage3.image = self.capturedImage4.image;
                self.capturedImage4.image = nil;
                break;
        }
        
    } else if (currentPage == 1) {
        switch (self.photosArray.count) {
            case 2:
                self.capturedImage2.image = nil;
                break;
            case 3:
                self.capturedImage2.image = self.capturedImage3.image;
                self.capturedImage3.image = nil;
                break;
            case 4:
                self.capturedImage2.image = self.capturedImage3.image;
                self.capturedImage3.image = self.capturedImage4.image;
                self.capturedImage4.image = nil;
                break;
        }
        
    } else if (currentPage == 2) {
        switch (self.photosArray.count) {
            case 3:
                self.capturedImage3.image = nil;
                break;
            case 4:
                self.capturedImage3.image = self.capturedImage4.image;
                self.capturedImage4.image = nil;
                break;
        }
    } else if (currentPage == 3) {
        self.capturedImage4.image = nil;
    }
    
    [self.photosArray removeObjectAtIndex:currentPage];
    
    if (self.photosArray.count == 0) {
        self.capturedImagesView.hidden = YES;
        self.photosArray = nil;
        if (!isSessionRunning) {
            dispatch_queue_t queue = dispatch_queue_create("com.MyQueue", NULL);
            dispatch_async(queue, ^{
                [self initializeCamera];
            });
        }
        [self hideCapturedImagesView];
        
    } else {
        self.pageControl.numberOfPages = self.photosArray.count;
        self.cameraScrollView.contentSize = CGSizeMake(self.cameraScrollView.frame.size.width * [self.photosArray count], self.cameraScrollView.frame.size.height - 1);
    }
    
    self.anotherPhotoButton.hidden = NO;
}

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image {
    
    CGFloat imageSizeDivider = image.size.width / 414.0;
    UIImage *resizedImage = [appDelegate resizeImage:image toSize:CGSizeMake(image.size.width / imageSizeDivider,
                                                                             image.size.height / imageSizeDivider)];
    
    [self addNewPhotoToList:resizedImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addFromLibrary:(id)sender {
    self.imagePicker = [[GKImagePicker alloc] init];
    self.imagePicker.delegate = self;
    [self presentViewController:self.imagePicker.imagePickerController animated:YES completion:nil];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
        return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskLandscapeLeft;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

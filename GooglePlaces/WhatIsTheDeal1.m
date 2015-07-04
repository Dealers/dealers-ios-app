 //
//  WhatIsTheDeal1.m
//  Dealers
//
//  Created by Gilad Lumbroso on 10/2/14.
//
//

#import "WhatIsTheDeal1.h"
#import "WhereIsTheDeal.h"

#define DegreesToRadians(x) ((x) * M_PI / 180.0)
#define TITLE_HEIGHT 92.0

@interface WhatIsTheDeal1 ()

@end

@implementation WhatIsTheDeal1

@synthesize appDelegate;
@synthesize session, captureVideoPreviewLayer, isShowingFullScreenCamera;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"What is the deal?", nil);
    
    self.deal = [[Deal alloc] init];
    
    [self initialize];
    [self setNavigationBar];
    [self initializeCameraSection];
    [self setTextViewSettings];
    [self setCounter];
    [self setProgressIndicator];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.photosFileName = nil;
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Add Deal - What Is The Deal 1 Local Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    if ([viewControllers indexOfObject:self] == NSNotFound) {
        // View is disappearing because it was popped from the stack
        WhereIsTheDeal *witdvc = (WhereIsTheDeal *)viewControllers.lastObject;
        witdvc.cashedInstance = self;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.hintLabel.alpha = 0;
}

- (void)initialize
{
    appDelegate = [[UIApplication sharedApplication] delegate];
    isFrontCamera = NO;
    self.capturedImagesSection.hidden = YES;
    self.cameraSection.hidden = NO;
    shouldDealloc = NO;
    self.hintLabel.text = NSLocalizedString(@"If you're done, tap Next near the title", nil);
    self.hintLabel.alpha = 0;
}


#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = tableView.rowHeight;
    if (indexPath.row == 0) {
        height = tableView.bounds.size.width * 0.678125; // 217:320 ratio
    } else if (indexPath.row == 1) {
        height = titleHeight; // 4 for extra padding
        if (height <= TITLE_HEIGHT) {
            titleHeight = TITLE_HEIGHT;
            return titleHeight;
        } else {
            height = titleHeight + 15.0;
        }
    }
    return height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}


#pragma mark - View components

- (void)setNavigationBar
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    UIView *nextButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 58, 30)];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [nextButton addTarget:self action:@selector(nextView) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setFrame:CGRectMake(8, 0, 58, 30)];
    [nextButton setTitle:NSLocalizedString(@"Next", nil) forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton.titleLabel setFont:[UIFont fontWithName:@"Avenir-Roman" size:15.0]];
    [nextButton setBackgroundColor:[appDelegate ourPurple]];
    [nextButton.layer setCornerRadius:5.0];
    [nextButton.layer setMasksToBounds:YES];
    
    [nextButtonView addSubview:nextButton];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:nextButtonView];
    
    self.navigationItem.rightBarButtonItem = barButton;
}

- (void)setTextViewSettings
{
    self.titlePlaceholder.text = NSLocalizedString(@"Tell us about the deal...", nil);
    
    if ([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft) {
        [self.dealTitle setBaseWritingDirection:UITextWritingDirectionRightToLeft forRange:nil];
        [self.dealTitle setTextAlignment:NSTextAlignmentRight];
        [self.titlePlaceholder setTextAlignment:NSTextAlignmentRight];
    }
}

- (void)setCounter
{
    CGSize counterLabelSize = CGSizeMake(40, 30);
    CGFloat x = self.view.frame.size.width - counterLabelSize.width - 5;
    self.countLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, 0, counterLabelSize.width, counterLabelSize.height)];
    
    self.countLabel.backgroundColor = [UIColor blackColor];
    self.countLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:14.0];
    self.countLabel.textColor = [UIColor whiteColor];
    self.countLabel.layer.cornerRadius = 6;
    self.countLabel.layer.masksToBounds = YES;
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    
    self.countContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 32)];
    
    self.countContainer.alpha = 0;
    self.countContainer.hidden = YES;
    
    [self.countContainer addSubview:self.countLabel];
    
    [self.dealTitle setInputAccessoryView:self.countContainer];
}

- (void)setProgressIndicator
{
    blankTitleIndicator = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    blankTitleIndicator.delegate = self;
    blankTitleIndicator.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Error"]];
    blankTitleIndicator.mode = MBProgressHUDModeCustomView;
    blankTitleIndicator.labelText = NSLocalizedString(@"Title can't be blank!", nil);
    blankTitleIndicator.labelFont = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    blankTitleIndicator.animationType = MBProgressHUDAnimationZoomIn;
    
    tooMuchIndicator = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    tooMuchIndicator.delegate = self;
    tooMuchIndicator.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Error"]];
    tooMuchIndicator.mode = MBProgressHUDModeCustomView;
    tooMuchIndicator.labelText = NSLocalizedString(@"Title is too long", nil);
    tooMuchIndicator.labelFont = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    tooMuchIndicator.detailsLabelText = NSLocalizedString(@"190 characters max", nil);
    tooMuchIndicator.detailsLabelFont = [UIFont fontWithName:@"Avenir-Light" size:15.0];
    tooMuchIndicator.animationType = MBProgressHUDAnimationZoomIn;
    
    [self.navigationController.view addSubview:blankTitleIndicator];
    [self.navigationController.view addSubview:tooMuchIndicator];
}

#pragma mark - Camera

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
    
    if (![self checkAuthorizationStatus]) {
        return;
    }
    
    NSError *error = nil;
    backCameraInput = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:&error];
    if (!backCameraInput) {
        NSLog(@"ERROR: trying to open camera: %@", error);
    }
    [session addInput:backCameraInput];
    
    error = nil;
    frontCameraInput = [AVCaptureDeviceInput deviceInputWithDevice:frontCamera error:&error];
    if (!frontCameraInput) {
        NSLog(@"ERROR: trying to open camera: %@", error);
    }
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    [session addOutput:self.stillImageOutput];
    
    [session startRunning];
    
    isSessionRunning = YES;
}

- (BOOL)checkAuthorizationStatus
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        return YES;
    } else if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Permission For Camera", nil)
                                                           message:NSLocalizedString(@"In order to use the camera, go to the settings and authorize the app to do so.", nil)
                                                          delegate:self
                                                 cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                 otherButtonTitles:nil];
            alert.tag = 123;
            [alert show];
        });
            return NO;
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // not determined?!
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){
                NSLog(@"Granted access to %@", AVMediaTypeVideo);
            } else {
                NSLog(@"Not granted access to %@", AVMediaTypeVideo);
            }
        }];
        return NO;
    } else {
        // impossible, unknown authorization status
        return NO;
    }
}

- (void)deallocCameraSession
{
    [captureVideoPreviewLayer removeFromSuperlayer];
    AVCaptureDeviceInput *input = [session.inputs objectAtIndex:0];
    [session removeInput:input];
    AVCaptureVideoDataOutput *output = [session.outputs objectAtIndex:0];
    [session removeOutput:output];
    [session stopRunning];
    session = nil;
    captureVideoPreviewLayer = nil;
    isSessionRunning = NO;
}

- (void)initializeCameraSection {
    
    // First checking if there is any photo at all (shouldn't be here in WhatIsTheDeal1):
    
    if (!self.photosArray) {
        
        self.cameraSection.hidden = NO;
        self.capturedImagesSection.hidden = YES;
        self.addPhoto.hidden = NO;
        
    } else {
        
        self.cameraSection.hidden = YES;
        self.capturedImagesSection.hidden = NO;
        self.addPhoto.hidden = YES;

        // Populating the image views:
        for (int i = 0; i < [self.photosArray count]; i++) {
            
            switch (i) {
                case 0:
                    self.captureImage.image = self.photosArray[i];
                    break;
                case 1:
                    self.captureImage2.image = self.photosArray[i];
                    break;
                case 2:
                    self.captureImage3.image = self.photosArray[i];
                    break;
                case 3:
                    self.captureImage4.image = self.photosArray[i];
                    break;
                    
                default:
                    break;
            }
        }
    }
    
    // Setting the Add Photo button in place
    
    self.addPhoto.hidden = YES;
    
    // Setting the width of the content view of the camera scroll view
    
    self.widthContentViewConstraint.constant = self.tableView.bounds.size.width * self.photosArray.count;
    
    if (self.photosArray.count == 4) {
        self.addAnotherPhoto.hidden = YES;
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
        self.exitCameraModeButton.hidden = YES;
        self.rotateCameraButton.hidden = YES;
        
        return;
    }
    
    dispatch_queue_t queue = dispatch_queue_create("com.MyQueue", NULL);
    dispatch_async(queue, ^{
        
        [self initializeCamera];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.3
                             animations:^{ self.cameraBlackCover.alpha = 0; }
                             completion:^(BOOL finished) { self.cameraBlackCover.hidden = YES; }];
        });
    });
    
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = self.cameraScrollView.frame.size.width;
    int page = floor((self.cameraScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

- (IBAction)snap:(id)sender {
    
    [UIView animateWithDuration: 0.1 animations:^{ self.flash.alpha = 1.0; }];
    [self capImage];
}

- (void)hideFlash {
    [UIView animateWithDuration: 1.0 animations:^{ self.flash.alpha = 0; }];
}

- (IBAction)addPhoto:(id)sender {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Camera", nil)
                                                              message:NSLocalizedString(@"Your device has no camera. You can still add photos from your library", nil)
                                                             delegate:nil
                                                    cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                    otherButtonTitles: nil];
        [myAlertView show];
        self.snapButton.hidden = YES;
        self.exitCameraModeButton.hidden = YES;
        self.rotateCameraButton.hidden = YES;
        
        return;
    }
    
    if (!self.addPhoto.hidden) {
        
        [self.view layoutIfNeeded];
        self.verticalSpaceAddPhotoContentViewConstraint.constant = -(self.cameraCell.contentView.bounds.size.height);
        self.cameraSection.hidden = NO;
        if (!isSessionRunning) [self initializeCamera];
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];;
        } completion:^(BOOL finished){
            self.addPhoto.hidden = YES;
        }];
        
    } else {
        if (!isSessionRunning) {
            [self initializeCamera];
        }
        [self hideCapturedSection];
    }
}

- (IBAction)deletePhoto:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Delete Photo", nil)
                                                    message:NSLocalizedString(@"Are you sure want to delete this photo?", nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                          otherButtonTitles:NSLocalizedString(@"Yes", nil), nil];
    alert.tag = 22;
    [alert show];
}

- (IBAction)rotateCamera:(id)sender {
    
    if (isFrontCamera == NO) {
        isFrontCamera = YES;
        [session beginConfiguration];
        
        [session removeInput:backCameraInput];
        [session addInput:frontCameraInput];
        
        [session commitConfiguration];
        
    } else {
        isFrontCamera = NO;
        [session beginConfiguration];
        
        [session removeInput:frontCameraInput];
        [session addInput:backCameraInput];
        
        [session commitConfiguration];
    }
}

- (IBAction)exitCameraMode:(id)sender {
    
    if (self.photosArray.count == 0) {
        self.verticalSpaceAddPhotoContentViewConstraint.constant = -(self.cameraCell.contentView.bounds.size.height);
        [self.view layoutIfNeeded];
        
        self.addPhoto.hidden = NO;
        self.verticalSpaceAddPhotoContentViewConstraint.constant = 0;
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
        
    } else {
        [self showCapturedSection];
    }
}

- (void)showCapturedSection
{
    [self.view layoutIfNeeded];
    self.verticalSpaceCapturedImagesSectionContentViewConstraint.constant = 0;
    self.capturedImagesSection.hidden = NO;
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         self.cameraSection.hidden = YES;
                     }];
}

- (void)hideCapturedSection
{
    [self.view layoutIfNeeded];
    self.verticalSpaceCapturedImagesSectionContentViewConstraint.constant = self.cameraCell.contentView.bounds.size.height;
    self.cameraSection.hidden = NO;
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                         self.capturedImagesSection.hidden = YES;
                     }];
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

- (void) processImage:(UIImage *)image // Process captured image, crop, resize and rotate
{
    CGRect outputRect = [captureVideoPreviewLayer metadataOutputRectOfInterestForRect:captureVideoPreviewLayer.bounds];
    CGImageRef takenCGImage = image.CGImage;
    size_t width = CGImageGetWidth(takenCGImage);
    size_t height = CGImageGetHeight(takenCGImage);
    CGRect cropRect = CGRectMake(outputRect.origin.x * width, outputRect.origin.y * height, outputRect.size.width * width, outputRect.size.height * height);
    
    CGImageRef cropCGImage = CGImageCreateWithImageInRect(takenCGImage, cropRect);
    image = [UIImage imageWithCGImage:cropCGImage scale:1 orientation:image.imageOrientation];
    CGImageRelease(cropCGImage);
    
    UIGraphicsBeginImageContext(image.size);
    [image drawAtPoint:CGPointZero];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGFloat imageSizeDivider = image.size.width / 375.0;

    UIImage *resizedImage = [appDelegate resizeImage:image toSize:CGSizeMake(image.size.width / imageSizeDivider, image.size.height / imageSizeDivider)];
    
    [self addNewPhotoToList:resizedImage];
    
    // Adjust image orientation based on device orientation (not needed yet if at all...)
    /*
     if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) {
     NSLog(@"landscape left image");
     
     [UIView beginAnimations:@"rotate" context:nil];
     [UIView setAnimationDuration:0.5];
     captureImage.transform = CGAffineTransformMakeRotation(DegreesToRadians(-90));
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
    [self hideFlash];
    
    if (!self.photosArray) {
        self.captureImage.image = image;
        self.photosArray = [NSMutableArray arrayWithObjects:self.captureImage.image, nil];
        self.pageControl.numberOfPages = 1;
        self.widthContentViewConstraint.constant = self.cameraCell.contentView.bounds.size.width;
        
    } else {
        [self.photosArray addObject:image];
        [self setCapturedSectionAfterSnap];
    }
    
    self.cameraSection.hidden = YES;
    self.capturedImagesSection.hidden = NO;
    self.verticalSpaceCapturedImagesSectionContentViewConstraint.constant = 0;
    [self.view layoutIfNeeded];
    
    [self updatePageController];
    
    if (shouldDealloc) {
        [self deallocCameraSession];
        shouldDealloc = NO;
    }
}

- (void)updatePageController
{
    NSInteger currentPage = self.photosArray.count - 1;
    self.cameraScrollView.contentOffset = CGPointMake(currentPage * self.tableView.bounds.size.width, 0);
    self.pageControl.currentPage = currentPage;
}

- (void)setCapturedSectionAfterSnap
{
    CGPoint origin;
    switch (self.photosArray.count) {
        case 2:
            self.captureImage2.image = self.photosArray[1];
            origin = self.captureImage2.frame.origin;
            break;
        case 3:
            self.captureImage3.image = self.photosArray[2];
            origin = self.captureImage3.frame.origin;
            break;
        case 4:
            self.captureImage4.image = self.photosArray[3];
            origin = self.captureImage4.frame.origin;
            break;
            
        default:
            origin = CGPointZero;
            break;
    }
    
    self.widthContentViewConstraint.constant += self.cameraCell.contentView.bounds.size.width;
    self.cameraScrollView.contentOffset = origin;
    
    self.pageControl.numberOfPages++;
    self.pageControl.currentPage = origin.x / self.tableView.bounds.size.width;
    
    if (self.photosArray.count == 4) {
        self.addAnotherPhoto.hidden = YES;
    } else {
        self.addAnotherPhoto.hidden = NO;
    }
}

- (void)setCapturedSectionAfterDelete
{
    NSInteger currentPage = self.pageControl.currentPage;
    
    if (currentPage == 0) {
        
        switch (self.photosArray.count) {
            case 1:
                self.captureImage.image = nil;
                break;
            case 2:
                self.captureImage.image = self.captureImage2.image;
                self.captureImage2.image = nil;
                break;
            case 3:
                self.captureImage.image = self.captureImage2.image;
                self.captureImage2.image = self.captureImage3.image;
                self.captureImage3.image = nil;
                break;
            case 4:
                self.captureImage.image = self.captureImage2.image;
                self.captureImage2.image = self.captureImage3.image;
                self.captureImage3.image = self.captureImage4.image;
                self.captureImage4.image = nil;
                break;
        }
        
    } else if (currentPage == 1) {
        switch (self.photosArray.count) {
            case 2:
                self.captureImage2.image = nil;
                break;
            case 3:
                self.captureImage2.image = self.captureImage3.image;
                self.captureImage3.image = nil;
                break;
            case 4:
                self.captureImage2.image = self.captureImage3.image;
                self.captureImage3.image = self.captureImage4.image;
                self.captureImage4.image = nil;
                break;
        }
        
    } else if (currentPage == 2) {
        switch (self.photosArray.count) {
            case 3:
                self.captureImage3.image = nil;
                break;
            case 4:
                self.captureImage3.image = self.captureImage4.image;
                self.captureImage4.image = nil;
                break;
        }
    } else if (currentPage == 3) {
        self.captureImage4.image = nil;
    }
    
    [self.photosArray removeObjectAtIndex:currentPage];
    
    if (self.photosArray.count == 0) {
        self.capturedImagesSection.hidden = YES;
        self.photosArray = nil;
        if (!isSessionRunning) {
            [self initializeCamera];
        }
        [self hideCapturedSection];
        
    } else {
        self.pageControl.numberOfPages = self.photosArray.count;
        self.widthContentViewConstraint.constant -= self.cameraCell.bounds.size.width;
    }
    
    self.addAnotherPhoto.hidden = NO;
}

- (IBAction)addFromLibrary:(id)sender {
    
    self.imagePicker = [[GKImagePicker alloc] init];
    self.imagePicker.delegate = self;
    [self presentViewController:self.imagePicker.imagePickerController animated:YES completion:nil];
}

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image {
    
    CGFloat imageSizeDivider = image.size.width / 375.0;
    UIImage *resizedImage = [appDelegate resizeImage:image toSize:CGSizeMake(image.size.width / imageSizeDivider,
                                                                             image.size.height / imageSizeDivider)];
    
    [self addNewPhotoToList:resizedImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cameraModeDismissed:(NSNotification *)notification
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    isShowingFullScreenCamera = NO;
}


#pragma mark - General methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        [self setCapturedSectionAfterDelete];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView == self.dealTitle) {
        int maxLength = 190;
        
        NSString *stringlength = [NSString stringWithString:self.dealTitle.text];
        self.countLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)(maxLength - stringlength.length)];
        
        if (stringlength.length > (maxLength / 3) * 2) {
            
            [UIView animateWithDuration:0.3
                             animations:^{
                                 self.countContainer.hidden = NO;
                                 self.countContainer.alpha = 0.7;
                             }];
            
            if (stringlength.length > maxLength) {
                self.countLabel.backgroundColor = [UIColor redColor];
                self.tooMuchText = YES;
                self.countLabel.text = @"0";
            } else {
                self.countLabel.backgroundColor = [UIColor blackColor];
                self.tooMuchText = NO;
                self.countLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)(maxLength - stringlength.length)];
            }
        } else {
            if (self.countLabel.hidden == NO) {
                [UIView animateWithDuration:0.3
                                 animations:^{
                                     self.countContainer.alpha = 0; }
                                 completion:^(BOOL finished) {
                                     self.countContainer.hidden = YES;
                                 }];
            }
        }
        
        CGSize sizeThatFitsTextView = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, MAXFLOAT)];
        [self adjustHeight:sizeThatFitsTextView.height toTextView:@"Title"];
        
        if (self.dealTitle.text.length == 0) {
            self.titlePlaceholder.hidden = NO;
        } else {
            self.titlePlaceholder.hidden = YES;
        }
    }
}

- (void)adjustHeight:(CGFloat)height toTextView:(NSString *)textViewName
{
    if ([textViewName isEqualToString:@"Title"]) {
        titleHeight = height;
    }
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

// Setting the return button as Done:

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView == self.dealTitle) {
        if ([text isEqualToString:@"\n"]) {
            
            if (self.countLabel.hidden == NO) {
                [UIView animateWithDuration:0.35
                                 animations:^{
                                     self.countContainer.alpha = 0;
                                     self.countContainer.hidden = YES;
                                 }];
            }
            [self.view endEditing:YES];
            [self performSelector:@selector(showHint) withObject:nil afterDelay:0.6];
            return NO;
        }
    }
    return YES;
}

- (void)showHint
{
    [UIView animateWithDuration:0.3 animations:^{ self.hintLabel.alpha = 1.0; }];
}

- (IBAction)disableKeyboard:(id)sender
{
    [self.view endEditing:YES];
}

/*
 - (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
 {
 if (textField == self.priceTextField) {
 
 self.priceValue = [self.priceTextField.text floatValue];
 
 } else if (textField == self.discountTextField) {
 
 self.discountValue = [self.discountTextField.text floatValue];
 }
 
 return YES;
 }
 */

- (void)nextView
{
    [self manageData];
}

- (void)manageData
{
    if (![self validation]) {
        return;
    }
    
    NSDictionary *categoryDictionary = self.store.categories.firstObject;
    self.store.categoryID = [categoryDictionary valueForKey:@"id"];
    
    self.deal.store = self.store;
    
    self.deal.dealer = appDelegate.dealer;
    
    self.deal.dealAttrib = [[DealAttrib alloc] init];
    
    self.deal.type = @"Local";
    
    self.deal.title = self.dealTitle.text;

    // Prepering photos (if exist) for upload
    
    if (self.photosArray.count > 0) {
        
        for (int i = 0; i < self.photosArray.count; i++) {
            
            if (!self.photosFileName) {
                self.photosFileName = [[NSMutableArray alloc]init];
            }
            
            NSString *fileName = [NSString stringWithFormat:@"%@_%f_%i.jpg", self.deal.dealer.dealerID, [[NSDate date] timeIntervalSince1970], 1];
            NSString *key = [NSString stringWithFormat:@"media/Deals_Photos/%@", fileName];
            [self.photosFileName addObject:fileName];
            
            switch (i) {
                case 0:
                    self.deal.photoURL1 = key;
                    self.deal.photo1 = [self.photosArray objectAtIndex:i];
                    break;
                case 1:
                    self.deal.photoURL2 = key;
                    self.deal.photo2 = [self.photosArray objectAtIndex:i];
                    break;
                case 2:
                    self.deal.photoURL3 = key;
                    self.deal.photo3 = [self.photosArray objectAtIndex:i];
                    break;
                case 3:
                    self.deal.photoURL4 = key;
                    self.deal.photo4 = [self.photosArray objectAtIndex:i];
                    break;
                default:
                    break;
            }
            
            NSData *binaryImageData = UIImageJPEGRepresentation([self.photosArray objectAtIndex:i], 0.6);
            NSString *bodyFileURL = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
            [binaryImageData writeToFile:bodyFileURL atomically:YES];
        }
        
    } else {
        
        // There are no photos. Randomly pick a color number and save it in the photoURL1 attribute
        int random = arc4random_uniform(4);
        self.deal.photoURL1 = [NSNumber numberWithInt:random].stringValue;
    }
    
    self.deal.photoSum = [NSNumber numberWithLong:self.photosArray.count];
    
    [self pushNextView];
}

- (BOOL)validation
{
    if (!(self.dealTitle.text.length > 0)) {
        
        [blankTitleIndicator show:YES];
        [blankTitleIndicator hide:YES afterDelay:1.5];
        return NO;
        
    } else if (self.tooMuchText) {
        
        [tooMuchIndicator show:YES];
        [tooMuchIndicator hide:YES afterDelay:2.0];
        return NO;
        
    } else
        return YES;
}

- (void)pushNextView
{
    WhatIsTheDeal2 *nextView;
    if (self.cashedInstance) {
        nextView = self.cashedInstance;
    } else {
        nextView = [self.storyboard instantiateViewControllerWithIdentifier:@"WhatIsTheDeal2ID"];
    }
    nextView.deal = self.deal;
    nextView.photosFileName = self.photosFileName;
    if (self.cashedCategory) {
        nextView.cashedCategory = self.cashedCategory;
    }
    [self.navigationController pushViewController:nextView animated:YES];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

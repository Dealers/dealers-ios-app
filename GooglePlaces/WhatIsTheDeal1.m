//
//  WhatIsTheDeal1.m
//  Dealers
//
//  Created by Gilad Lumbroso on 10/2/14.
//
//

#import "WhatIsTheDeal1.h"

#define DegreesToRadians(x) ((x) * M_PI / 180.0)
#define keyboardHeight 216

@interface WhatIsTheDeal1 ()

@end

@implementation WhatIsTheDeal1

@synthesize appDelegate;
@synthesize session, captureVideoPreviewLayer;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"What is the Deal?";
    
    self.deal = [[Deal alloc]init];
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    [self setNavigationBar];
    
    isFrontCamera = NO;
    self.capturedImagesSection.hidden = YES;
    self.cameraSection.hidden = NO;
    shouldDealloc = NO;
    
    [self initializeCameraSection];
    [self setKeyboardNotification];
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
    if (!(self.dealTitle.text.length > 0)) {
        
        [self.dealTitle becomeFirstResponder];
    }
    
    self.photosFileName = nil;
}

#pragma mark - Table view delegate

/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *container = [[UIView alloc]init];
    UILabel *labelHeader = [[UILabel alloc] initWithFrame:CGRectMake (0, 21, tableView.bounds.size.width, 22)];
    
    if (section == 1) {
        
        labelHeader.font = [UIFont fontWithName:@"Avenir-Light" size:20.0];
//        labelHeader.textColor = [UIColor colorWithRed:130.0/255.0 green:130.0/255.0 blue:136.0/255.0 alpha:1.0];
        labelHeader.textColor = [UIColor blackColor];
        labelHeader.text = @"Tell us about the deal";
        labelHeader.textAlignment = NSTextAlignmentCenter;
    }
    
    [container addSubview:labelHeader];
    
    return container;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 0.1;
    
    } else if (section == 1) {

        return 56.0;
    }
    
    return 0.1;
}

*/

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
    UIImage *nextImage = [[UIImage imageNamed:@"Next Button"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *next = [[UIBarButtonItem alloc]initWithImage:nextImage style:UIBarButtonItemStyleBordered target:self action:@selector(nextView)];
    [next setImageInsets:UIEdgeInsetsMake(1, -9, 0, 9)];
    
    self.navigationItem.rightBarButtonItem = next;
}

- (void)setKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(editingScrollPosition)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
}

- (void)setCounter
{
    CGSize counterLabelSize = CGSizeMake(40, 30);
    CGFloat x = self.view.frame.size.width - counterLabelSize.width - 5;
    //    CGFloat y = self.view.frame.size.height - counterLabelSize.height - keyboardHeight - 5;
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
    blankTitleIndicator.labelText = @"Title can't be blank!";
    blankTitleIndicator.labelFont = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    blankTitleIndicator.animationType = MBProgressHUDAnimationZoomIn;
    
    tooMuchIndicator = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    tooMuchIndicator.delegate = self;
    tooMuchIndicator.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Error"]];
    tooMuchIndicator.mode = MBProgressHUDModeCustomView;
    tooMuchIndicator.labelText = @"Title is too long";
    tooMuchIndicator.labelFont = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    tooMuchIndicator.detailsLabelText = @"120 characters max";
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
    
    captureVideoPreviewLayer.frame = self.cameraView.bounds;
    [self.cameraView.layer addSublayer:captureVideoPreviewLayer];
    
    UIView *view = [self cameraView];
    CALayer *viewLayer = [view layer];
    [viewLayer setMasksToBounds:YES];
    
    CGRect bounds = [view bounds];
    [captureVideoPreviewLayer setFrame:bounds];
    
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
        
        self.capturedImagesSection.hidden = YES;
        self.addPhoto.hidden = NO;
        
    } else {
        
        self.capturedImagesSection.hidden = NO;
        self.addPhoto.hidden = YES;
        
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
    
    // Setting the Add Photo button in place
    
    self.addPhoto.center = CGPointMake(self.addPhoto.center.x, - self.addPhoto.center.y);
    self.addPhoto.hidden = YES;
    
    // Setting the content size of the camera scroll view
    
    self.cameraScrollView.contentSize = CGSizeMake(self.cameraScrollView.frame.size.width * [self.photosArray count], self.cameraScrollView.frame.size.height - 1);
    
    if (self.photosArray.count == 4) {
        self.addAnotherPhoto.hidden = YES;
    }
    
    // Finally, setting camera in the background
    
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
    [self performSelector:@selector(hideFlash) withObject:nil afterDelay:0.7];
}

- (void)hideFlash {
    [UIView animateWithDuration: 1.0 animations:^{ self.flash.alpha = 0; }];
}

- (IBAction)addPhoto:(id)sender {
    
    if (self.addPhoto.hidden == NO) {
        
        self.cameraSection.hidden = NO;
        if (!isSessionRunning) [self initializeCamera];
        [UIView animateWithDuration:0.3 animations:^{
            self.addPhoto.center = CGPointMake(self.addPhoto.center.x, - self.addPhoto.center.y);
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
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Delete Photo" message:@"Are you sure want to delete this photo?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    alert.tag = 22;
    [alert show];
}

- (IBAction)rotateCamera:(id)sender {
    
    if (isFrontCamera == NO) {
        isFrontCamera = YES;
        [self initializeCamera];
    } else {
        isFrontCamera = NO;
        [self initializeCamera];
    }
}

- (IBAction)exitCameraMode:(id)sender {
    
    if (!self.photosArray.count) {
        self.addPhoto.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.addPhoto.center = self.cameraCell.contentView.center;
        }];
        
    } else {
        self.capturedImagesSection.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.capturedImagesSection.center = self.cameraCell.contentView.center;
        }];
    }
}

- (void)showCapturedSection
{
    CGPoint center = self.cameraCell.contentView.center;
    self.cameraSection.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.capturedImagesSection.center = center;
    }];
}

- (void)hideCapturedSection
{
    CGPoint center = self.cameraCell.contentView.center;
    self.cameraSection.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.capturedImagesSection.center = CGPointMake(center.x, center.y + self.cameraCell.bounds.size.height);
    } completion:^(BOOL finished){
        self.capturedImagesSection.hidden = YES;
    }];
}

- (void) capImage // Method to capture image from AVCaptureSession video feed
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
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width, image.size.height));
    [image drawInRect: CGRectMake(0, 0, image.size.width, image.size.height)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    float imageSizeMultiplier; // The front camera is 3, the back is 7.65.
    
    if (isFrontCamera == NO) {
        imageSizeMultiplier = 7.65;
    } else {
        imageSizeMultiplier = 3;
    }
    
    float originX = self.cameraCell.frame.origin.x * imageSizeMultiplier;
    float originY = 132 * imageSizeMultiplier;
    float sizeWidth = self.captureImage.frame.size.width * imageSizeMultiplier;
    float sizeHeight = self.captureImage.frame.size.height * imageSizeMultiplier;
    
    CGRect cropRect = CGRectMake(originX, originY, sizeWidth, sizeHeight);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([smallImage CGImage], cropRect);
    
    if (!self.photosArray) {
        self.captureImage.image = [UIImage imageWithCGImage:imageRef];
        self.photosArray = [NSMutableArray arrayWithObjects:self.captureImage.image, nil];
        self.pageControl.numberOfPages = 1;
        
    } else {
        [self.photosArray addObject:[UIImage imageWithCGImage:imageRef]];
        [self setCapturedSectionAfterSnap];
    }
    
    CGImageRelease(imageRef);
    
    self.cameraSection.hidden = YES;
    self.capturedImagesSection.hidden = NO;
    self.capturedImagesSection.center = self.cameraCell.contentView.center;
    //    self.addPhoto.center = self.cameraCell.contentView.center;
    
    if (shouldDealloc) {
        [self deallocCameraSession];
        shouldDealloc = NO;
    }
    
    //  [self deallocCameraSession];
    
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

- (void)setCapturedSectionAfterSnap
{
    CGRect frame;
    NSUInteger i = self.photosArray.count - 1;
    frame.origin.x = self.cameraScrollView.frame.size.width * i;
    frame.origin.y = 0;
    frame.size = self.cameraScrollView.frame.size;
    
    unsigned long tag = i + 1;
    UIImageView *captureImageView = (UIImageView *)[self.cameraScrollView viewWithTag:tag];
    captureImageView.image = [self.photosArray objectAtIndex:i];
    captureImageView.frame = frame;
    
    self.cameraScrollView.contentSize = CGSizeMake(self.cameraScrollView.frame.size.width * [self.photosArray count], self.cameraScrollView.frame.size.height - 1);
    self.cameraScrollView.contentOffset = frame.origin;
    
    self.pageControl.numberOfPages++;
    self.pageControl.currentPage = i;
    
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
        self.cameraScrollView.contentSize = CGSizeMake(self.cameraScrollView.frame.size.width * [self.photosArray count], self.cameraScrollView.frame.size.height - 1);
    }
    
    self.addAnotherPhoto.hidden = NO;
}


#pragma mark - General methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        [self setCapturedSectionAfterDelete];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    int maxLength = 120;
    
    NSString *stringlength = [NSString stringWithString:self.dealTitle.text];
    self.countLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)(maxLength - stringlength.length)];
    
    if (stringlength.length > maxLength / 2) {
        
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
    
    if (self.dealTitle.text.length == 0) {
        self.titlePlaceholder.hidden = NO;
    } else {
        self.titlePlaceholder.hidden = YES;
    }
}

// Setting the return button as Done:

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        
        if (self.countLabel.hidden == NO) {
            [UIView animateWithDuration:0.35
                             animations:^{
                                 self.countContainer.alpha = 0;
                                 self.countContainer.hidden = YES;
                             }];
        }
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


- (void)editingScrollPosition
{
    if ([[self.navigationController visibleViewController] isEqual:self]) {
        
        CGPoint offsetPoint = CGPointMake(0, -29.0);
        [self.tableView setContentOffset:offsetPoint animated:YES];
    }
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
    [self.dealTitle resignFirstResponder];
    
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
    
    self.deal.dealAttrib = [[DealAttrib alloc]init];
    
    self.deal.type = @"Local";
    
    self.deal.title = self.dealTitle.text;
    
    // Prepering photos (if exist) for upload
    for (int i = 0; i < self.photosArray.count; i++) {
        
        if (!self.photosFileName) {
            self.photosFileName = [[NSMutableArray alloc]init];
        }
        
        NSString *fileName = [NSString stringWithFormat:@"%@_%@_%i.jpg", self.deal.dealer.dealerID, [NSDate date], i + 1];
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
        
        NSData *binaryImageData = UIImageJPEGRepresentation([self.photosArray objectAtIndex:i], 0.55);
        NSString *bodyFileURL = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
        [binaryImageData writeToFile:bodyFileURL atomically:YES];
    }
    
    /*
     if (self.photosArray.count == 1) {
         self.deal.photo1 = [self.photosArray objectAtIndex:0];
     } else if (self.photosArray.count == 2) {
         self.deal.photo1 = [self.photosArray objectAtIndex:0];
         self.deal.photo2 = [self.photosArray objectAtIndex:1];
     } else if (self.photosArray.count == 3) {
         self.deal.photo1 = [self.photosArray objectAtIndex:0];
         self.deal.photo2 = [self.photosArray objectAtIndex:1];
         self.deal.photo3 = [self.photosArray objectAtIndex:2];
     } else if (self.photosArray.count == 4) {
         self.deal.photo1 = [self.photosArray objectAtIndex:0];
         self.deal.photo2 = [self.photosArray objectAtIndex:1];
         self.deal.photo3 = [self.photosArray objectAtIndex:2];
         self.deal.photo4 = [self.photosArray objectAtIndex:3];
     }
    */
    
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
    WhatIsTheDeal2 *witd2vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WhatIsTheDeal2ID"];
    
    witd2vc.deal = self.deal;
    witd2vc.photosFileName = self.photosFileName;
    
    [self.navigationController pushViewController:witd2vc animated:YES];
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

//
//  EditDealTableViewController.m
//  Dealers-testbeta
//
//  Created by Gilad Lumbroso on 7/20/14.
//
//

#import "EditDealTableViewController.h"

#define DegreesToRadians(x) ((x) * M_PI / 180.0)

@interface EditDealTableViewController ()

@end

@implementation EditDealTableViewController

@synthesize session, captureVideoPreviewLayer;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)Dismiss:(id)sender {
    // First we need to check if the original deal is different.
    // If different, ask if the user is sure he wants to cancel. If he still does, we need to load back the original deal, and then dismiss.
    
    if (self.didChangeOriginalDeal) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Unsaved Changes" message:@"You have unsaved changes. Are you sure you want to cancel?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        alert.tag = 11;
        [alert show];
    } else {
        // If not, just dismiss:
        [self dismissViewControllerAnimated:YES completion:NO];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (alertView.tag) {
            
        case 11:
            switch (buttonIndex) {
                case 1:
                    self.currentDeal = nil;
                    [self dismissViewControllerAnimated:YES completion:NO];
                    break;
                    
                default:
                    break;
            }
            break;
            
        case 22:
            if (buttonIndex == 1) {
                //            [UIView animateWithDuration:0.4 animations:^{
                //                [self.capturedImagesSection viewWithTag:self.pageControl.currentPage + 1].alpha = 0;
                //            } completion:^(BOOL finished) {
                //                [self setCapturedSectionAfterDelete];
                //            }];
                //            [self.capturedImagesSection viewWithTag:self.pageControl.currentPage + 1].alpha = 1;
                [self setCapturedSectionAfterDelete];
                break;
            }
    }
}

#pragma mark - Loading View & Parameters

- (void)loadingParameters
{
    self.dealTitle.text = [self.currentDeal title];
    
    self.dealStore.text = [self.currentDeal store];
    
    if (![self.currentDeal.price isEqualToString:@"0"]) {
        self.dealPrice.text = [self.currentDeal.currency stringByAppendingString:self.currentDeal.price];
        self.dealPrice.textColor = [UIColor blackColor];
    } else {
        self.dealPrice.text = @"Price";
        self.dealPrice.textColor = [UIColor lightGrayColor];
    }
    
    if (![self.currentDeal.discountValue isEqualToString:@"0"]) {
        if ([self.currentDeal.discountType isEqualToString:@"%"]) {
            self.dealDiscount.text = [self.currentDeal.discountValue stringByAppendingString:self.currentDeal.discountType];
        } else {
            NSDictionary* attributes = @{ NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle] };
            NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:self.currentDeal.discountValue attributes:attributes];
            self.dealDiscount.attributedText = attrText;
        }
        self.dealDiscount.textColor = [UIColor blackColor];
    } else {
        self.dealDiscount.text = @"Discount";
        self.dealDiscount.textColor = [UIColor lightGrayColor];
    }
    
    if (self.currentDeal.category) {
        self.dealCategory.text = self.currentDeal.category;
        self.dealCategory.textColor = [UIColor blackColor];
    } else {
        self.dealCategory.text = @"Category";
        self.dealCategory.textColor = [UIColor lightGrayColor];
    }
    
    if(![self.currentDeal.moreDescription isEqualToString:@"0"]) {
        self.dealDescription.text = self.currentDeal.moreDescription;
        self.dealDescription.textColor = [UIColor blackColor];
    } else {
        self.dealDescription.text = @"Description";
        self.dealDescription.textColor = [UIColor lightGrayColor];
    }
}

- (void)canDelete
{
    AppDelegate *app = [[AppDelegate alloc]init];
    if (![app.UserID isEqualToString:self.currentDeal.dealUserID]) {
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    [self loadingParameters];
    self.pageControl.numberOfPages = self.photosArray.count;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Edit Deal";
    
    self.didChangeOriginalDeal = NO;
    isFrontCamera = NO;
    self.capturedImagesSection.hidden = NO;
    self.cameraSection.hidden = YES;
    shouldDealloc = NO;
    
    self.currentDeal = [self.originalDeal mutableCopy]; // DealClass's mutableCopy DOES NOT copy the deal's photos themselves. Only the IDs.
    
    [self bundlePhotosInArray];
    
    [self initializeCameraSection];
    
    [self setupExpirationDateCellContentView];
    
    [self canDelete];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self initializeCamera];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    shouldDealloc = YES;
}

- (void)setupExpirationDateCellContentView {
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSDate *today = [NSDate date];
    [self.datePicker setMinimumDate:today];
    
    self.datePicker.backgroundColor = [UIColor whiteColor];
    
    self.datePickerIsShowing = NO;
    self.datePicker.hidden = YES;
    self.noDateButton.hidden = YES;
}

- (void)bundlePhotosInArray
{
    switch ([self.currentDeal.photoSum intValue]) {
            
        case 0:
            NSLog(@"No Photos, so no photosArray...");
            break;
            
        case 1:
            self.photosArray = [NSMutableArray arrayWithObjects:self.originalDeal.photo1, nil];
            break;
            
        case 2:
            self.photosArray = [NSMutableArray arrayWithObjects:
                                self.originalDeal.photo1,
                                self.originalDeal.photo2, nil];
            break;
            
        case 3:
            self.photosArray = [NSMutableArray arrayWithObjects:
                                self.originalDeal.photo1,
                                self.originalDeal.photo2,
                                self.originalDeal.photo3, nil];
            break;
            
        case 4:
            self.photosArray = [NSMutableArray arrayWithObjects:
                                self.originalDeal.photo1,
                                self.originalDeal.photo2,
                                self.originalDeal.photo3,
                                self.originalDeal.photo4, nil ];
            break;
            
        default:
            NSLog(@"Weird... Too many photos...");
            break;
    }
}

#pragma mark - Table view

/*
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
 {
 #warning Incomplete method implementation.
 // Return the number of rows in the section.
 return 0;
 }
 */

/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

#define pictureCell 0
#define pictureSection 0
#define expirationDateCell 2
#define expirationDateSection 2
#define expirationDateCellHeight 162

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = tableView.rowHeight;
    
    if (indexPath.row == pictureCell && indexPath.section == pictureSection) {
        height = 165.0f;
    } else if (indexPath.row == expirationDateCell && indexPath.section == expirationDateSection) {
        height = self.datePickerIsShowing ? expirationDateCellHeight : 0.0f;
    }
    
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditTextModeViewController *etmvc = [self.storyboard instantiateViewControllerWithIdentifier:@"editTextModeViewControllerID"];
    TableViewController *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"TableView"];
    ChooseCategoryTableViewController *cctvc = [self.storyboard instantiateViewControllerWithIdentifier:@"chooseCategoryID"];
    
    if (!(indexPath.section == 2 && indexPath.row == 1) && self.datePickerIsShowing) {
        [self hideDatePickerCell];
    }
    
    switch (indexPath.section) {
        case 1:
            switch (indexPath.row) {
                case 0:
                    etmvc.title = @"Title";
                    etmvc.currentValue = self.currentDeal.title;
                    etmvc.textView.returnKeyType = UIReturnKeyDone;
                    [self.navigationController pushViewController:etmvc animated:YES];
                    NSLog(@"image \n width: %f \n height: %f", self.captureImage.image.size.width, self.captureImage.image.size.height);
                    break;
                    
                case 1:
                    tvc.cameFrom = @"editDeal";
                    [self.navigationController pushViewController:tvc animated:YES];
                    break;
                    
                case 2:
                    etmvc.title = @"Price";
                    etmvc.currency = self.currentDeal.currency;
                    etmvc.currentValue = self.currentDeal.price;
                    if ([self.currentDeal.price isEqualToString:@"0"]) {
                        etmvc.currentValue = @"";
                    }
                    [self.navigationController pushViewController:etmvc animated:YES];
                    break;
                    
                case 3:
                    etmvc.title = @"Discount";
                    etmvc.discountType = self.currentDeal.discountType;
                    etmvc.currentValue = self.currentDeal.discountValue;
                    if ([self.currentDeal.discountValue isEqualToString:@"0"]) {
                        etmvc.currentValue = @"";
                    }
                    [self.navigationController pushViewController:etmvc animated:YES];
                    
                default:
                    break;
            }
            break;
            
        case 2:
            switch (indexPath.row) {
                case 0:
                    cctvc.cameFrom = @"editDeal";
                    [self.navigationController pushViewController:cctvc animated:YES];
                    break;
                    
                case 1:
                    if (self.datePickerIsShowing) {
                        [self hideDatePickerCell];
                    } else {
                        [self showDatePickerCell];
                        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                        [self performSelector:@selector(dateChanged:) withObject:self.datePicker];
                    }
                    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                    break;
                    
                case 3:
                    etmvc.title = @"Description";
                    etmvc.currentValue = self.currentDeal.moreDescription;
                    if ([self.currentDeal.moreDescription isEqualToString:@"0"]) {
                        etmvc.currentValue = @"";
                    }
                    [self.navigationController pushViewController:etmvc animated:YES];
                    break;
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
}

- (void)showDatePickerCell
{
    self.datePickerIsShowing = YES;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    self.datePicker.hidden = NO;
    self.noDateButton.hidden = NO;
    
    if (self.didCancelDate) self.datePicker.date = [NSDate date];
    
    self.didCancelDate = NO;
    self.datePicker.alpha = 0.0f;
    self.noDateButton.alpha = 0.0f;
    self.didChangeOriginalDeal = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.datePicker.alpha = 1.0f;
        self.noDateButton.alpha = 1.0f;
        self.dealExpirationDate.textColor = [UIColor colorWithRed:150.0/250.0 green:0/250.0 blue:180.0/250.0 alpha:1.0];
    }];
}

- (void)hideDatePickerCell
{
    self.datePickerIsShowing = NO;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.datePicker.alpha = 0.0f;
        self.noDateButton.alpha = 0.0f;
        self.dealExpirationDate.textColor = self.didCancelDate ? [UIColor lightGrayColor] : [UIColor blackColor];
    } completion:^(BOOL finished) {
        self.datePicker.hidden = YES;
        self.noDateButton.hidden = YES;
    }];
}

- (IBAction)dateChanged:(UIDatePicker *)sender {
    
    if (!self.didCancelDate) {
        self.currentDeal.expiration = sender.date;
        self.dealExpirationDate.text = [@"Expires on " stringByAppendingString:[self.dateFormatter stringFromDate:sender.date]];
    }
}

- (IBAction)noDate:(id)sender {
    
    self.currentDeal.expiration = nil;
    self.dealExpirationDate.text = @"Expiration Date";
    self.dealExpirationDate.textColor = [UIColor lightGrayColor];
    self.didCancelDate = YES;
    [self hideDatePickerCell];
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

-(void) initializeCameraSection {
    
    // First checking if there is any photo at all:
    
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
    // Finally, setting the content size of the camera scroll view:
    
    self.cameraScrollView.contentSize = CGSizeMake(self.cameraScrollView.frame.size.width * [self.photosArray count], self.cameraScrollView.frame.size.height - 1);
    
    if (self.photosArray.count == 4) {
        self.addAnotherPhoto.hidden = YES;
    }
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
    [self performSelector:@selector(hideFlash) withObject:nil afterDelay:0.5];
    self.didChangeOriginalDeal = YES;
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
    self.addPhoto.center = self.cameraCell.contentView.center;
    
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
        self.addPhoto.hidden = NO;
        self.photosArray = nil;
        
    } else {
        self.pageControl.numberOfPages = self.photosArray.count;
        self.cameraScrollView.contentSize = CGSizeMake(self.cameraScrollView.frame.size.width * [self.photosArray count], self.cameraScrollView.frame.size.height - 1);
    }
    
    self.addAnotherPhoto.hidden = NO;
    self.didChangeOriginalDeal = YES;
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

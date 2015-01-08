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

@synthesize session, captureVideoPreviewLayer, appDelegate;


#pragma mark - Loading View & Parameters

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    self.pageControl.numberOfPages = self.photosArray.count;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Edit Deal";
    
    [self initialize];
    
    [self setSaveButton];
    
    [self setProgressIndicator];
    
    [self setupExpirationDateCellContentView];
    
    [self loadingParameters];
    
    [self bundlePhotosInArray];
    
    [self initializeCameraSection];
    
    [self canDelete];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    shouldDealloc = YES;
}

- (void)setSaveButton
{
    UIImage *saveImage = [[UIImage imageNamed:@"Save Button"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *save = [[UIBarButtonItem alloc]initWithImage:saveImage style:UIBarButtonItemStyleBordered target:self action:@selector(saveChanges)];
    [save setImageInsets:UIEdgeInsetsMake(0, -9, 0, 9)];
    
    self.navigationItem.rightBarButtonItem = save;
}

- (void)initialize
{
    appDelegate = [[UIApplication sharedApplication] delegate];
    self.didChangeOriginalDeal = NO;
    isFrontCamera = NO;
    self.capturedImagesSection.hidden = NO;
    self.cameraSection.hidden = YES;
    shouldDealloc = NO;
    placeholderColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:206.0/255.0 alpha:1.0];
}

- (void)loadingParameters
{
    self.dealTitle.text = [self.deal.title mutableCopy];
    
    self.dealStore.text = [self.deal.store.name mutableCopy];
    
    if (self.deal.price) {
        self.dealPrice.text = [self.deal.currency stringByAppendingString:self.deal.price.stringValue];
        self.dealPrice.textColor = [UIColor blackColor];
        self.selectedCurrency = [self.deal.currency mutableCopy];
    } else {
        self.dealPrice.text = @"Price";
        self.dealPrice.textColor = placeholderColor;
    }
    
    if (self.deal.discountValue) {
        if ([self.deal.discountType isEqualToString:@"%"]) {
            self.dealDiscount.text = [self.deal.discountValue.stringValue stringByAppendingString:self.deal.discountType];
        } else if ([self.deal.discountType isEqualToString:@"lastPrice"]){
            NSDictionary* attributes = @{ NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle] };
            NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:self.deal.discountValue.stringValue attributes:attributes];
            self.dealDiscount.attributedText = attrText;
        }
        self.dealDiscount.textColor = [UIColor blackColor];
        self.selectedDiscountType = [self.deal.discountType mutableCopy];
    } else {
        self.dealDiscount.text = @"Discount or Last Price";
        self.dealDiscount.textColor = placeholderColor;
    }
    
    if (self.deal.category.length > 0) {
        self.dealCategory.text = [self.deal.category mutableCopy];
        self.dealCategory.textColor = [UIColor blackColor];
    } else {
        self.dealCategory.text = @"Category";
        self.dealCategory.textColor = placeholderColor;
    }
    
    if (self.deal.expiration) {
        self.dealExpirationDate.text = [@"Expires on " stringByAppendingString:[self.dateFormatter stringFromDate:self.deal.expiration]];
        self.datePicker.date = self.deal.expiration;
        self.dealExpirationDate.textColor = [UIColor blackColor];
    } else {
        self.dealExpirationDate.text = @"Expiration Date";
        self.dealExpirationDate.textColor = placeholderColor;
    }
    
    if (self.deal.moreDescription.length > 0 && ![self.deal.moreDescription isEqualToString:@"None"]) {
        self.dealDescription.text = [self.deal.moreDescription mutableCopy];
        self.dealDescription.textColor = [UIColor blackColor];
    } else {
        self.dealDescription.text = @"Description";
        self.dealDescription.textColor = placeholderColor;
    }
}

- (void)canDelete
{
    if (![appDelegate.dealer.email isEqualToString:self.deal.dealer.email]) {
        
        // Add a cell at the end of the table view for - "Delete Deal".
    }
}

- (void)setupExpirationDateCellContentView {
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    self.datePicker.backgroundColor = [UIColor whiteColor];
    
    self.datePickerIsShowing = NO;
    self.datePicker.hidden = YES;
    self.noDateButton.hidden = YES;
}

- (void)bundlePhotosInArray
{
    switch ([self.deal.photoSum intValue]) {
            
        case 0:
            NSLog(@"No Photos, so no photosArray...");
            break;
            
        case 1:
            self.photosArray = [NSMutableArray arrayWithObjects:self.deal.photo1, nil];
            break;
            
        case 2:
            self.photosArray = [NSMutableArray arrayWithObjects:
                                self.deal.photo1,
                                self.deal.photo2, nil];
            break;
            
        case 3:
            self.photosArray = [NSMutableArray arrayWithObjects:
                                self.deal.photo1,
                                self.deal.photo2,
                                self.deal.photo3, nil];
            break;
            
        case 4:
            self.photosArray = [NSMutableArray arrayWithObjects:
                                self.deal.photo1,
                                self.deal.photo2,
                                self.deal.photo3,
                                self.deal.photo4, nil ];
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
#define expirationDateSection 3
#define expirationDateCellHeight 162

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = tableView.rowHeight;
    
    if (indexPath.row == pictureCell && indexPath.section == pictureSection) {
        height = 0; // We don't want to allow photo editing for now...
    } else if (indexPath.row == expirationDateCell && indexPath.section == expirationDateSection) {
        height = self.datePickerIsShowing ? expirationDateCellHeight : 0.0f;
    }
    
    if (indexPath.section == 4) {
        if (!self.canDeleteDeal) {
            height = 0;
        }
    }
    
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditTextModeViewController *etmvc = [self.storyboard instantiateViewControllerWithIdentifier:@"editTextModeViewControllerID"];
    WhereIsTheDeal *witdvc = [self.storyboard instantiateViewControllerWithIdentifier:@"whereIsTheDealID"];
    ChooseCategoryTableViewController *cctvc = [self.storyboard instantiateViewControllerWithIdentifier:@"chooseCategoryID"];
    
    if (!(indexPath.section == 3 && indexPath.row == 1) && self.datePickerIsShowing) {
        [self hideDatePickerCell];
    }
    
    switch (indexPath.section) {
            
        case 1:
            etmvc.title = @"Title";
            etmvc.currentValue = self.dealTitle.text;
            etmvc.textView.returnKeyType = UIReturnKeyDone;
            [self.navigationController pushViewController:etmvc animated:YES];
            break;
            
        case 2:
            switch (indexPath.row) {
                    
                case 0:
                    witdvc.cameFrom = @"Edit Deal";
                    [self.navigationController pushViewController:witdvc animated:YES];
                    break;
                    
                case 1:
                    etmvc.title = @"Price";
                    etmvc.currency = self.selectedCurrency;
                    etmvc.currentValue = [self.dealPrice.text substringFromIndex:1];
                    if ([self.dealPrice.text isEqualToString:@"Price"]) {
                        etmvc.currentValue = @"";
                    }
                    [self.navigationController pushViewController:etmvc animated:YES];
                    break;
                    
                case 2:
                    etmvc.title = @"Discount";
                    if ([self.dealDiscount.text isEqualToString:@"Discount or Last Price"]) {
                        etmvc.currentValue = @"";
                    } else {
                        etmvc.discountType = self.selectedDiscountType;
                        if ([etmvc.discountType isEqualToString:@"%"]) {
                            etmvc.currentValue = [self.dealDiscount.text substringToIndex:self.dealDiscount.text.length - 1];
                        } else {
                            etmvc.currentValue = self.dealDiscount.text;
                        }
                    }
                    [self.navigationController pushViewController:etmvc animated:YES];
                    break;
                    
                default:
                    break;
            }
            break;
            
        case 3:
            switch (indexPath.row) {
                case 0:
                    cctvc.cameFrom = @"Edit Deal";
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
                    if ([self.dealDescription.text isEqualToString:@"Description"]) {
                        etmvc.currentValue = @"";
                    } else {
                        etmvc.currentValue = self.dealDescription.text;
                    }
                    [self.navigationController pushViewController:etmvc animated:YES];
                    break;
                    
                default:
                    break;
            }
            break;
            
        case 4: {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Deal"
                                                            message:@"Are you sure you want to delete this deal? This action cannot be undone."
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Delete", nil];
            alert.tag = 33;
            [alert show];
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
        self.dealExpirationDate.textColor = self.didCancelDate ? placeholderColor : [UIColor blackColor];
    } completion:^(BOOL finished) {
        self.datePicker.hidden = YES;
        self.noDateButton.hidden = YES;
    }];
}

- (IBAction)dateChanged:(UIDatePicker *)sender {
    
    NSDate *date = sender.date;
    
    while ([date timeIntervalSinceNow] < -86400) {
        date = [date dateByAddingTimeInterval: (31536000)];
    }
    
    [sender setDate:date animated:YES];
    
    if (!self.didCancelDate) {
        self.dealExpirationDate.text = [self.dateFormatter stringFromDate:sender.date];
    }
}

- (IBAction)noDate:(id)sender {
    
    self.dealExpirationDate.text = @"Expiration Date";
    self.dealExpirationDate.textColor = placeholderColor;
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
    
    dispatch_queue_t queue = dispatch_queue_create("com.MyQueue", NULL);
    dispatch_async(queue, ^{
        
        [self initializeCamera];
        
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

#pragma mark - General methods, saving and deleting

- (void)saveChanges
{
    if (![self validation]) {
        return;
    }
    
    // Were there any changes?
    
    if (!self.didChangeOriginalDeal) {
        
        [self deallocCameraSession];
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    // Pass all the values into self.deal
    
    self.deal.title = self.dealTitle.text;
    
    if (self.deal.store != self.store && self.store) {
        
        NSDictionary *categoryDictionary = self.store.categories.firstObject;
        self.store.categoryID = [categoryDictionary valueForKey:@"id"];
        self.deal.store = self.store;
        
    }
    
    if ([self.dealPrice.text isEqualToString:@"Price"]) {
        self.deal.price = nil;
        self.deal.currency = nil;
    } else {
        float price = [self.dealPrice.text substringFromIndex:1].floatValue;
        self.deal.price = [NSNumber numberWithFloat:price];
        self.deal.currency = [appDelegate getCurrencyKey:self.selectedCurrency];
    }
    
    if ([self.dealDiscount.text isEqualToString:@"Discount or Last Price"]) {
        self.deal.discountValue = nil;
        self.deal.discountType = nil;
    } else if ([self.selectedDiscountType isEqualToString:@"%"]) {
        float discount = [self.dealDiscount.text substringToIndex:self.dealDiscount.text.length - 1].floatValue;
        self.deal.discountValue = [NSNumber numberWithFloat:discount];
        self.deal.discountType = [appDelegate getDiscountKey:self.selectedDiscountType];
    } else {
        self.deal.discountValue = [NSNumber numberWithFloat:self.dealDiscount.text.floatValue];
        self.deal.discountType = [appDelegate getDiscountKey:self.selectedDiscountType];
    }
    
    if ([self.dealCategory.text isEqualToString:@"Category"]) {
        self.deal.category = nil;
    } else {
        self.deal.category = [appDelegate getCategoryKeyForValue:self.dealCategory.text];
    }
    
    if ([self.dealExpirationDate.text isEqualToString:@"Expiration Date"]) {
        self.deal.expiration = nil;
    } else {
        self.deal.expiration = self.datePicker.date;
    }
    
    if ([self.dealDescription.text isEqualToString:@"Description"]) {
        self.deal.moreDescription = nil;
    } else {
        self.deal.moreDescription = self.dealDescription.text;
    }
    
    // Passing the photos
    if (self.photosArray.count > 0) {
        
        NSInteger numberOfPics = (unsigned long)(self.photosArray.count);
        
        switch (numberOfPics) {
            case 0:
                self.deal.photo1 = nil;
                self.deal.photo2 = nil;
                self.deal.photo3 = nil;
                self.deal.photo4 = nil;
                break;
                
            case 1:
                self.deal.photo1 = [self.photosArray objectAtIndex:0];
                self.deal.photo2 = nil;
                self.deal.photo3 = nil;
                self.deal.photo4 = nil;
                break;
                
            case 2:
                self.deal.photo1 = [self.photosArray objectAtIndex:0];
                self.deal.photo2 = [self.photosArray objectAtIndex:1];
                self.deal.photo3 = nil;
                self.deal.photo4 = nil;
                break;
                
            case 3:
                self.deal.photo1 = [self.photosArray objectAtIndex:0];
                self.deal.photo2 = [self.photosArray objectAtIndex:1];
                self.deal.photo3 = [self.photosArray objectAtIndex:2];
                self.deal.photo4 = nil;
                break;
                
            case 4:
                self.deal.photo1 = [self.photosArray objectAtIndex:0];
                self.deal.photo2 = [self.photosArray objectAtIndex:1];
                self.deal.photo3 = [self.photosArray objectAtIndex:2];
                self.deal.photo4 = [self.photosArray objectAtIndex:3];
                break;
                
            default:
                break;
        }
        
        self.deal.photoSum = [NSNumber numberWithInteger:numberOfPics];
    }
    
    
    ViewonedealViewController *vodvc = self.delegate;
    vodvc.afterEditing = YES;
    
    [uploadingDeal show:YES];
    
    // Patch self.deal to the server
    
    [self uploadChanges];
}

- (void)uploadChanges
{
    NSString *path = [NSString stringWithFormat:@"/adddeals/%@/", self.deal.dealID];
    
    [[RKObjectManager sharedManager] patchObject:self.deal
                                            path:path
                                      parameters:nil
                                         success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                             
                                             [uploadingDeal hide:YES];
                                             NSLog(@"Deal was edited successfuly!");
                                             [self dismissViewControllerAnimated:YES completion:nil];
                                             
                                             if (self.deal.dealer.dealerID.intValue != appDelegate.dealer.dealerID.intValue) {
                                                 [appDelegate sendNotificationOfType:@"Edit"
                                                                        toRecipients:@[self.deal.dealer.dealerID]
                                                                    regardingTheDeal:self.deal.dealID];
                                             }
                                         }
                                         failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                             
                                             [uploadingDeal hide:YES];
                                             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                             [alert show];
                                         }];
}

- (IBAction)Dismiss:(id)sender {
    
    if (self.didChangeOriginalDeal) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Unsaved Changes" message:@"You have unsaved changes. Are you sure you want to cancel?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        alert.tag = 11;
        [alert show];
    } else {
        // If not, just dismiss:
        [self deallocCameraSession];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (alertView.tag) {
            
        case 11:
            switch (buttonIndex) {
                case 1:
                    [self dismissViewControllerAnimated:YES completion:nil];
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
            
        case 33:
            
            if (buttonIndex == 0) {
                
                [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
            
            } else if (buttonIndex == 1) {
                
                NSString *path = [NSString stringWithFormat:@"/adddeals/%@/", self.deal.dealID];
                
                [[RKObjectManager sharedManager] deleteObject:self.deal
                                                         path:path
                                                   parameters:nil
                                                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                          
                                                          NSLog(@"Deal was deleted successfuly.");
                                                          [self dismissViewControllerAnimated:YES completion:nil];
                                                          ViewonedealViewController *vodvc = self.delegate;
                                                          appDelegate.shouldUpdateMyFeed = YES;
                                                          appDelegate.shouldUpdateProfile = YES;
                                                          [vodvc.navigationController popToRootViewControllerAnimated:YES];
                                                      }
                                                      failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                          
                                                          NSLog(@"\n\nCouldn't delete the deal...");
                                                          [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
                                                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't delete the deal"
                                                                                                          message:@"This deal could not be deleted... Please try again later."
                                                                                                         delegate:self
                                                                                                cancelButtonTitle:@"OK"
                                                                                                otherButtonTitles:nil];
                                                          [alert show];
                                                      }];
            }
            break;
    }
}

- (BOOL)validation
{
    if ([self.selectedDiscountType isEqualToString:@"%"] && [self.dealDiscount.text intValue] > 100) {
        
        [illogicalPercentage show:YES];
        [illogicalPercentage hide:YES afterDelay:2.0];
        
        return NO;
        
    } else if ([self.selectedDiscountType isEqualToString:@"lastPrice"] && [self.dealPrice.text isEqualToString:@"Price"]) {
        
        [lastPriceWithoutPrice show:YES];
        [lastPriceWithoutPrice hide:YES afterDelay:2.0];
        
        return NO;
    }
    
    return YES;
}

- (void)setProgressIndicator
{
    
    illogicalPercentage = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    illogicalPercentage.delegate = self;
    illogicalPercentage.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Error"]];
    illogicalPercentage.mode = MBProgressHUDModeCustomView;
    illogicalPercentage.labelText = @"Discount above 100%!";
    illogicalPercentage.labelFont = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    illogicalPercentage.animationType = MBProgressHUDAnimationZoomIn;
    
    lastPriceWithoutPrice = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    lastPriceWithoutPrice.delegate = self;
    lastPriceWithoutPrice.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Error"]];
    lastPriceWithoutPrice.mode = MBProgressHUDModeCustomView;
    lastPriceWithoutPrice.labelText = @"Price is empty!";
    lastPriceWithoutPrice.labelFont = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    lastPriceWithoutPrice.detailsLabelText = @"Required if there's previous price";
    lastPriceWithoutPrice.detailsLabelFont = [UIFont fontWithName:@"Avenir-Light" size:15.0];
    lastPriceWithoutPrice.animationType = MBProgressHUDAnimationZoomIn;
    
    
    UIImageView *loadingAnimation = [appDelegate loadingAnimationWhite];
    [loadingAnimation startAnimating];
    
    uploadingDeal = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    uploadingDeal.delegate = self;
    uploadingDeal.customView = loadingAnimation;
    uploadingDeal.mode = MBProgressHUDModeCustomView;
    uploadingDeal.labelText = @"Uploading";
    uploadingDeal.labelFont = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    uploadingDeal.animationType = MBProgressHUDAnimationZoomIn;
    
    [self.navigationController.view addSubview:illogicalPercentage];
    [self.navigationController.view addSubview:lastPriceWithoutPrice];
    [self.navigationController.view addSubview:uploadingDeal];
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

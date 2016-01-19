//
//  WhatIsTheDeal1OnlineTableViewController.m
//  Dealers
//
//  Created by Gilad Lumbroso on 5/14/15.
//
//

#import "WhatIsTheDeal1Online.h"
#import "WhereIsTheDealOnline.h"

#define IMAGE_HEIGHT 216.0
#define TITLE_HEIGHT 92.0

@interface WhatIsTheDeal1Online ()

@end

@implementation WhatIsTheDeal1Online

@synthesize appDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"What is the deal?", nil);
    
    [self initialize];
    [self setNavigationBar];
    [self setTextViewSettings];
    [self setCounter];
    [self setProgressIndicator];
    
    if (self.images) {
        if (self.images.count > 0) {
            [self insertImageInImageView:self.images.firstObject];
        } else {
            self.imageContainer.hidden = YES;
            self.selectedImage = NO;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSArray *viewControllers = self.navigationController.viewControllers;
    if ([viewControllers indexOfObject:self] == NSNotFound) {
        // View is disappearing because it was popped from the stack
        WhereIsTheDealOnline *witdovc = (WhereIsTheDealOnline *)viewControllers.lastObject;
        witdovc.cashedInstance = self;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Add Deal - What Is The Deal 1 Online Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.hintLabel.alpha = 0;
}

- (void)initialize
{
    appDelegate = [[UIApplication sharedApplication] delegate];
    self.hintLabel.text = NSLocalizedString(@"If you're done, tap Next near the title", nil);
    [self.changeImage setTitle:NSLocalizedString(@"Change Image", nil) forState:UIControlStateNormal];
    self.hintLabel.alpha = 0;
}

- (void)setNavigationBar
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    UIView *nextButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 58, 30)];
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [nextButton addTarget:self action:@selector(nextView) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setFrame:CGRectMake(7, 0, 58, 30)];
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

- (void)insertImageInImageView:(UIImage *)image
{
    if (image) {
        self.imageView.image = image;
        self.imageView = [appDelegate contentModeForImageView:self.imageView];
        self.imageContainer.hidden = NO;
        self.addPhotoContainer.hidden = YES;
        self.selectedImage = YES;
        [self.tableView reloadData];
    }
}

- (void)removeImageFromImageView
{
    if (self.selectedImage) {
        self.imageView.image = nil;
        self.imageContainer.hidden = YES;
        self.addPhotoContainer.hidden = NO;
        self.selectedImage = NO;
        [self.tableView reloadData];
    }
}

- (IBAction)changeImage:(id)sender
{
    OnlineImagePickerCollectionViewController *oipcvc = [self.storyboard instantiateViewControllerWithIdentifier:@"OnlineImagePicker"];
    oipcvc.images = self.images;
    oipcvc.delegate = self;
    AddDealNavigationController *navigationController = [[AddDealNavigationController alloc] initWithRootViewController:oipcvc];
    [self presentViewController:navigationController animated:YES completion:nil];
}


#pragma mark - Table view

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = tableView.rowHeight;
    if (indexPath.row == 0) {
        if (self.selectedImage) {
            height = IMAGE_HEIGHT;
        } else {
            height = 54.0;
        }
    } else if (indexPath.row == 1) {
        height = titleHeight;
        if (height <= TITLE_HEIGHT) {
            titleHeight = TITLE_HEIGHT;
            return titleHeight;
        } else {
            height = titleHeight + 15.0;
        }
    }
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if (self.images.count > 0) {
            [self changeImage:nil];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Images", nil)
                                                            message:NSLocalizedString(@"Appropriate images weren't found", nil)
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
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


#pragma mark - Text view

- (void)setKeyboardDirection:(NSString *)text
{
    NSUInteger len = text.length;
    NSString *language;
    if (len == 1) {
        language = (NSString *)CFBridgingRelease(CFStringTokenizerCopyBestStringLanguage((CFStringRef)text, CFRangeMake(0, len)));
    } else {
        language = (NSString *)CFBridgingRelease(CFStringTokenizerCopyBestStringLanguage((CFStringRef)text, CFRangeMake(0, 100)));
    }
    if ([language isEqualToString:@"he"]) {
        [self.dealTitle setBaseWritingDirection:UITextWritingDirectionRightToLeft forRange:nil];
        [self.dealTitle setTextAlignment:NSTextAlignmentRight];
        [self.titlePlaceholder setTextAlignment:NSTextAlignmentRight];
    } else {
        [self.dealTitle setBaseWritingDirection:UITextWritingDirectionLeftToRight forRange:nil];
        [self.dealTitle setTextAlignment:NSTextAlignmentLeft];
        [self.titlePlaceholder setTextAlignment:NSTextAlignmentLeft];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView == self.dealTitle) {
        if (textView.text.length == 1) {
            // Check the language and set the keyboard direction accordingly.
            [self setKeyboardDirection:textView.text];
        }
        
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

// Setting the return button of the title as Done:

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


#pragma mark - Next

- (void)nextView
{
    if ([self validation]) {
        [self manageData];
        [self pushNextView];
    }
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

- (void)manageData
{
    self.deal = [[Deal alloc] init];
    
    self.deal.title = self.dealTitle.text;
    self.deal.store = self.store;
    self.deal.dealer = appDelegate.dealer;
    self.deal.dealAttrib = [[DealAttrib alloc] init];
    self.deal.type = @"Online";
    
    if (self.selectedImage) {
        NSString *fileName = [NSString stringWithFormat:@"%@_%f_%i.jpg", self.deal.dealer.dealerID, [[NSDate date] timeIntervalSince1970], 1];
        NSString *key = [NSString stringWithFormat:@"media/Deals_Photos/%@", fileName];
        if (!self.photosFileName) {
            self.photosFileName = [[NSMutableArray alloc] init];
        }
        [self.photosFileName addObject:fileName];
        self.deal.photo1 = self.imageView.image;
        self.deal.photoURL1 = key;
        NSData *binaryImageData = UIImageJPEGRepresentation(self.deal.photo1, 0.6);
        NSString *bodyFileURL = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
        [binaryImageData writeToFile:bodyFileURL atomically:YES];
        self.deal.photoSum = [NSNumber numberWithInt:1];
    } else {
        int random = arc4random_uniform(4);
        self.deal.photoURL1 = [NSNumber numberWithInt:random].stringValue;
        self.deal.photoSum = [NSNumber numberWithInt:0];
    }
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
    [self.navigationController pushViewController:nextView animated:YES];
}


@end

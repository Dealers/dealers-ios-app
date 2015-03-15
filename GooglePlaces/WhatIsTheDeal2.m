//
//  WhatIsTheDeal2.m
//  Dealers
//
//  Created by Gilad Lumbroso on 10/2/14.
//
//

#import "WhatIsTheDeal2.h"

#define categorySheetTag 6666
#define expirationDateSheetTag 7777

#define sharedViewTag 8888
#define iconsLeftMargin 18
#define labelsLeftMargin 48

#define AWS_S3_BUCKET_NAME @"dealers-app"

@interface WhatIsTheDeal2 ()

@end

@implementation WhatIsTheDeal2

@synthesize appDelegate;
@synthesize shekel, dollar, pound, percentage, lastPrice;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Have more details?", nil);
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleFBSessionStateChangeWithNotification:)
                                                 name:@"SessionStateChangeNotification"
                                               object:nil];
    
    [self initialize];
    [self setupExpirationDateCellContentView];
    [self setAddDealButton];
    [self setProgressIndicator];
    [self createInputAccessoryViews];
    [self setCashedData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    
    if ([viewControllers indexOfObject:self] == NSNotFound) {
        // View is disappearing because it was popped from the stack
        WhatIsTheDeal1 *witd1 = viewControllers.lastObject;
        if (self.priceTextField.text.length > 0) {
            witd1.cashedPrice = self.priceTextField.text;
            witd1.cashedCurrency = self.selectedCurrency;
        } else {
            witd1.cashedPrice = nil;
            witd1.cashedCurrency = nil;
        }
        if (self.discountTextField.text.length > 0) {
            witd1.cashedDiscountValue = [NSNumber numberWithFloat:self.discountValue];
            witd1.cashedDiscountType = self.selectedDiscountType;
        } else {
            witd1.cashedDiscountValue = nil;
            witd1.cashedDiscountType = nil;
        }
        if (self.categoryLabel.text.length > 0 && ![self.categoryLabel.text isEqualToString:NSLocalizedString(@"Choose Category", nil)]) {
            witd1.cashedCategory = self.categoryLabel.text;
        } else {
            witd1.cashedCategory = nil;
        }
        if (self.expirationDateLabel.text.length > 0) {
            witd1.cashedExpirationDate = self.datePicker.date;
        } else {
            witd1.cashedExpirationDate = nil;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initialize
{
    appDelegate = [[UIApplication sharedApplication]delegate];
    isFacebookSelectd = NO;
    isWhatsAppSelected = NO;
    self.didTouchDatePicker = NO;
    didUploadDealData = NO;
    didDealPhotosFinishedUploading = NO;
    placeholder = [UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:186.0/255.0 alpha:1.0];
}

#pragma mark - Table view

#define expirationDateCellHeight 162

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = tableView.rowHeight;
    
    if (indexPath.row == 1 && indexPath.section == 2) {
        
        height = self.datePickerIsShowing ? expirationDateCellHeight : 0.0f;
    }
    
    return height;
}

/*
 - (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
 {
 UIView *container = [[UIView alloc]init];
 UILabel *labelHeader = [[UILabel alloc] initWithFrame:CGRectMake (0, 21, tableView.bounds.size.width, 22)];
 
 if (section == 0) {
 
 labelHeader.font = [UIFont fontWithName:@"Avenir-Light" size:20.0];
 //        labelHeader.textColor = [UIColor colorWithRed:130.0/255.0 green:130.0/255.0 blue:136.0/255.0 alpha:1.0];
 labelHeader.textColor = [UIColor blackColor];
 labelHeader.text = @"Great! Have more details?";
 labelHeader.textAlignment = NSTextAlignmentCenter;
 }
 
 [container addSubview:labelHeader];
 
 return container;
 }
 
 - (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
 {
 if (section == 0) {
 
 return 56.0;
 
 } else if (section == 3) {
 
 return 30.0;
 }
 
 return 0;
 }
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) { // Price & Discount Section
        
        if (indexPath.row == 0) {
            
            [self.priceTextField becomeFirstResponder];
            
        } else {
            
            [self.discountTextField becomeFirstResponder];
        }
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self hideDatePickerCell];
    }
    
    if (indexPath.section == 1) { // Category Section
        
        if ([self.categoryLabel.text isEqualToString:NSLocalizedString(@"Choose Category", nil)] || !(self.categoryLabel.text.length > 0)) {
            
            [self chooseCategoryView];
            
        } else {
            
            UIActionSheet *categorySheet = [[UIActionSheet alloc]initWithTitle:nil
                                                                      delegate:self
                                                             cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                        destructiveButtonTitle:NSLocalizedString(@"Remove Category", nil)
                                                             otherButtonTitles:NSLocalizedString(@"Pick a New Category", nil), nil];
            categorySheet.tag = categorySheetTag;
            [categorySheet showInView:self.view];
        }
        
        [self.priceTextField resignFirstResponder];
        [self.discountTextField resignFirstResponder];
        [self hideDatePickerCell];
        
    } else if (indexPath.section == 2 && indexPath.row == 0) { // Expiration Date Section
        
        if (self.datePickerIsShowing) {
            
            [self hideDatePickerCell];
            
        } else {
            
            if ([self.expirationDateLabel.text isEqualToString:NSLocalizedString(@"Choose Date", nil)] || !(self.expirationDateLabel.text.length > 0)) {
                
                [self showDatePickerCell];
                [self performSelector:@selector(dateChanged:) withObject:self.datePicker];
                
            } else {
                
                UIActionSheet *expirationDateSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                                                delegate:self
                                                                       cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                                  destructiveButtonTitle:NSLocalizedString(@"Remove Date", nil)
                                                                       otherButtonTitles:NSLocalizedString(@"Change Date", nil), nil];
                expirationDateSheet.tag = expirationDateSheetTag;
                [expirationDateSheet showInView:self.view];
            }
        }
        
        self.didTouchDatePicker = YES;
        
        [self.priceTextField resignFirstResponder];
        [self.discountTextField resignFirstResponder];
        
    } else if (indexPath.section == 3) { // Social Networks
        
        if (indexPath.row == 0) {
            
            if (isFacebookSelectd) {
                
                self.facebookIcon.selected = NO;
                self.facebookLabel.textColor = [UIColor blackColor];
                [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
                isFacebookSelectd = NO;
                
            } else {
                
                [self setFacebookConnection];
            }
        }
        
        else if (indexPath.row == 1) {
            
            if (isWhatsAppSelected) {
                
                self.whatsAppIcon.selected = NO;
                self.whatsAppLabel.textColor = [UIColor blackColor];
                [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
                isWhatsAppSelected = NO;
                
            } else {
                
                self.whatsAppIcon.selected = YES;
                self.whatsAppLabel.textColor = [UIColor colorWithRed:48.0/255.0 green:178.0/255.0 blue:32.0/255.0 alpha:1.0];
                [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                isWhatsAppSelected = YES;
            }
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 2) {
        
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
    } else {
        
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 53.0, 0, 0)];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 53.0, 0, 0)];
        }
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

- (void)cancelCategory {
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.categoryLabel.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         self.categoryLabel.text = nil;
                         self.categoryLabel.textColor = placeholder;
                         [UIView animateWithDuration:0.2
                                          animations:^{
                                              self.categoryLabel.alpha = 1.0;
                                          }];
                     }];
    
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

- (void)setupExpirationDateCellContentView {
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    self.datePicker.backgroundColor = [UIColor whiteColor];
    
    self.datePickerIsShowing = NO;
    self.datePicker.hidden = YES;
}

- (void)showDatePickerCell
{
    self.datePickerIsShowing = YES;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    self.datePicker.hidden = NO;
    
    if (self.didCancelDate) self.datePicker.date = [NSDate date];
    
    self.didCancelDate = NO;
    self.datePicker.alpha = 0.0f;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.datePicker.alpha = 1.0f;
        self.expirationDateLabel.textColor = [UIColor colorWithRed:150.0/250.0 green:0/250.0 blue:180.0/250.0 alpha:0.9];
    }];
}

- (void)hideDatePickerCell
{
    if (self.datePickerIsShowing) {
        
        self.datePickerIsShowing = NO;
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.datePicker.alpha = 0.0f;
            self.expirationDateLabel.textColor = self.didCancelDate ? [UIColor colorWithWhite:0.8 alpha:1.0] : [UIColor blackColor];
        } completion:^(BOOL finished) {
            self.datePicker.hidden = YES;
        }];
    }
}

- (IBAction)dateChanged:(UIDatePicker *)sender {
    
    NSDate *date = sender.date;
    
    while ([date timeIntervalSinceNow] < -86400) {
        date = [date dateByAddingTimeInterval: (31536000)];
    }
    
    [sender setDate:date animated:YES];
    
    if (!self.didCancelDate) {
        self.expirationDateLabel.text = [self.dateFormatter stringFromDate:sender.date];
    }
}

- (void)noDate {
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.expirationDateLabel.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         self.expirationDateLabel.text = nil;
                         self.expirationDateLabel.textColor = placeholder;
                         self.didCancelDate = YES;
                         //    [self hideDatePickerCell];
                         [UIView animateWithDuration:0.2
                                          animations:^{
                                              self.expirationDateLabel.alpha = 1.0;
                                          }];
                     }];
}

- (void)createInputAccessoryViews
{
    // Creating the price bar:
    
    UIView *priceBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    
    priceBar.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:226.0/255.0 blue:234.0/255.0 alpha:1.0];
    priceBar.tintColor = [UIColor colorWithRed:150.0/255.0 green:0 blue:180.0/255.0 alpha:1.0];
    
    shekel = [UIButton buttonWithType:UIButtonTypeSystem];
    [shekel setTitle:@"₪" forState:UIControlStateNormal];
    [shekel setFrame:CGRectMake(15, 6, 30, 30)];
    [shekel setAlpha:0.9];
    [[shekel titleLabel] setFont:[UIFont fontWithName:@"Avenir-Light" size:26]];
    [shekel addTarget:self action:@selector(selectCurrency:) forControlEvents:UIControlEventTouchUpInside];
    
    dollar = [UIButton buttonWithType:UIButtonTypeSystem];
    [dollar setTitle:@"$" forState:UIControlStateNormal];
    [dollar setFrame:CGRectMake(60, 7, 30, 30)];
    [dollar setAlpha:0.9];
    [[dollar titleLabel] setFont:[UIFont fontWithName:@"Avenir-Light" size:24]];
    [dollar addTarget:self action:@selector(selectCurrency:) forControlEvents:UIControlEventTouchUpInside];
    
    pound = [UIButton buttonWithType:UIButtonTypeSystem];
    [pound setTitle:@"£" forState:UIControlStateNormal];
    [pound setFrame:CGRectMake(105, 7, 30, 30)];
    [pound setAlpha:0.9];
    [[pound titleLabel] setFont:[UIFont fontWithName:@"Avenir-Light" size:24]];
    [pound addTarget:self action:@selector(selectCurrency:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *done1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [done1 setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];
    [done1 setFrame:CGRectMake(self.tableView.bounds.size.width - 70, 0, 60, 44)];
    [done1 setAlpha:0.9];
    [[done1 titleLabel] setFont:[UIFont fontWithName:@"Avenir-Medium" size:17.0]];
    [done1 addTarget:self action:@selector(doneTextField) forControlEvents:UIControlEventTouchUpInside];
    
    [priceBar addSubview:shekel];
    [priceBar addSubview:dollar];
    [priceBar addSubview:pound];
    [priceBar addSubview:done1];
    
    if (self.cashedCurrency.length > 0) {
        
        self.selectedCurrency = self.cashedCurrency;
        if ([self.selectedCurrency isEqualToString:@"₪"]) {
            [shekel setSelected:YES];
            
        } else if ([self.selectedCurrency isEqualToString:@"$"]) {
            [dollar setSelected:YES];
            
        } else if ([self.selectedCurrency isEqualToString:@"£"]) {
            [pound setSelected:YES];
        }
        
    } else {
        
        // default choise:
        [shekel setSelected:YES];
        self.selectedCurrency = @"₪";
    }
    
    [self.priceTextField setInputAccessoryView:priceBar];
    
    // Creating the discount bar:
    
    UIView *discountBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    
    discountBar.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:226.0/255.0 blue:234.0/255.0 alpha:1.0];
    discountBar.tintColor = [UIColor colorWithRed:150.0/255.0 green:0 blue:180.0/255.0 alpha:1.0];
    
    percentage = [UIButton buttonWithType:UIButtonTypeSystem];
    [percentage setTitle:@"%" forState:UIControlStateNormal];
    [percentage setFrame:CGRectMake(15, 7, 30, 30)];
    [percentage setAlpha:0.9];
    [[percentage titleLabel] setFont:[UIFont fontWithName:@"Avenir-Light" size:24]];
    [percentage addTarget:self action:@selector(selectDiscountType:) forControlEvents:UIControlEventTouchUpInside];
    
    lastPrice = [UIButton buttonWithType:UIButtonTypeSystem];
    
    NSDictionary* attributes = @{ NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle] };
    NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:@"123" attributes:attributes];
    
    [lastPrice setAttributedTitle:attrText forState:UIControlStateNormal];
    [lastPrice setFrame:CGRectMake(62, 7, 50, 30)];
    [lastPrice setAlpha:0.9];
    [[lastPrice titleLabel] setFont:[UIFont fontWithName:@"Avenir-Light" size:23]];
    [lastPrice addTarget:self action:@selector(selectDiscountType:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *done2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [done2 setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];
    [done2 setFrame:CGRectMake(self.tableView.bounds.size.width - 70, 0, 60, 44)];
    [done2 setAlpha:0.9];
    [[done2 titleLabel] setFont:[UIFont fontWithName:@"Avenir-Medium" size:17.0]];
    [done2 addTarget:self action:@selector(doneTextField) forControlEvents:UIControlEventTouchUpInside];
    
    [discountBar addSubview:percentage];
    [discountBar addSubview:lastPrice];
    [discountBar addSubview:done2];
    
    if (self.cashedDiscountType.length > 0) {
        
        self.selectedDiscountType = self.cashedDiscountType;
        if ([self.selectedDiscountType isEqualToString:@"%"]) {
            [percentage setSelected:YES];
            
        } else {
            [lastPrice setSelected:YES];
        }
        
    } else {
        
        // default choise:
        [percentage setSelected:YES];
        self.selectedDiscountType = @"%";
    }
    
    [self.discountTextField setInputAccessoryView:discountBar];
    
    
    // Creating the more description bar (obsolete):
    
    /*
     UIView *doneBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
     
     doneBar.backgroundColor = [UIColor groupTableViewBackgroundColor];
     doneBar.tintColor = [UIColor colorWithRed:150.0/250.0 green:0 blue:180.0/250.0 alpha:1.0];
     
     UIButton *done = [UIButton buttonWithType:UIButtonTypeSystem];
     [done setTitle:@"Done" forState:UIControlStateNormal];
     [done setFrame:CGRectMake(260, 0, 60, 44)];
     [done setAlpha:0.9];
     [[done titleLabel] setFont:[UIFont fontWithName:@"Avenir-Medium" size:17.0]];
     [done addTarget:self action:@selector(doneTextView) forControlEvents:UIControlEventTouchUpInside];
     
     [doneBar addSubview:done];
     
     [self.moreDescriptionTextView setInputAccessoryView:doneBar];
     */
}

- (void)selectCurrency:(UIButton *)sender
{
    shekel.selected = NO;
    dollar.selected = NO;
    pound.selected = NO;
    
    sender.selected = YES;
    self.selectedCurrency = sender.titleLabel.text;
    
    if (self.priceTextField.text.length > 0) {
        [self.priceTextField resignFirstResponder];
    }
}

- (void)selectDiscountType:(UIButton *)sender
{
    percentage.selected = NO;
    lastPrice.selected = NO;
    
    sender.selected = YES;
    
    if (percentage.selected) {
        self.selectedDiscountType = @"%";
    } else {
        self.selectedDiscountType = @"lastPrice";
    }
    
    if (self.discountTextField.text.length > 0) {
        [self.discountTextField resignFirstResponder];
    }
}

- (void)doneTextField {
    
    [self.priceTextField resignFirstResponder];
    [self.discountTextField resignFirstResponder];
}

- (NSString *)convertCurrency {
    
    if ([self.selectedCurrency isEqualToString:@"₪"]) {
        return @"SH";
    } else if ([self.selectedCurrency isEqualToString:@"$"]) {
        return @"DO";
    } else if ([self.selectedCurrency isEqualToString:@"£"]) {
        return @"PO";
    } else {
        return nil;
    }
}

- (NSString *)convertDiscountType {
    
    if ([self.selectedDiscountType isEqualToString:@"%"]) {
        return @"PE";
    } else if ([self.selectedDiscountType isEqualToString:@"lastPrice"]) {
        return @"PP";
    } else {
        return nil;
    }
}

- (void)doneTextView
{
    [self.moreDescriptionTextView resignFirstResponder];
}

- (void)setAddDealButton
{
    if (!self.addDealButton) {
        self.addDealButton = [appDelegate actionButton];
        CGRect addDealButtonFrame = self.addDealButton.frame;
        addDealButtonFrame.origin.y = 18.0;
        self.addDealButton.frame = addDealButtonFrame;
        self.addDealButton.backgroundColor = [appDelegate ourPurple];
        [self.addDealButton setTitle:NSLocalizedString(@"Share the Deal", nil) forState:UIControlStateNormal];
        [self.addDealButton setTintColor:[UIColor whiteColor]];
    
        [self.addDealButton addTarget:self action:@selector(addDeal) forControlEvents:UIControlEventTouchUpInside];
        [self.addDealView addSubview:self.addDealButton];
    }
    
    if (!self.addDealButtonBackground) {
        self.addDealButtonBackground = [[UIView alloc]initWithFrame:self.addDealButton.frame];
        self.addDealButtonBackground.layer.cornerRadius = 8.0;
        self.addDealButtonBackground.layer.masksToBounds = YES;
        self.addDealButtonBackground.backgroundColor = [appDelegate ourPurple];
        [self.addDealView insertSubview:self.addDealButtonBackground belowSubview:self.addDealButton];
    }
    
    if (!self.loadingAnimation) {
        [self setLoadingAnimation];
    }
}

- (void)setLoadingAnimation
{
    self.loadingAnimation = [appDelegate loadingAnimationWhite];
    [self.addDealButtonBackground addSubview:self.loadingAnimation];
    [self setConstraintsForLoadingAnimation];
    self.loadingAnimation.transform = CGAffineTransformMakeScale(0.001, 0.001);
}

- (void)setConstraintsForLoadingAnimation
{
    [self.addDealButtonBackground addConstraint:[NSLayoutConstraint constraintWithItem:self.loadingAnimation
                                                                      attribute:NSLayoutAttributeCenterX
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.addDealButtonBackground
                                                                      attribute:NSLayoutAttributeCenterX
                                                                     multiplier:1.0
                                                                       constant:0]];
    
    [self.addDealButtonBackground addConstraint:[NSLayoutConstraint constraintWithItem:self.loadingAnimation
                                                                      attribute:NSLayoutAttributeCenterY
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.addDealButtonBackground
                                                                      attribute:NSLayoutAttributeCenterY
                                                                     multiplier:1.0
                                                                       constant:0]];
}

- (void)startLoading
{
    [self.loadingAnimation startAnimating];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.addDealButton.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.addDealButton.alpha = 0.5;
        self.loadingAnimation.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

- (void)stopLoading
{
    [self.loadingAnimation stopAnimating];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.loadingAnimation.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.addDealButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.addDealButton.alpha = 1.0;
    }];
}

- (void)setSharedView
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    if ([self.tableView viewWithTag:sharedViewTag]) {
        
        UIView *oldSharedView = [self.tableView viewWithTag:sharedViewTag];
        [oldSharedView removeFromSuperview];
    }
    
    UIView *sharedView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height + 1000, screenWidth, screenWidth)];
    sharedView.backgroundColor = [UIColor whiteColor];
    sharedView.tag = sharedViewTag;
    [self.tableView addSubview:sharedView];
    
    // Setting the shared view content:
    
    UIImageView *dealPic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenWidth * 0.678125)];
    [sharedView addSubview:dealPic];
    
    if (self.deal.photo1) {
        
        dealPic.image = self.deal.photo1;
        
    } else {
        
        dealPic.backgroundColor = [DealTableViewCell randomBackgroundColors:self.deal.photoURL1];
        UIImageView *logo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"White Logo"]];
        CGSize logoSize = CGSizeMake(45.0, 64.0);
        CGFloat x = sharedView.center.x - logoSize.width / 2;
        CGFloat y = 52.0;
        logo.frame = CGRectMake(x, y, logoSize.width, logoSize.height);
        
        [sharedView addSubview:logo];
    }
    
    
    CGFloat titleBackgroundHeight = 78.0;
    UIImageView *titleBackground = [[UIImageView alloc]initWithFrame:CGRectMake(0, dealPic.frame.size.height - titleBackgroundHeight, screenWidth, titleBackgroundHeight)];
    titleBackground.image = [UIImage imageNamed:@"Title Background"];
    
    if (self.deal.photo1) {
        titleBackground.alpha = 0.75;
    } else {
        titleBackground.alpha = 0;
    }
    
    [sharedView addSubview:titleBackground];
    
    CGFloat titleLabelHeight = 48.0;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconsLeftMargin,
                                                                   dealPic.frame.size.height - titleLabelHeight - 5,
                                                                   screenWidth - iconsLeftMargin * 2,
                                                                   titleLabelHeight)];
    titleLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.numberOfLines = 2;
    titleLabel.text = self.deal.title;
    [sharedView addSubview:titleLabel];
    
    CGFloat detailsVerticalGap = 9.0;
    CGFloat detailsLowestYPoint;
    CGFloat priceXPoint = labelsLeftMargin;
    CGSize iconSize = CGSizeMake(22.0, 22.0);
    CGSize labelSize = CGSizeMake(screenWidth - labelsLeftMargin - iconsLeftMargin, 22.0);
    UIColor *detailsTextColor = [appDelegate textGrayColor];
    BOOL hasPriceOrDiscount = NO;
    
    UIImageView *storeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(iconsLeftMargin,
                                                                          dealPic.frame.size.height + detailsVerticalGap,
                                                                          iconSize.width,
                                                                          iconSize.height)];
    storeIcon.image = [UIImage imageNamed:@"Store Icon"];
    [sharedView addSubview:storeIcon];
    
    UILabel *storeLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelsLeftMargin,
                                                                   storeIcon.frame.origin.y,
                                                                   labelSize.width,
                                                                   labelSize.height)];
    storeLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:15.0];
    storeLabel.textColor = detailsTextColor;
    storeLabel.numberOfLines = 1;
    storeLabel.text = self.deal.store.name;
    [sharedView addSubview:storeLabel];
    
    detailsLowestYPoint = CGRectGetMaxY(storeIcon.frame);
    
    if (self.priceTextField.text.length > 0 || self.discountTextField.text.length > 0) {
        
        hasPriceOrDiscount = YES;
        
        UIImageView *priceIcon = [[UIImageView alloc] initWithFrame:CGRectMake(iconsLeftMargin,
                                                                              detailsLowestYPoint + detailsVerticalGap,
                                                                              iconSize.width,
                                                                              iconSize.height)];
        if (!(self.priceValue > 0) && self.discountValue > 0) {
            priceIcon.image = [UIImage imageNamed:@"Discount Icon"];
        } else {
            priceIcon.image = [UIImage imageNamed:@"Price Icon"];
        }
        [sharedView addSubview:priceIcon];
        
        if (self.priceValue > 0) {
            
            UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelsLeftMargin,
                                                                           priceIcon.frame.origin.y,
                                                                           labelSize.width,
                                                                           labelSize.height)];
            priceLabel.text = self.priceTextField.text;
            priceLabel.font = [UIFont fontWithName:@"Avenir-Light" size:17.0];
            [priceLabel sizeToFit];
            priceLabel.center = priceIcon.center;
            CGRect priceLabelFrame = priceLabel.frame;
            priceLabelFrame.origin.x = labelsLeftMargin;
            priceLabel.frame = priceLabelFrame;
            
            priceLabel.textColor = [UIColor blackColor];
            priceLabel.numberOfLines = 1;
            [sharedView addSubview:priceLabel];
            
            priceXPoint = CGRectGetMaxX(priceLabel.frame) + 20;
        }
        
        if (self.discountValue > 0) {
            
            UILabel *discountLabel = [[UILabel alloc]initWithFrame:CGRectMake(priceXPoint,
                                                                              priceIcon.frame.origin.y,
                                                                              labelSize.width,
                                                                              labelSize.height)];
            
            discountLabel.font = [UIFont fontWithName:@"Avenir-Light" size:17.0];
            
            if ([self.selectedDiscountType isEqualToString:@"lastPrice"]) {
                
                NSDictionary* attributes = @{ NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle] };
                NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:[self.selectedCurrency stringByAppendingString:self.discountTextField.text] attributes:attributes];
                [discountLabel setAttributedText:attrText];
                
            } else if ([self.selectedDiscountType isEqualToString:@"%"]) {
                
                discountLabel.text = self.discountTextField.text;
            }
            
            [discountLabel sizeToFit];
            discountLabel.center = priceIcon.center;
            CGRect discountLabelFrame = discountLabel.frame;
            discountLabelFrame.origin.x = priceXPoint;
            discountLabel.frame = discountLabelFrame;
            
            discountLabel.textColor = detailsTextColor;
            discountLabel.numberOfLines = 1;
            [sharedView addSubview:discountLabel];
        }
        
        detailsLowestYPoint = CGRectGetMaxY(priceIcon.frame);
    }
    
    if (self.deal.store.address.length > 1 && ![self.deal.store.address isEqualToString:@"None"]) {
        
        UIImageView *addressIcon = [[UIImageView alloc] initWithFrame:CGRectMake(iconsLeftMargin,
                                                                                 detailsLowestYPoint + detailsVerticalGap,
                                                                                 iconSize.width,
                                                                                 iconSize.height)];
        addressIcon.image = [UIImage imageNamed:@"Address Icon"];
        [sharedView addSubview:addressIcon];
        
        UILabel *addressLabel = [[UILabel alloc] init];
        addressLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:15.0];
        addressLabel.textColor = detailsTextColor;
        addressLabel.text = self.deal.store.address;
        
        if (self.deal.store.city.length > 0 && ![self.deal.store.city isEqualToString:@"None"]) {
            NSString *cityAddition = [NSString stringWithFormat:@", %@", self.deal.store.city];
            addressLabel.text = [addressLabel.text stringByAppendingString:cityAddition];
        }
        
        CGSize addressLabelSize;
        
        if (hasPriceOrDiscount) {
            addressLabelSize = labelSize;
            addressLabel.numberOfLines = 1;
        } else {
            NSDictionary *attributes = @{NSFontAttributeName : addressLabel.font};
            CGSize boundingRect = CGSizeMake(storeLabel.frame.size.width - 18.0, MAXFLOAT);
            CGRect addressLabelBounds = [addressLabel.text boundingRectWithSize:boundingRect
                                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                                     attributes:attributes
                                                                        context:nil];
            addressLabelSize = addressLabelBounds.size;
            addressLabel.numberOfLines = 2;
        }
        
        addressLabel.frame = CGRectMake(labelsLeftMargin, addressIcon.frame.origin.y + 2, addressLabelSize.width, addressLabelSize.height);
        
        [sharedView addSubview:addressLabel];
        
        detailsLowestYPoint = CGRectGetMaxY(addressIcon.frame) > CGRectGetMaxY(addressLabel.frame) ? CGRectGetMaxY(addressIcon.frame) : CGRectGetMaxY(addressLabel.frame);
    }
    
//    if (![self.expirationDateLabel.text isEqualToString:NSLocalizedString(@"Choose Date", nil)] && self.expirationDateLabel.text.length > 0) {
//        
//        UIImageView *expirationIcon = [[UIImageView alloc]initWithFrame:CGRectMake(iconsLeftMargin,
//                                                                                   detailsLowestYPoint + detailsVerticalGap,
//                                                                                   iconSize.width,
//                                                                                   iconSize.height)];
//        expirationIcon.image = [UIImage imageNamed:@"Expiration Date Icon"];
//        [sharedView addSubview:expirationIcon];
//        
//        UILabel *expirationLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelsLeftMargin,
//                                                                            expirationIcon.frame.origin.y,
//                                                                            labelWidth,
//                                                                            expirationIcon.frame.size.height)];
//        expirationLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
//        expirationLabel.textColor = detailsTextColor;
//        expirationLabel.numberOfLines = 1;
//        expirationLabel.text = [NSLocalizedString(@"Expires on ", nil) stringByAppendingString:self.expirationDateLabel.text];
//        [sharedView addSubview:expirationLabel];
//    }
}

- (void)screenshotSharedView
{
    self.sharedImage = [[UIImage alloc]init];
    
    UIView *sharedView = [self.tableView viewWithTag:sharedViewTag];
    
    CGRect screenShotRect = sharedView.bounds;
    
    UIGraphicsBeginImageContextWithOptions(sharedView.bounds.size, YES, 0.0);
    [sharedView drawViewHierarchyInRect:screenShotRect afterScreenUpdates:YES];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.sharedImage = screenshot;
}

- (void)setProgressIndicator
{
    illogicalPercentage = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    illogicalPercentage.delegate = self;
    illogicalPercentage.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Error"]];
    illogicalPercentage.mode = MBProgressHUDModeCustomView;
    illogicalPercentage.labelText = NSLocalizedString(@"Discount above 100%!", nil);
    illogicalPercentage.labelFont = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    illogicalPercentage.animationType = MBProgressHUDAnimationZoomIn;
    
    lastPriceWithoutPrice = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    lastPriceWithoutPrice.delegate = self;
    lastPriceWithoutPrice.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Error"]];
    lastPriceWithoutPrice.mode = MBProgressHUDModeCustomView;
    lastPriceWithoutPrice.labelText = NSLocalizedString(@"Price is empty!", nil);
    lastPriceWithoutPrice.labelFont = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    lastPriceWithoutPrice.detailsLabelText = NSLocalizedString(@"Required if there's previous price", nil);
    lastPriceWithoutPrice.detailsLabelFont = [UIFont fontWithName:@"Avenir-Light" size:15.0];
    lastPriceWithoutPrice.animationType = MBProgressHUDAnimationZoomIn;
    
    UIImageView *customView = [self.appDelegate loadingAnimationWhite];
    [customView startAnimating];
    
    loggingInFacebook = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    loggingInFacebook.delegate = self;
    loggingInFacebook.customView = customView;
    loggingInFacebook.mode = MBProgressHUDModeCustomView;
    loggingInFacebook.labelText = NSLocalizedString(@"Connecting", nil);
    loggingInFacebook.labelFont = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    loggingInFacebook.animationType = MBProgressHUDAnimationZoomIn;
    
    [self.navigationController.view addSubview:illogicalPercentage];
    [self.navigationController.view addSubview:lastPriceWithoutPrice];
    [self.navigationController.view addSubview:loggingInFacebook];
}


#pragma mark - General methods

- (void)setCashedData
{
    if (self.cashedPrice.length > 0) {
        
        self.priceValue = [self.cashedPrice substringFromIndex:1].floatValue;
        self.priceTextField.text = self.cashedPrice;
        // Cashed currency has already been set in the createInputAccessoryViews method
    }
    
    if (self.cashedDiscountValue.floatValue > 0) {
        
        self.discountValue = self.cashedDiscountValue.floatValue;
        // Cashed discount type has already been set in the createInputAccessoryViews method
        
        NSString *discountValue = [[NSNumber numberWithFloat:self.discountValue] stringValue];
        
        if ([self.selectedDiscountType isEqualToString:@"%"]) {
            self.discountTextField.text = [discountValue stringByAppendingString:self.selectedDiscountType];
            
        } else {
            NSDictionary* attributes = @{ NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle] };
            NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:discountValue attributes:attributes];
            [self.discountTextField setAttributedText:attrText];
        }
    }
    
    if (self.cashedCategory.length > 0) {
        self.categoryLabel.text = self.cashedCategory;
        self.categoryLabel.textColor = [UIColor blackColor];
        
    } else if (self.deal.store.categoryID) {
        // No cashed category, determine category according to the store
        NSString *category = [StoreCategoriesOrganizer superCategoryForCategory:self.deal.store.categoryID];
        
        self.categoryLabel.text = category;
        self.categoryLabel.textColor = [UIColor blackColor];
    }
    
    if (self.cashedExpirationDate) {
        [self.datePicker setDate:self.cashedExpirationDate];
        self.expirationDateLabel.text = [self.dateFormatter stringFromDate:self.cashedExpirationDate];
        self.expirationDateLabel.textColor = [UIColor blackColor];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.priceTextField) {
        
        if (textField.text.length > 0 && [textField.text rangeOfString:self.selectedCurrency].location != NSNotFound) {
            textField.text = [textField.text stringByReplacingOccurrencesOfString:self.selectedCurrency withString:@""];
            
        }
        
    } else if (textField == self.discountTextField) {
        
        if (textField.text.length > 0) {
            
            if ([textField.text rangeOfString:@"%"].location != NSNotFound) {
                textField.text = [textField.text stringByReplacingOccurrencesOfString:@"%" withString:@""];
            } else if (textField.attributedText) {
                NSDictionary* attributes = @{};
                NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:textField.text attributes:attributes];
                textField.attributedText = attrText;
            }
        }
    }
    
    [self hideDatePickerCell];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.priceTextField) {
        
        if (textField.text.length > 0 && textField.text.floatValue != 0) {
            
            self.priceValue = [self.priceTextField.text floatValue];
            
            self.priceTextField.text = [self.selectedCurrency stringByAppendingString:[[NSNumber numberWithFloat:self.priceValue] stringValue]];
            
        } else {
            
            self.priceValue = 0;
            textField.text = nil;
        }
        
    } else if (textField == self.discountTextField ) {
        
        if (textField.text.length > 0 && textField.text.floatValue != 0) {
            
            self.discountValue = [self.discountTextField.text floatValue];
            
            if (percentage.selected) {
                
                self.discountTextField.text = [[[NSNumber numberWithFloat:self.discountValue] stringValue] stringByAppendingString:@"%"];
                
            } else if (lastPrice.selected) {
                
                self.discountTextField.text = [[NSNumber numberWithFloat:self.discountValue] stringValue];
                
                NSDictionary* attributes = @{ NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle] };
                NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:self.discountTextField.text attributes:attributes];
                [self.discountTextField setAttributedText:attrText];
            }
            
        } else {
            
            self.discountValue = 0;
            textField.text = nil;
        }
    }
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//
//    if (textField == self.priceTextField) {
//
//        if (range.location < 1) {
//
//            UITextPosition *start = [textField positionFromPosition:textField.beginningOfDocument offset:range.location];
//            UITextPosition *end = [textField positionFromPosition:start offset:range.length];
//            UITextRange *textRange = [textField textRangeFromPosition:start toPosition:end];
//
//            textField.selectedTextRange = textRange;
//
//            return YES;
//        }
//    }
//}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag) {
            
        case categorySheetTag:
            
            if (buttonIndex == 0) {
                
                [self cancelCategory];
                
            } else if (buttonIndex == 1) {
                
                [self chooseCategoryView];
            }
            
            [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
            
            break;
            
        case expirationDateSheetTag:
            
            if (buttonIndex == 0) {
                
                [self noDate];
                
            } else if (buttonIndex == 1) {
                
                [self showDatePickerCell];
            }
            
            break;
            
        default:
            break;
    }
}

- (void)chooseCategoryView {
    
    ChooseCategoryTableViewController *cctvc = [self.storyboard instantiateViewControllerWithIdentifier:@"chooseCategoryID"];
    cctvc.cameFrom = @"Add Deal";
    [self.navigationController pushViewController:cctvc animated:YES];
}

- (void)setFacebookConnection
{
    if ([appDelegate isFacebookConnected]) {
        
        [self.facebookActivityIndicator startAnimating];
        
        if (self.hasPublishPermissions) {
            [self turnOnFacebook];
            
        } else {
            
            // Present the permissions dialog and ask for publish_actions
            [FBRequestConnection startWithGraphPath:@"/me/permissions"
                                  completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                      
                                      if (!error){
                                          
                                          NSDictionary *permissions = [(NSArray *)[result data] objectAtIndex:2]; // object at index 2 is the publish_actions permission
                                          
                                          if ([[permissions objectForKey:@"permission"] isEqualToString:@"publish_actions"]
                                              && [[permissions objectForKey:@"status"] isEqualToString:@"granted"]) {
                                              
                                              // Publish permissions found, turn on facebook
                                              self.hasPublishPermissions = YES;
                                              [self turnOnFacebook];
                                              
                                          } else {
                                              
                                              // Publish permissions not found, ask for publish_actions
                                              self.hasPublishPermissions = NO;
                                              [self requestPublishPermissions];
                                              
                                          }
                                          
                                      } else {
                                          // There was an error, handle it
                                          [self.facebookActivityIndicator stopAnimating];
                                      }
                                  }];
        }
        
    } else {
        
        // Connect with Facebook Login and ask for all the necessary permissions, including publish_actions
        
        [appDelegate openActiveSessionWithPermissions:@[@"public_profile", @"user_friends", @"email", @"user_birthday", @"user_location", @"publish_actions"] allowLoginUI:YES];
    }
}

- (void)requestPublishPermissions
{
    [FBSession.activeSession requestNewPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                          defaultAudience:FBSessionDefaultAudienceFriends
                                        completionHandler:^(FBSession *session, NSError *error) {
                                            
                                            if (!error) {
                                                
                                                [self checkPublishPermissions];
                                                
                                            } else {
                                                
                                                // There was an error, handle it
                                                NSLog(@"error! %@", [error localizedDescription]);
                                                [self.facebookActivityIndicator stopAnimating];
                                            }
                                        }];
}

- (void)checkPublishPermissions
{
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        
        // Permission not granted, tell the user we will not publish
        
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Permission not granted", nil)
                                    message:NSLocalizedString(@"Your deal will not be published to Facebook.", nil)
                                   delegate:self
                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                          otherButtonTitles:nil] show];
        
        self.hasPublishPermissions = NO;
        [self.facebookActivityIndicator stopAnimating];
        
    } else {
        
        // Permission granted, turn on facebook
        self.hasPublishPermissions = YES;
        [self turnOnFacebook];
    }
}

- (void)turnOnFacebook
{
    [self.facebookActivityIndicator stopAnimating];
    NSIndexPath *facebookIndexPath = [NSIndexPath indexPathForRow:0 inSection:3];
    self.facebookIcon.selected = YES;
    self.facebookLabel.textColor = [UIColor colorWithRed:59.0/255.0 green:87.0/255.0 blue:157.0/255.0 alpha:1.0];
    [self.tableView cellForRowAtIndexPath:facebookIndexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    isFacebookSelectd = YES;
}

- (void)handleFBSessionStateChangeWithNotification:(NSNotification *)notification
{
    if (!self.hasPublishPermissions) { // Otherwise there is no need to fetch the user's info, because we already have it.
        
        // Get the session, state and error values from the notification's userInfo dictionary.
        NSDictionary *userInfo = [notification userInfo];
        
        FBSessionState sessionState = [[userInfo objectForKey:@"state"] integerValue];
        NSError *error = [userInfo objectForKey:@"error"];
        
        if (!error) {
            
            // In case that there's not any error, then check if the session opened or closed.
            
            if ([appDelegate isFacebookConnected]) {
                
                // The session is open. Get the user information and update the UI.
                
                [FBRequestConnection startWithGraphPath:@"me"
                                             parameters:@{@"fields": @"first_name, last_name, gender, birthday, picture.type(large), location, email"}
                                             HTTPMethod:@"GET"
                                      completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                          
                                          if (!error) {
                                              
                                              appDelegate.dealer = [appDelegate updateDealer:appDelegate.dealer withFacebookInfo:(FBGraphObject *)result withPhoto:NO];
                                              
                                              [self checkPublishPermissions];
                                              
                                          } else {
                                              
                                              NSLog(@"%@", [error localizedDescription]);
                                              [self.facebookActivityIndicator stopAnimating];
                                          }
                                      }];
                
            } else if (sessionState == FBSessionStateClosed || sessionState == FBSessionStateClosedLoginFailed){
                
                // A session was closed or the login was failed or canceled. Update the UI accordingly.
                
                [self.facebookActivityIndicator stopAnimating];
            }
            
        } else {
            
            // In case an error has occured, then just log the error and update the UI accordingly.
            NSLog(@"Error: %@", [error localizedDescription]);
            [self.facebookActivityIndicator stopAnimating];
        }
    }
}


#pragma mark - Upload Deal

- (void)addDeal
{
    [self.priceTextField resignFirstResponder];
    [self.discountTextField resignFirstResponder];
    
    // First check if all is valid
    
    if (![self validation]) {
        
        return;
    }
    
    // were any other social network selected?
    
    if (isFacebookSelectd || isWhatsAppSelected) {
        
        [self setSharedView];
        [self screenshotSharedView];
    }
    
    // store all the data in the view in the Deal object
    
    if (self.priceTextField.text.length > 0) {
        
        self.deal.price = [NSNumber numberWithFloat:self.priceValue];
        
        self.deal.currency = [self convertCurrency];
    }
    
    if (self.discountTextField.text.length > 0) {
        
        self.deal.discountValue = [NSNumber numberWithFloat:self.discountValue];
        
        self.deal.discountType = [self convertDiscountType];
    }
    
    if (self.categoryLabel.text.length > 0 && ![self.categoryLabel.text isEqualToString:NSLocalizedString(@"Choose Category", nil)]) {
        
        NSDictionary *categoriesKeys = [appDelegate getCategoriesDictionary];
        NSArray *temp = [categoriesKeys allKeysForObject:self.categoryLabel.text];
        self.deal.category = temp.firstObject;
    }
    
    if (self.expirationDateLabel.text.length > 2 && !self.didCancelDate) {
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *expirationDateComponents = [calendar components:NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                                         fromDate:self.datePicker.date];
        self.deal.expiration = [calendar dateFromComponents:expirationDateComponents];
    }
    
    self.deal.uploadDate = [NSDate date];
    
    // upload the deal to the server
    
    [self startLoading];
    
    [self uploadDeal];
    if (self.deal.photoSum > 0) [self uploadDealPhotos];
}

- (BOOL)validation
{
    if ([self.selectedDiscountType isEqualToString:@"%"] && [self.discountTextField.text intValue] > 100) {
        
        [illogicalPercentage show:YES];
        [illogicalPercentage hide:YES afterDelay:2.0];
        
        return NO;
        
    } else if ([self.selectedDiscountType isEqualToString:@"lastPrice"] && self.discountTextField.text.length > 0 && !(self.priceTextField.text.length > 0)) {
        
        [lastPriceWithoutPrice show:YES];
        [lastPriceWithoutPrice hide:YES afterDelay:2.0];
        
        return NO;
    }
    
    return YES;
}

- (void)uploadDeal
{
    // Posting the deal
    [[RKObjectManager sharedManager] postObject:self.deal
                                           path:@"/adddeals/"
                                     parameters:nil
                                        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                            
                                            NSLog(@"Deal was uploaded successfuly!");
                                            didUploadDealData = YES;
                                            
                                            self.deal = mappingResult.firstObject;
                                            
                                            if (self.deal.photoSum.intValue > 0) {
                                                
                                                if (didDealPhotosFinishedUploading) {
                                                    [self uploadFinishedSuccessfuly];
                                                }
                                                
                                            } else {
                                                
                                                [self uploadFinishedSuccessfuly];
                                            }
                                        }
     
                                        failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                            
                                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                                                            message:NSLocalizedString(@"Couldn't upload the deal :(", nil)
                                                                                           delegate:nil
                                                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                                                  otherButtonTitles:nil];
                                            [alert show];
                                            
                                            [self stopLoading];
                                            
                                            [[[AWSS3TransferManager defaultS3TransferManager] cancelAll] continueWithBlock:^id(BFTask *task) {
                                                if (task.error) {
                                                    NSLog(@"Error with cancelling uploads: %@",task.error);
                                                } else {
                                                    NSLog(@"Upload cancelled");
                                                }
                                                return nil;
                                            }];
                                        }];
}

- (void)uploadDealPhotos
{
    // Post Photos to S3
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    
    for (int i = 0; i < self.deal.photoSum.intValue; i++) {
        
        NSString *fileName = [self.photosFileName objectAtIndex:i];
        NSURL *fileURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:fileName]];
        NSData *photoData = [NSData dataWithContentsOfURL:fileURL];
        NSString *key;
        
        switch (i) {
            case 0:
                key = self.deal.photoURL1;
                break;
            case 1:
                key = self.deal.photoURL2;
                break;
            case 2:
                key = self.deal.photoURL3;
                break;
            case 3:
                key = self.deal.photoURL4;
                break;
                
            default:
                break;
        }
        
        AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
        uploadRequest.bucket = AWS_S3_BUCKET_NAME;
        uploadRequest.key = key;
        uploadRequest.body = fileURL;
        uploadRequest.contentLength = [NSNumber numberWithUnsignedLongLong:photoData.length];
        
        [[transferManager upload:uploadRequest] continueWithExecutor:[BFExecutor mainThreadExecutor]
                                                           withBlock:^id(BFTask *task) {
                                                               if (task.error) {
                                                                   if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
                                                                       switch (task.error.code) {
                                                                               
                                                                           case AWSS3TransferManagerErrorCancelled:
                                                                               NSLog(@"Photo number %i upload cancelled", i + 1);
                                                                               [self stopLoading];
                                                                               break;
                                                                               
                                                                           case AWSS3TransferManagerErrorPaused:
                                                                               NSLog(@"Photo number %i upload paused", i + 1);
                                                                               [self stopLoading];
                                                                               break;
                                                                               
                                                                           default:
                                                                               NSLog(@"Error: %@", task.error);
                                                                               [self stopLoading];
                                                                               break;
                                                                       }
                                                                   } else {
                                                                       // Unknown error.
                                                                       NSLog(@"Error: %@", task.error);
                                                                       [self stopLoading];
                                                                       UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Couldn't upload the deal's photos. Please try again :(" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                                       [alert show];
                                                                       if (didUploadDealData) {
                                                                           [self deleteDamagedDeal];
                                                                           [self stopLoading];
                                                                       } else {
                                                                           [[RKObjectManager sharedManager] cancelAllObjectRequestOperationsWithMethod:RKRequestMethodAny matchingPathPattern:nil];
                                                                           [self stopLoading];
                                                                       }
                                                                   }
                                                               }
                                                               
                                                               if (task.result) {
                                                                   
                                                                   NSLog(@"Photo number %i uploaded successfuly!", i + 1);
                                                                   if (i + 1 == self.deal.photoSum.intValue) {
                                                                       // All photos were uploaded successfuly
                                                                       didDealPhotosFinishedUploading = YES;
                                                                       if (didUploadDealData) {
                                                                           [self uploadFinishedSuccessfuly];
                                                                       }
                                                                   }
                                                               }
                                                               return nil;
                                                           }];
    }
}

- (void)deleteDamagedDeal
{
    NSString *path = [NSString stringWithFormat:@"/deals/%@", self.deal.dealID];
    [[RKObjectManager sharedManager] deleteObject:self.deal
                                             path:path
                                       parameters:nil
                                          success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                              
                                              NSLog(@"Deal was deleted successfuly.");
                                          }
                                          failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                              
                                              NSLog(@"\n\nCouldn't delete the deal...");
                                          }];
}

- (void)uploadFinishedSuccessfuly
{
    ThankYouViewController *tyvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ThankYouID"];
    
    tyvc.wasFacebookSelected = isFacebookSelectd;
    tyvc.wasWhatsAppSelected = isWhatsAppSelected;
    tyvc.sharedImage = self.sharedImage;
    
    appDelegate.shouldUpdateMyFeed = YES;
    appDelegate.shouldUpdateProfile = YES;
    
    [appDelegate updateUserInfo];
    
    [self.navigationController pushViewController:tyvc animated:YES];
}

// All the text view delegate methods for the description (obsolete):

/*
 - (void)textViewDidBeginEditing:(UITextView *)textView {
 
 [self hideDatePickerCell];
 }
 
 - (void)textViewDidChangeSelection:(UITextView *)textView {
 
 if (textView.selectedRange.location < 13) { // 13 representing the length of the pharse: "Description: "...
 
 NSUInteger first = 13 - textView.selectedRange.location;
 NSUInteger second = textView.selectedRange.length - first;
 textView.selectedRange = NSMakeRange(13, second);
 }
 }
 
 - (void)textViewDidChange:(UITextView *)textView {
 
 if (textView.text.length == 13) {
 
 self.moreDescriptionPlaceholder.hidden = NO;
 
 } else {
 
 self.moreDescriptionPlaceholder.hidden = YES;
 }
 }
 
 - (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
 
 if (range.location < 13) {
 
 textView.selectedRange = NSMakeRange(13, 0);
 return NO;
 
 } else {
 
 return YES;
 }
 }
 */

@end

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
#define iconsLeftMargin 12
#define labelsLeftMargin 52

@interface WhatIsTheDeal2 ()

@end

@implementation WhatIsTheDeal2

@synthesize appDelegate;
@synthesize shekel, dollar, pound, percentage, lastPrice;


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
    
    self.title = @"Add the Deal";
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    [self initialize];
    [self configureRestKit];
    [self setupExpirationDateCellContentView];
    [self setAddDealButton];
    [self setProgressIndicator];
    [self createInputAccessoryViews];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
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
    self.priceValue = 0;
    self.discountValue = 0;
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
        
        if ([self.categoryLabel.text isEqualToString:@"Choose Category"] || !(self.categoryLabel.text.length > 0)) {
            
            [self chooseCategoryView];
            
        } else {
            
            UIActionSheet *categorySheet = [[UIActionSheet alloc]initWithTitle:nil
                                                                      delegate:self
                                                             cancelButtonTitle:@"Cancel"
                                                        destructiveButtonTitle:@"Remove Category"
                                                             otherButtonTitles:@"Pick a New Category", nil];
            categorySheet.tag = categorySheetTag;
            [categorySheet showFromTabBar:self.tabBarController.tabBar];
        }
        
        [self.priceTextField resignFirstResponder];
        [self.discountTextField resignFirstResponder];
        [self hideDatePickerCell];
        
    } else if (indexPath.section == 2 && indexPath.row == 0) { // Expiration Date Section
        
        if (self.datePickerIsShowing) {
            
            [self hideDatePickerCell];
            
        } else {
            
            if ([self.expirationDateLabel.text isEqualToString:@"Choose Date"] || !(self.expirationDateLabel.text.length > 0)) {
                
                [self showDatePickerCell];
                [self performSelector:@selector(dateChanged:) withObject:self.datePicker];
                
            } else {
                
                UIActionSheet *expirationDateSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                                                delegate:self
                                                                       cancelButtonTitle:@"Cancel"
                                                                  destructiveButtonTitle:@"Remove Date"
                                                                       otherButtonTitles:@"Change Date", nil];
                expirationDateSheet.tag = expirationDateSheetTag;
                [expirationDateSheet showFromTabBar:self.tabBarController.tabBar];
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
                
                self.facebookIcon.selected = YES;
                self.facebookLabel.textColor = [UIColor colorWithRed:59.0/255.0 green:87.0/255.0 blue:157.0/255.0 alpha:1.0];
                [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                isFacebookSelectd = YES;
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
    
    NSDate *today = [NSDate date];
    [self.datePicker setMinimumDate:today];
    
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
    [done1 setTitle:@"Done" forState:UIControlStateNormal];
    [done1 setFrame:CGRectMake(260, 0, 60, 44)];
    [done1 setAlpha:0.9];
    [[done1 titleLabel] setFont:[UIFont fontWithName:@"Avenir-Medium" size:17.0]];
    [done1 addTarget:self action:@selector(doneTextField) forControlEvents:UIControlEventTouchUpInside];
    
    [priceBar addSubview:shekel];
    [priceBar addSubview:dollar];
    [priceBar addSubview:pound];
    [priceBar addSubview:done1];
    
    // default choise:
    [shekel setSelected:YES];
    selectedCurrency = @"₪";
    
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
    [done2 setTitle:@"Done" forState:UIControlStateNormal];
    [done2 setFrame:CGRectMake(260, 0, 60, 44)];
    [done2 setAlpha:0.9];
    [[done2 titleLabel] setFont:[UIFont fontWithName:@"Avenir-Medium" size:17.0]];
    [done2 addTarget:self action:@selector(doneTextField) forControlEvents:UIControlEventTouchUpInside];
    
    [discountBar addSubview:percentage];
    [discountBar addSubview:lastPrice];
    [discountBar addSubview:done2];
    
    // default choise:
    [percentage setSelected:YES];
    selectedDiscountType = @"%";
    
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
    selectedCurrency = sender.titleLabel.text;
}

- (void)selectDiscountType:(UIButton *)sender
{
    percentage.selected = NO;
    lastPrice.selected = NO;
    
    sender.selected = YES;
    
    if (percentage.selected) {
        selectedDiscountType = @"%";
    } else {
        selectedDiscountType = @"lastPrice";
    }
}

- (void)doneTextField {
    
    [self.priceTextField resignFirstResponder];
    [self.discountTextField resignFirstResponder];
}

- (NSString *)convertCurrency {
    
    if ([selectedCurrency isEqualToString:@"₪"]) {
        return @"SH";
    } else if ([selectedCurrency isEqualToString:@"$"]) {
        return @"DO";
    } else if ([selectedCurrency isEqualToString:@"£"]) {
        return @"PO";
    } else {
        return nil;
    }
}

- (NSString *)convertDiscountType {
    
    if ([selectedDiscountType isEqualToString:@"%"]) {
        return @"PE";
    } else if ([selectedDiscountType isEqualToString:@"lastPrice"]) {
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
    UIButton *addDeal = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGFloat x = 20;
    CGFloat y = 18;
    CGFloat width = self.view.frame.size.width - x * 2;
    CGFloat height = 44;
    
    [addDeal setFrame:CGRectMake(x, y, width, height)];
    [addDeal setBackgroundColor:[UIColor colorWithRed:150.0/250.0 green:0 blue:180.0/250.0 alpha:1.0]];
    [addDeal setTitle:@"Add the Deal" forState:UIControlStateNormal];
    [[addDeal titleLabel]setFont:[UIFont fontWithName:@"Avenir-Medium" size:19.0]];
    [[addDeal layer]setCornerRadius:8.0];
    [[addDeal layer]setMasksToBounds:YES];
    [addDeal addTarget:self action:@selector(addDeal) forControlEvents:UIControlEventTouchUpInside];
    
    [self.addDealView addSubview:addDeal];
}

- (void)setSharedView
{
    CGFloat screenWidth = self.view.frame.size.width;
    
    if ([self.tableView viewWithTag:sharedViewTag]) {
        
        UIView *oldSharedView = [self.tableView viewWithTag:sharedViewTag];
        [oldSharedView removeFromSuperview];
    }
    
    UIView *sharedView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height + 1000, screenWidth, screenWidth)];
    sharedView.backgroundColor = [UIColor whiteColor];
    sharedView.tag = sharedViewTag;
    [self.tableView addSubview:sharedView];
    
    // Setting the shared view content:
    
    UIImageView *dealPic = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 165.0)];

    if (self.deal.photo1) {
        
        dealPic.image = self.deal.photo1;
    
    } else {
        
        dealPic.image = [UIImage imageNamed:@""];
    }
    
    [sharedView addSubview:dealPic];
    
    CGFloat titleBackgroundHeight = 78.0;
    UIImageView *titleBackground = [[UIImageView alloc]initWithFrame:CGRectMake(0, dealPic.frame.size.height - titleBackgroundHeight, screenWidth, titleBackgroundHeight)];
    titleBackground.image = [UIImage imageNamed:@"Title Background"];
    titleBackground.alpha = 0.65;
    [sharedView addSubview:titleBackground];
    
    CGFloat titleLabelHeight = 48.0;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(iconsLeftMargin,
                                                                   dealPic.frame.size.height - titleLabelHeight - 5,
                                                                   screenWidth - iconsLeftMargin * 2,
                                                                   titleLabelHeight)];
    titleLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:17.0];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.numberOfLines = 2;
    titleLabel.text = self.deal.title;
    [sharedView addSubview:titleLabel];
    
    CGFloat detailsVerticalGap = 7.0;
    CGFloat detailsLowestYPoint;
    CGFloat priceXPoint = labelsLeftMargin;
    CGSize iconSize = CGSizeMake(30, 30);
    CGFloat labelWidth = self.view.frame.size.width - labelsLeftMargin - 10;
    UIColor *detailsTextColor = [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:160.0/255.0 alpha:1.0];
    
    UIImageView *storeIcon = [[UIImageView alloc]initWithFrame:CGRectMake(iconsLeftMargin,
                                                                          dealPic.frame.size.height + detailsVerticalGap,
                                                                          iconSize.width,
                                                                          iconSize.height)];
    storeIcon.image = [UIImage imageNamed:@"Store Icon"];
    [sharedView addSubview:storeIcon];
    
    UILabel *storeLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelsLeftMargin,
                                                                   storeIcon.frame.origin.y,
                                                                   labelWidth,
                                                                   storeIcon.frame.size.height)];
    storeLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:15.0];
    storeLabel.textColor = detailsTextColor;
    storeLabel.numberOfLines = 1;
    storeLabel.text = [@"At " stringByAppendingString:self.deal.store.name];
    [sharedView addSubview:storeLabel];
    
    detailsLowestYPoint = CGRectGetMaxY(storeIcon.frame);
    
    if (self.priceTextField.text.length > 0 || self.discountTextField.text.length > 0) {
        
        UIImageView *priceIcon = [[UIImageView alloc]initWithFrame:CGRectMake(iconsLeftMargin,
                                                                              detailsLowestYPoint + detailsVerticalGap,
                                                                              iconSize.width,
                                                                              iconSize.height)];
        priceIcon.image = [UIImage imageNamed:@"Price Icon"];
        [sharedView addSubview:priceIcon];
        
        if (self.priceValue > 0) {
            
            UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelsLeftMargin,
                                                                           priceIcon.frame.origin.y,
                                                                           labelWidth,
                                                                           priceIcon.frame.size.height)];
            priceLabel.text = self.priceTextField.text;
            priceLabel.font = [UIFont fontWithName:@"Avenir-Light" size:18.0];
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
                                                                              labelWidth,
                                                                              priceIcon.frame.size.height)];
            
            discountLabel.font = [UIFont fontWithName:@"Avenir-Light" size:18.0];
            
            if ([selectedDiscountType isEqualToString:@"lastPrice"]) {
                
                NSDictionary* attributes = @{ NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle] };
                NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:self.discountTextField.text attributes:attributes];
                [discountLabel setAttributedText:attrText];
            
            } else if ([selectedDiscountType isEqualToString:@"%"]) {
                
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
    
    if (self.categoryLabel.text.length > 0 && [self.categoryLabel.text rangeOfString:@"Choose Category"].location == NSNotFound) {
        
        UIImageView *categoryIcon = [[UIImageView alloc]initWithFrame:CGRectMake(iconsLeftMargin,
                                                                                 detailsLowestYPoint + detailsVerticalGap,
                                                                                 iconSize.width,
                                                                                 iconSize.height)];
        categoryIcon.image = [UIImage imageNamed:@"Category Icon"];
        [sharedView addSubview:categoryIcon];
        
        UILabel *categoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelsLeftMargin,
                                                                          categoryIcon.frame.origin.y,
                                                                          labelWidth,
                                                                          categoryIcon.frame.size.height)];
        categoryLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:15.0];
        categoryLabel.textColor = detailsTextColor;
        categoryLabel.numberOfLines = 1;
        categoryLabel.text = self.categoryLabel.text;
        [sharedView addSubview:categoryLabel];
        
        detailsLowestYPoint = CGRectGetMaxY(categoryIcon.frame);
    }
    
    if (![self.expirationDateLabel.text isEqualToString:@"Choose Date"] && self.expirationDateLabel.text.length > 0) {
        
        UIImageView *expirationIcon = [[UIImageView alloc]initWithFrame:CGRectMake(iconsLeftMargin,
                                                                                   detailsLowestYPoint + detailsVerticalGap,
                                                                                   iconSize.width,
                                                                                   iconSize.height)];
        expirationIcon.image = [UIImage imageNamed:@"Expiration Date Icon"];
        [sharedView addSubview:expirationIcon];
        
        UILabel *expirationLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelsLeftMargin,
                                                                            expirationIcon.frame.origin.y,
                                                                            labelWidth,
                                                                            expirationIcon.frame.size.height)];
        expirationLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:15.0];
        expirationLabel.textColor = detailsTextColor;
        expirationLabel.numberOfLines = 1;
        expirationLabel.text = self.expirationDateLabel.text;
        [sharedView addSubview:expirationLabel];
        
        detailsLowestYPoint = CGRectGetMaxY(expirationLabel.frame);
    }
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
    lastPriceWithoutPrice.detailsLabelFont = [UIFont fontWithName:@"Avenir-Roman" size:15.0];
    lastPriceWithoutPrice.animationType = MBProgressHUDAnimationZoomIn;
    
    [self.navigationController.view addSubview:illogicalPercentage];
    [self.navigationController.view addSubview:lastPriceWithoutPrice];
}


#pragma mark - General methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.priceTextField) {
        
        if (textField.text.length > 0 && [textField.text rangeOfString:selectedCurrency].location != NSNotFound) {
            textField.text = [textField.text stringByReplacingOccurrencesOfString:selectedCurrency withString:@""];
            
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
            
            self.priceTextField.text = [selectedCurrency stringByAppendingString:[[NSNumber numberWithFloat:self.priceValue] stringValue]];
            
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
    
    if (self.categoryLabel.text.length > 0 && ![self.categoryLabel.text isEqualToString:@"Choose Category"]) {
        
        NSDictionary *categoriesKeys = [appDelegate getCategoriesDictionary];
        NSArray *temp = [categoriesKeys allKeysForObject:self.categoryLabel.text];
        self.deal.category = temp.firstObject;
    }
    
    if (self.didTouchDatePicker && !self.didCancelDate) {
        
        self.deal.expiration = self.datePicker.date;
    }
    
    self.deal.uploadDate = [NSDate date];
    
    // upload the deal to the server
    
    [self uploadDeal];
}

- (BOOL)validation
{
    if ([selectedDiscountType isEqualToString:@"%"] && [self.discountTextField.text intValue] > 100) {
        
        [illogicalPercentage show:YES];
        [illogicalPercentage hide:YES afterDelay:2.0];
        
        return NO;
        
    } else if ([selectedDiscountType isEqualToString:@"lastPrice"] && !(self.priceTextField.text.length > 0)) {
        
        [lastPriceWithoutPrice show:YES];
        [lastPriceWithoutPrice hide:YES afterDelay:2.0];
        
        return NO;
    }
    
    return YES;
}

- (void)configureRestKit
{
    
}


- (void)uploadDeal
{
    if (self.deal.photo1) {
        NSMutableURLRequest *request = [[RKObjectManager sharedManager] multipartFormRequestWithObject:self.deal
                                                                                                method:RKRequestMethodPOST
                                                                                                  path:@"/deals/"
                                                                                            parameters:nil
                                                                             constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                                                 [formData appendPartWithFileData:UIImagePNGRepresentation(self.deal.photo1)
                                                                                                             name:@"deal[image]"
                                                                                                         fileName:@"Gilad"
                                                                                                         mimeType:@"image/png"];
                                                                             }];
        
        RKObjectRequestOperation *operation = [[RKObjectManager sharedManager] objectRequestOperationWithRequest:request
                                                                                                         success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                                                                             
                                                                                                             NSLog(@"Deal was uploaded successfuly!");
                                                                                                             ThankYouViewController *tyvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ThankYouID"];
                                                                                                             
                                                                                                             tyvc.wasFacebookSelected = isFacebookSelectd;
                                                                                                             tyvc.wasWhatsAppSelected = isWhatsAppSelected;
                                                                                                             tyvc.sharedImage = self.sharedImage;
                                                                                                             
                                                                                                             [self.navigationController pushViewController:tyvc animated:YES];
                                                                                                         }
                                                                                                         failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                                                                             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                                                                             [alert show];
                                                                                                         }];
        
        ThankYouViewController *tyvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ThankYouID"];
        
        tyvc.wasFacebookSelected = isFacebookSelectd;
        tyvc.wasWhatsAppSelected = isWhatsAppSelected;
        tyvc.sharedImage = self.sharedImage;
        
        [self.navigationController pushViewController:tyvc animated:YES];
        
        [[RKObjectManager sharedManager] enqueueObjectRequestOperation:operation]; // NOTE: Must be enqueued rather than started
        
    } else {
        
        [[RKObjectManager sharedManager] postObject:self.deal
                                               path:@"/deals/"
                                         parameters:nil
                                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                
                                                NSLog(@"Deal was uploaded successfuly!");
                                                ThankYouViewController *tyvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ThankYouID"];
                                                [self.navigationController pushViewController:tyvc animated:YES];
                                            }
                                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                [alert show];
                                            }];
    }
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

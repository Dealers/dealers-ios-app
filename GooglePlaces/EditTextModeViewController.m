//
//  EditTextModeViewController.m
//  Dealers-testbeta
//
//  Created by Gilad Lumbroso on 8/3/14.
//
//

#import "EditTextModeViewController.h"

#define keyboardHeight 216

@interface EditTextModeViewController () {
    
    UIColor *placeholderColor;
    NSString *newCurrency;
}

@end

@implementation EditTextModeViewController

@synthesize dollar, euro, shekel, pound;

- (IBAction)done:(id)sender {
    EditDealTableViewController *edtvc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    
    if ([self.title isEqualToString:NSLocalizedString(@"Title", nil)]) {
        
        if ([self titleValidation]) {
            edtvc.dealTitle.text = self.textView.text;
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } else if ([self.title isEqualToString:NSLocalizedString(@"Price", nil)]) {
        if ([self.textView.text isEqualToString:@""]) {
            edtvc.dealPrice.text = NSLocalizedString(@"Price", nil);
            edtvc.dealPrice.textColor = placeholderColor;
        } else {
            if (newCurrency) {
                self.selectedCurrency = newCurrency;
            }
            double doubleValue = [self.textView.text doubleValue];
            edtvc.dealPrice.text = [self.selectedCurrency stringByAppendingString:[[NSNumber numberWithDouble:doubleValue] stringValue]];
            edtvc.selectedCurrency = self.selectedCurrency;
            edtvc.dealPrice.textColor = [UIColor blackColor];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } else if ([self.title isEqualToString:NSLocalizedString(@"Discount", nil)]) {
        if ([self.textView.text isEqualToString:@""]) {
            edtvc.dealDiscount.text = NSLocalizedString(@"Discount or Last Price", nil);
            edtvc.dealDiscount.textColor = placeholderColor;
        } else {
            NSString *discountType;
            double doubleValue = [self.textView.text doubleValue];
            if (self.percentage.selected) {
                discountType = @"%";
                edtvc.dealDiscount.text = [[[NSNumber numberWithDouble:doubleValue] stringValue] stringByAppendingString:discountType];
            } else if (self.lastPrice.selected) {
                discountType = @"lastPrice";
                NSDictionary* attributes = @{ NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle] };
                NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:[[NSNumber numberWithDouble:doubleValue] stringValue] attributes:attributes];
                edtvc.dealDiscount.attributedText = attrText;
            }
            edtvc.selectedDiscountType = discountType;
            edtvc.dealDiscount.textColor = [UIColor blackColor];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } else if ([self.title isEqualToString:NSLocalizedString(@"More about the deal", nil)]) {
        if ([self.textView.text isEqualToString:@""]) {
            edtvc.dealDescription.text = NSLocalizedString(@"More about the deal", nil);
            edtvc.dealDescription.textColor = placeholderColor;
        } else {
            edtvc.dealDescription.text = self.textView.text;
            edtvc.dealDescription.textColor = [UIColor blackColor];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    edtvc.didChangeOriginalDeal = YES;
}

- (BOOL)titleValidation
{
    if (!(self.textView.text.length > 0)) {
        
        [blankTitleIndicator show:YES];
        [blankTitleIndicator hide:YES afterDelay:1.5];
        return NO;
    }
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.textView.text = self.currentValue;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    placeholderColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0];
    self.screenName = @"Edit Deal - Text Mode";
    
    [self registerForKeyboardNotifications];
    [self setProgressIndicator];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.textView becomeFirstResponder];
    if ([self.title isEqualToString:NSLocalizedString(@"Price", nil)]) [self showPriceBar];
    if ([self.title isEqualToString:NSLocalizedString(@"Discount", nil)]) [self showDiscountBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.title isEqualToString:NSLocalizedString(@"Title", nil)]) {
        self.textView.keyboardType = UIKeyboardTypeDefault;
        self.textView.returnKeyType = UIReturnKeyDone;
        self.textView.font = [UIFont fontWithName:@"Avenir-Roman" size:20.0];
    } else if ([self.title isEqualToString:NSLocalizedString(@"Price", nil)] || [self.title isEqualToString:NSLocalizedString(@"Discount", nil)]) {
        self.textView.keyboardType = UIKeyboardTypeDecimalPad;
        self.textView.font = [UIFont fontWithName:@"Avenir-Light" size:25.0];
    } else if ([self.title isEqualToString:NSLocalizedString(@"More about the deal", nil)]) {
        self.textView.keyboardType = UIKeyboardTypeDefault;
        self.textView.returnKeyType = UIReturnKeyDefault;
        if ([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft) {
            [self.textView setBaseWritingDirection:UITextWritingDirectionRightToLeft forRange:nil];
            [self.textView setTextAlignment:NSTextAlignmentNatural];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.textView.contentInset = contentInsets;
    self.textView.scrollIndicatorInsets = contentInsets;
    
    self.verticalSpacePriceBar.constant = kbSize.height;
    self.verticalSpaceDiscountBar.constant = kbSize.height;
    [self.view layoutIfNeeded];
}

- (void)keyboardWillBeHidden:(NSNotification*)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.textView.contentInset = contentInsets;
    self.textView.scrollIndicatorInsets = contentInsets;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([self.currentValue isEqualToString:self.textView.text]) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

// Setting the return button as Done:

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([self.title isEqualToString:NSLocalizedString(@"Title", nil)] && [text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - Price and Discount Type Bars

- (void)showDiscountBar
{
    NSDictionary* attributes = @{ NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle] };
    NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:@"123" attributes:attributes];
    self.lastPrice.titleLabel.attributedText = attrText;
    
    self.discountBar.hidden = NO;
    self.discountBar.alpha = 0;
    
    if ([self.discountType isEqualToString:@"lastPrice"]) {
        self.lastPrice.selected = YES;
    } else {
        self.percentage.selected = YES;
    }
    
    [UIView animateWithDuration:0.4 animations:^{self.discountBar.alpha = 1.0;}];
}

- (void)selectCurrency:(UIButton *)sender
{
    if (![self.selectedCurrency isEqualToString:sender.titleLabel.text]) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else if (![self.selectedCurrency isEqualToString:@""] && [self.currentValue isEqualToString:self.textView.text]) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    shekel.selected = NO;
    dollar.selected = NO;
    euro.selected = NO;
    pound.selected = NO;
    
    sender.selected = YES;
    newCurrency = sender.titleLabel.text;
}

- (IBAction)percentageSelected:(id)sender {
    
    if (![self.discountType isEqualToString:@"%"]) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else if (![self.discountType isEqualToString:@""] && [self.currentValue isEqualToString:self.textView.text]) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    self.percentage.selected = YES;
    self.lastPrice.selected = NO;
}

- (IBAction)lastPriceSelected:(id)sender {
    
    if (![self.discountType isEqualToString:@"lastPrice"]) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else if (![self.discountType isEqualToString:@""] && [self.currentValue isEqualToString:self.textView.text]) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    self.percentage.selected = NO;
    self.lastPrice.selected = YES;
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
    tooMuchIndicator.detailsLabelText = NSLocalizedString(@"120 characters max", nil);
    tooMuchIndicator.detailsLabelFont = [UIFont fontWithName:@"Avenir-Light" size:15.0];
    tooMuchIndicator.animationType = MBProgressHUDAnimationZoomIn;
    
    [self.navigationController.view addSubview:blankTitleIndicator];
    [self.navigationController.view addSubview:tooMuchIndicator];
}

- (void)showPriceBar
{
    dollar = [UIButton buttonWithType:UIButtonTypeSystem];
    [dollar setTitle:@"$" forState:UIControlStateNormal];
    [dollar setAlpha:0.9];
    [[dollar titleLabel] setFont:[UIFont fontWithName:@"Avenir-Light" size:24]];
    [dollar addTarget:self action:@selector(selectCurrency:) forControlEvents:UIControlEventTouchUpInside];
    
    euro = [UIButton buttonWithType:UIButtonTypeSystem];
    [euro setTitle:@"€" forState:UIControlStateNormal];
    [euro setAlpha:0.9];
    [[euro titleLabel] setFont:[UIFont fontWithName:@"Avenir-Light" size:24]];
    [euro addTarget:self action:@selector(selectCurrency:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([[[NSLocale autoupdatingCurrentLocale] localeIdentifier] isEqualToString:@"he_IL"]) {
        shekel = [UIButton buttonWithType:UIButtonTypeSystem];
        [shekel setTitle:@"₪" forState:UIControlStateNormal];
        [shekel setAlpha:0.9];
        [[shekel titleLabel] setFont:[UIFont fontWithName:@"Avenir-Light" size:26]];
        [shekel addTarget:self action:@selector(selectCurrency:) forControlEvents:UIControlEventTouchUpInside];
        
        [self orderCurrenciesFirst:shekel second:dollar third:euro];
        
        [self.priceBar addSubview:shekel];
        
    } else {
        [self orderCurrenciesFirst:dollar second:euro third:nil];
    }
    
    [self.priceBar addSubview:dollar];
    [self.priceBar addSubview:euro];
    
    self.priceBar.hidden = NO;
    self.priceBar.alpha = 0;
    [UIView animateWithDuration:0.4 animations:^{self.priceBar.alpha = 1.0;}];
}

- (void)orderCurrenciesFirst:(UIButton *)first second:(UIButton *)second third:(UIButton *)third
{
    BOOL shouldSelectDefault = YES;
    if (first) {
        [first setFrame:CGRectMake(15, 7, 30, 30)];
        if ([self.selectedCurrency isEqualToString:first.titleLabel.text]) {
            first.selected = YES;
            shouldSelectDefault = NO;
        }
    }
    if (second) {
        [second setFrame:CGRectMake(60, 7, 30, 30)];
        if ([self.selectedCurrency isEqualToString:second.titleLabel.text]) {
            second.selected = YES;
            shouldSelectDefault = NO;
        }
    }
    if (third) {
        [third setFrame:CGRectMake(105, 7, 30, 30)];
        if ([self.selectedCurrency isEqualToString:third.titleLabel.text]) {
            third.selected = YES;
            shouldSelectDefault = NO;
        }
    }
    if (shouldSelectDefault) {
        first.selected = YES;
        newCurrency = first.titleLabel.text;
    }
}


@end

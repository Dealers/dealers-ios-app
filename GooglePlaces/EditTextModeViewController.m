//
//  EditTextModeViewController.m
//  Dealers-testbeta
//
//  Created by Gilad Lumbroso on 8/3/14.
//
//

#import "EditTextModeViewController.h"

#define keyboardHeight 216

@interface EditTextModeViewController ()

@end

@implementation EditTextModeViewController

- (IBAction)done:(id)sender {
    EditDealTableViewController *edtvc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    
    if ([self.title isEqualToString:@"Title"]) {
        if ([self.textView.text isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Title Can't Be Empty" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        } else {
            edtvc.currentDeal.dealTitle = self.textView.text;
            [self.navigationController popViewControllerAnimated:YES];
        }
    
    } else if ([self.title isEqualToString:@"Price"]) {
        if ([self.textView.text isEqualToString:@""]) {
            edtvc.currentDeal.dealPrice = @"0";
        } else {
            edtvc.currentDeal.dealPrice = self.textView.text;
        }
        if (self.shekel.selected) edtvc.currentDeal.dealCurrency = @"₪";
        if (self.dollar.selected) edtvc.currentDeal.dealCurrency = @"$";
        if (self.pound.selected) edtvc.currentDeal.dealCurrency = @"£";
    
        [self.navigationController popViewControllerAnimated:YES];
        
    } else if ([self.title isEqualToString:@"Discount"]) {
        if ([self.textView.text isEqualToString:@""]) {
            edtvc.currentDeal.dealDiscount = @"0";
        } else {
            edtvc.currentDeal.dealDiscount = self.textView.text;
        }
        if (self.percentage.selected) edtvc.currentDeal.dealDiscountType = @"%";
        if (self.lastPrice.selected) edtvc.currentDeal.dealDiscountType = @"lastPrice";
        [self.navigationController popViewControllerAnimated:YES];
    
    } else if ([self.title isEqualToString:@"Description"]) {
        if ([self.textView.text isEqualToString:@""]) {
            edtvc.currentDeal.dealDescription = @"0";
        } else {
            edtvc.currentDeal.dealDescription = self.textView.text;
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    edtvc.didChangeOriginalDeal = YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.textView.text = self.currentValue;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [self positionBarsInPlace];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.textView becomeFirstResponder];
    if ([self.title isEqualToString:@"Price"]) [self showPriceBar];
    if ([self.title isEqualToString:@"Discount"]) [self showDiscountBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([self.title isEqualToString:@"Title"]) {
        self.textView.keyboardType = UIKeyboardTypeDefault;
        self.textView.returnKeyType = UIReturnKeyDone;
    } else if ([self.title isEqualToString:@"Price"] || [self.title isEqualToString:@"Discount"]) {
        self.textView.keyboardType = UIKeyboardTypeDecimalPad;
        self.textView.keyboardType = UIKeyboardTypeDecimalPad;
        self.textView.font = [UIFont fontWithName:@"Avenir-Light" size:22.0];
    } else if ([self.title isEqualToString:@"Description"]) {
        self.textView.keyboardType = UIKeyboardTypeDefault;
        self.textView.returnKeyType = UIReturnKeyDefault;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if([self.title isEqualToString:@"Title"] && [text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - Price and Discount Type Bars

- (void) positionBarsInPlace
{
    CGPoint barCenter = CGPointMake(self.view.center.x, self.view.frame.size.height - keyboardHeight - self.priceBar.frame.size.height/2);
    
    self.priceBar.center = barCenter;
    self.discountBar.center = barCenter;
}

- (void)showPriceBar
{
    self.priceBar.hidden = NO;
    self.priceBar.alpha = 0;
    
    if ([self.currency isEqualToString:@"$"]) {
        self.dollar.selected = YES;
    } else if ([self.currency isEqualToString:@"£"]) {
        self.pound.selected = YES;
    } else {
        self.shekel.selected = YES;
    }

    [UIView animateWithDuration:0.4 animations:^{self.priceBar.alpha = 1.0;}];
}

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

- (IBAction)shekelSelected:(id)sender {
    
    if (![self.currency isEqualToString:@"₪"]) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else if (![self.currency isEqualToString:@""] && [self.currentValue isEqualToString:self.textView.text]) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }

    self.shekel.selected = YES;
    self.dollar.selected = NO;
    self.pound.selected = NO;
}

- (IBAction)dollarSelected:(id)sender {
    
    if (![self.currency isEqualToString:@"$"]) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else if (![self.currency isEqualToString:@""] && [self.currentValue isEqualToString:self.textView.text]) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    self.shekel.selected = NO;
    self.dollar.selected = YES;
    self.pound.selected = NO;
}

- (IBAction)poundSelected:(id)sender {
    
    if (![self.currency isEqualToString:@"£"]) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else if (![self.currency isEqualToString:@""] && [self.currentValue isEqualToString:self.textView.text]) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    self.shekel.selected = NO;
    self.dollar.selected = NO;
    self.pound.selected = YES;
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

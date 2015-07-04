//
//  EditTextModeViewController.h
//  Dealers-testbeta
//
//  Created by Gilad Lumbroso on 8/3/14.
//
//

#import <UIKit/UIKit.h>
#import "EditDealTableViewController.h"
#import "MBProgressHUD.h"
#import "GAITrackedViewController.h"

@interface EditTextModeViewController : GAITrackedViewController <MBProgressHUDDelegate> {
    
    MBProgressHUD *blankTitleIndicator, *tooMuchIndicator;
}

@property NSString *currentValue;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property NSString *selectedCurrency;
@property (weak, nonatomic) IBOutlet UIView *priceBar;
@property (retain, nonatomic) UIButton *shekel;
@property (retain, nonatomic) UIButton *dollar;
@property (retain, nonatomic) UIButton *euro;
@property (retain, nonatomic) UIButton *pound;

@property NSString *discountType;
@property (weak, nonatomic) IBOutlet UIView *discountBar;
@property (weak, nonatomic) IBOutlet UIButton *percentage;
@property (weak, nonatomic) IBOutlet UIButton *lastPrice;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpacePriceBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpaceDiscountBar;


@end

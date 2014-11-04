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

@interface EditTextModeViewController : UIViewController <MBProgressHUDDelegate> {
    
    MBProgressHUD *blankTitleIndicator, *tooMuchIndicator;
}

@property NSString *currentValue;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property NSString *currency;
@property (weak, nonatomic) IBOutlet UIView *priceBar;
@property (weak, nonatomic) IBOutlet UIButton *shekel;
@property (weak, nonatomic) IBOutlet UIButton *dollar;
@property (weak, nonatomic) IBOutlet UIButton *pound;

@property NSString *discountType;
@property (weak, nonatomic) IBOutlet UIView *discountBar;
@property (weak, nonatomic) IBOutlet UIButton *percentage;
@property (weak, nonatomic) IBOutlet UIButton *lastPrice;

@end

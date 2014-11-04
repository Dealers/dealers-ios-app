//
//  WhatIsTheDeal2.h
//  Dealers
//
//  Created by Gilad Lumbroso on 10/2/14.
//
//

#import <UIKit/UIKit.h>
#import "ChooseCategoryTableViewController.h"
#import "ThankYouViewController.h"
#import "Deal.h"
#import "Dealer.h"
#import "Store.h"
#import "MBProgressHUD.h"

@interface WhatIsTheDeal2 : UITableViewController <UITextViewDelegate, UIActionSheetDelegate, UITextFieldDelegate, MBProgressHUDDelegate> {
    
    NSString *selectedCurrency, *selectedDiscountType;
    BOOL isFacebookSelectd;
    BOOL isWhatsAppSelected;
    UIColor *placeholder;
    
    MBProgressHUD *illogicalPercentage, *lastPriceWithoutPrice;
}

@property AppDelegate *appDelegate;

@property Deal *deal;

@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *discountTextField;

@property float priceValue;
@property float discountValue;

@property (retain, nonatomic) UIButton *shekel;
@property (retain, nonatomic) UIButton *dollar;
@property (retain, nonatomic) UIButton *pound;
@property (retain, nonatomic) UIButton *percentage;
@property (retain, nonatomic) UIButton *lastPrice;

@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@property (weak, nonatomic) IBOutlet UILabel *expirationDateLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITableViewCell *datePickerCell;
@property (nonatomic) NSDateFormatter *dateFormatter;
@property (nonatomic) NSDateFormatter *dateFormatterDataBase;
@property BOOL datePickerIsShowing;
@property BOOL didTouchDatePicker;
@property BOOL didCancelDate;

@property (weak, nonatomic) IBOutlet UIButton *facebookIcon;
@property (weak, nonatomic) IBOutlet UILabel *facebookLabel;
@property (weak, nonatomic) IBOutlet UIButton *whatsAppIcon;
@property (weak, nonatomic) IBOutlet UILabel *whatsAppLabel;

@property (weak, nonatomic) IBOutlet UIView *addDealView;

@property UIImage *sharedImage;


// The Description Field (obsolete)
@property (weak, nonatomic) IBOutlet UILabel *moreDescriptionPlaceholder;
@property (weak, nonatomic) IBOutlet UITextView *moreDescriptionTextView;

@end

//
//  WhatIsTheDeal1OnlineTableViewController.h
//  Dealers
//
//  Created by Gilad Lumbroso on 5/14/15.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "WhatIsTheDeal2.h"
#import "AddDealNavigationController.h"
#import "MBProgressHUD.h"
#import "ElasticLabel.h"
#import "OnlineImagePickerCollectionViewController.h"

@interface WhatIsTheDeal1Online : UITableViewController <UITextViewDelegate, MBProgressHUDDelegate> {
    
    CGFloat titleHeight, descriptionHeight;
    MBProgressHUD *blankTitleIndicator, *tooMuchIndicator;
}

@property AppDelegate *appDelegate;

@property Deal *deal;
@property Store *store;

@property (weak, nonatomic) IBOutlet UIView *addPhotoContainer;
@property (weak, nonatomic) IBOutlet UILabel *addPhotoLabel;
@property (weak, nonatomic) IBOutlet UIView *imageContainer;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *changeImage;

@property (weak, nonatomic) IBOutlet ElasticLabel *titlePlaceholder;
@property (weak, nonatomic) IBOutlet UITextView *dealTitle;
@property (nonatomic) UILabel *countLabel;
@property (nonatomic) UIView *countContainer;
@property BOOL tooMuchText;

@property (weak, nonatomic) IBOutlet ElasticLabel *descriptionPlaceholder;
@property (weak, nonatomic) IBOutlet UITextView *dealDescription;

@property (weak, nonatomic) IBOutlet UILabel *hintLabel;

@property WhatIsTheDeal2 *cashedInstance;

@property NSMutableArray *images;
@property NSMutableArray *photosFileName;
@property BOOL selectedImage;

- (void)insertImageInImageView:(UIImage *)image;
- (void)removeImageFromImageView;


@end

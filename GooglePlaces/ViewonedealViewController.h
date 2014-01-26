//
//  ViewonedealViewController.h
//  GooglePlaces
//
//  Created by itzik berrebi on 9/26/13.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ViewonedealViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    BOOL LikeOrUnlike;
}

@property (strong,nonatomic) NSString *titlefromseg;
@property (strong,nonatomic) NSString *storefromseg;
@property (strong,nonatomic) NSString *categoryfromseg;
@property (strong,nonatomic) NSString *pricefromseg;
@property (strong,nonatomic) NSString *discountfromseg;
@property (strong,nonatomic) NSString *expirefromseg;
@property (strong,nonatomic) NSString *descriptionfromseg;
@property (strong,nonatomic) NSString *photoidfromseg;
@property (strong,nonatomic) NSString *likefromseg;
@property (strong,nonatomic) NSString *commentfromseg;
@property (strong,nonatomic) NSString *clientfromseg;



@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UIImageView *productimage;
@property (weak, nonatomic) IBOutlet UIImageView *clientimage;
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UILabel *storelabel;
@property (weak, nonatomic) IBOutlet UILabel *categorylabel;
@property (weak, nonatomic) IBOutlet UILabel *pricelabel;
@property (weak, nonatomic) IBOutlet UILabel *discountlabel;
@property (weak, nonatomic) IBOutlet UILabel *expirelabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionlabel;
@property (weak, nonatomic) IBOutlet UILabel *likelabel;
@property (weak, nonatomic) IBOutlet UILabel *commentlabel;

- (IBAction)ReturnButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *ReturnButton;
@property (weak, nonatomic) IBOutlet UIButton *ReturnButtonFull;


- (IBAction)Adddeal:(id)sender;
- (IBAction)myfeedbutton:(id)sender;
- (IBAction)morebutton:(id)sender;
- (IBAction)profilebutton:(id)sender;
- (IBAction)explorebutton:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *BlueButtonsView;
@property (weak, nonatomic) IBOutlet UIButton *LocalButton;
@property (weak, nonatomic) IBOutlet UIButton *OnlineButton;
@property (weak, nonatomic) IBOutlet UIButton *LockTableButton;
@property (weak, nonatomic) IBOutlet UILabel *OnlineText;
@property (weak, nonatomic) IBOutlet UILabel *LocalText;
- (IBAction)LocalButtonAction:(id)sender;
- (IBAction)OnlineButtonAction:(id)sender;
- (IBAction)UNLockButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *TitleIcon;
@property (weak, nonatomic) IBOutlet UIImageView *StoreIcon;
@property (weak, nonatomic) IBOutlet UIImageView *CategoryIcon;
@property (weak, nonatomic) IBOutlet UIImageView *PriceIcon;
@property (weak, nonatomic) IBOutlet UIImageView *ExpireIcon;
@property (weak, nonatomic) IBOutlet UIImageView *DescriptionIcon;

@property (weak, nonatomic) IBOutlet UIView *SecondView;

@property (weak, nonatomic) IBOutlet UIButton *LikeButton;
- (IBAction)LikeButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *CommentButton;
- (IBAction)CommentButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *ShareButton;
- (IBAction)ShareButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *captureImage;
@property (weak, nonatomic) IBOutlet UIImageView *captureImage2;
@property (weak, nonatomic) IBOutlet UIImageView *captureImage3;
@property (weak, nonatomic) IBOutlet UIImageView *captureImage4;

@end

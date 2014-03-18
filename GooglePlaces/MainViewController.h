//
//  MainViewController.h
//  GooglePlaces
//
//  Created by itzik berrebi on 9/26/13.
//
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <UINavigationBarDelegate,UINavigationBarDelegate>
{
     float ScreenHeight;
}

@property (weak, nonatomic) IBOutlet UIImageView *dealershead;
@property (weak, nonatomic) IBOutlet UIImageView *backwhite;

@property (weak, nonatomic) IBOutlet UIImageView *bagimage;
@property (weak, nonatomic) IBOutlet UIButton *facebookicon;
@property (weak, nonatomic) IBOutlet UIButton *twittericon;
@property (weak, nonatomic) IBOutlet UIButton *emailicon;
@property (weak, nonatomic) NSString *i;

@property (weak, nonatomic) IBOutlet UILabel *already;
@property (weak, nonatomic) IBOutlet UILabel *signin;
@property (weak, nonatomic) IBOutlet UILabel *via;

- (IBAction)EmailimageButton:(id)sender;
- (IBAction)SigninButton:(id)sender;


@end

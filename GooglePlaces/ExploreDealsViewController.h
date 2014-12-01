//
//  ExploreDealsViewController.h
//  Dealers-testbeta
//
//  Created by itzik berrebi on 4/12/14.
//
//

#import <UIKit/UIKit.h>

@interface ExploreDealsViewController : UIViewController

{
    int GAP;
    int gap2;
    BOOL isShortCell;
    BOOL isUpdatingNow;
    int cellNumberInScrollView;
    int cellsNumbersInFillWithImages;
    BOOL myFeedsFirstTime;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic)  UIImage *image2;
@property (weak, nonatomic) IBOutlet UIImageView *loadingImage;

@property (nonatomic, strong) NSMutableArray *dealsArray;
@property (nonatomic, strong) NSMutableArray *dealPhotosArray;


@property (nonatomic, strong) NSString *dealerId;
@property (nonatomic, strong) NSString *categoryFromExplore;
@property (strong, nonatomic) NSString *dealsUserLikes;
@property (strong, nonatomic) NSString *vcTitle;


@end

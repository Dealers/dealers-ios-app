//
//  MyFeedsViewController.m
//  Dealers-testbeta
//
//  Created by itzik berrebi on 2/16/14.
//
//

#import "MyFeedsViewController.h"
#import "AppDelegate.h"
#import "ViewonedealViewController.h"
#import "MoreViewController.h"
#import "ProfileViewController.h"
#import "ExploretableViewController.h"
#import "TableViewController.h"
#import "OnlineViewController.h"
#define OFFSETSHORTCELL 109
#import <mach/mach.h>
#import "OptionalaftergoogleplaceViewController.h"

@interface MyFeedsViewController ()
@end

@implementation MyFeedsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{/*
  NSLog(@"MEMORY");
  NSArray *viewsToRemove = [self.scrollView subviews];
  for (UIView *v in viewsToRemove) {
  [v removeFromSuperview];
  }
  [super didReceiveMemoryWarning];
  AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
  app.AfterAddDeal=@"yes";
  [self viewDidAppear:YES];*/
}

-(void) removeCellsFromSuperview {
    NSArray *viewsToRemove = [self.scrollView subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
}

-(void) loadDataFromDB {
    
    self.TITLEMARRAY=nil;
    self.DESCRIPTIONMARRAY =nil;
    self.STOREMARRAY=nil;
    self.PRICEMARRAY=nil;
    self.DISCOUNTMARRAY=nil;
    self.EXPIREMARRAY=nil;
    self.LIKEMARRAY=nil;
    self.COMMENTMARRAY=nil;
    self.CLIENTMARRAY=nil;
    self.PHOTOIDMARRAY=nil;
    self.CATEGORYARRAY=nil;
    self.SIGNARRAY=nil;
    self.DEALIDARRAY=nil;
    self.USERSIDSARRAY=nil;
    
    
    NSArray *types = [[NSArray alloc] initWithObjects:@"TITLE",@"DESCRIPTION",@"STORE",@"PRICE",@"DISCOUNT",@"EXPIRE",@"LIKEBUTTON",@"COMMENT",@"CLIENTID",@"PHOTOID",@"CATEGORY",@"SIGN",@"DEALID",@"USERSIDS", nil];
    
    NSString *FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/getphpFile.php?var=%@",[types objectAtIndex:0]];
    NSData *URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    NSString *DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    NSArray *DataArray = [DataResult componentsSeparatedByString:@"///"];
    NSArray *reversed = [[DataArray reverseObjectEnumerator] allObjects];
    NSMutableArray *TITLEMARRAY_temp = [[NSMutableArray alloc] initWithArray:reversed];
    
    FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/getphpFile.php?var=%@",[types objectAtIndex:1]];
    URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    DataArray = [DataResult componentsSeparatedByString:@"///"];
    reversed = [[DataArray reverseObjectEnumerator] allObjects];
    NSMutableArray *DESCRIPTIONMARRAY_temp = [[NSMutableArray alloc] initWithArray:reversed];
    
    FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/getphpFile.php?var=%@",[types objectAtIndex:2]];
    URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    DataArray = [DataResult componentsSeparatedByString:@"///"];
    reversed = [[DataArray reverseObjectEnumerator] allObjects];
    NSMutableArray *STOREMARRAY_temp = [[NSMutableArray alloc] initWithArray:reversed];
    
    FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/getphpFile.php?var=%@",[types objectAtIndex:3]];
    URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    DataArray = [DataResult componentsSeparatedByString:@"///"];
    reversed = [[DataArray reverseObjectEnumerator] allObjects];
    NSMutableArray *PRICEMARRAY_temp = [[NSMutableArray alloc] initWithArray:reversed];
    
    FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/getphpFile.php?var=%@",[types objectAtIndex:4]];
    URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    DataArray = [DataResult componentsSeparatedByString:@"///"];
    reversed = [[DataArray reverseObjectEnumerator] allObjects];
    NSMutableArray *DISCOUNTMARRAY_temp = [[NSMutableArray alloc] initWithArray:reversed];
    
    FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/getphpFile.php?var=%@",[types objectAtIndex:5]];
    URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    DataArray = [DataResult componentsSeparatedByString:@"///"];
    reversed = [[DataArray reverseObjectEnumerator] allObjects];
    NSMutableArray *EXPIREMARRAY_temp = [[NSMutableArray alloc] initWithArray:reversed];
    
    FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/getphpFile.php?var=%@",[types objectAtIndex:6]];
    URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    DataArray = [DataResult componentsSeparatedByString:@"///"];
    reversed = [[DataArray reverseObjectEnumerator] allObjects];
    NSMutableArray *LIKEMARRAY_temp = [[NSMutableArray alloc] initWithArray:reversed];
    
    FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/getphpFile.php?var=%@",[types objectAtIndex:7]];
    URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    DataArray = [DataResult componentsSeparatedByString:@"///"];
    reversed = [[DataArray reverseObjectEnumerator] allObjects];
    NSMutableArray *COMMENTMARRAY_temp = [[NSMutableArray alloc] initWithArray:reversed];
    
    FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/getphpFile.php?var=%@",[types objectAtIndex:8]];
    URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    DataArray = [DataResult componentsSeparatedByString:@"///"];
    reversed = [[DataArray reverseObjectEnumerator] allObjects];
    NSMutableArray *CLIENTMARRAY_temp = [[NSMutableArray alloc] initWithArray:reversed];
    
    FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/getphpFile.php?var=%@",[types objectAtIndex:9]];
    URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    DataArray = [DataResult componentsSeparatedByString:@"///"];
    reversed = [[DataArray reverseObjectEnumerator] allObjects];
    NSMutableArray *PHOTOIDMARRAY_temp = [[NSMutableArray alloc] initWithArray:reversed];
    
    FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/getphpFile.php?var=%@",[types objectAtIndex:10]];
    URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    DataArray = [DataResult componentsSeparatedByString:@"///"];
    reversed = [[DataArray reverseObjectEnumerator] allObjects];
    NSMutableArray *CATEGORYARRAY_temp = [[NSMutableArray alloc] initWithArray:reversed];
    
    FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/getphpFile.php?var=%@",[types objectAtIndex:11]];
    URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    DataArray = [DataResult componentsSeparatedByString:@"///"];
    reversed = [[DataArray reverseObjectEnumerator] allObjects];
    NSMutableArray *SIGNARRAY_temp = [[NSMutableArray alloc] initWithArray:reversed];
    
    FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/getphpFile.php?var=%@",[types objectAtIndex:12]];
    URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    DataArray = [DataResult componentsSeparatedByString:@"///"];
    reversed = [[DataArray reverseObjectEnumerator] allObjects];
    NSMutableArray *DEALIDARRAY_temp = [[NSMutableArray alloc] initWithArray:reversed];
    
    FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/getphpFile.php?var=%@",[types objectAtIndex:13]];
    URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    DataArray = [DataResult componentsSeparatedByString:@"///"];
    reversed = [[DataArray reverseObjectEnumerator] allObjects];
    NSMutableArray *USERSIDSARRAY_temp = [[NSMutableArray alloc] initWithArray:reversed];
    
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    app.AfterAddDeal=@"aftersign";
    
    for (int i=0; i<[[TITLEMARRAY_temp copy] count]; i++) {
        NSString *title=[TITLEMARRAY_temp objectAtIndex:i];
        title = [title stringByReplacingOccurrencesOfString:@"q9j" withString:@"&"];
        title = [title stringByReplacingOccurrencesOfString:@"q8j" withString:@"'"];
        [TITLEMARRAY_temp replaceObjectAtIndex:i withObject:title];
    }
    for (int i=0; i<[[STOREMARRAY_temp copy] count]; i++) {
        NSString *store=[STOREMARRAY_temp objectAtIndex:i];
        store = [store stringByReplacingOccurrencesOfString:@"q9j" withString:@"&"];
        store = [store stringByReplacingOccurrencesOfString:@"q8j" withString:@"'"];
        [STOREMARRAY_temp replaceObjectAtIndex:i withObject:store];
    }
    for (int i=0; i<[[DESCRIPTIONMARRAY_temp copy] count]; i++) {
        NSString *description=[DESCRIPTIONMARRAY_temp objectAtIndex:i];
        description = [description stringByReplacingOccurrencesOfString:@"q9j" withString:@"&"];
        description = [description stringByReplacingOccurrencesOfString:@"q8j" withString:@"'"];
        [DESCRIPTIONMARRAY_temp replaceObjectAtIndex:i withObject:description];
    }
    for (int i=0; i<[[CATEGORYARRAY_temp copy] count]; i++) {
        NSString *category=[CATEGORYARRAY_temp objectAtIndex:i];
        category = [category stringByReplacingOccurrencesOfString:@"q9j" withString:@" & "];
        [CATEGORYARRAY_temp replaceObjectAtIndex:i withObject:category];
    }
    
    
    self.TITLEMARRAY = [NSMutableArray arrayWithArray:TITLEMARRAY_temp];
    self.DESCRIPTIONMARRAY = [NSMutableArray arrayWithArray:DESCRIPTIONMARRAY_temp];
    self.STOREMARRAY = [NSMutableArray arrayWithArray:STOREMARRAY_temp];
    self.PRICEMARRAY = [NSMutableArray arrayWithArray:PRICEMARRAY_temp];
    self.DISCOUNTMARRAY = [NSMutableArray arrayWithArray:DISCOUNTMARRAY_temp];
    self.EXPIREMARRAY = [NSMutableArray arrayWithArray:EXPIREMARRAY_temp];
    self.LIKEMARRAY = [NSMutableArray arrayWithArray:LIKEMARRAY_temp];
    self.COMMENTMARRAY = [NSMutableArray arrayWithArray:COMMENTMARRAY_temp];
    self.CLIENTMARRAY = [NSMutableArray arrayWithArray:CLIENTMARRAY_temp];
    self.PHOTOIDMARRAY = [NSMutableArray arrayWithArray:PHOTOIDMARRAY_temp];
    self.CATEGORYARRAY = [NSMutableArray arrayWithArray:CATEGORYARRAY_temp];
    self.SIGNARRAY = [NSMutableArray arrayWithArray:SIGNARRAY_temp];
    self.DEALIDARRAY = [NSMutableArray arrayWithArray:DEALIDARRAY_temp];
    self.USERSIDSARRAY = [NSMutableArray arrayWithArray:USERSIDSARRAY_temp];
    
    
}

-(void) dbError {
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"oops!" message:@"DB ERROR" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [alert show];
}

-(void) hiddenWhiteCoverView {
    [UIView animateWithDuration:0.5 animations:^{self.whiteCoverView.alpha=0.0;}];
    [self.LoadingImage stopAnimating];
    //[self report_memory];
}

-(void) startLoadingUploadIcon {
    
    self.LoadingImage.animationImages = [NSArray arrayWithObjects:
                                         [UIImage imageNamed:@"loading.png"],
                                         [UIImage imageNamed:@"loading5.png"],
                                         [UIImage imageNamed:@"loading10.png"],
                                         [UIImage imageNamed:@"loading15.png"],
                                         [UIImage imageNamed:@"loading20.png"],
                                         [UIImage imageNamed:@"loading25.png"],
                                         [UIImage imageNamed:@"loading30.png"],
                                         [UIImage imageNamed:@"loading35.png"],
                                         [UIImage imageNamed:@"loading40.png"],
                                         [UIImage imageNamed:@"loading45.png"],
                                         [UIImage imageNamed:@"loading50.png"],
                                         [UIImage imageNamed:@"loading55.png"],
                                         [UIImage imageNamed:@"loading60.png"],
                                         [UIImage imageNamed:@"loading65.png"],
                                         [UIImage imageNamed:@"loading70.png"],
                                         [UIImage imageNamed:@"loading75.png"],
                                         [UIImage imageNamed:@"loading80.png"],
                                         [UIImage imageNamed:@"loading85.png"],
                                         nil];
    self.LoadingImage.animationDuration = 0.3;
    [self.LoadingImage startAnimating];
    [UIView animateWithDuration:0.2 animations:^{self.LoadingImage.alpha=1.0; self.LoadingImage.transform =CGAffineTransformMakeScale(0,0);
        self.LoadingImage.transform =CGAffineTransformMakeScale(1,1);}];
    
    
}

-(void) createDealsTable {
    
    self.AddDealButton.enabled=NO;
    self.ProfileButton.enabled=NO;
    self.ExploreButton.enabled=NO;
    
    isUpdatingNow = YES;
    for (int i=cellNumberInScrollView; ((i<5+cellNumberInScrollView) && (i<[[self.TITLEMARRAY copy] count])); i++) {
        NSString *num=[self.PHOTOIDMARRAY objectAtIndex:i];
        
        if ([num isEqualToString:@"0"]) {
            isShortCell = YES;
        } else isShortCell = NO;
        
        UIImageView *imageview;
        if (isShortCell) {
            imageview=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal - New Version_No Pic Deal background & Shadow.png"]];
        } else imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal (final)_Deal background & Shadow.png"]];
        
        [imageview setFrame:CGRectMake(2.5, 4+(GAP), 315, 199-(OFFSETSHORTCELL*isShortCell))];
		[[self scrollView] addSubview:imageview];
        
        UIImageView *imageview4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal (final)_Local icon.png"]];
        [imageview4 setFrame:CGRectMake(18, 170+(GAP)-(OFFSETSHORTCELL*isShortCell), 13, 16)];
        [[self scrollView] addSubview:imageview4];
        
        UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(35, 167+(GAP)-(OFFSETSHORTCELL*isShortCell), 175, 24)];
        [label2 setFont:[UIFont fontWithName:@"Avenir-Light" size:12.0]];
        label2.text=[self.STOREMARRAY objectAtIndex:i];
        label2.backgroundColor=[UIColor clearColor];
        label2.textColor = [UIColor colorWithRed:(160/255.0) green:(160/255.0) blue:(165/255.0) alpha:1.0];
        [[self scrollView] addSubview:label2];
        
        UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(197, 169+(GAP)-(OFFSETSHORTCELL*isShortCell), 53, 21)];
        [label3 setFont:[UIFont fontWithName:@"Avenir-Light" size:17.0]];
        label3.text=[self.PRICEMARRAY objectAtIndex:i];
        label3.backgroundColor=[UIColor clearColor];
        label3.textColor = [UIColor blackColor];
        [label3 sizeToFit];
        [[self scrollView] addSubview:label3];
        
        UILabel *label4=[[UILabel alloc]initWithFrame:CGRectMake(247, 169+(GAP)-(OFFSETSHORTCELL*isShortCell), 53, 21)];
        [label4 setFont:[UIFont fontWithName:@"Avenir-Light" size:17.0]];
        label4.text=[self.DISCOUNTMARRAY objectAtIndex:i];
        label4.backgroundColor=[UIColor clearColor];
        label4.textColor = [UIColor colorWithRed:(255/255.0) green:(59/255.0) blue:(48/255.0) alpha:1.0];
        [label4 sizeToFit];
        [[self scrollView] addSubview:label4];
        
		GAP=CGRectGetMaxY(imageview.frame)-4;
	}
    cellNumberInScrollView+=5;
    [[self scrollView] setContentSize:CGSizeMake(319,GAP)];
    isUpdatingNow = NO;
    self.AddDealButton.enabled=YES;
    self.ProfileButton.enabled=YES;
    self.ExploreButton.enabled=YES;
    [self hiddenWhiteCoverView];
}

-(void) fillTheCellsWithImages {
    isUpdatingNow = YES;
    
    dispatch_queue_t queue = dispatch_queue_create("com.MyQueue", NULL);
    dispatch_async(queue, ^{
        // Do some computation here.
        for (int i=cellsNumbersInFillWithImages; ((i<cellNumberInScrollView) && (i<[[self.TITLEMARRAY copy] count])); i++) {
            NSString *num=[self.PHOTOIDMARRAY objectAtIndex:i];
            NSString *URLforphoto = [NSString stringWithFormat:@"http://www.dealers.co.il/%@.jpg",num];
            
            if (([num isEqualToString:@"0"])||(num==nil)||([num length]==0)) {
                [_PHOTOIDMARRAYCONVERT addObject:@"0"];
                NSLog(@"no image");
            } else{
                NSLog(@"image number %d",[num length]);
                _image2=[[UIImage alloc]init];
                _image2 =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:URLforphoto]]];
                [_PHOTOIDMARRAYCONVERT addObject:_image2];
            }
        }
        // Update UI after computation.
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI on the main thread.
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"return to main thread!" message:@"" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];
            
            for (int i=cellsNumbersInFillWithImages; ((i<cellNumberInScrollView) && (i<[[self.TITLEMARRAY copy] count])); i++) {
                NSString *num=[self.PHOTOIDMARRAY objectAtIndex:i];
                if ([num isEqualToString:@"0"]||([num length]==0)) {
                    isShortCell = YES;
                } else isShortCell = NO;
                
                UIImageView *imageview;
                if (isShortCell) {
                    imageview=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal - New Version_No Pic Deal background & Shadow.png"]];
                } else imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal (final)_Deal background & Shadow.png"]];
                [imageview setFrame:CGRectMake(2.5, 4+(gap2), 315, 199-(OFFSETSHORTCELL*isShortCell))];
                
                UIImageView *imageview2 = [[UIImageView alloc]init];
                if (isShortCell) {
                } else {
                    NSLog(@"%@",[_PHOTOIDMARRAYCONVERT objectAtIndex:i-1]);
                    imageview2.image=[_PHOTOIDMARRAYCONVERT objectAtIndex:i-1];
                    [imageview2 setFrame:CGRectMake(10, 10+(gap2), 300, 155)];
                    NSLog(@"download succsses with = %@",imageview2);
                    CALayer *mask = [CALayer layer];
                    mask.contents=(id)[[UIImage imageNamed:@"My Feed+View Deal (final)_Deal Pic mask.png"]CGImage];
                    mask.frame = CGRectMake(0, 0, 300, 155);
                    imageview2.layer.mask = mask;
                    imageview2.layer.masksToBounds = YES;
                    imageview2.tag=i;
                    if (!isShortCell) [[self scrollView] addSubview:imageview2];
                }
                UIImageView *imageview3;
                if (isShortCell) {
                    imageview3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal - New Version_No Pic Deal Dark background.png"]];
                    [imageview3 setFrame:CGRectMake(10, 6+(gap2), 300, 48)];
                    
                } else { imageview3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal (final)_Title & Store shade.png"]];
                    [imageview3 setFrame:CGRectMake(10, 87+(gap2)-(OFFSETSHORTCELL*isShortCell), 300, 78)];
                }
                [[self scrollView] addSubview:imageview3];
                
                UIImageView *imageview5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal (final)_Likes icon.png"]];
                [imageview5 setFrame:CGRectMake(274, 124+(gap2)-(OFFSETSHORTCELL*isShortCell), 13, 12)];
                [[self scrollView] addSubview:imageview5];
                
                UIImageView *imageview6 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal (final)_Comments icon.png"]];
                [imageview6 setFrame:CGRectMake(274, 143+(gap2)-(OFFSETSHORTCELL*isShortCell), 12, 14)];
                [[self scrollView] addSubview:imageview6];
                
                
                UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(18, 119+(gap2)-(OFFSETSHORTCELL*isShortCell), 249, 41)];
                [label setFont:[UIFont fontWithName:@"Avenir-Light" size:14.0]];
                label.text=[self.TITLEMARRAY objectAtIndex:i];
                label.backgroundColor=[UIColor clearColor];
                label.textColor = [UIColor whiteColor];
                label.numberOfLines=2;
                [[self scrollView] addSubview:label];
                
                UILabel *label5=[[UILabel alloc]initWithFrame:CGRectMake(290, 119+(gap2)-(OFFSETSHORTCELL*isShortCell), 21, 21)];
                [label5 setFont:[UIFont fontWithName:@"Avenir-Medium" size:13.0]];
                label5.text=[self.LIKEMARRAY objectAtIndex:i];
                label5.backgroundColor=[UIColor clearColor];
                label5.textColor = [UIColor whiteColor];
                [label5 sizeToFit];
                [[self scrollView] addSubview:label5];
                
                UILabel *label6=[[UILabel alloc]initWithFrame:CGRectMake(290, 139+(gap2)-(OFFSETSHORTCELL*isShortCell), 21, 21)];
                [label6 setFont:[UIFont fontWithName:@"Avenir-Medium" size:13.0]];
                label6.text=[self.COMMENTMARRAY objectAtIndex:i];
                label6.backgroundColor=[UIColor clearColor];
                label6.textColor = [UIColor whiteColor];
                [label6 sizeToFit];
                [[self scrollView] addSubview:label6];
                
                UIButton *selectDealButton=[UIButton buttonWithType:UIButtonTypeCustom];
                [selectDealButton setTitle:@"" forState:UIControlStateNormal];
                selectDealButton.frame=CGRectMake(0, 4+(gap2), 319, 193-(OFFSETSHORTCELL*isShortCell));//193
                selectDealButton.tag=i;
                [selectDealButton addTarget:self action:@selector(selectDealButtonClicked:) forControlEvents: UIControlEventTouchUpInside];
                [[self scrollView] addSubview:selectDealButton];
                gap2=CGRectGetMaxY(imageview.frame)-4;
            }
            cellsNumbersInFillWithImages+=5;
            isUpdatingNow = NO;

        });
    });

}

-(void) selectDealButtonClicked:(id)sender {
    ViewonedealViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"viewdeal"];
    UIButton *button = (UIButton *)sender;
    controller.titleLabelFromMyFeeds = [self.TITLEMARRAY objectAtIndex:(button.tag)];
    controller.storeLabelFromMyFeeds = [self.STOREMARRAY objectAtIndex:(button.tag)];
    controller.categoryLabelFromMyFeeds = [self.CATEGORYARRAY objectAtIndex:(button.tag)];
    controller.priceLabelFromMyFeeds = [self.PRICEMARRAY objectAtIndex:(button.tag)];
    controller.discountLabelFromMyFeeds = [self.DISCOUNTMARRAY objectAtIndex:(button.tag)];
    controller.expireLabelFromMyFeeds = [self.EXPIREMARRAY objectAtIndex:(button.tag)];
    controller.descriptionLabelFromMyFeeds = [self.DESCRIPTIONMARRAY objectAtIndex:(button.tag)];
    controller.likeLabelFromMyFeeds = [self.LIKEMARRAY objectAtIndex:(button.tag)];
    controller.commentLabelFromMyFeeds = [self.COMMENTMARRAY objectAtIndex:(button.tag)];
    controller.signLabelFromMyFeeds = [self.SIGNARRAY objectAtIndex:(button.tag)];
    controller.photoIdLabelFromMyFeeds = [self.PHOTOIDMARRAY objectAtIndex:(button.tag)];
    controller.dealidLabelFromMyFeeds = [self.DEALIDARRAY objectAtIndex:(button.tag)];
    
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSString *FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/setLikeToDeal.php?Userid=%@&Indicator=%@",app.UserID,@"whatdealstheuserlikes"];
    NSData *URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    NSString *DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    _dealsUserLikes=DataResult;
    
    NSLog(@"in myfeeds the dealid is: %@ and the deals that user likes is: %@",[self.DEALIDARRAY objectAtIndex:(button.tag)],_dealsUserLikes);
    
    if ([_dealsUserLikes rangeOfString:[self.DEALIDARRAY objectAtIndex:(button.tag)]].location == NSNotFound) {
        controller.likeornotLabelFromMyFeeds=@"no";
        NSLog(@"didnt find");
    } else {
        controller.likeornotLabelFromMyFeeds=@"yes";
    }
    
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)initializeView {
    NSMutableArray *allViewControllers2 = [NSMutableArray arrayWithArray: self.navigationController.viewControllers];
    [self.navigationController setViewControllers:allViewControllers2];
    self.onlineOrLocalView.alpha=0.0;
    self.denyClickingOnCellsButton.alpha=0.0;
    self.whiteCoverView.alpha=1.0;
    [[self scrollView] setBackgroundColor:[UIColor colorWithRed:(230/255.0) green:(230/255.0) blue:(230/255.0) alpha:1.0]];
    [[self scrollView]setScrollEnabled:YES];
    self.scrollView.delegate=self;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    isShortCell=NO;
    isUpdatingNow=NO;
    cellNumberInScrollView=1;
    cellsNumbersInFillWithImages=1;
    GAP=0;
    gap2=0;
	[self orderInPositionTapBarIcons];
    myFeedsFirstTime = YES;
}

-(void) allocArrays {
    self.TITLEMARRAY = [[NSMutableArray alloc]init];
    self.DESCRIPTIONMARRAY = [[NSMutableArray alloc]init];
    self.STOREMARRAY = [[NSMutableArray alloc]init];
    self.PRICEMARRAY = [[NSMutableArray alloc]init];
    self.DISCOUNTMARRAY = [[NSMutableArray alloc]init];
    self.EXPIREMARRAY =  [[NSMutableArray alloc]init];
    self.LIKEMARRAY = [[NSMutableArray alloc]init];
    self.COMMENTMARRAY = [[NSMutableArray alloc]init];
    self.CLIENTMARRAY =  [[NSMutableArray alloc]init];
    self.PHOTOIDMARRAY = [[NSMutableArray alloc]init];
    _PHOTOIDMARRAYCONVERT = [[NSMutableArray alloc]init];
    self.CATEGORYARRAY = [[NSMutableArray alloc]init];
    self.SIGNARRAY =  [[NSMutableArray alloc]init];
    self.DEALIDARRAY = [[NSMutableArray alloc]init];
    self.USERSIDSARRAY = [[NSMutableArray alloc]init];
}

-(void) setRefreshControl {
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor=[UIColor colorWithRed:150/255.0f green:0/255.0f blue:180/255.0f alpha:1.0];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [[self scrollView] addSubview:refreshControl];
}

-(void) didReachFromRegisterOrAddDeal {
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    if ([app.AfterAddDeal isEqualToString:@"aftersign"]) {
        app.AfterAddDeal = @"no";
        NSArray *viewsToRemove = [self.scrollView subviews];
        for (UIView *v in viewsToRemove) {
            [v removeFromSuperview];
        }
        
        [self createDealsTable];
        [self fillTheCellsWithImages];
    }
    
    if ([app.AfterAddDeal isEqualToString:@"yes"]) {
        app.AfterAddDeal = @"no";
        NSArray *viewsToRemove = [self.scrollView subviews];
        for (UIView *v in viewsToRemove) {
            [v removeFromSuperview];
        }
        
        [self createDealsTable];
        [self fillTheCellsWithImages];
    }
    
    if ([app.AfterAddDeal isEqualToString:@"aftertapbar"]) {
    }
}

-(void)viewDidAppear:(BOOL)animated {
    
    [self deallocPrevViewControllers];
    
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    if ([app.AfterAddDeal isEqualToString:@"yes"]) {
        app.AfterAddDeal = @"no";
        [self startLoadingUploadIcon];
        [self initializeView];
        static NSCache *_cache = nil;
        [_cache removeAllObjects];
        [self removeCellsFromSuperview];
        dispatch_queue_t queue = dispatch_queue_create("com.MyQueue", NULL);
        dispatch_async(queue, ^{
            // Do some computation here.
            [self loadDataFromDB];
            // Update UI after computation.
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI on the main thread.
                [self didReachFromRegisterOrAddDeal];
            });
        });
        
    }
}

-(void) deallocPrevViewControllers {
    
    if (myFeedsFirstTime) {
        NSArray *viewControllers = self.navigationController.viewControllers;
        id previousController = [viewControllers objectAtIndex:0];
        if ([previousController respondsToSelector:@selector(deallocMemory)])
            [previousController deallocMemory];
        previousController = [viewControllers objectAtIndex:1];
        if ([previousController respondsToSelector:@selector(deallocMemory)])
            [previousController deallocMemory];
        myFeedsFirstTime=NO;
    }
}
- (void)viewDidLoad {
    [self initializeView];
    [self allocArrays];
    //[self setRefreshControl];
    [self startLoadingUploadIcon];
    [self removeCellsFromSuperview];
    dispatch_queue_t queue = dispatch_queue_create("com.MyQueue", NULL);
    dispatch_async(queue, ^{
        // Do some computation here.
        [self loadDataFromDB];
        // Update UI after computation.
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI on the main thread.
            NSLog(@"creating cells");
            [self didReachFromRegisterOrAddDeal];
        });
    });
    [super viewDidLoad];
}

-(void)scrollViewDidScroll: (UIScrollView*)scrollView{
    int scrollOffset = scrollView.contentOffset.y + 300;
    if ((GAP - scrollOffset) < 50) {
        if (!isUpdatingNow) {
            isUpdatingNow = YES;
            [self createDealsTable];
            [self fillTheCellsWithImages];
        }
    }
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    //[self performSelectorInBackground:@selector(backGroundMethod) withObject:nil];
    //[refreshControl endRefreshing];
}

-(NSString *) convetCurrency: (NSString *) currencyToConvert {
    if ([currencyToConvert isEqualToString:@"1"]) {
        currencyToConvert=@"₪";
    }
    if ([currencyToConvert isEqualToString:@"2"]) {
        currencyToConvert=@"$";
    }
    if ([currencyToConvert isEqualToString:@"3"]) {
        currencyToConvert=@"£";
    }
	return currencyToConvert;
}

-(IBAction)addDealButtonClicked:(id)sender {
    self.denyClickingOnCellsButton.alpha=1.0;
    self.denyClickingOnCellsButton.backgroundColor = [UIColor colorWithRed:230 green:230 blue:230 alpha:0.5];
    [UIView animateWithDuration:0.5 animations:^{self.onlineOrLocalView.alpha=1.0;}];
}

-(IBAction)denyClickingOnCellsButtonClicked:(id)sender{
    [UIView animateWithDuration:0.5 animations:^{self.denyClickingOnCellsButton.alpha=0.0;}];
    [UIView animateWithDuration:0.5 animations:^{self.onlineOrLocalView.alpha=0.0;}];
}

-(void) orderInPositionTapBarIcons {
    float tapBarHeight = self.view.frame.size.height - self.TapBar.bounds.size.height/2;
    float iconHeight = self.view.frame.size.height - self.TapBar.bounds.size.height/2-5;
    float textHeight = self.view.frame.size.height - 7.5;
    
    [UIView animateWithDuration:0.5 animations:^{self.DealersTitle.alpha=1.0;}];
    [UIView animateWithDuration:0.5 animations:^{self.TapBar.center = CGPointMake(160, (tapBarHeight));}];
    [UIView animateWithDuration:0.5 animations:^{self.moreImage.center = CGPointMake(290, iconHeight);}];
    [UIView animateWithDuration:0.5 animations:^{self.MoreButton.center = CGPointMake(290, iconHeight);}];
    [UIView animateWithDuration:0.5 animations:^{self.MoreText.center = CGPointMake(290, textHeight);}];
    [UIView animateWithDuration:0.5 animations:^{self.profileImage.center = CGPointMake(232, iconHeight);}];
    [UIView animateWithDuration:0.5 animations:^{self.ProfileButton.center = CGPointMake(232, iconHeight);}];
    [UIView animateWithDuration:0.5 animations:^{self.ProfileText.center = CGPointMake(232, textHeight);}];
    [UIView animateWithDuration:0.5 animations:^{self.AddDealButton.center = CGPointMake(160, tapBarHeight);}];
    [UIView animateWithDuration:0.5 animations:^{self.ExploreButton.center = CGPointMake(88, iconHeight);}];
    [UIView animateWithDuration:0.5 animations:^{self.exploreImage.center = CGPointMake(88, iconHeight);}];
    [UIView animateWithDuration:0.5 animations:^{self.ExploreText.center = CGPointMake(88, textHeight);}];
    [UIView animateWithDuration:0.5 animations:^{self.MyFeedButton.center = CGPointMake(33, iconHeight);}];
    [UIView animateWithDuration:0.5 animations:^{self.myfeedsImage.center = CGPointMake(33, iconHeight);}];
    [UIView animateWithDuration:0.5 animations:^{self.MyFeedText.center = CGPointMake(33, textHeight);}];
}

-(void) goToAddDeal {
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    app.previousViewControllerAddDeal=@"foursquare";
    TableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TableView"];
    [self.navigationController pushViewController:controller animated:NO];
}

-(void) goToOnline {
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    app.previousViewControllerAddDeal=@"online";
    OnlineViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"OnlineView"];
    [self.navigationController pushViewController:controller animated:NO];
}

-(IBAction)morebutton:(id)sender{
    MoreViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"more"];
    [self.navigationController pushViewController:controller animated:NO];
}

-(IBAction)profilebutton:(id)sender{
    ProfileViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"profile"];
    [self.navigationController pushViewController:controller animated:NO];
    
}

-(IBAction)explorebutton:(id)sender{
    ExploretableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"explore"];
    [self.navigationController pushViewController:controller animated:NO];
    
    
}

-(void)hideTapBarAndNavigationBarAndScrollView {
    [UIView animateWithDuration:0.5 animations:^{self.DealersTitle.alpha=0.0;}];
    [UIView animateWithDuration:0.5 animations:^{self.TapBar.center = CGPointMake(160, 2500);}];
    [UIView animateWithDuration:0.5 animations:^{self.MoreButton.center = CGPointMake(290, 2500);}];
    [UIView animateWithDuration:0.5 animations:^{self.MoreText.center = CGPointMake(290, 2500);}];
    [UIView animateWithDuration:0.5 animations:^{self.moreImage.center = CGPointMake(290, 2500);}];
    [UIView animateWithDuration:0.5 animations:^{self.ProfileButton.center = CGPointMake(232, 2500);}];
    [UIView animateWithDuration:0.5 animations:^{self.ProfileText.center = CGPointMake(232, 2500);}];
    [UIView animateWithDuration:0.5 animations:^{self.profileImage.center = CGPointMake(232, 2500);}];
    [UIView animateWithDuration:0.5 animations:^{self.AddDealButton.center = CGPointMake(160, 2500);}];
    [UIView animateWithDuration:0.5 animations:^{self.ExploreButton.center = CGPointMake(88, 2500);}];
    [UIView animateWithDuration:0.5 animations:^{self.ExploreText.center = CGPointMake(88, 2500);}];
    [UIView animateWithDuration:0.5 animations:^{self.exploreImage.center = CGPointMake(88, 2500);}];
    [UIView animateWithDuration:0.5 animations:^{self.MyFeedButton.center = CGPointMake(30, 2500);}];
    [UIView animateWithDuration:0.5 animations:^{self.MyFeedText.center = CGPointMake(30, 2500);}];
    [UIView animateWithDuration:0.5 animations:^{self.myfeedsImage.center = CGPointMake(30, 2500);}];
    [UIView animateWithDuration:0.5 animations:^{self.onlineOrLocalView.alpha=0.0;}];
    [UIView animateWithDuration:0.5 animations:^{self.whiteCoverView.alpha=1.0;}];
    
    
}

-(void) hideOnlineLocalView {
    [UIView animateWithDuration:0.5 animations:^{self.onlineOrLocalView.alpha=0.0;}];
    [UIView animateWithDuration:0.5 animations:^{self.whiteCoverView.alpha=0.0;}];
    [UIView animateWithDuration:0.5 animations:^{self.denyClickingOnCellsButton.alpha=0.0;}];
    
}
-(void)localButtonClicked:(id)sender{
	[self hideTapBarAndNavigationBarAndScrollView];
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(goToAddDeal) userInfo:nil repeats:NO];
}

-(void)onlineButtonClicked:(id)sender{
	[self hideTapBarAndNavigationBarAndScrollView];
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(goToOnline) userInfo:nil repeats:NO];
}

-(void)viewDidDisappear:(BOOL)animated {
    sleep(1);
    self.onlineOrLocalView.alpha=0.0;
    self.denyClickingOnCellsButton.alpha=0.0;
    self.whiteCoverView.alpha=0.0;
   	[self orderInPositionTapBarIcons];
}

-(void) report_memory {
    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;
    
    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);
    
    vm_statistics_data_t vm_stat;
    
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS)
        NSLog(@"Failed to fetch vm statistics");
    
    /* Stats in bytes */
    natural_t mem_used = (vm_stat.active_count +
                          vm_stat.inactive_count +
                          vm_stat.wire_count) * pagesize;
    natural_t mem_free = vm_stat.free_count * pagesize;
    natural_t mem_total = mem_used + mem_free;
    NSLog(@"used: %u free: %u total: %u", mem_used/1000000, mem_free/1000000, mem_total/1000000);
}

@end


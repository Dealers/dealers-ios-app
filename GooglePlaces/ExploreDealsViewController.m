//
//  ExploreDealsViewController.m
//  Dealers-testbeta
//
//  Created by itzik berrebi on 4/12/14.
//
//

#import "ExploreDealsViewController.h"
#import "ProfileViewController.h"
#import "ViewonedealViewController.h"
#import "MoreViewController.h"
#import "ExploretableViewController.h"
#import "AppDelegate.h"
#import "TableViewController.h"
#define OFFSETSHORTCELL 109

@interface ExploreDealsViewController ()

@end

@implementation ExploreDealsViewController

@synthesize OnlineButton,OnlineText,LocalButton,LocalText,LockTableButton;

-(void) checkIfThereIsNoDeals {
    if ([_TITLEMARRAY count]==0) {
        UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(35, 168, 175, 24)];
        [label2 setFont:[UIFont fontWithName:@"Avenir-Light" size:16.0]];
        label2.text=@"There are no deals at this moment!";
        label2.backgroundColor=[UIColor clearColor];
        label2.textColor = [UIColor colorWithRed:(170/255.0) green:(170/255.0) blue:(175/255.0) alpha:1.0];
        [label2 sizeToFit];
        [[self scrollView] addSubview:label2];
    }
}

-(void) loadFromDB {
        
    NSMutableArray *TITLEMARRAY_temp = [[NSMutableArray alloc] init];
    NSMutableArray *DESCRIPTIONMARRAY_temp = [[NSMutableArray alloc] init];
    NSMutableArray *STOREMARRAY_temp = [[NSMutableArray alloc] init];
    NSMutableArray *PRICEMARRAY_temp = [[NSMutableArray alloc] init];
    NSMutableArray *DISCOUNTMARRAY_temp = [[NSMutableArray alloc] init];
    NSMutableArray *EXPIREMARRAY_temp = [[NSMutableArray alloc] init];
    NSMutableArray *LIKEMARRAY_temp = [[NSMutableArray alloc] init];
    NSMutableArray *COMMENTMARRAY_temp = [[NSMutableArray alloc] init];
    NSMutableArray *CLIENTMARRAY_temp = [[NSMutableArray alloc] init];
    NSMutableArray *PHOTOIDMARRAY_temp = [[NSMutableArray alloc] init];
    NSMutableArray *CATEGORYARRAY_temp = [[NSMutableArray alloc] init];
    NSMutableArray *SIGNARRAY_temp = [[NSMutableArray alloc] init];
    NSMutableArray *DEALIDARRAY_temp = [[NSMutableArray alloc] init];
    NSMutableArray *uploadDateArray_temp = [[NSMutableArray alloc] init];
    NSMutableArray *onlineOrLocalArray_temp = [[NSMutableArray alloc] init];
    
    NSString *FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/explore.php?indicator=bringDeals&Category='%@'",_categoryFromExplore];
    NSData *URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    NSString *DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    NSArray *dataArray = [DataResult componentsSeparatedByString:@"^"];
    
    for (int i=0; i<([[dataArray copy]count])-1; i=i+15) {
        [TITLEMARRAY_temp addObject:[dataArray objectAtIndex:i]];
        [DESCRIPTIONMARRAY_temp addObject:[dataArray objectAtIndex:i+1]];
        [STOREMARRAY_temp addObject:[dataArray objectAtIndex:i+2]];
        [PRICEMARRAY_temp addObject:[dataArray objectAtIndex:i+3]];
        [DISCOUNTMARRAY_temp addObject:[dataArray objectAtIndex:i+4]];
        [EXPIREMARRAY_temp addObject:[dataArray objectAtIndex:i+5]];
        [LIKEMARRAY_temp addObject:[dataArray objectAtIndex:i+6]];
        [COMMENTMARRAY_temp addObject:[dataArray objectAtIndex:i+7]];
        [PHOTOIDMARRAY_temp addObject:[dataArray objectAtIndex:i+8]];
        [CATEGORYARRAY_temp addObject:[dataArray objectAtIndex:i+9]];
        [CLIENTMARRAY_temp addObject:[dataArray objectAtIndex:i+10]];
        [DEALIDARRAY_temp addObject:[dataArray objectAtIndex:i+11]];
        [SIGNARRAY_temp addObject:[dataArray objectAtIndex:i+12]];
        [uploadDateArray_temp addObject:[dataArray objectAtIndex:i+13]];
        [onlineOrLocalArray_temp addObject:[dataArray objectAtIndex:i+14]];

    }
    
    for (int i=0; i<[[TITLEMARRAY_temp copy] count]; i++) {
        NSString *title=[TITLEMARRAY_temp objectAtIndex:i];
        NSString *store=[STOREMARRAY_temp objectAtIndex:i];
        NSString *description=[DESCRIPTIONMARRAY_temp objectAtIndex:i];
        NSString *category=[CATEGORYARRAY_temp objectAtIndex:i];
        category = [category stringByReplacingOccurrencesOfString:@"q9j" withString:@" & "];
        title = [title stringByReplacingOccurrencesOfString:@"q9j" withString:@"&"];
        store = [store stringByReplacingOccurrencesOfString:@"q9j" withString:@"&"];
        description = [description stringByReplacingOccurrencesOfString:@"q9j" withString:@"&"];
        [TITLEMARRAY_temp replaceObjectAtIndex:i withObject:title];
        [STOREMARRAY_temp replaceObjectAtIndex:i withObject:store];
        [CATEGORYARRAY_temp replaceObjectAtIndex:i withObject:category];
        [DESCRIPTIONMARRAY_temp replaceObjectAtIndex:i withObject:description];
    }
    
    _TITLEMARRAY = [NSMutableArray arrayWithArray:TITLEMARRAY_temp];
    _DESCRIPTIONMARRAY = [NSMutableArray arrayWithArray:DESCRIPTIONMARRAY_temp];
    _STOREMARRAY = [NSMutableArray arrayWithArray:STOREMARRAY_temp];
    _PRICEMARRAY = [NSMutableArray arrayWithArray:PRICEMARRAY_temp];
    _DISCOUNTMARRAY = [NSMutableArray arrayWithArray:DISCOUNTMARRAY_temp];
    _EXPIREMARRAY = [NSMutableArray arrayWithArray:EXPIREMARRAY_temp];
    _LIKEMARRAY = [NSMutableArray arrayWithArray:LIKEMARRAY_temp];
    _COMMENTMARRAY = [NSMutableArray arrayWithArray:COMMENTMARRAY_temp];
    _CLIENTMARRAY = [NSMutableArray arrayWithArray:CLIENTMARRAY_temp];
    _PHOTOIDMARRAY = [NSMutableArray arrayWithArray:PHOTOIDMARRAY_temp];
    _CATEGORYARRAY = [NSMutableArray arrayWithArray:CATEGORYARRAY_temp];
    _SIGNARRAY = [NSMutableArray arrayWithArray:SIGNARRAY_temp];
    _DEALIDARRAY = [NSMutableArray arrayWithArray:DEALIDARRAY_temp];
    _uploadDateArray = [NSMutableArray arrayWithArray:uploadDateArray_temp];
    _onlineOrLocalArray = [NSMutableArray arrayWithArray:uploadDateArray_temp];
    
}
-(void) startLoadingUploadImage:(UIImageView*)image {
    image.animationImages = [NSArray arrayWithObjects:
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
    image.animationDuration = 0.3;
    [image startAnimating];
    [UIView animateWithDuration:0.2 animations:^{image.alpha=1.0; image.transform =CGAffineTransformMakeScale(0,0);
        image.transform =CGAffineTransformMakeScale(1,1);}];
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
        
    if ([_dealsUserLikes rangeOfString:[self.DEALIDARRAY objectAtIndex:(button.tag)]].location == NSNotFound) {
        controller.likeornotLabelFromMyFeeds=@"no";
        NSLog(@"didnt find");
    } else {
        controller.likeornotLabelFromMyFeeds=@"yes";
    }
    
    [self.navigationController pushViewController:controller animated:YES];
}



-(NSString *) currencySymbol : (NSString *) sign {
    if ([sign isEqualToString:@"1"]) {
        sign=@"₪";
    }
    if ([sign isEqualToString:@"2"]) {
        sign=@"$";
    }
    if ([sign isEqualToString:@"3"]) {
        sign=@"£";
    }
    return sign;
}

-(void) createDealsTable {
    NSLog(@"in createDealsTable");

    isUpdatingNow = YES;
    for (int i=cellNumberInScrollView; ((i<10+cellNumberInScrollView) && (i<[[self.TITLEMARRAY copy] count])); i++) {
        NSString *num=[self.PHOTOIDMARRAY objectAtIndex:i];
        NSLog(@"%@",num);
        if ([num isEqualToString:@"0"]) {
            isShortCell = YES;
        } else isShortCell = NO;
        
        UIImageView *imageview;
        if (isShortCell) {
            imageview=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal - New Version_No Pic Deal background & Shadow.png"]];
        } else imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal (final)_Deal background & Shadow.png"]];
        
        [imageview setFrame:CGRectMake(2.5, 4+(GAP), 315, 199-(OFFSETSHORTCELL*isShortCell))];
		[[self scrollView] addSubview:imageview];
        
        UIImageView *imageview4;
        if ([[_onlineOrLocalArray objectAtIndex:i] isEqualToString:@"local"]) {
            imageview4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal - New Version_Local icon_Grey.png"]];
            [imageview4 setFrame:CGRectMake(17, 172+(GAP)-(OFFSETSHORTCELL*isShortCell), 12, 15)];
        } else {
            imageview4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal - New Version_Online icon_Grey.png"]];
            [imageview4 setFrame:CGRectMake(17, 172+(GAP)-(OFFSETSHORTCELL*isShortCell), 13, 13)];
        }
        [[self scrollView] addSubview:imageview4];
        
        UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(33, 168+(GAP)-(OFFSETSHORTCELL*isShortCell), 175, 24)];
        [label2 setFont:[UIFont fontWithName:@"Avenir-Light" size:13.0]];
        label2.text=[self.STOREMARRAY objectAtIndex:i];
        label2.backgroundColor=[UIColor clearColor];
        label2.textColor = [UIColor colorWithRed:(170/255.0) green:(170/255.0) blue:(175/255.0) alpha:1.0];
        [[self scrollView] addSubview:label2];
        
        if ((![[self.PRICEMARRAY objectAtIndex:i] isEqualToString:@"0"])&&([[self.DISCOUNTMARRAY objectAtIndex:i] isEqualToString:@"0"])) {
            UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(265, 169+(GAP)-(OFFSETSHORTCELL*isShortCell), 53, 21)];
            [label3 setFont:[UIFont fontWithName:@"Avenir-Light" size:17.0]];
            label3.text=[self.PRICEMARRAY objectAtIndex:i];
            label3.text = [label3.text stringByAppendingString:[self currencySymbol:[_SIGNARRAY objectAtIndex:i]]];
            label3.backgroundColor=[UIColor clearColor];
            label3.textColor = [UIColor blackColor];
            [label3 sizeToFit];
            [[self scrollView] addSubview:label3];
        }
        
        if ((![[self.PRICEMARRAY objectAtIndex:i] isEqualToString:@"0"])&&(![[self.DISCOUNTMARRAY objectAtIndex:i] isEqualToString:@"0"])) {
            UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(215, 169+(GAP)-(OFFSETSHORTCELL*isShortCell), 53, 21)];
            [label3 setFont:[UIFont fontWithName:@"Avenir-Light" size:17.0]];
            label3.text=[self.PRICEMARRAY objectAtIndex:i];
            label3.text = [label3.text stringByAppendingString:[self currencySymbol:[_SIGNARRAY objectAtIndex:i]]];
            label3.backgroundColor=[UIColor clearColor];
            label3.textColor = [UIColor blackColor];
            [label3 sizeToFit];
            [[self scrollView] addSubview:label3];
            
            UILabel *label4=[[UILabel alloc]initWithFrame:CGRectMake(265, 169+(GAP)-(OFFSETSHORTCELL*isShortCell), 53, 21)];
            [label4 setFont:[UIFont fontWithName:@"Avenir-Light" size:17.0]];
            label4.text=[self.DISCOUNTMARRAY objectAtIndex:i];
            label4.text = [label4.text stringByAppendingString:@"%"];
            label4.backgroundColor=[UIColor clearColor];
            label4.textColor = [UIColor colorWithRed:(255/255.0) green:(59/255.0) blue:(48/255.0) alpha:1.0];
            [label4 sizeToFit];
            [[self scrollView] addSubview:label4];
        }
        
        if (([[self.PRICEMARRAY objectAtIndex:i] isEqualToString:@"0"])&&(![[self.DISCOUNTMARRAY objectAtIndex:i] isEqualToString:@"0"])) {
            UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(265, 169+(GAP)-(OFFSETSHORTCELL*isShortCell), 53, 21)];
            [label3 setFont:[UIFont fontWithName:@"Avenir-Light" size:17.0]];
            label3.text=[self.DISCOUNTMARRAY objectAtIndex:i];
            label3.text = [label3.text stringByAppendingString:@"%"];
            label3.backgroundColor=[UIColor clearColor];
            label3.textColor = [UIColor blackColor];
            [label3 sizeToFit];
            [[self scrollView] addSubview:label3];
        }
        
		GAP=CGRectGetMaxY(imageview.frame)-4;
	}
    cellNumberInScrollView+=10;
    [[self scrollView] setContentSize:CGSizeMake(319,GAP+100)];
    isUpdatingNow = NO;
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
                    NSLog(@"download succsses with = %@",imageview2);
                    [imageview2 setFrame:CGRectMake(10, 10+(gap2), 300, 155)];
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
                [label setFont:[UIFont fontWithName:@"Avenir-Roman" size:14.0]];
                label.text=[self.TITLEMARRAY objectAtIndex:i];
                label.backgroundColor=[UIColor clearColor];
                label.textColor = [UIColor whiteColor];
                label.numberOfLines=2;
                [[self scrollView] addSubview:label];
                
                UILabel *label5=[[UILabel alloc]initWithFrame:CGRectMake(291, 121+(gap2)-(OFFSETSHORTCELL*isShortCell), 21, 21)];
                [label5 setFont:[UIFont fontWithName:@"Avenir-Roman" size:13.0]];
                label5.text=[self.LIKEMARRAY objectAtIndex:i];
                label5.backgroundColor=[UIColor clearColor];
                label5.textColor = [UIColor whiteColor];
                [label5 sizeToFit];
                [[self scrollView] addSubview:label5];
                
                UILabel *label6=[[UILabel alloc]initWithFrame:CGRectMake(291, 141+(gap2)-(OFFSETSHORTCELL*isShortCell), 21, 21)];
                [label6 setFont:[UIFont fontWithName:@"Avenir-Roman" size:13.0]];
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
            cellsNumbersInFillWithImages+=10;
            isUpdatingNow = NO;
            [_loadingImage stopAnimating];
            
            [self checkIfThereIsNoDeals];
            
        });
    });
    
}

-(void) allocArrays {
    _TITLEMARRAY = [[NSMutableArray alloc]init];
    _DESCRIPTIONMARRAY = [[NSMutableArray alloc]init];
    _STOREMARRAY = [[NSMutableArray alloc]init];
    _PRICEMARRAY = [[NSMutableArray alloc]init];
    _DISCOUNTMARRAY = [[NSMutableArray alloc]init];
    _EXPIREMARRAY =  [[NSMutableArray alloc]init];
    _LIKEMARRAY = [[NSMutableArray alloc]init];
    _COMMENTMARRAY = [[NSMutableArray alloc]init];
    _CLIENTMARRAY =  [[NSMutableArray alloc]init];
    _PHOTOIDMARRAY = [[NSMutableArray alloc]init];
    _PHOTOIDMARRAYCONVERT = [[NSMutableArray alloc]init];
    _CATEGORYARRAY = [[NSMutableArray alloc]init];
    _SIGNARRAY =  [[NSMutableArray alloc]init];
    _DEALIDARRAY = [[NSMutableArray alloc]init];
    _uploadDateArray = [[NSMutableArray alloc]init];
    _onlineOrLocalArray = [[NSMutableArray alloc]init];
}


//
-(void) didReachFromRegisterOrAddDeal {
    
    NSArray *viewsToRemove = [self.scrollView subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    
    [self createDealsTable];
    [self fillTheCellsWithImages];
}

-(void) initialize {
    
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    app.AfterAddDeal=@"aftertapbar";
    //self.onlineOrLocalView.alpha=0.0;
    //self.denyClickingOnCellsButton.alpha=0.0;
    //self.whiteCoverView.alpha=1.0;
    [[self scrollView] setBackgroundColor:[UIColor colorWithRed:(230/255.0) green:(230/255.0) blue:(230/255.0) alpha:1.0]];
    [[self scrollView]setScrollEnabled:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    isShortCell=NO;
    isUpdatingNow=NO;
    cellNumberInScrollView=1;
    cellsNumbersInFillWithImages=1;
    GAP=0;
    gap2=0;
}
//
- (void)viewDidLoad
{
    [self initialize];
    [self allocArrays];
    //[self setRefreshControl];
    [self startLoadingUploadImage:_loadingImage];
    dispatch_queue_t queue = dispatch_queue_create("com.MyQueue", NULL);
    dispatch_async(queue, ^{
        // Do some computation here.
        [self loadFromDB];
        // Update UI after computation.
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI on the main thread.
            NSLog(@"creating cells");
            [self didReachFromRegisterOrAddDeal];
        });
    });
    [super viewDidLoad];
}
//
-(void)scrollViewDidScroll: (UIScrollView*)scrollView{
    int scrollOffset = scrollView.contentOffset.y + 300;
    if ((GAP - scrollOffset) < 50) {
        if (!isUpdatingNow) {
            if ((cellNumberInScrollView < [_TITLEMARRAY count])) {
                isUpdatingNow = YES;
                [self createDealsTable];
                [self fillTheCellsWithImages];
                
            }
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) deallocMemory {
    _TITLEMARRAY=nil;
    _DESCRIPTIONMARRAY =nil;
    _STOREMARRAY=nil;
    _PRICEMARRAY=nil;
    _DISCOUNTMARRAY=nil;
    _EXPIREMARRAY=nil;
    _LIKEMARRAY=nil;
    _COMMENTMARRAY=nil;
    _CLIENTMARRAY=nil;
    _PHOTOIDMARRAY=nil;
    _PHOTOIDMARRAYCONVERT=nil;
    _CATEGORYARRAY=nil;
    _SIGNARRAY=nil;
    _DEALIDARRAY=nil;
    _uploadDateArray=nil;
    _onlineOrLocalArray=nil;
    
    static NSCache *_cache = nil;
    [_cache removeAllObjects];
    NSArray *viewsToRemove = [self.view subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    [self.view removeFromSuperview];
    self.view=nil;
}

- (IBAction)myfeedbutton:(id)sender{
    [self deallocMemory];
    NSArray *viewControllers = self.navigationController.viewControllers;
    UINavigationController * navigationController = self.navigationController;
    [navigationController popToViewController:[viewControllers objectAtIndex:2] animated:NO];
}
- (IBAction)morebutton:(id)sender{
    [self deallocMemory];
    NSArray *viewControllers = self.navigationController.viewControllers;
    UINavigationController * navigationController = self.navigationController;
    MoreViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"more"];
    
    [navigationController popToViewController:[viewControllers objectAtIndex:2] animated:NO];
    [navigationController pushViewController:controller animated:NO];
}

- (IBAction)profilebutton:(id)sender{
    [self deallocMemory];
    NSArray *viewControllers = self.navigationController.viewControllers;
    UINavigationController * navigationController = self.navigationController;
    ProfileViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"profile"];
    
    [navigationController popToViewController:[viewControllers objectAtIndex:2] animated:NO];
    [navigationController pushViewController:controller animated:NO];
}
- (IBAction)explorebutton:(id)sender{
}

- (IBAction)returnButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)Adddeal:(id)sender {
    LockTableButton.alpha=1.0;
    [UIView animateWithDuration:0.5 animations:^{_BlueButtonsView.alpha=1.0;}];
}

-(IBAction)UNLockButtonAction:(id)sender{
    LockTableButton.alpha=0.0;
    [UIView animateWithDuration:0.5 animations:^{_BlueButtonsView.alpha=0.0;}];
}

-(void) AddDealFunction {
    [self deallocMemory];
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    UINavigationController * navigationController = self.navigationController;
    TableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TableView"];
    
    [navigationController popToViewController:[viewControllers objectAtIndex:2] animated:NO];
    [navigationController pushViewController:controller animated:NO];
}

-(void)LocalButtonAction:(id)sender{
    [UIView animateWithDuration:0.5 animations:^{_BlueButtonsView.alpha=0.0;}];
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(AddDealFunction) userInfo:nil repeats:NO];
}

-(void)OnlineButtonAction:(id)sender{
    
}





@end

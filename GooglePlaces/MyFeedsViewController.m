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
#import <mach/mach.h>
#import "OptionalaftergoogleplaceViewController.h"
#import "CheckConnection.h"
#import "Deal.h"
#import "Functions.h"


#define offSetShortCell 109
#define imageViewTag -10
#define imageViewBackgroundTag 10
#define titleBackgroundTag 1000
#define loadingIndicatorTag 100000
#define spinningWheelTag 4444

#define S3_PHOTOS_ADDRESS @"https://s3-eu-west-1.amazonaws.com/dealers-app/"

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

-(void) removeCellsFromSuperview {
    NSArray *viewsToRemove = [self.scrollView subviews];
    for (UIView *v in viewsToRemove) {
        if (v.tag != 999) {     // Every view except the refresh controller.
            [v removeFromSuperview];
        }
    }
}

- (void)configureRestKit
{
    // initialize AFNetworking HTTPClient
    NSURL *baseURL = [NSURL URLWithString:@"http://dealers-env.elasticbeanstalk.com"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // initialize RestKit
    RKObjectManager *dealsManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // validate with username and password
    NSString *username = @"uzi";
    NSString *password = @"090909";
    [dealsManager.HTTPClient setAuthorizationHeaderWithUsername:username password:password];
    
    // setup object mappings
    RKObjectMapping *dealMapping = [RKObjectMapping mappingForClass:[Deal class]];
    [dealMapping addAttributeMappingsFromDictionary:@{
                                                      @"url" : @"url",
                                                      @"title" : @"title",
                                                      @"store" : @"store",
                                                      @"price" : @"price",
                                                      @"currency" : @"currency",
                                                      @"discount_value" : @"discountValue",
                                                      @"discount_type" : @"discountType",
                                                      @"category" : @"category",
                                                      @"type" : @"type",
                                                      @"upload_date" : @"uploadDate",
                                                      @"photo1" : @"photoID1",
                                                      @"photo2" : @"photoID2",
                                                      @"photo3" : @"photoID3",
                                                      @"photo4" : @"photoID4"
                                                      }];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:dealMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:@"/deals/"
                                                keyPath:@"results"
                                            statusCodes:statusCodes];
    
    [dealsManager addResponseDescriptor:responseDescriptor];
}

- (void)loadDeals
{
    NSDictionary *parameters;
    if ([selfViewController isEqualToString:@"My Feed"]) {
        parameters = nil;
    } else {
        parameters = @{@"category": self.categoryFromExplore};
    }
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/deals/"
                                           parameters:parameters
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  [self.deals addObjectsFromArray:mappingResult.array];
                                                  
                                                  if (self.deals == nil || self.deals.count == 0) {
                                                      [self noDealMessage];
                                                      
                                                  } else {
                                                      [self createDealsTable];
                                                      [self fillCellsImagesOneByOne];
                                                  }
                                                  
                                                  NSLog(@"\n success! \n number of deals: %lu", (unsigned long)self.deals.count);
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"There was an error with the loading of the store search: %@", error);
                                                  UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                  [alert show];
                                              }];
}

/*
 -(void) loadDataFromDB {
 
 CheckConnection *checkconnection = [[CheckConnection alloc]init];
 if ([checkconnection connected]) {
 
 NSString *url;
 
 if ([selfViewController isEqualToString:@"My Feed"]) {
 url = [NSString stringWithFormat:@"http://www.dealers.co.il/getDealsData.php"];
 } else if ([selfViewController isEqualToString:@"Explore"]) {
 url = [NSString stringWithFormat:@"http://www.dealers.co.il/newExplore.php?Category='%@'", self.categoryFromExplore];
 }
 
 NSURL *dbRequestURL = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
 NSData *data = [NSData dataWithContentsOfURL: dbRequestURL];
 NSError* error;
 
 if (data!=nil) {
 NSDictionary* json = [NSJSONSerialization
 JSONObjectWithData:data
 options:kNilOptions
 error:&error];
 NSDictionary *responseData = json[@"respone"];
 NSArray *deals = responseData[@"deals"];
 NSLog(@"%@",deals);
 
 for (int i=0; i<[deals count]-1 && deals!=NULL; i++)
 {
 Deal *dealClass = [[Deal alloc]init];
 NSDictionary *dealsDictionary = [deals objectAtIndex:i];
 [dealClass setTitle:[dealsDictionary objectForKey:@"title"]];
 [dealClass setStore:[dealsDictionary objectForKey:@"store"]];
 [dealClass setMoreDescription:[dealsDictionary objectForKey:@"description"]];
 [dealClass setCurrency:[dealsDictionary objectForKey:@"currency"]];
 [dealClass setPrice:[dealsDictionary objectForKey:@"price"]];
 [dealClass setDiscountValue:[dealsDictionary objectForKey:@"discount"]];
 
 NSDate *date = [[NSDate alloc]init];
 date = [self.dateFormatter dateFromString:[dealsDictionary objectForKey:@"expire"]];
 [dealClass setExpiration:date];
 
 [dealClass setLikeCounter:[dealsDictionary objectForKey:@"likescount"]];
 [dealClass setCommentCounter:[dealsDictionary objectForKey:@"commentscount"]];
 [dealClass setPhotoID1:[dealsDictionary objectForKey:@"photoid1"]];
 [dealClass setPhotoID2:[dealsDictionary objectForKey:@"photoid2"]];
 [dealClass setPhotoID3:[dealsDictionary objectForKey:@"photoid3"]];
 [dealClass setPhotoID4:[dealsDictionary objectForKey:@"photoid4"]];
 [dealClass setPhotoSum:[dealsDictionary objectForKey:@"photosum"]];
 [dealClass setCategory:[dealsDictionary objectForKey:@"category"]];
 [dealClass setDealUserID:[dealsDictionary objectForKey:@"userid"]];
 [dealClass setDealID:[dealsDictionary objectForKey:@"dealid"]];
 [dealClass setUploadDate:[dealsDictionary objectForKey:@"uploaddate"]];
 [dealClass setType:[dealsDictionary objectForKey:@"onlineorlocal"]];
 [dealClass setDealUrlSite:[dealsDictionary objectForKey:@"urlsite"]];
 [dealClass setDealStoreAddress:[dealsDictionary objectForKey:@"storeaddress"]];
 [dealClass setDealStoreLatitude:[dealsDictionary objectForKey:@"storelatitude"]];
 [dealClass setDealStoreLongitude:[dealsDictionary objectForKey:@"storelongitude"]];
 
 [self.deals addObject:dealClass];
 }
 }
 }
 AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
 app.AfterAddDeal = @"aftersign";
 }
 */

- (void)createDealsTable {
    
    Deal *dealClass = [[Deal alloc]init];
    
    isUpdatingNow = YES;
    
    for (int i = cellNumberInScrollView; ((i < numberOfDealsLoadingAtATime + cellNumberInScrollView) && (i < [self.deals count])); i++) {
        dealClass = [self.deals objectAtIndex:i];
        NSString *imageID = [dealClass photoID1];
        
        dealClass.photoSum = [self setPhotoSum:dealClass];
        
        if (imageID.length == 0) {
            isShortCell = YES;
        } else isShortCell = NO;
        
        UIImageView *imageview, *imageViewBackground;
        
        if (isShortCell) {
            imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"No Pic Deal Background"]];
        } else {
            imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Deal Background"]];
            imageViewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Deal Pic Mask"]];
        }
        
        [imageview setFrame:CGRectMake(2.5, 4+(GAP), 315, 199-(offSetShortCell*isShortCell))];
        [imageViewBackground setFrame:CGRectMake(10, 10+(GAP), 300, 155)];
        imageViewBackground.tag = (i + 1) * imageViewBackgroundTag;
        [[self scrollView] addSubview:imageview];
        [[self scrollView] addSubview:imageViewBackground];
        
        if (!isShortCell) {
            UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            loading.center = imageViewBackground.center;
            loading.tag = (i + 1) * loadingIndicatorTag;
            [loading startAnimating];
            [self.scrollView addSubview:loading];
        }
        
        UIImageView *titleBackground;
        
        if (isShortCell) {
            titleBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"No Pic Title Background"]];
            [titleBackground setFrame:CGRectMake(10, 9+(GAP), 300, 47)];
        } else {
            titleBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Title Background"]];
            titleBackground.alpha = 0.7;
            [titleBackground setFrame:CGRectMake(10, 87+(GAP)-(offSetShortCell*isShortCell), 300, 78)];
            titleBackground.tag = (i + 1) * titleBackgroundTag;
        }
        [[self scrollView] addSubview:titleBackground];
        
        UIImageView *likeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal (final)_Likes icon.png"]];
        [likeIcon setFrame:CGRectMake(274, 124+(GAP)-(offSetShortCell*isShortCell), 13, 12)];
        [[self scrollView] addSubview:likeIcon];
        
        UIImageView *commentIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal (final)_Comments icon.png"]];
        [commentIcon setFrame:CGRectMake(274, 143+(GAP)-(offSetShortCell*isShortCell), 12, 14)];
        [[self scrollView] addSubview:commentIcon];
        
        
        UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(18, 119+(GAP)-(offSetShortCell*isShortCell), 249, 41)];
        [title setFont:[UIFont fontWithName:@"Avenir-Roman" size:16.0]];
        title.text = [dealClass title];
        title.backgroundColor = [UIColor clearColor];
        title.textColor = [UIColor whiteColor];
        title.numberOfLines = 2;
        [[self scrollView] addSubview:title];
        
        UILabel *likes = [[UILabel alloc]initWithFrame:CGRectMake(291, 121+(GAP)-(offSetShortCell*isShortCell), 21, 21)];
        [likes setFont:[UIFont fontWithName:@"Avenir-Roman" size:13.0]];
        likes.text = [[dealClass likeCounter] stringValue];
        likes.backgroundColor = [UIColor clearColor];
        likes.textColor = [UIColor whiteColor];
        [likes sizeToFit];
        [[self scrollView] addSubview:likes];
        
        UILabel *comments = [[UILabel alloc]initWithFrame:CGRectMake(291, 141+(GAP)-(offSetShortCell*isShortCell), 21, 21)];
        [comments setFont:[UIFont fontWithName:@"Avenir-Roman" size:13.0]];
        comments.text = [[dealClass commentCounter] stringValue];
        comments.backgroundColor = [UIColor clearColor];
        comments.textColor = [UIColor whiteColor];
        [comments sizeToFit];
        [[self scrollView] addSubview:comments];
        
        UIButton *selectDealButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [selectDealButton setTitle:@"" forState:UIControlStateNormal];
        selectDealButton.frame = CGRectMake(0, 4+(GAP), 319, 193-(offSetShortCell*isShortCell));//193
        selectDealButton.tag = i;
        [selectDealButton addTarget:self action:@selector(selectDealButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [[self scrollView] addSubview:selectDealButton];
        
        UIImageView *imageview4;
        if ([[dealClass type] isEqualToString:@"L"]) {
            imageview4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Local Icon"]];
            [imageview4 setFrame:CGRectMake(18, 173+(GAP)-(offSetShortCell*isShortCell), 11, 14)];
        } else {
            imageview4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Online Icon"]];
            [imageview4 setFrame:CGRectMake(17, 174+(GAP)-(offSetShortCell*isShortCell), 13, 13)];
        }
        [[self scrollView] addSubview:imageview4];
        
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(34, 168+(GAP)-(offSetShortCell*isShortCell), 175, 24)];
        [label2 setFont:[UIFont fontWithName:@"Avenir-Roman" size:13.0]];
        label2.text = [dealClass store];
        label2.backgroundColor = [UIColor clearColor];
        label2.textColor = [UIColor blackColor];
        [[self scrollView] addSubview:label2];
        
        if ((![dealClass.price.stringValue isEqualToString:@"0"]) && ([dealClass.discountValue.stringValue isEqualToString:@"0"])) {
            UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(265, 169+(GAP)-(offSetShortCell*isShortCell), 53, 21)];
            [label3 setFont:[UIFont fontWithName:@"Avenir-Light" size:17.0]];
            label3.text = [dealClass.currency stringByAppendingString:dealClass.price.stringValue];
            label3.backgroundColor = [UIColor clearColor];
            label3.textColor = [UIColor blackColor];
            [label3 sizeToFit];
            label3.textAlignment = NSTextAlignmentRight;
            [[self scrollView] addSubview:label3];
        }
        
        if ((![dealClass.price.stringValue isEqualToString:@"0"]) && (![dealClass.discountValue.stringValue isEqualToString:@"0"])) {
            UILabel *label4=[[UILabel alloc]initWithFrame:CGRectMake(265, 169+(GAP)-(offSetShortCell*isShortCell), 53, 21)];
            [label4 setFont:[UIFont fontWithName:@"Avenir-Light" size:17.0]];
            label4.text = [[dealClass discountValue] stringValue];
            label4.text = [label4.text stringByAppendingString:@"%"];
            label4.backgroundColor = [UIColor clearColor];
            label4.textColor = [UIColor colorWithRed:(255/255.0) green:(59/255.0) blue:(48/255.0) alpha:1.0];
            [label4 sizeToFit];
            label4.textAlignment = NSTextAlignmentRight;
            [[self scrollView] addSubview:label4];
            
            UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(215, 169+(GAP)-(offSetShortCell*isShortCell), 53, 21)];
            [label3 setFont:[UIFont fontWithName:@"Avenir-Light" size:17.0]];
            label3.text = [dealClass.currency stringByAppendingString:dealClass.price.stringValue];
            label3.backgroundColor = [UIColor clearColor];
            label3.textColor = [UIColor blackColor];
            label3.textAlignment = NSTextAlignmentRight;
            [label3 sizeToFit];
            [[self scrollView] addSubview:label3];
        }
        
        if (([dealClass.price.stringValue isEqualToString:@"0"]) && (![dealClass.discountValue.stringValue isEqualToString:@"0"])) {
            UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(265, 169+(GAP)-(offSetShortCell*isShortCell), 53, 21)];
            [label3 setFont:[UIFont fontWithName:@"Avenir-Light" size:17.0]];
            label3.text = [[dealClass discountValue] stringValue];
            label3.text = [label3.text stringByAppendingString:@"%"];
            label3.backgroundColor=[UIColor clearColor];
            label3.textColor = [UIColor redColor];
            [label3 sizeToFit];
            label3.textAlignment = NSTextAlignmentRight;
            [[self scrollView] addSubview:label3];
        }
        
        GAP = CGRectGetMaxY(imageview.frame)-4;
        
    } // End of for loop.
    
    if (cellNumberInScrollView + numberOfDealsLoadingAtATime < self.deals.count) {
        
        // Need the spinning wheel:
        CGFloat width = 30;
        CGFloat height = 30;
        CGFloat x = self.view.center.x - width/2;
        CGFloat y = GAP + 15;
        UIImageView *spinningWheel = [[UIImageView alloc]initWithFrame:CGRectMake(x , y, width, height)];
        spinningWheel.tag = spinningWheelTag;
        
        [self.scrollView addSubview:spinningWheel];
        [self startLoading:spinningWheel];
        
        [[self scrollView] setContentSize:CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(spinningWheel.frame) + 22)];
        
    } else {
        // Add here the logo that indicates that the deals array is finished.
        [[self scrollView] setContentSize:CGSizeMake(self.view.frame.size.width, GAP + 10)];
    }
    
    cellNumberInScrollView += numberOfDealsLoadingAtATime;
    
    UIRefreshControl *refreshControl = (UIRefreshControl *)[self.scrollView viewWithTag:999];
    
    if ([refreshControl isRefreshing]) {
        [refreshControl endRefreshing];
    }
}

- (void)fillCellsImagesOneByOne {
    
    isUpdatingNow = YES;
    
    dispatch_queue_t photosQueue;
    
    for (int i = cellsNumbersInFillWithImages; ((i < cellNumberInScrollView) && (i < [self.deals count])); i++) {
        
        if (!photosQueue) {
            photosQueue = dispatch_queue_create("com.MyQueue", NULL);
        }
        
        dispatch_async(photosQueue, ^{
            
            Deal *dealClass = [[Deal alloc]init];
            
            
            dealClass = [self.deals objectAtIndex:i];
            NSString *imageID = [dealClass photoID1];
            
            if ((![imageID isEqualToString:@""]) && (imageID != nil) && ([imageID length] != 0)) {
                
                NSString *URLForPhoto = [S3_PHOTOS_ADDRESS stringByAppendingString:imageID];
                NSData *imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:URLForPhoto]];
                self.image = [[UIImage alloc]initWithData:imageData];
                [dealClass setPhoto1:self.image];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIImageView *imageview2 = [[UIImageView alloc]init];
                    
                    UIImageView *imageViewBackground = (UIImageView *)[self.scrollView viewWithTag:(i + 1) * imageViewBackgroundTag];
                    [imageview2 setFrame:imageViewBackground.frame];
                    
                    imageview2.image = [dealClass photo1];
                    CALayer *mask = [CALayer layer];
                    mask.contents = (id)[[UIImage imageNamed:@"Deal Pic Mask"]CGImage];
                    mask.frame = CGRectMake(0, 0, 300, 155);
                    imageview2.layer.mask = mask;
                    imageview2.layer.masksToBounds = YES;
                    imageview2.tag = (i + 1) * imageViewTag;
                    imageview2.alpha = 0;
                    UIImageView *titlebackground = (UIImageView *)[self.scrollView viewWithTag:(i + 1) * titleBackgroundTag];
                    [[self scrollView] insertSubview:imageview2 belowSubview:titlebackground];
                    UIActivityIndicatorView *loading = (UIActivityIndicatorView *)[self.scrollView viewWithTag:(i + 1) * loadingIndicatorTag];
                    
                    [UIView animateWithDuration:0.5 animations:^{
                        loading.alpha = 0;
                        imageview2.alpha = 1.0;
                    } completion:^(BOOL finished){
                        [loading stopAnimating];
                    }];
                });
            } // End of if statement
            
            if (i + 1 == cellNumberInScrollView) {
                
                isUpdatingNow = NO; // Releasing only when the loop is finished.
                
                int scrollOffset = self.scrollView.contentOffset.y + self.view.frame.size.height;
                if (((GAP - scrollOffset) < 200) && (GAP != 0)) {
                    isUpdatingNow = YES;
                    [self stopWheelAndPresentDeals];
                }
                
                NSLog(@"\n cellNumbersInFillWithImages: %i \n cellNumberInScrollView: %i \n i: %i", cellsNumbersInFillWithImages, cellNumberInScrollView, i);
            }
        });
    } // End of for loop
    
    cellsNumbersInFillWithImages += numberOfDealsLoadingAtATime;
}

- (void)selectDealButtonClicked:(id)sender {
    
    ViewonedealViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"viewdeal"];
    UIButton *button = (UIButton *)sender;
    Deal *dealClass = [[Deal alloc]init];
    dealClass = [self.deals objectAtIndex:(button.tag)];
    controller.dealClass = dealClass;
    
    if (dealClass.photoID1.length > 0) {
        controller.isShortCell = @"no";
    } else controller.isShortCell = @"yes";
    
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    if ([app.dealerClass.userLikesList rangeOfString:[dealClass url]].location == NSNotFound) {
        controller.likeornotLabelFromMyFeeds = @"no";
    } else {
        controller.likeornotLabelFromMyFeeds = @"yes";
    }
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)startLoading:(UIImageView *)spinningWheel
{
    spinningWheel.animationImages = [NSArray arrayWithObjects:
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
    spinningWheel.animationDuration = 0.3;
    [spinningWheel startAnimating];
    [UIView animateWithDuration:0.3 animations:^{spinningWheel.alpha=1.0; spinningWheel.transform =CGAffineTransformMakeScale(0,0);
        spinningWheel.transform =CGAffineTransformMakeScale(1,1);}];
}

- (NSNumber *)setPhotoSum:(Deal *)deal {
    
    if (deal.photoID1.length > 0)
        deal.photoSum = @(deal.photoSum.intValue + 1);
    else
        return [NSNumber numberWithInt:0];
    
    if (deal.photoID2.length > 0)
        deal.photoSum = @(deal.photoSum.intValue + 1);
    else
        return [NSNumber numberWithInt:1];
    
    if (deal.photoID3.length > 0)
        deal.photoSum = @(deal.photoSum.intValue + 1);
    else
        return [NSNumber numberWithInt:2];
    
    if (deal.photoID4.length > 0)
        deal.photoSum = @(deal.photoSum.intValue + 1);
    else
        return [NSNumber numberWithInt:3];
    
    return [NSNumber numberWithInt:4];
}

- (void)initializeView {
    
    [[self scrollView] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    isShortCell = NO;
    isUpdatingNow = NO;
    
    numberOfDealsLoadingAtATime = 10;
    cellNumberInScrollView = 0;
    cellsNumbersInFillWithImages = 0;
    
    GAP = 0;
    gap2 = 0;
    
    myFeedsFirstTime = YES;
    self.scrollView.frame = [[UIScreen mainScreen] bounds];
}

- (void)allocArrays {
    self.deals = nil;
    self.deals = [[NSMutableArray alloc]init];
    self.dealPhotosArray = nil;
    self.dealPhotosArray=[[NSMutableArray alloc]init];
}

- (void)setRefreshControl {
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor colorWithRed:150/255.0f green:0/255.0f blue:180/255.0f alpha:1.0];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    refreshControl.tag = 999;
    [[self scrollView] addSubview:refreshControl];
}

-(void)refresh:(UIRefreshControl *)refreshControl {
    NSLog(@"refreshing");
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    app.AfterAddDeal = @"yes";
    [self viewDidAppear:YES];
}

- (void)didReachFromRegisterOrAddDeal {
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    if (![app.AfterAddDeal isEqualToString:@"no"]) {
        app.AfterAddDeal = @"no";
        [self removeCellsFromSuperview];
        if (self.deals == nil || self.deals.count == 0) {
            [self noDealMessage];
        } else {
            [self createDealsTable];
            [self fillCellsImagesOneByOne];
        }
    }
}

- (void)noDealMessage
{
    UILabel *noDealsMessage = [[UILabel alloc]initWithFrame:CGRectMake(0, self.scrollView.center.y - 60, 320, 18)];
    [noDealsMessage setFont:[UIFont fontWithName:@"Avenir-Light" size:17.0]];
    [noDealsMessage setTextAlignment:NSTextAlignmentCenter];
    noDealsMessage.text=@"There are no deals at this moment!";
    noDealsMessage.backgroundColor=[UIColor clearColor];
    noDealsMessage.textColor = [UIColor colorWithRed:(150/255.0) green:(150/255.0) blue:(155/255.0) alpha:1.0];
    noDealsMessage.alpha = 0;
    [[self scrollView] addSubview:noDealsMessage];
    
    [UIView animateWithDuration:0.3 animations:^{ noDealsMessage.alpha = 1.0; }];
}

- (void)viewDidAppear:(BOOL)animated {
    
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    if ([app.AfterAddDeal isEqualToString:@"yes"]) {
        app.AfterAddDeal = @"no";
        NSLog(@"delete old deals, uploading new deals, and update VC");
        [self initializeView];
        [self allocArrays];
        [self removeCellsFromSuperview];
        static NSCache *_cache = nil;
        [_cache removeAllObjects];
        
        CheckConnection *checkconnection = [[CheckConnection alloc]init];
        if ([checkconnection connected]) {
            
            [self loadDeals];
            //            [self loadDBandUpdateCells];
            
        } else {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection Error" message:@"Check Your Internet Connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
}

/*
 - (void)loadDBandUpdateCells {
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
 */

- (void)viewDidLoad {
    
    [self checkFeature];
    
    if ([selfViewController isEqualToString:@"My Feed"]) {
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Dealers Logo"]];
    } else if ([selfViewController isEqualToString:@"Explore"]) {
        self.title = self.categoryFromExplore;
    }
    
    [self initializeView];
    [self allocArrays];
    [self removeCellsFromSuperview];
    [self setRefreshControl];
    
    [self configureRestKit];
    
    CheckConnection *checkconnection = [[CheckConnection alloc]init];
    
    if ([checkconnection connected]){
        
        [self loadDeals];
        //        [self loadDBandUpdateCells];
        
    } else {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection Error" message:@"Check Internet Connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    
    [self setDateFormatter];
    
    [super viewDidLoad];
}

- (void)setDateFormatter
{
    self.dateFormatter = [[NSDateFormatter alloc]init];
    self.dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    self.dateFormatter.timeStyle = NSDateFormatterNoStyle;
}

- (void)checkFeature
{
    if ([[[self.navigationController viewControllers] objectAtIndex:0] isEqual:self]) {
        selfViewController = @"My Feed";
    } else {
        selfViewController = @"Explore";
    }
}

- (void)scrollViewDidScroll: (UIScrollView *)scrollView {
    int scrollOffset = scrollView.contentOffset.y + self.view.frame.size.height;
    if (((GAP - scrollOffset) < 200) && (GAP != 0)) {
        
        if (!isUpdatingNow) {
            isUpdatingNow = YES;
            [self stopWheelAndPresentDeals];
            
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [scrollView becomeFirstResponder];
}

- (void)stopWheelAndPresentDeals
{
    UIImageView *spinningWheel = (UIImageView *)[self.scrollView viewWithTag:spinningWheelTag];
    
    if (spinningWheel) {
        
        [UIView animateWithDuration:0.3 animations:^{ spinningWheel.transform = CGAffineTransformMakeScale(0,0); }
                         completion:^(BOOL finished){
                             [self createDealsTable];
                             [self fillCellsImagesOneByOne];
                             [spinningWheel stopAnimating];
                         }];
    } else {
        [self createDealsTable];
        [self fillCellsImagesOneByOne];
    }
}


//////////////////////
//// tapbar //////////
//////////////////////


-(void) func {
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    app.previousViewControllerAddDeal=@"foursquare";
    app.onlineOrLocal=@"local";
    TableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TableView"];
    [self.navigationController pushViewController:controller animated:NO];
}

-(void) func2 {
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    app.previousViewControllerAddDeal=@"online";
    app.onlineOrLocal=@"online";
    OnlineViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"OnlineView"];
    [self.navigationController pushViewController:controller animated:NO];
}

-(void) goToOnline {
    [self hideLocalOrOnlineView];
    [self performSelector:@selector(func2) withObject:nil afterDelay:0.5];
}

-(void) goToAddDeal {
    [self hideLocalOrOnlineView];
    [self performSelector:@selector(func) withObject:nil afterDelay:0.1];
    
}

-(void) tapBarSet {
    
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal_Tab Bar@2X.png"]];
    [imageview setFrame:CGRectMake(0, ([[UIScreen mainScreen] bounds].size.height)-69, ([[UIScreen mainScreen] bounds].size.width), 50)];
    [[self view] addSubview:imageview];
    
    UIImageView *imageview2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal_Explore button@2X.png"]];
    [imageview2 setFrame:CGRectMake(74, ([[UIScreen mainScreen] bounds].size.height)-64, 29, 29)];
    [[self view] addSubview:imageview2];
    
    UIImageView *imageview3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal_More button@2X.png"]];
    [imageview3 setFrame:CGRectMake(276, ([[UIScreen mainScreen] bounds].size.height)-64, 29, 29)];
    [[self view] addSubview:imageview3];
    
    UIImageView *imageview4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal_My Feed button(selected)@2X.png"]];
    [imageview4 setFrame:CGRectMake(19, ([[UIScreen mainScreen] bounds].size.height)-64, 29, 29)];
    [[self view] addSubview:imageview4];
    
    UIImageView *imageview5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal_Profile button@2X.png"]];
    [imageview5 setFrame:CGRectMake(218, ([[UIScreen mainScreen] bounds].size.height)-64, 29, 29)];
    [[self view] addSubview:imageview5];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(56, ([[UIScreen mainScreen] bounds].size.height)-38, 65, 21)];
    [label setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:11.0]];
    label.text=@"Explore";
    label.backgroundColor=[UIColor clearColor];
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    [[self view] addSubview:label];
    
    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(258, ([[UIScreen mainScreen] bounds].size.height)-38, 65, 21)];
    [label2 setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:11.0]];
    label2.text=@"More";
    label2.backgroundColor=[UIColor clearColor];
    label2.textColor = [UIColor lightGrayColor];
    label2.textAlignment = NSTextAlignmentCenter;
    [[self view] addSubview:label2];
    
    UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(1, ([[UIScreen mainScreen] bounds].size.height)-38, 65, 21)];
    [label3 setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:11.0]];
    label3.text=@"My Feed";
    label3.backgroundColor=[UIColor clearColor];
    label3.textColor = [UIColor colorWithRed:150/255.0 green:0/255.0 blue:180/255.0 alpha:1.0];
    label3.textAlignment = NSTextAlignmentCenter;
    [[self view] addSubview:label3];
    
    UILabel *label4=[[UILabel alloc]initWithFrame:CGRectMake(200, ([[UIScreen mainScreen] bounds].size.height)-38, 65, 21)];
    [label4 setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:11.0]];
    label4.text=@"Profile";
    label4.backgroundColor=[UIColor clearColor];
    label4.textColor = [UIColor lightGrayColor];
    label4.textAlignment = NSTextAlignmentCenter;
    [[self view] addSubview:label4];
    
    
    UIButton *selectDealButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [selectDealButton setTitle:@"" forState:UIControlStateNormal];
    [selectDealButton setImage:[UIImage imageNamed:@"My Feed+View Deal_Add Deal button@2X.png"] forState:UIControlStateNormal];
    selectDealButton.frame=CGRectMake(129, ([[UIScreen mainScreen] bounds].size.height)-75,62,56);
    [selectDealButton addTarget:self action:@selector(showLocalOrOnlineView:) forControlEvents: UIControlEventTouchUpInside];
    selectDealButton.tag=120;
    [[self view] addSubview:selectDealButton];
    
    UIButton *selectDealButton2=[UIButton buttonWithType:UIButtonTypeCustom];
    [selectDealButton2 setTitle:@"" forState:UIControlStateNormal];
    selectDealButton2.frame=CGRectMake(10, ([[UIScreen mainScreen] bounds].size.height)-64,46,45);
    [selectDealButton2 addTarget:self action:@selector(myFeedClicked:) forControlEvents: UIControlEventTouchUpInside];
    [[self view] addSubview:selectDealButton2];
    
    UIButton *selectDealButton3=[UIButton buttonWithType:UIButtonTypeCustom];
    [selectDealButton3 setTitle:@"" forState:UIControlStateNormal];
    selectDealButton3.frame=CGRectMake(65, ([[UIScreen mainScreen] bounds].size.height)-64,46,45);
    [selectDealButton3 addTarget:self action:@selector(exploreClicked:) forControlEvents: UIControlEventTouchUpInside];
    [[self view] addSubview:selectDealButton3];
    
    UIButton *selectDealButton4=[UIButton buttonWithType:UIButtonTypeCustom];
    [selectDealButton4 setTitle:@"" forState:UIControlStateNormal];
    selectDealButton4.frame=CGRectMake(209, ([[UIScreen mainScreen] bounds].size.height)-64,46,45);
    [selectDealButton4 addTarget:self action:@selector(profileClicked:) forControlEvents: UIControlEventTouchUpInside];
    [[self view] addSubview:selectDealButton4];
    
    UIButton *selectDealButton5=[UIButton buttonWithType:UIButtonTypeCustom];
    [selectDealButton5 setTitle:@"" forState:UIControlStateNormal];
    selectDealButton5.frame=CGRectMake(267, ([[UIScreen mainScreen] bounds].size.height)-64,46,45);
    [selectDealButton5 addTarget:self action:@selector(moreClicked:) forControlEvents: UIControlEventTouchUpInside];
    [[self view] addSubview:selectDealButton5];
    
    
    //////////////////////
    //// blue buttons ////
    //////////////////////
    
    UIButton *selectDealButton6=[UIButton buttonWithType:UIButtonTypeCustom];
    [selectDealButton6 setTitle:@"" forState:UIControlStateNormal];
    selectDealButton6.frame=CGRectMake(0, 0,([[UIScreen mainScreen] bounds].size.width),([[UIScreen mainScreen] bounds].size.height-68));
    NSLog(@"%f",[[UIScreen mainScreen] bounds].size.height-44);
    selectDealButton6.tag=100;
    [selectDealButton6 setBackgroundColor:[UIColor whiteColor]];
    [selectDealButton6 addTarget:self action:@selector(hideLocalOrOnlineView) forControlEvents: UIControlEventTouchUpInside];
    selectDealButton6.alpha=0.0;
    [[self view] addSubview:selectDealButton6];
    
    UIButton *selectDealButton9=[UIButton buttonWithType:UIButtonTypeCustom];
    [selectDealButton9 setTitle:@"" forState:UIControlStateNormal];
    selectDealButton9.frame=CGRectMake(0, 0,([[UIScreen mainScreen] bounds].size.width),([[UIScreen mainScreen] bounds].size.height-68));
    selectDealButton9.tag=110;
    [selectDealButton9 setBackgroundColor:[UIColor whiteColor]];
    selectDealButton9.alpha=0.0;
    [[self view] addSubview:selectDealButton9];
    
    UIButton *selectDealButton7=[UIButton buttonWithType:UIButtonTypeCustom];
    [selectDealButton7 setTitle:@"" forState:UIControlStateNormal];
    [selectDealButton7 setImage:[UIImage imageNamed:@"Add Deal (Final)_Local button.png"] forState:UIControlStateNormal];
    selectDealButton7.frame=CGRectMake(55, ([[UIScreen mainScreen] bounds].size.height)-210,90,90);
    selectDealButton7.tag=101;
    [selectDealButton7 addTarget:self action:@selector(goToAddDeal) forControlEvents: UIControlEventTouchUpInside];
    selectDealButton7.alpha=0.0;
    [[self view] addSubview:selectDealButton7];
    
    UIButton *selectDealButton8=[UIButton buttonWithType:UIButtonTypeCustom];
    [selectDealButton8 setTitle:@"" forState:UIControlStateNormal];
    [selectDealButton8 setImage:[UIImage imageNamed:@"Add Deal (Final)_Online button.png"] forState:UIControlStateNormal];
    selectDealButton8.frame=CGRectMake(175, ([[UIScreen mainScreen] bounds].size.height)-210,90,90);
    selectDealButton8.tag=102;
    [selectDealButton8 addTarget:self action:@selector(goToOnline) forControlEvents: UIControlEventTouchUpInside];
    selectDealButton8.alpha=0.0;
    [[self view] addSubview:selectDealButton8];
    
    UILabel *label5=[[UILabel alloc]initWithFrame:CGRectMake(55, ([[UIScreen mainScreen] bounds].size.height)-110, 90, 16)];
    [label5 setFont:[UIFont fontWithName:@"Avenir-Roman" size:16.0]];
    label5.text=@"Local Store";
    label5.backgroundColor=[UIColor clearColor];
    label5.textColor = [UIColor colorWithRed:0/255 green:122/255 blue:255/255 alpha:1.0];
    label5.textAlignment = NSTextAlignmentCenter;
    label5.tag=103;
    label5.alpha=0.0;
    [[self view] addSubview:label5];
    
    UILabel *label6=[[UILabel alloc]initWithFrame:CGRectMake(175, ([[UIScreen mainScreen] bounds].size.height)-110, 90, 16)];
    [label6 setFont:[UIFont fontWithName:@"Avenir-Roman" size:16.0]];
    label6.text=@"The Web";
    label6.backgroundColor=[UIColor clearColor];
    label6.textColor = [UIColor colorWithRed:0/255 green:122/255 blue:255/255 alpha:1.0];
    label6.textAlignment = NSTextAlignmentCenter;
    label6.tag=104;
    label6.alpha=0.0;
    [[self view] addSubview:label6];
    
    UILabel *label7=[[UILabel alloc]initWithFrame:CGRectMake(0, ([[UIScreen mainScreen] bounds].size.height)-251, 320, 22)];
    [label7 setFont:[UIFont fontWithName:@"Avenir-Light" size:22.0]];
    label7.text=@"Add deal from?";
    label7.backgroundColor=[UIColor clearColor];
    label7.textColor = [UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:1.0];
    label7.textAlignment = NSTextAlignmentCenter;
    label7.tag=105;
    label7.alpha=0.0;
    [[self view] addSubview:label7];
    
}

-(void) myFeedClicked:(id)sender {
}

-(void) exploreClicked:(id)sender {
    ExploretableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"explore"];
    [self.navigationController pushViewController:controller animated:NO];
}

-(void) moreClicked:(id)sender {
    MoreViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"more"];
    [self.navigationController pushViewController:controller animated:NO];
}

-(void) profileClicked:(id)sender {
    ProfileViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"profile"];
    [self.navigationController pushViewController:controller animated:NO];
}

-(void) hideLocalOrOnlineView {
    NSLog(@"remove cover");
    UIButton *button1 = (UIButton*)[self.view viewWithTag:100];
    UIButton *button2 = (UIButton*)[self.view viewWithTag:101];
    UIButton *button3 = (UIButton*)[self.view viewWithTag:102];
    UILabel *label1 = (UILabel*)[self.view viewWithTag:103];
    UILabel *label2 = (UILabel*)[self.view viewWithTag:104];
    UILabel *label3 = (UILabel*)[self.view viewWithTag:105];
    
    
    [UIView animateWithDuration:0.5 animations:^{
        button1.alpha=0.0;
        button2.alpha=0.0;
        button3.alpha=0.0;
        label1.alpha=0.0;
        label2.alpha=0.0;
        label3.alpha=0.0;
    }];
    
}

-(void) showLocalOrOnlineView:(id)sender {
    UIButton *button1 = (UIButton*)[self.view viewWithTag:100];
    UIButton *button2 = (UIButton*)[self.view viewWithTag:101];
    UIButton *button3 = (UIButton*)[self.view viewWithTag:102];
    UIButton *button4 = (UIButton*)[self.view viewWithTag:120];
    UILabel *label1 = (UILabel*)[self.view viewWithTag:103];
    UILabel *label2 = (UILabel*)[self.view viewWithTag:104];
    UILabel *label3 = (UILabel*)[self.view viewWithTag:105];
    [self.view bringSubviewToFront:button4];
    
    [UIView animateWithDuration:0.5 animations:^{
        button1.alpha=0.9;
        button2.alpha=1.0;
        button3.alpha=1.0;
        label1.alpha=1.0;
        label2.alpha=1.0;
        label3.alpha=1.0;
    }];
    
}

@end


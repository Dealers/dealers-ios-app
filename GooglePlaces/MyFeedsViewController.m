//
//  MyFeedsViewController.m
//  Dealers-testbeta
//
//  Created by itzik berrebi on 2/16/14.
//
//

#import "MyFeedsViewController.h"
#import "ViewonedealViewController.h"
#import "ProfileViewController.h"
#import "ExploretableViewController.h"
#import "WhereIsTheDeal.h"
#import "OnlineViewController.h"
#import <mach/mach.h>
#import <AWSiOSSDKv2/S3.h>
#import <AWSiOSSDKv2/AWSCore.h>
#import <Bolts/Bolts.h>
#import "WhatIsTheDeal.h"
#import "CheckConnection.h"
#import "Deal.h"
#import "Functions.h"
#import "DealsTableViewController.h"


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

@synthesize appDelegate;

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

- (void)loadDeals
{
    NSDictionary *parameters;
    if ([selfViewController isEqualToString:@"My Feed"]) {
        parameters = nil;
    } else {
        parameters = @{@"category": [appDelegate getCategoryKeyForValue:self.categoryFromExplore]};
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
        NSString *imageID = [dealClass photoURL1];
        
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
        
        dealClass.currency = [appDelegate getCurrencySign:dealClass.currency];
        dealClass.discountType = [appDelegate getDiscountType:dealClass.discountType];
        
        UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(18, 119+(GAP)-(offSetShortCell*isShortCell), 249, 41)];
        [title setFont:[UIFont fontWithName:@"Avenir-Medium" size:17.0]];
        title.text = [dealClass title];
        title.backgroundColor = [UIColor clearColor];
        title.textColor = [UIColor whiteColor];
        title.numberOfLines = 2;
        [[self scrollView] addSubview:title];
        
        if (dealClass.dealAttrib.dealersThatLiked.count > 0) {
        
            UIImageView *likeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal (final)_Likes icon.png"]];
            [likeIcon setFrame:CGRectMake(270, 132+(GAP)-(offSetShortCell*isShortCell), 18, 16)];
            [[self scrollView] addSubview:likeIcon];
            
            UILabel *likes = [[UILabel alloc]initWithFrame:CGRectMake(291, 130+(GAP)-(offSetShortCell*isShortCell), 21, 21)];
            [likes setFont:[UIFont fontWithName:@"Avenir-Roman" size:15.0]];
            likes.text = [NSNumber numberWithInteger:dealClass.dealAttrib.dealersThatLiked.count].stringValue;
            likes.backgroundColor = [UIColor clearColor];
            likes.textColor = [UIColor whiteColor];
            [likes sizeToFit];
            [[self scrollView] addSubview:likes];
        }
        
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
        [label2 setFont:[UIFont fontWithName:@"Avenir-Roman" size:14.0]];
        label2.text = [dealClass store].name;
        label2.backgroundColor = [UIColor clearColor];
        label2.textColor = [UIColor blackColor];
        [[self scrollView] addSubview:label2];
        
        if (dealClass.price.intValue > 0 && !(dealClass.discountValue.intValue > 0)) {
            UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(265, 169+(GAP)-(offSetShortCell*isShortCell), 53, 21)];
            [label3 setFont:[UIFont fontWithName:@"Avenir-Light" size:17.0]];
            label3.text = [dealClass.currency stringByAppendingString:dealClass.price.stringValue];
            label3.backgroundColor = [UIColor clearColor];
            label3.textColor = [UIColor blackColor];
            [label3 sizeToFit];
            label3.textAlignment = NSTextAlignmentRight;
            [[self scrollView] addSubview:label3];
        }
        
        if (dealClass.price.intValue > 0 && dealClass.discountValue.intValue > 0) {
            UILabel *label4=[[UILabel alloc]initWithFrame:CGRectMake(265, 169+(GAP)-(offSetShortCell*isShortCell), 53, 21)];
            [label4 setFont:[UIFont fontWithName:@"Avenir-Light" size:17.0]];
            label4.text = [[dealClass discountValue] stringValue];
            
            if ([dealClass.discountType isEqualToString:@"%"]) {
                label4.text = [dealClass.discountValue.stringValue stringByAppendingString:dealClass.discountType];
            } else if ([dealClass.discountType isEqualToString:@"lastPrice"]){
                NSDictionary* attributes = @{ NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle] };
                NSString *lastPriceDiscount = [dealClass.currency stringByAppendingString:dealClass.discountValue.stringValue];
                NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:lastPriceDiscount attributes:attributes];
                label4.attributedText = attrText;
            }
            
            label4.backgroundColor = [UIColor clearColor];
            label4.textColor = lightGray;
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
        
        if (!(dealClass.price.intValue > 0) && dealClass.discountValue.intValue > 0) {
            UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(265, 169+(GAP)-(offSetShortCell*isShortCell), 53, 21)];
            [label3 setFont:[UIFont fontWithName:@"Avenir-Light" size:17.0]];
            label3.text = [[dealClass discountValue] stringValue];

            if ([dealClass.discountType isEqualToString:@"%"]) {
                label3.text = [dealClass.discountValue.stringValue stringByAppendingString:dealClass.discountType];
            } else if ([dealClass.discountType isEqualToString:@"lastPrice"]){
                NSDictionary* attributes = @{ NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle] };
                NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:dealClass.discountValue.stringValue attributes:attributes];
                label3.attributedText = attrText;
            }
            
            label3.backgroundColor = [UIColor clearColor];
            label3.textColor = lightGray;
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
        
        Deal *deal = [self.deals objectAtIndex:i];
        
        NSString *downloadingFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"downloaded_image_%@.jpg", deal.dealID]];
        NSURL *downloadingFileURL = [NSURL fileURLWithPath:downloadingFilePath];
        
        AWSS3TransferManagerDownloadRequest *downloadRequest = [AWSS3TransferManagerDownloadRequest new];
                
        downloadRequest.bucket = @"dealers-app";
        downloadRequest.key = deal.photoURL1;
        downloadRequest.downloadingFileURL = downloadingFileURL;
        
        [[[AWSS3TransferManager defaultS3TransferManager] download:downloadRequest] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
            
            if (task.error){
                if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
                    switch (task.error.code) {
                        case AWSS3TransferManagerErrorCancelled:
                        case AWSS3TransferManagerErrorPaused:
                            break;
                            
                        default:
                            NSLog(@"Error: %@", task.error);
                            break;
                    }
                } else {
                    // Unknown error.
                    NSLog(@"Error: %@", task.error);
                }
            }
            
            if (task.result) {
                
                deal.photo1 = [UIImage imageWithContentsOfFile:downloadingFilePath];
                UIImageView *imageView = [[UIImageView alloc]initWithImage:deal.photo1];
                
                UIImageView *imageViewBackground = (UIImageView *)[self.scrollView viewWithTag:(i + 1) * imageViewBackgroundTag];
                [imageView setFrame:imageViewBackground.frame];
                
                CALayer *mask = [CALayer layer];
                mask.contents = (id)[[UIImage imageNamed:@"Deal Pic Mask"]CGImage];
                mask.frame = CGRectMake(0, 0, 300, 155);
                imageView.layer.mask = mask;
                imageView.layer.masksToBounds = YES;
                imageView.tag = (i + 1) * imageViewTag;
                imageView.alpha = 0;
                UIImageView *titlebackground = (UIImageView *)[self.scrollView viewWithTag:(i + 1) * titleBackgroundTag];
                [[self scrollView] insertSubview:imageView belowSubview:titlebackground];
                UIActivityIndicatorView *loading = (UIActivityIndicatorView *)[self.scrollView viewWithTag:(i + 1) * loadingIndicatorTag];
                
                [UIView animateWithDuration:0.5 animations:^{
                    loading.alpha = 0;
                    imageView.alpha = 1.0;
                } completion:^(BOOL finished){
                    [loading stopAnimating];
                }];
            }
            return nil;
        }];
        
        /*

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
         */
    } // End of for loop
    
    cellsNumbersInFillWithImages += numberOfDealsLoadingAtATime;
}

- (void)selectDealButtonClicked:(id)sender {
    
    ViewonedealViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"viewdeal"];
    UIButton *button = (UIButton *)sender;
    Deal *deal = [[Deal alloc]init];
    deal = [self.deals objectAtIndex:(button.tag)];
    controller.deal = deal;
    
    if (deal.photoURL1.length > 0) {
        controller.isShortCell = @"no";
    } else controller.isShortCell = @"yes";
    
    if ([deal.dealAttrib.dealersThatLiked containsObject:appDelegate.dealer.dealerID]) {
        
        controller.isDealLikedByUser = @"yes";
    } else {
        controller.isDealLikedByUser = @"no";
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
    
    if (deal.photoURL1.length > 0 && ![deal.photoURL1 isEqualToString:@"None"])
        deal.photoSum = @(deal.photoSum.intValue + 1);
    else
        return [NSNumber numberWithInt:0];
    
    if (deal.photoURL2.length > 0 && ![deal.photoURL2 isEqualToString:@"None"])
        deal.photoSum = @(deal.photoSum.intValue + 1);
    else
        return [NSNumber numberWithInt:1];
    
    if (deal.photoURL3.length > 0 && ![deal.photoURL3 isEqualToString:@"None"])
        deal.photoSum = @(deal.photoSum.intValue + 1);
    else
        return [NSNumber numberWithInt:2];
    
    if (deal.photoURL4.length > 0 && ![deal.photoURL4 isEqualToString:@"None"])
        deal.photoSum = @(deal.photoSum.intValue + 1);
    else
        return [NSNumber numberWithInt:3];
    
    return [NSNumber numberWithInt:4];
}

- (void)initializeView {
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    
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
    
    lightGray = [UIColor colorWithRed:140.0/255.0 green:140.0/255.0 blue:146.0/255.0 alpha:1.0];
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
    appDelegate.AfterAddDeal = @"yes";
    [self viewDidAppear:YES];
}

- (void)didReachFromRegisterOrAddDeal {
    
    if (![appDelegate.AfterAddDeal isEqualToString:@"no"]) {
        appDelegate.AfterAddDeal = @"no";
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
    
    if ([appDelegate.AfterAddDeal isEqualToString:@"yes"]) {
        appDelegate.AfterAddDeal = @"no";
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
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setFrame:CGRectMake(0, 0, 44.0, 44.0)];
        [button setBackgroundColor:[UIColor redColor]];
        [button addTarget:self action:@selector(pushDealsTableViewController) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationItem.titleView addSubview:button];
        [self.navigationItem.titleView setUserInteractionEnabled:YES];
    } else if ([selfViewController isEqualToString:@"Explore"]) {
        self.title = self.categoryFromExplore;
    }
    
    [self initializeView];
    [self allocArrays];
    [self removeCellsFromSuperview];
    [self setRefreshControl];
        
    CheckConnection *checkconnection = [[CheckConnection alloc]init];
    
    if ([checkconnection connected]){
        
        [self loadDeals];
//        [self loadDBandUpdateCells];
        
    } else {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection Error" message:@"Check Internet Connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    
//    [self setDummyDeals];
    [self setDateFormatter];

    [super viewDidLoad];
}

- (void)pushDealsTableViewController
{
    DealsTableViewController *dtvc = [self.storyboard instantiateViewControllerWithIdentifier:@"DealsID"];
    [self.navigationController pushViewController:dtvc animated:YES];
}

- (void)setDummyDeals
{
    for (int i = 0; i < 10; i++) {
        
        Deal *deal = [[Deal alloc]init];
        
        deal.title = @"Great Deal!";
        deal.store = [[Store alloc]init];
        deal.store.name = @"Macy's";
        deal.dealer = self.appDelegate.dealer;
//        deal.price = [NSNumber numberWithInt:55];
//        deal.currency = @"DO";
//        deal.discountValue = [NSNumber numberWithFloat:75];
//        deal.discountType = @"PE";
        deal.category = @"Electronics";
        deal.expiration = [NSDate date];
        deal.type = @"L";
        deal.photo1 = [UIImage imageNamed:@"WhatsApp Icon"];
        
        [self.deals addObject:deal];
    }
    [self createDealsTable];
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

@end


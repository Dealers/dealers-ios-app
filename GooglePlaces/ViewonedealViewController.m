//
//  ViewonedealViewController.m
//  GooglePlaces
//
//  Created by itzik berrebi on 9/26/13.
//
//

#import "ViewonedealViewController.h"
#import "ProfileTableViewController.h"
#import "ExploretableViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "ActivityTypeWhatsApp.h"
#import "CommentsTableViewController.h"

#define GAP 15
#define sectionGap 25
#define loadingIndicatorTag 1111
#define sharedViewTag 9898
#define REPORT_ALERT 43454

#define iconsLeftMargin 12
#define labelsLeftMargin 52
#define iconsLeftMarginSharedView 18
#define labelsLeftMarginSharedView 48

#define AWS_S3_BUCKET_NAME @"dealers-app"
#define NAME_FOR_NOTIFICATIONS @"View Deal Photos Notifications"
#define APPSTORE_LINK @"https://appsto.re/il/12CB5.i"

#define COMMENTS_OVERVIEW_BUTTON 123456789
#define COMMENTS_OVERVIEW_TITLE 987654321

@interface ViewonedealViewController ()

@end

@implementation ViewonedealViewController
@synthesize scroll;
@synthesize titlelabel;
@synthesize storelabel;
@synthesize categorylabel;
@synthesize pricelabel;
@synthesize discountlabel;
@synthesize expirelabel;
@synthesize descriptionlabel;
@synthesize likelabel;
@synthesize commentlabel;
@synthesize appDelegate;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialize];
    [self setNavigationBar];
    [self setProgressIndicator];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadPhotosToView:)
                                                 name:NAME_FOR_NOTIFICATIONS
                                               object:nil];
    
    if (!self.deal && self.dealID) {
        self.navigationItem.titleView.userInteractionEnabled = NO;
        [self downloadDeal];
    } else {
        [self setDealsDetails];
        [self loadViewDealPage];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.afterEditing || self.didChangesInComments) { // If the user edited the deal, then it should load iteself again in order to present the updated info.
        
        [self.scroll setNeedsLayout];
        
        [self initialize];
        [self loadViewDealPage];
    }
    
    if (self.tabBarController.tabBar.hidden == YES) {
        self.tabBarController.tabBar.hidden = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setSharedView];
    [self screenshotSharedView];
    
    UIButton *plusButton = (UIButton *)[self.tabBarController.view viewWithTag:123];
    
    [self performSelector:@selector(bringPlusButtonToFront:) withObject:plusButton afterDelay:0.01];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Check if should update the dealAttrib
    if (self.likeCounter.integerValue != self.deal.dealAttrib.dealersThatLiked.count) {
        
        NSMutableArray *dealersThatLikedArray = [[NSMutableArray alloc]initWithArray:self.deal.dealAttrib.dealersThatLiked];
        
        if (self.likeCounter.integerValue > dealersThatLikedArray.count) {
            
            // need to add the dealer's id to the likes array
            if (![dealersThatLikedArray containsObject:self.appDelegate.dealer.dealerID]) {
                
                [dealersThatLikedArray addObject:self.appDelegate.dealer.dealerID];
                shouldAddID = YES;
                
                [appDelegate sendNotificationOfType:@"Like" toRecipients:@[self.deal.dealer.dealerID] regardingTheDeal:self.deal.dealID];
                
            } else {
                
                NSLog(@"Something's wrong, the dealer's id is already in the dealersThatLikedArray");
            }
        } else if (self.likeCounter.integerValue < dealersThatLikedArray.count) {
            
            // need to remove the dealer's id from the likes array
            if ([dealersThatLikedArray containsObject:self.appDelegate.dealer.dealerID]) {
                
                [dealersThatLikedArray removeObject:self.appDelegate.dealer.dealerID];
                shouldRemoveID = YES;
                
            } else {
                
                NSLog(@"Something's wrong, the dealer's id wasn't in the dealersThatLikedArray");
            }
        }
        
        self.deal.dealAttrib.dealersThatLiked = dealersThatLikedArray;
        
        NSString *path = [NSString stringWithFormat:@"/dealattribs/%@/", self.deal.dealAttrib.dealAttribID];
        
        [[RKObjectManager sharedManager] patchObject:self.deal.dealAttrib
                                                path:path
                                          parameters:nil
                                             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                 
                                                 NSLog(@"Deal Attrib was updated successfuly!");
                                                 DealAttrib *dealAttrib = mappingResult.firstObject;
                                                 self.deal.dealAttrib = dealAttrib;
                                                 [self updateDealersLikedDealsArray];
                                             }
                                             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                 
                                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                                                                 message:nil
                                                                                                delegate:nil
                                                                                       cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                                                       otherButtonTitles:nil];
                                                 [alert show];
                                                 
                                                 NSMutableArray *dealersThatLikedArray = self.deal.dealAttrib.dealersThatLiked;
                                                 if (shouldAddID) {
                                                     [dealersThatLikedArray removeObject:self.appDelegate.dealer.dealerID];
                                                     shouldAddID = NO;
                                                     
                                                 } else if (shouldRemoveID) {
                                                     [dealersThatLikedArray addObject:self.appDelegate.dealer.dealerID];
                                                     shouldRemoveID = NO;
                                                 }
                                             }];
    }
    
    if (self.delegate) {
        [[self.delegate tableView] reloadRowsAtIndexPaths:@[self.dealIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)loadViewDealPage
{
    [self loadVarsFromDeal];
    [self setImagesSection];
    [self setPageControlView];
    [self setBasicDetailsSection];
    [self setDealerSection];
    [self setCommentsSection];
    [self setMapAndStoreInfo];
}

- (void)downloadDeal
{
    NSString *path = [NSString stringWithFormat:@"/alldeals/%@/", self.dealID];
    
    [self setLoadingView];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  NSLog(@"Deal downloaded successfuly!");
                                                  
                                                  self.deal = mappingResult.firstObject;
                                                  [self setDealsDetails];
                                                  [self loadViewDealPage];
                                                  [self stopLoadingAnimation];
                                                  self.navigationItem.titleView.userInteractionEnabled = YES;
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  
                                                  NSLog(@"Deal failed to download...");
                                                  
                                                  UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Error", nil)
                                                                                                 message:error.localizedDescription
                                                                                                delegate:nil
                                                                                       cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                                                       otherButtonTitles:nil];
                                                  [alert show];
                                                  [self stopLoadingAnimation];
                                              }];
}

- (void)setDealsDetails
{
    self.deal.photoSum = [appDelegate setPhotoSum:self.deal];
    
    if (self.deal.photoURL1.length > 1 && ![self.deal.photoURL1 isEqualToString:@"None"]) {
        self.isShortCell = @"no";
    } else self.isShortCell = @"yes";
    
    if ([self.deal.dealAttrib.dealersThatLiked containsObject:appDelegate.dealer.dealerID]) {
        self.isDealLikedByUser = @"yes";
    } else {
        self.isDealLikedByUser = @"no";
    }
}

- (void)setLoadingView
{
    loadingView = [[UIView alloc]initWithFrame:scroll.frame];
    
    loadingView.backgroundColor = [UIColor whiteColor];
    UIImageView *loadingAnimation = [appDelegate loadingAnimationPurple];
    loadingAnimation.tag = 4343434;
    [loadingAnimation startAnimating];
    loadingAnimation.frame = CGRectMake(self.view.center.x - 15.0, 15.0, 30.0, 30.0);
    [loadingView addSubview:loadingAnimation];
    [self.scroll addSubview:loadingView];
}

- (void)stopLoadingAnimation
{
    UIImageView *loadingAnimation = (UIImageView *)[loadingView viewWithTag:4343434];
    [loadingAnimation stopAnimating];
    [UIView animateWithDuration:0.3 animations:^{ loadingView.alpha = 0; }];
}

- (void)updateDealersLikedDealsArray
{
    if (shouldAddID) {
        NSMutableArray *likedDeals = [NSMutableArray arrayWithArray:appDelegate.dealer.likedDeals];
        [likedDeals addObject:self.deal.dealID];
        appDelegate.dealer.likedDeals = likedDeals;
    }
    
    if (shouldRemoveID) {
        
        for (NSNumber *dealID in self.appDelegate.dealer.likedDeals) {
            
            if (dealID.intValue == self.deal.dealID.intValue) {
                NSMutableArray *likedDeals = [NSMutableArray arrayWithArray:appDelegate.dealer.likedDeals];
                [likedDeals removeObject:dealID];
                appDelegate.dealer.likedDeals = likedDeals;
                break;
            }
        }
    }
    
    shouldAddID = NO;
    shouldRemoveID = NO;
}

- (void)bringPlusButtonToFront:(UIButton *)plusButton
{
    [self.tabBarController.view bringSubviewToFront:plusButton];
}

- (void)initialize
{
    self.appDelegate = [[UIApplication sharedApplication]delegate];
    
    [self setDateFormatter];
    
    self.scroll.frame = [[UIScreen mainScreen] bounds];
    
    self.afterEditing = NO;
    self.didChangesInComments = NO;
    shouldAddID = NO;
    shouldRemoveID = NO;
    
    textGray = [appDelegate textGrayColor];
}

- (void)setNavigationBar
{
    UIView *actionsTitleView = [[UIView alloc] init];
    actionsTitleView.frame = CGRectMake(0, 0, 130, 30);
    
    self.likeBarButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.likeBarButton setImage:[UIImage imageNamed:@"Like Bar Button"] forState:UIControlStateNormal];
    [self.likeBarButton setFrame:CGRectMake(0, 0, 30, 30)];
    [self.likeBarButton addTarget:self action:@selector(LikeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [actionsTitleView addSubview:self.likeBarButton];
    
    self.likeBarButtonSelected = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.likeBarButtonSelected setImage:[UIImage imageNamed:@"Like Bar Button Selected"] forState:UIControlStateNormal];
    [self.likeBarButtonSelected setFrame:CGRectMake(0, 0, 30, 30)];
    [self.likeBarButtonSelected addTarget:self action:@selector(LikeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.likeBarButtonSelected setHidden:YES];
    [actionsTitleView addSubview:self.likeBarButtonSelected];
    
    self.commentBarButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.commentBarButton setImage:[UIImage imageNamed:@"Comment Bar Button"] forState:UIControlStateNormal];
    [self.commentBarButton setFrame:CGRectMake(50, 0, 30, 30)];
    [self.commentBarButton addTarget:self action:@selector(CommentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [actionsTitleView addSubview:self.commentBarButton];
    
    self.shareBarButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.shareBarButton setImage:[UIImage imageNamed:@"Share Bar Button"] forState:UIControlStateNormal];
    [self.shareBarButton setFrame:CGRectMake(100, 0, 30, 30)];
    [self.shareBarButton addTarget:self action:@selector(ShareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [actionsTitleView addSubview:self.shareBarButton];
    
    self.navigationItem.titleView = actionsTitleView;
    
    UIBarButtonItem *options = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Options Button"]
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(optionsAction:)];
    [options setImageInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    self.navigationItem.rightBarButtonItem = options;
}

- (void)setDateFormatter
{
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
}

- (void)setPageControlView
{
    if ([[self.deal photoSum]intValue] >= 2) {
        self.pageControl.hidden = NO;
        lowestYPoint = CGRectGetMaxY(self.pageControl.frame) - 10;
    } else {
        self.pageControl.hidden = YES;
    }
    
    self.pageControl.numberOfPages = [[self.deal photoSum]intValue];
    [self.cameraScrollView setContentSize:((CGSizeMake(320 * [[self.deal photoSum] intValue], 217)))];
    [self.cameraScrollView setScrollEnabled:YES];
}

- (void)loadVarsFromDeal{
    
    titlelabel.text = [self.deal title];
    storelabel.text = self.deal.store != nil ? [NSLocalizedString(@"At ", nil) stringByAppendingString:self.deal.store.name] : @"No store";
    
    [self checkForUnconvertedKeys];
    
    pricelabel.text = self.deal.price != nil ? [self.deal.currency stringByAppendingString:self.deal.price.stringValue] : nil;
    discountlabel.text = self.deal.discountValue != nil ? [self.deal.discountValue stringValue] : nil;
    
    if (self.deal.category.length > 0 && ![self.deal.category isEqualToString:@"No Category"]) {
        
        categorylabel.text = [NSLocalizedString(@"In ", nil) stringByAppendingString:self.deal.category];
        
    } else
        categorylabel.text = nil;
    
    if (self.deal.expiration)
        expirelabel.text = [NSLocalizedString(@"Expires on ", nil) stringByAppendingString:[self.dateFormatter stringFromDate:self.deal.expiration]];
    else
        expirelabel.text = nil;
    
    if (self.deal.moreDescription.length > 0 && ![self.deal.moreDescription isEqualToString:@"None"])
        descriptionlabel.text = [NSLocalizedString(@"Description: ", nil) stringByAppendingString:self.deal.moreDescription];
    else
        descriptionlabel.text = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self deallocMapView];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Setting View's Sections

- (void)setImagesSection
{
    if ([self.isShortCell isEqualToString:@"yes"]) {
        self.cameraScrollView.hidden = YES;
        lowestYPoint = CGRectGetMaxY(self.expiredTag.frame) + 2.0;
        
    } else {
        self.captureImage.image = self.deal.photo1;
        lowestYPoint = CGRectGetMaxY(self.captureImage.frame) + 5;
        
        if (!self.captureImage.image) { // In case the photo didn't downloaded in the my feed yet.
            UIActivityIndicatorView *loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            loadingIndicator.center = self.captureImage.center;
            loadingIndicator.tag = loadingIndicatorTag;
            [loadingIndicator startAnimating];
            [self.cameraScrollView addSubview:loadingIndicator];
        }
        
        [self downloadImages];
    }
}

- (void)downloadImages
{
    if (self.deal.photoSum.intValue > 0) {
        
        // Download photos from S3
        AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
        
        for (int i = 0; i < self.deal.photoSum.intValue; i++) {
            
            NSString *downloadingFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:
                                             [NSString stringWithFormat:@"downloaded_image_%@_%i.jpg", self.deal.dealID, i + 1]];
            NSURL *downloadingFileURL = [NSURL fileURLWithPath:downloadingFilePath];
            NSString *key;
            UIImageView *captureImage;
            UIActivityIndicatorView *loadingIndicator;
            
            switch (i) {
                    
                case 0:
                    if (self.deal.photo1) {
                        // The deal's photo is already inserted in the capture image view.
                        continue;
                    }
                    key = self.deal.photoURL1;
                    captureImage = self.captureImage;
                    loadingIndicator = (UIActivityIndicatorView *)[self.cameraScrollView viewWithTag:loadingIndicatorTag];
                    break;
                case 1:
                    if (self.deal.photo2) {
                        self.captureImage2.image = self.deal.photo2;
                        self.captureImage2.alpha = 1.0;
                        [self.imageLoading2 stopAnimating];
                        continue;
                    }
                    key = self.deal.photoURL2;
                    captureImage = self.captureImage2;
                    loadingIndicator = self.imageLoading2;
                    break;
                case 2:
                    if (self.deal.photo3) {
                        self.captureImage3.image = self.deal.photo3;
                        self.captureImage3.alpha = 1.0;
                        [self.imageLoading3 stopAnimating];
                        continue;
                    }
                    key = self.deal.photoURL3;
                    captureImage = self.captureImage3;
                    loadingIndicator = self.imageLoading3;
                    break;
                case 3:
                    if (self.deal.photo4) {
                        self.captureImage4.image = self.deal.photo4;
                        self.captureImage4.alpha = 1.0;
                        [self.imageLoading4 stopAnimating];
                        continue;
                    }
                    key = self.deal.photoURL4;
                    captureImage = self.captureImage4;
                    loadingIndicator = self.imageLoading4;
                    break;
                    
                default:
                    break;
            }
            
            AWSS3TransferManagerDownloadRequest *downloadRequest = [AWSS3TransferManagerDownloadRequest new];
            downloadRequest.bucket = AWS_S3_BUCKET_NAME;
            downloadRequest.key = key;
            downloadRequest.downloadingFileURL = downloadingFileURL;
            
            [[transferManager download:downloadRequest] continueWithExecutor:[BFExecutor mainThreadExecutor]
                                                                   withBlock:^id(BFTask *task) {
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
                                                                               
                                                                               [UIView animateWithDuration:0.5 animations:^{
                                                                                   [loadingIndicator stopAnimating];
                                                                                   captureImage.alpha = 1;
                                                                               }];
                                                                           }
                                                                       }
                                                                       
                                                                       if (task.result) {
                                                                           
                                                                           __block UIImage *dealPhoto = [UIImage imageWithContentsOfFile:downloadingFilePath];
                                                                           captureImage.image = dealPhoto;
                                                                           captureImage.alpha = 0;
                                                                           [UIView animateWithDuration:0.5 animations:^{
                                                                               [loadingIndicator stopAnimating];
                                                                               captureImage.alpha = 1;
                                                                           }];
                                                                           
                                                                           switch (i) {
                                                                               case 0:
                                                                                   self.deal.photo1 = dealPhoto;
                                                                                   break;
                                                                               case 1:
                                                                                   self.deal.photo2 = dealPhoto;
                                                                                   break;
                                                                               case 2:
                                                                                   self.deal.photo3 = dealPhoto;
                                                                                   break;
                                                                               case 3:
                                                                                   self.deal.photo4 = dealPhoto;
                                                                                   break;
                                                                                   
                                                                               default:
                                                                                   break;
                                                                           }
                                                                       }
                                                                       
                                                                       return nil;
                                                                   }];
        }
    }
}

- (void)setBasicDetailsSection
{
    if ([self.isDealLikedByUser isEqualToString:@"yes"]) {
        
        self.likeBarButton.hidden = YES;
        self.likeBarButtonSelected.hidden = NO;
    } else {
        self.likeBarButton.hidden = NO;
        self.likeBarButtonSelected.hidden = YES;
    }
    
    UIFont *font = titlelabel.font;
    
    NSDictionary *attributes = @{NSFontAttributeName : font};
    CGSize boundingRect = CGSizeMake(self.view.bounds.size.width - 40,MAXFLOAT);
    CGRect titleLabelBounds = [titlelabel.text boundingRectWithSize:boundingRect
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:attributes
                                                            context:nil];
    
    titlelabel.frame = CGRectMake(iconsLeftMargin,
                                  lowestYPoint + GAP,
                                  self.view.frame.size.width - iconsLeftMargin * 2,
                                  titleLabelBounds.size.height);
    titlelabel.numberOfLines = 0;
    titlelabel.textAlignment = NSTextAlignmentCenter;
    
    lowestYPoint = CGRectGetMaxY(titlelabel.frame);
    
    CGFloat fieldsWidth = self.view.frame.size.width - labelsLeftMargin - 10;
    
    self.StoreIcon.frame = CGRectMake(iconsLeftMargin, lowestYPoint + GAP + 5, self.StoreIcon.frame.size.width, self.StoreIcon.frame.size.height);
    storelabel.frame = CGRectMake(labelsLeftMargin, lowestYPoint + 3 + GAP + 5, fieldsWidth, storelabel.frame.size.height);
    
    // Toggle the store icon
    UIButton *toggleStoreIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    [toggleStoreIcon setFrame:self.StoreIcon.frame];
    [toggleStoreIcon addTarget:self action:@selector(toggleStoreIcon) forControlEvents:UIControlEventTouchUpInside];
    [self.scroll addSubview:toggleStoreIcon];
    
    if ([[_deal type] isEqualToString:@"online"]) {
        _urlSiteButton.frame = CGRectMake(labelsLeftMargin, lowestYPoint+3+GAP, storelabel.frame.size.width, storelabel.frame.size.height);
    } else _urlSiteButton.hidden=YES;
    
    lowestYPoint = (CGRectGetMaxY(self.StoreIcon.frame) > CGRectGetMaxY(storelabel.frame)) ? CGRectGetMaxY(self.StoreIcon.frame) : CGRectGetMaxY(storelabel.frame);
    
    maxXPoint = 50;
    
    if (self.deal.price.intValue > 0) {
        
        self.pricelabel.hidden = NO;
        
        self.PriceIcon.frame = CGRectMake(iconsLeftMargin, lowestYPoint + GAP, self.PriceIcon.frame.size.width, self.PriceIcon.frame.size.height);
        pricelabel.frame = CGRectMake(maxXPoint, lowestYPoint+3+GAP, pricelabel.frame.size.width, pricelabel.frame.size.height);
        [pricelabel sizeToFit];
        maxXPoint = CGRectGetMaxX (pricelabel.frame) + 20;
    } else {
        pricelabel.hidden = YES;
    }
    
    if (self.deal.discountValue.intValue > 0) {
        
        self.discountlabel.hidden = NO;
        
        if ([self.deal.discountType isEqualToString:@"%"]) {
            discountlabel.text = [discountlabel.text stringByAppendingString:@"%"];
        } else {
            NSDictionary* attributes = @{ NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle] };
            NSString *lastPriceDiscount = [self.deal.currency stringByAppendingString:self.deal.discountValue.stringValue];
            NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:lastPriceDiscount attributes:attributes];
            discountlabel.attributedText = attrText;
        }
        self.PriceIcon.frame = CGRectMake(iconsLeftMargin, lowestYPoint + GAP, self.PriceIcon.frame.size.width, self.PriceIcon.frame.size.height);
        discountlabel.frame = CGRectMake(maxXPoint, lowestYPoint+3+GAP, discountlabel.frame.size.width, discountlabel.frame.size.height);
        [discountlabel sizeToFit];
        lowestYPoint=(CGRectGetMaxY(self.PriceIcon.frame) > CGRectGetMaxY(discountlabel.frame)) ? CGRectGetMaxY(self.PriceIcon.frame) : CGRectGetMaxY(discountlabel.frame);
    } else {
        discountlabel.hidden = YES;
        if (self.deal.price.intValue > 0) {
            lowestYPoint=(CGRectGetMaxY(self.PriceIcon.frame) > CGRectGetMaxY(pricelabel.frame)) ? CGRectGetMaxY(self.PriceIcon.frame) : CGRectGetMaxY(pricelabel.frame);
        }
    }
    if ((pricelabel.hidden == YES) && (discountlabel.hidden == YES)) {
        self.PriceIcon.hidden = YES;
    } else {
        self.PriceIcon.hidden = NO;
    }
    if (pricelabel.hidden == YES && discountlabel.hidden == NO) {
        self.PriceIcon.image = [UIImage imageNamed:@"Discount Icon"];
    } else {
        self.PriceIcon.image = [UIImage imageNamed:@"Price Icon"];
    }
    
    if (self.categorylabel.text.length > 0 && [self.categorylabel.text rangeOfString:@"No Category"].location == NSNotFound) {
        
        self.CategoryIcon.hidden = NO;
        self.categorylabel.hidden = NO;
        
        self.CategoryIcon.frame = CGRectMake(iconsLeftMargin, lowestYPoint + GAP, self.CategoryIcon.frame.size.width, self.CategoryIcon.frame.size.height);
        categorylabel.frame = CGRectMake(labelsLeftMargin, lowestYPoint + 3 + GAP, fieldsWidth, categorylabel.frame.size.height);
        lowestYPoint = (CGRectGetMaxY(self.CategoryIcon.frame) > CGRectGetMaxY(categorylabel.frame)) ? CGRectGetMaxY(self.CategoryIcon.frame) : CGRectGetMaxY(categorylabel.frame);
    } else {
        categorylabel.hidden=YES;
        self.CategoryIcon.hidden=YES;
    }
    
    if (![expirelabel.text isEqualToString:@"0000-00-00 00:00:00"] && ![expirelabel.text isEqualToString:@"0"] && expirelabel.text.length > 0) {
        
        self.ExpireIcon.hidden = NO;
        self.expirelabel.hidden = NO;
        
        self.ExpireIcon.frame = CGRectMake(iconsLeftMargin, lowestYPoint + GAP, self.ExpireIcon.frame.size.width, self.ExpireIcon.frame.size.height);
        self.expirelabel.frame = CGRectMake(labelsLeftMargin, lowestYPoint+3+GAP, fieldsWidth, expirelabel.frame.size.height);
        lowestYPoint=(CGRectGetMaxY(self.ExpireIcon.frame) > CGRectGetMaxY(expirelabel.frame)) ? CGRectGetMaxY(self.ExpireIcon.frame) : CGRectGetMaxY(expirelabel.frame);
        
        // Checking if the deal expired. But first, get rid of the old red background if exists.
        
        if ([self.scroll viewWithTag:321232123]) {
            [[self.scroll viewWithTag:321232123] removeFromSuperview];
        }
        
        if ([appDelegate didDealExpired:self.deal]) {
            [self setExpiredDeal];
        } else {
            self.expiredTag.hidden = YES;
        }
        
    } else {
        expirelabel.hidden = YES;
        self.ExpireIcon.hidden = YES;
    }
    
    if (descriptionlabel.text.length > 0 && ![descriptionlabel.text isEqualToString:@"None"]) {
        
        self.DescriptionIcon.hidden = NO;
        self.descriptionlabel.hidden = NO;
        
        descriptionlabel.numberOfLines = 0;
        [descriptionlabel sizeToFit];
        self.DescriptionIcon.frame = CGRectMake(iconsLeftMargin, lowestYPoint + GAP, self.DescriptionIcon.frame.size.width, self.DescriptionIcon.frame.size.height);
        descriptionlabel.frame = CGRectMake(labelsLeftMargin, lowestYPoint+3+GAP, fieldsWidth, descriptionlabel.frame.size.height);
        lowestYPoint = (CGRectGetMaxY(self.DescriptionIcon.frame) > CGRectGetMaxY(descriptionlabel.frame)) ? CGRectGetMaxY(self.DescriptionIcon.frame) : CGRectGetMaxY(descriptionlabel.frame);
    } else {
        descriptionlabel.hidden = YES;
        self.DescriptionIcon.hidden = YES;
    }
    
    
    NSInteger x = self.deal.dealAttrib.dealersThatLiked.count;
    NSInteger y = self.deal.dealAttrib.dealersThatShared.count;
    
    self.likeCounter = [NSNumber numberWithInteger:x];
    self.shareCounter = [NSNumber numberWithInteger:y];
    
    if (self.likeCounter.intValue > 0) {
        
        self.likesCountImage.frame = CGRectMake(iconsLeftMargin + 6,
                                                lowestYPoint + sectionGap,
                                                self.likesCountImage.frame.size.width,
                                                self.likesCountImage.frame.size.height);
        self.likesCountLabel.frame = CGRectMake(labelsLeftMargin,
                                                self.likesCountImage.frame.origin.y,
                                                self.likesCountLabel.frame.size.width,
                                                self.likesCountLabel.frame.size.height);
        
        if (self.likeCounter.intValue == 1) {
            self.likesCountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"1 person likes this deal", nil)];
        } else {
            self.likesCountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@ people like this deal", nil), self.likeCounter];
        }
        
        UIButton *likersButton = [UIButton buttonWithType:UIButtonTypeCustom];
        likersButton.frame = self.likesCountLabel.frame;
        [likersButton addTarget:self action:@selector(presentLikers) forControlEvents:UIControlEventTouchUpInside];
        [self.scroll addSubview:likersButton];
        
        lowestYPoint = CGRectGetMaxY(self.likesCountImage.frame);
        
    } else {
        self.likesCountImage.hidden = YES;
        self.likesCountLabel.hidden = YES;
    }
}

- (void)setExpiredDeal
{
    self.expiredTag.layer.cornerRadius = 5.0;
    self.expiredTag.layer.masksToBounds = YES;
    self.expiredTag.layer.borderWidth = 1.5;
    self.expiredTag.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.expiredTag.text = NSLocalizedString(@"Expired", nil);
    self.expiredTag.hidden = NO;
    
    CGFloat x = iconsLeftMargin / 2;
    CGFloat y = self.ExpireIcon.frame.origin.y - GAP / 2;
    CGFloat width = self.view.frame.size.width - x * 2;
    CGFloat height = self.ExpireIcon.frame.size.height + GAP;
    
    UIView *expiredBackground = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    expiredBackground.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:59.0/255.0 blue:48.0/255.0 alpha:0.2];
    expiredBackground.layer.cornerRadius = 8.0;
    expiredBackground.layer.masksToBounds = YES;
    expiredBackground.tag = 321232123;
    [self.scroll insertSubview:expiredBackground belowSubview:self.ExpireIcon];
    
    self.expirelabel.text = [NSLocalizedString(@"Expired on ", nil) stringByAppendingString:[self.dateFormatter stringFromDate:self.deal.expiration]];
}

- (void)toggleStoreIcon
{
    if ([self.StoreIcon.image isEqual:[UIImage imageNamed:@"Store Icon"]]) {
        
        [UIView animateWithDuration:0.3
                         animations:^{ self.StoreIcon.transform = CGAffineTransformMakeScale(0.1, 0.1); }
                         completion:^(BOOL finished) {
                             self.StoreIcon.image = [UIImage imageNamed:@"Store Icon 2"];
                             [UIView animateWithDuration:0.3
                                              animations:^{ self.StoreIcon.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                              }];
                         }];
    } else {
        
        [UIView animateWithDuration:0.3
                         animations:^{ self.StoreIcon.transform = CGAffineTransformMakeScale(0.1, 0.1); }
                         completion:^(BOOL finished) {
                             self.StoreIcon.image = [UIImage imageNamed:@"Store Icon"];
                             [UIView animateWithDuration:0.3
                                              animations:^{ self.StoreIcon.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                              }];
                         }];
    }
}

- (void)setDealerSection
{
    CGRect dealerSectionFrame = self.dealerSection.frame;
    dealerSectionFrame.origin.y = lowestYPoint;
    self.dealerSection.frame = dealerSectionFrame;
    lowestYPoint = (CGRectGetMaxY(self.dealerSection.frame));
    
    Dealer *dealer = self.deal.dealer;
    
    self.dealerImagePlaceholder.layer.cornerRadius = self.dealerImagePlaceholder.frame.size.width / 2;
    self.dealerImagePlaceholder.layer.masksToBounds = YES;
    self.dealerImage.layer.cornerRadius = self.dealerImage.frame.size.width / 2;
    self.dealerImage.layer.masksToBounds = YES;
    
    self.dealersNameLabel.text = dealer.fullName;
    
    if (self.deal.uploadDate) {
        self.uploadDateLabel.text = [NSLocalizedString(@"Uploaded on ", nil) stringByAppendingString:[self.dateFormatter stringFromDate:self.deal.uploadDate]];
    }
    
    if (!self.dealerImage.image) {
        
        if (self.deal.dealer.dealerID.intValue == appDelegate.dealer.dealerID.intValue) {
            self.deal.dealer = self.appDelegate.dealer;
            self.dealerImage.image = [appDelegate myProfilePic];
        } else {
            [appDelegate otherProfilePic:self.deal.dealer forTarget:@"Deal Dealer's Photo" notificationName:NAME_FOR_NOTIFICATIONS atIndexPath:nil];
        }
    }
}

- (void)setCommentsSection
{
    CGFloat sectionHeight = sectionGap * 2 + 10;
    
    if (self.commentsSection) {
        
        [self.commentsSection removeFromSuperview];
        self.commentsSection = nil;
    }
    
    self.commentsSection = [[UIView alloc]init];
    
    [self loadPreviewWithLastThreeComments];
    [self setCommentsOverview];
    [self setCommentsTableViewAtPoint: sectionGap * 2];
    
    sectionHeight += self.commentsTableView.contentSize.height + 10;
    
    self.commentsSection.frame = CGRectMake(0,
                                            lowestYPoint,
                                            self.view.frame.size.width,
                                            sectionHeight);
    
    self.commentsSection.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self.scroll addSubview:self.commentsSection];
    
    lowestYPoint = CGRectGetMaxY(self.commentsSection.frame);
}

- (void)presentLikers
{
    DealersTableViewController *dtvc = [self.storyboard instantiateViewControllerWithIdentifier:@"DealersTableViewController"];
    dtvc.mode = @"Likers";
    dtvc.dealID = self.deal.dealID;
    [self.navigationController pushViewController:dtvc animated:YES];
}

- (void)setCommentsOverview
{
    // first check if there are old elements, and if so get rid of them
    if ([self.commentsSection viewWithTag:COMMENTS_OVERVIEW_BUTTON]) {
        
        [[self.commentsSection viewWithTag:COMMENTS_OVERVIEW_BUTTON] removeFromSuperview];
    }
    
    if ([self.commentsSection viewWithTag:COMMENTS_OVERVIEW_TITLE]) {
        
        [[self.commentsSection viewWithTag:COMMENTS_OVERVIEW_TITLE] removeFromSuperview];
    }
    
    CGRect overviewFrame = CGRectMake(iconsLeftMargin,
                                      sectionGap,
                                      self.view.frame.size.width - iconsLeftMargin * 2,
                                      19);
    UIFont *font = [UIFont fontWithName:@"Avenir-Roman" size:18.0];
    UIColor *color = [appDelegate darkTextGrayColor];
    
    
    if (self.deal.comments.count > 3) {
        
        UIButton *commentsOverview = [UIButton buttonWithType:UIButtonTypeSystem];
        [commentsOverview setFrame:overviewFrame];
        NSString *buttonTitle = [NSString stringWithFormat:NSLocalizedString(@"View all %@ comments", nil), [NSNumber numberWithUnsignedInteger:self.deal.comments.count]];
        [commentsOverview setTitle:buttonTitle forState:UIControlStateNormal];
        commentsOverview.titleLabel.font = font;
        commentsOverview.tintColor = color;
        [commentsOverview addTarget:self action:@selector(CommentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        commentsOverview.tag = COMMENTS_OVERVIEW_BUTTON;
        
        [self.commentsSection addSubview:commentsOverview];
        
    } else {
        
        UILabel *commentsTitle = [[UILabel alloc]initWithFrame:overviewFrame];
        commentsTitle.text = NSLocalizedString(@"Comments", nil);
        commentsTitle.font = font;
        commentsTitle.textColor = color;
        commentsTitle.textAlignment = NSTextAlignmentCenter;
        commentsTitle.tag = COMMENTS_OVERVIEW_TITLE;
        
        [self.commentsSection addSubview:commentsTitle];
    }
}

- (void)setCommentsTableViewAtPoint:(CGFloat)originPoint
{
    if (self.commentsTableView) {
        
        [self.commentsTableView removeFromSuperview];
        self.commentsTableView = nil;
    }
    
    self.commentsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, originPoint, self.view.frame.size.width, 0) style:UITableViewStylePlain];
    self.commentsTableView.delegate = self;
    self.commentsTableView.dataSource = self;
    self.commentsTableView.backgroundColor = [UIColor clearColor];
    self.commentsTableView.rowHeight = 64.0;
    self.commentsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    static NSString *cellIdentifier = @"CommentsTableCell";
    [self.commentsTableView registerNib:[UINib nibWithNibName:@"CommentsTableCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    
    [self.commentsTableView reloadData];
    
    [self setTableViewHeight];
    
    [self.commentsSection addSubview:self.commentsTableView];
}

- (void)setTableViewHeight
{
    CGRect tableFrame = self.commentsTableView.frame;
    tableFrame.size = self.commentsTableView.contentSize;
    self.commentsTableView.frame = tableFrame;
}

- (void)setMapAndStoreInfo
{
    if (self.mapAndStoreSection) {
        
        [self.mapAndStoreSection removeFromSuperview];
        self.mapAndStoreSection = nil;
    }
    
    self.mapAndStoreSection = [[UIView alloc]initWithFrame:CGRectMake(0, lowestYPoint + sectionGap, self.view.frame.size.width, 500)];
    [self.scroll addSubview:self.mapAndStoreSection];
    
    if (self.deal.store.latitude.doubleValue != 0) {
        
        self.mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 240)];
        
        lastCoords.latitude = [self.deal.store.latitude doubleValue];
        lastCoords.longitude = [self.deal.store.longitude doubleValue];
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        span.latitudeDelta = 0.01;     // 0.0 is min value u van provide for zooming
        span.longitudeDelta = 0.01;
        region.span = span;
        region.center = lastCoords;     // to locate to the center
        [self.mapView setRegion:region animated:NO];
        [self.mapView regionThatFits:region];
        
        // Adding the circle which shows the specific location
        MKCircle *circle = [MKCircle circleWithCenterCoordinate:region.center radius:100];
        [self.mapView addOverlay:circle];
        
        UIImageView *mapSnapshot = [[UIImageView alloc]initWithFrame:self.mapView.frame];
        [self.mapAndStoreSection addSubview:mapSnapshot];
        
        MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
        options.region = self.mapView.region;
        options.size = self.mapView.frame.size;
        
        MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:options];
        [snapshotter startWithCompletionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
            
            CGPoint center = [snapshot pointForCoordinate:region.center];
            UIView *circle = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
            circle.center = center;
            circle.backgroundColor = [UIColor colorWithRed:150.0/255.0 green:0.0/255.0 blue:180.0/255.0 alpha:0.3];
            circle.layer.borderColor = [[UIColor colorWithRed:150.0/255.0 green:0.0/255.0 blue:180.0/255.0 alpha:0.6]CGColor];
            circle.layer.borderWidth = 1.0;
            circle.layer.cornerRadius = circle.frame.size.width / 2;
            circle.layer.masksToBounds = YES;
            
            mapSnapshot.image = snapshot.image;
            [mapSnapshot addSubview:circle];
            mapSnapshot.alpha = 0;
            [UIView animateWithDuration:0.3 animations:^{ mapSnapshot.alpha = 1.0; }];
            
        }];
        
        lowestYPoint = CGRectGetMaxY(mapSnapshot.frame);
        
        UILabel *storeTitle = [[UILabel alloc]init];
        UIFont *font = [UIFont fontWithName:@"Avenir-Roman" size:18.0];
        [storeTitle setFont:font];
        storeTitle.text = self.deal.store.name;
        storeTitle.numberOfLines = 0;
        
        NSDictionary *attributes = @{NSFontAttributeName : font};
        CGSize boundingRect = CGSizeMake(self.view.bounds.size.width - 40,MAXFLOAT);
        CGRect storeTitleBounds = [storeTitle.text boundingRectWithSize:boundingRect
                                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                             attributes:attributes
                                                                context:nil];
        storeTitle.frame = CGRectMake(20, lowestYPoint + GAP, self.view.bounds.size.width - 40, storeTitleBounds.size.height);
        storeTitle.textColor = [UIColor blackColor];
        storeTitle.textAlignment = NSTextAlignmentCenter;
        [self.mapAndStoreSection addSubview:storeTitle];
        lowestYPoint = CGRectGetMaxY(storeTitle.frame);
        
        if (self.deal.store.address.length > 1 && ![self.deal.store.address isEqualToString:@"None"]) {
            
            UILabel *storeAddress = [[UILabel alloc]init];
            UIFont *font = [UIFont fontWithName:@"Avenir-Roman" size:16.0];
            [storeAddress setFont:font];
            storeAddress.text = self.deal.store.address;
            
            if (self.deal.store.city.length > 0 && ![self.deal.store.city isEqualToString:@"None"]) {
                
                NSString *cityAddition = [NSString stringWithFormat:@", %@", self.deal.store.city];
                storeAddress.text = [storeAddress.text stringByAppendingString:cityAddition];
            }
            
            storeAddress.numberOfLines = 2;
            
            NSDictionary *attributes = @{NSFontAttributeName : font};
            CGSize boundingRect = CGSizeMake(self.view.bounds.size.width - 40,MAXFLOAT);
            CGRect storeAddressBounds = [storeAddress.text boundingRectWithSize:boundingRect
                                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                                     attributes:attributes
                                                                        context:nil];
            
            storeAddress.frame = CGRectMake(20, lowestYPoint + 6, self.view.bounds.size.width - 40, storeAddressBounds.size.height);
            storeAddress.textColor = textGray;
            storeAddress.textAlignment = NSTextAlignmentCenter;
            [self.mapAndStoreSection addSubview:storeAddress];
            lowestYPoint = CGRectGetMaxY(storeAddress.frame);
        }
        
        if (self.deal.store.url.length > 1 && ![self.deal.store.url isEqualToString:@"None"]) {
            
            UIImageView *storeWebsiteIcon = [[UIImageView alloc]initWithFrame:CGRectMake(iconsLeftMargin + 7, lowestYPoint + sectionGap + 1, 20, 20)];
            storeWebsiteIcon.image = [UIImage imageNamed:@"Store Website Icon"];
            [self.mapAndStoreSection addSubview:storeWebsiteIcon];
            
            UITextView *storeWebsite = [[UITextView alloc]initWithFrame:CGRectMake(labelsLeftMargin,
                                                                                   lowestYPoint + sectionGap,
                                                                                   self.view.bounds.size.width - labelsLeftMargin * 2 + 5,
                                                                                   20)];
            storeWebsite.textContainerInset = UIEdgeInsetsZero;
            storeWebsite.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
            storeWebsite.editable = NO;
            storeWebsite.textContainer.maximumNumberOfLines = 1;
            storeWebsite.scrollEnabled = NO;
            storeWebsite.dataDetectorTypes = UIDataDetectorTypeAll;
            [storeWebsite setFont:[UIFont fontWithName:@"Avenir-Roman" size:16.0]];
            storeWebsite.textColor = textGray;
            storeWebsite.textAlignment = NSTextAlignmentCenter;
            storeWebsite.text = self.deal.store.url;
            [self.mapAndStoreSection addSubview:storeWebsite];
            lowestYPoint = CGRectGetMaxY(storeWebsite.frame);
        }
        
        if (self.deal.store.phone.length > 1 && ![self.deal.store.phone isEqualToString:@"None"]) {
            
            UIImageView *storePhoneIcon = [[UIImageView alloc]initWithFrame:CGRectMake(iconsLeftMargin + 7, lowestYPoint + sectionGap + 1, 20, 20)];
            storePhoneIcon.image = [UIImage imageNamed:@"Store Phone Icon"];
            [self.mapAndStoreSection addSubview:storePhoneIcon];
            
            UITextView *storePhone = [[UITextView alloc]initWithFrame:CGRectMake(labelsLeftMargin,
                                                                                 lowestYPoint + sectionGap,
                                                                                 self.view.bounds.size.width - labelsLeftMargin * 2,
                                                                                 20)];
            storePhone.textContainerInset = UIEdgeInsetsZero;
            storePhone.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
            storePhone.editable = NO;
            storePhone.textContainer.maximumNumberOfLines = 1;
            storePhone.scrollEnabled = NO;
            storePhone.dataDetectorTypes = UIDataDetectorTypeAll;
            [storePhone setFont:[UIFont fontWithName:@"Avenir-Roman" size:16.0]];
            storePhone.textColor = textGray;
            storePhone.textAlignment = NSTextAlignmentCenter;
            storePhone.text = self.deal.store.phone;
            [self.mapAndStoreSection addSubview:storePhone];
            lowestYPoint = CGRectGetMaxY(storePhone.frame);
        }
        
        UIButton *wazeButton = [appDelegate actionButton];
        CGFloat buttonCenterY = lowestYPoint + wazeButton.frame.size.height/2 + sectionGap;
        wazeButton.center = CGPointMake(self.view.center.x, buttonCenterY);
        wazeButton.alpha = 0.9;
        [wazeButton setTitle:NSLocalizedString(@"Navigate via Waze", nil) forState:UIControlStateNormal];
        [wazeButton setImageEdgeInsets:UIEdgeInsetsMake(0, -4.0, 0, 4.0)];
        [wazeButton.titleLabel setFont:[UIFont fontWithName:@"Avenir-Roman" size:18.0]];
        [wazeButton.layer setCornerRadius:8.0];
        [wazeButton.layer setMasksToBounds:YES];
        [wazeButton.layer setBorderWidth:1.5];
        [wazeButton.layer setBorderColor:[[UIColor colorWithRed:150.0/255.0 green:0/255.0 blue:180.0/255.0 alpha:0.9] CGColor]];
        [wazeButton addTarget:self action:@selector(connectToWaze) forControlEvents: UIControlEventTouchUpInside];
        [self.mapAndStoreSection addSubview:wazeButton];
        
        UIImageView *wazeButtonIcon = [[UIImageView alloc] initWithFrame:CGRectMake(6.0, 2.0, 40.0, 40.0)];
        [wazeButtonIcon setImage:[UIImage imageNamed:@"Waze Button Icon"]];
        [wazeButton addSubview:wazeButtonIcon];
        
        self.mapAndStoreSection.frame = CGRectMake(self.mapAndStoreSection.frame.origin.x,
                                                   self.mapAndStoreSection.frame.origin.y,
                                                   self.mapAndStoreSection.frame.size.width,
                                                   CGRectGetMaxY(wazeButton.frame) + sectionGap);
        lowestYPoint = CGRectGetMaxY(self.mapAndStoreSection.frame);
        [self setScrollSize];
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKCircleRenderer *circleView = [[MKCircleRenderer alloc]initWithCircle:overlay];
    circleView.fillColor = [UIColor colorWithRed:150.0/255.0 green:0.0/255.0 blue:180.0/255.0 alpha:0.4];
    circleView.strokeColor = [UIColor colorWithRed:150.0/255.0 green:0.0/255.0 blue:180.0/255.0 alpha:0.8];
    circleView.lineWidth = 2;
    
    return circleView;
}

- (void)connectToWaze
{
    if ([[UIApplication sharedApplication]
         canOpenURL:[NSURL URLWithString:@"waze://"]]) {
        // Waze is installed. Launch Waze and start navigation
        NSString *urlStr =
        [NSString stringWithFormat:@"waze://?ll=%f,%f&navigate=yes",self.deal.store.latitude.doubleValue, self.deal.store.longitude.doubleValue];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    } else {
        // Waze is not installed. Launch AppStore to install Waze app
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/id323229106"]];
    }
}

- (void)setSharedView
{
    CGFloat screenWidth = self.view.frame.size.width;
    
    UIView *sharedView = [[UIView alloc]initWithFrame:CGRectMake(0, lowestYPoint + 1000, screenWidth, self.view.frame.size.width)];
    sharedView.backgroundColor = [UIColor whiteColor];
    sharedView.tag = sharedViewTag;
    [self.scroll addSubview:sharedView];
    
    // Setting the shared view content:
    
    UIImageView *dealPic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, self.captureImage.frame.size.height)];
    dealPic.contentMode = UIViewContentModeScaleAspectFill;
    [sharedView addSubview:dealPic];
    
    if (self.deal.photo1) {
        
        dealPic.image = self.deal.photo1;
        
    } else {
        
        dealPic.backgroundColor = [DealTableViewCell randomBackgroundColors:self.deal.photoURL1];
        
        UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"White Logo"]];
        CGSize logoSize = CGSizeMake(45.0, 64.0);
        CGFloat x = sharedView.center.x - logoSize.width / 2;
        CGFloat y = 52.0;
        logo.frame = CGRectMake(x, y, logoSize.width, logoSize.height);
        
        [sharedView addSubview:logo];
    }
    
    CGFloat titleBackgroundHeight = 78.0;
    UIImageView *titleBackground = [[UIImageView alloc]initWithFrame:CGRectMake(0, dealPic.frame.size.height - titleBackgroundHeight, screenWidth, titleBackgroundHeight)];
    titleBackground.image = [UIImage imageNamed:@"Title Background"];
    
    if (self.deal.photo1) {
        titleBackground.alpha = 0.75;
    } else {
        titleBackground.alpha = 0;
    }
    
    [sharedView addSubview:titleBackground];
    
    CGFloat titleLabelHeight = 48.0;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(iconsLeftMarginSharedView,
                                                                   dealPic.frame.size.height - titleLabelHeight - 5,
                                                                   screenWidth - iconsLeftMarginSharedView * 2,
                                                                   titleLabelHeight)];
    titleLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.numberOfLines = 2;
    titleLabel.text = self.titlelabel.text;
    [sharedView addSubview:titleLabel];
    
    CGFloat detailsVerticalGap = 9.0;
    CGFloat detailsLowestYPoint;
    CGSize iconSize = CGSizeMake(22.0, 22.0);
    CGSize labelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - labelsLeftMarginSharedView - iconsLeftMarginSharedView, 22.0);
    CGFloat priceXPoint = labelsLeftMarginSharedView;
    UIColor *detailsTextColor = textGray;
    BOOL hasPriceOrDiscount = NO;
    
    UIImageView *storeIcon = [[UIImageView alloc]initWithFrame:CGRectMake(iconsLeftMarginSharedView,
                                                                          dealPic.frame.size.height + detailsVerticalGap,
                                                                          iconSize.width,
                                                                          iconSize.height)];
    storeIcon.image = [UIImage imageNamed:@"Store Icon"];
    [sharedView addSubview:storeIcon];
    
    UILabel *storeLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelsLeftMarginSharedView,
                                                                   storeIcon.frame.origin.y,
                                                                   labelSize.width,
                                                                   labelSize.height)];
    storeLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:15.0];
    storeLabel.textColor = detailsTextColor;
    storeLabel.numberOfLines = 1;
    storeLabel.text = self.storelabel.text;
    [sharedView addSubview:storeLabel];
    
    detailsLowestYPoint = CGRectGetMaxY(storeIcon.frame);
    
    if (self.pricelabel.text.length > 0 || self.discountlabel.text.length > 0) {
        
        hasPriceOrDiscount = YES;
        
        UIImageView *priceIcon = [[UIImageView alloc] initWithFrame:CGRectMake(iconsLeftMarginSharedView,
                                                                               detailsLowestYPoint + detailsVerticalGap,
                                                                               iconSize.width,
                                                                               iconSize.height)];
        priceIcon.image = self.PriceIcon.image;
        [sharedView addSubview:priceIcon];
        
        if (self.pricelabel.text.length > 0) {
            
            UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelsLeftMarginSharedView,
                                                                            priceIcon.frame.origin.y,
                                                                            self.pricelabel.frame.size.width,
                                                                            priceIcon.frame.size.height)];
            priceLabel.text = self.pricelabel.text;
            priceLabel.font = [UIFont fontWithName:@"Avenir-Light" size:17.0];
            [priceLabel sizeToFit];
            priceLabel.center = priceIcon.center;
            CGRect priceLabelFrame = priceLabel.frame;
            priceLabelFrame.origin.x = labelsLeftMarginSharedView;
            priceLabel.frame = priceLabelFrame;
            
            priceLabel.textColor = [UIColor blackColor];
            priceLabel.numberOfLines = 1;
            [sharedView addSubview:priceLabel];
            
            priceXPoint = CGRectGetMaxX(priceLabel.frame) + 20;
        }
        
        if (self.discountlabel.text.length > 0) {
            
            UILabel *discountLabel = [[UILabel alloc]initWithFrame:CGRectMake(priceXPoint,
                                                                              priceIcon.frame.origin.y,
                                                                              self.pricelabel.frame.size.width,
                                                                              priceIcon.frame.size.height)];
            if ([self.deal.discountType isEqualToString:@"lastPrice"]) {
                discountLabel.attributedText = self.discountlabel.attributedText;
            } else {
                discountLabel.text = self.discountlabel.text;
            }
            discountLabel.font = [UIFont fontWithName:@"Avenir-Light" size:17.0];
            [discountLabel sizeToFit];
            discountLabel.center = priceIcon.center;
            CGRect discountLabelFrame = discountLabel.frame;
            discountLabelFrame.origin.x = priceXPoint;
            discountLabel.frame = discountLabelFrame;
            
            discountLabel.textColor = detailsTextColor;
            discountLabel.numberOfLines = 1;
            [sharedView addSubview:discountLabel];
        }
        
        detailsLowestYPoint = CGRectGetMaxY(priceIcon.frame);
        
    }
    
    if (self.deal.store.address.length > 1 && ![self.deal.store.address isEqualToString:@"None"]) {
        
        UIImageView *addressIcon = [[UIImageView alloc] initWithFrame:CGRectMake(iconsLeftMarginSharedView,
                                                                                 detailsLowestYPoint + detailsVerticalGap,
                                                                                 iconSize.width,
                                                                                 iconSize.height)];
        addressIcon.image = [UIImage imageNamed:@"Address Icon"];
        [sharedView addSubview:addressIcon];
        
        UILabel *addressLabel = [[UILabel alloc] init];
        addressLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:15.0];
        addressLabel.textColor = detailsTextColor;
        addressLabel.text = self.deal.store.address;
        
        if (self.deal.store.city.length > 0 && ![self.deal.store.city isEqualToString:@"None"]) {
            NSString *cityAddition = [NSString stringWithFormat:@", %@", self.deal.store.city];
            addressLabel.text = [addressLabel.text stringByAppendingString:cityAddition];
        }
        
        CGSize addressLabelSize;
        
        if (hasPriceOrDiscount) {
            addressLabelSize = labelSize;
            addressLabel.numberOfLines = 1;
        } else {
            NSDictionary *attributes = @{NSFontAttributeName : addressLabel.font};
            CGSize boundingRect = CGSizeMake(labelSize.width, MAXFLOAT);
            CGRect addressLabelBounds = [addressLabel.text boundingRectWithSize:boundingRect
                                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                                     attributes:attributes
                                                                        context:nil];
            addressLabelSize = addressLabelBounds.size;
            addressLabel.numberOfLines = 2;
        }
        
        addressLabel.frame = CGRectMake(labelsLeftMarginSharedView, addressIcon.frame.origin.y + 2, addressLabelSize.width, addressLabelSize.height);
        
        [sharedView addSubview:addressLabel];        
    }
    
//    if (![expirelabel.text isEqualToString:@"0000-00-00 00:00:00"] && ![expirelabel.text isEqualToString:@"0"] && expirelabel.text.length > 0) {
//        
//        UIImageView *expirationIcon = [[UIImageView alloc]initWithFrame:CGRectMake(iconsLeftMarginSharedView,
//                                                                                   detailsLowestYPoint + detailsVerticalGap,
//                                                                                   self.ExpireIcon.frame.size.width,
//                                                                                   self.ExpireIcon.frame.size.height)];
//        expirationIcon.image = [UIImage imageNamed:@"Expiration Date Icon"];
//        [sharedView addSubview:expirationIcon];
//        
//        UILabel *expirationLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelsLeftMarginSharedView,
//                                                                            expirationIcon.frame.origin.y,
//                                                                            self.expirelabel.frame.size.width - 18.0,
//                                                                            expirationIcon.frame.size.height)];
//        expirationLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
//        expirationLabel.textColor = detailsTextColor;
//        expirationLabel.numberOfLines = 1;
//        expirationLabel.text = self.expirelabel.text;
//        [sharedView addSubview:expirationLabel];
//    }
}

- (void)setScrollSize
{
    [scroll setContentSize:CGSizeMake(320, lowestYPoint)];
}


#pragma mark - Actions

- (IBAction)LikeButtonAction:(id)sender
{
    if (self.likeBarButtonSelected.hidden) {
        
        self.likeBarButtonSelected.hidden = NO;
        self.likeBarButtonSelected.alpha = 0;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.likeBarButtonSelected.transform = CGAffineTransformMakeScale(0.3, 0.3);
            self.likeBarButtonSelected.transform = CGAffineTransformMakeScale(1.0, 1.0);
            self.likeBarButtonSelected.alpha = 1.0;
        } completion:^(BOOL finished) {
            self.likeBarButton.hidden = YES;
        }];
        
        self.likeCounter = [NSNumber numberWithInt:self.likeCounter.intValue + 1];
        
    } else {
        
        self.likeBarButton.hidden = NO;
        self.likeBarButton.alpha = 1.0;
        
        [UIView animateWithDuration:0.15 animations:^{
            self.likeBarButtonSelected.alpha = 0;
        } completion:^(BOOL finished) {
            self.likeBarButtonSelected.hidden = YES;
        }];
        
        self.likeCounter = [NSNumber numberWithInt:self.likeCounter.intValue - 1];
    }
    
    if (self.likeCounter.intValue == 1) {
        self.likesCountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"1 person likes this deal", nil)];
    } else {
        self.likesCountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@ people like this deal", nil), self.likeCounter];
    }
}

- (IBAction)CommentButtonAction:(id)sender {
    
    CommentsTableViewController *ctvc = [self.storyboard instantiateViewControllerWithIdentifier:@"Comments"];
    ctvc.comments = self.deal.comments;
    ctvc.deal = self.deal;
    [ctvc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:ctvc animated:YES];
    
    UIButton *senderButton = (UIButton *)sender;
    
    if (senderButton.tag == COMMENTS_OVERVIEW_BUTTON) {
        ctvc.isKeyboardReady = NO;
    } else {
        ctvc.isKeyboardReady = YES;
    }
}

- (IBAction)ShareButtonAction:(id)sender {
    
    NSString *messageText = [NSString stringWithFormat:NSLocalizedString(@"Hear from others about great deals at Dealers: %@", nil), APPSTORE_LINK];
    NSArray *activityItems = @[self.sharedImage, messageText];
    NSArray *excludedActivities = @[UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeSaveToCameraRoll];
    
    ActivityTypeWhatsApp *whatsappActivity = [[ActivityTypeWhatsApp alloc]init];
    NSArray *appActivities = @[whatsappActivity];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:appActivities];
    
    activityController.excludedActivityTypes = excludedActivities;
    
    __weak ViewonedealViewController *weakSelf = self;
    
    [activityController setCompletionHandler:^(NSString *activityType, BOOL completed) {
        
        if (completed) {
            
            if ([activityType isEqualToString:@"WhatsApp Sharing"]) {
                [weakSelf whatsAppShare];
            }
            
            // need to add the dealer's id to the shares array
            NSMutableArray *dealersThatSharedArray = [[NSMutableArray alloc] initWithArray:self.deal.dealAttrib.dealersThatShared];
            
            if (![dealersThatSharedArray containsObject:appDelegate.dealer.dealerID]) {
                
                [dealersThatSharedArray addObject:appDelegate.dealer.dealerID];
                [appDelegate sendNotificationOfType:@"Share" toRecipients:@[self.deal.dealer.dealerID] regardingTheDeal:self.deal.dealID];
                self.deal.dealAttrib.dealersThatShared = dealersThatSharedArray;
                
                NSString *path = [NSString stringWithFormat:@"/dealattribs/%@/", self.deal.dealAttrib.dealAttribID];
                
                [[RKObjectManager sharedManager] patchObject:self.deal.dealAttrib
                                                        path:path
                                                  parameters:nil
                                                     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                         
                                                         NSLog(@"Deal Attrib was updated successfuly!");
                                                         DealAttrib *dealAttrib = mappingResult.firstObject;
                                                         self.deal.dealAttrib = dealAttrib;
                                                     }
                                                     failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                         
                                                         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                         [alert show];
                                                     }];
            }
            
        } else {
            NSLog(@"Activity view controller dismissed");
        }
    }];
    
    [self presentViewController:activityController animated:YES completion:nil];
}

- (void)optionsAction:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:NSLocalizedString(@"Edit Deal", nil), NSLocalizedString(@"Report as Spam", nil), nil];
    
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (IBAction)dealerProfileButtonClicked:(id)sender {
    
    ProfileTableViewController *ptvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileID"];
    ptvc.dealer = self.deal.dealer;
    ptvc.dealer.photo = UIImageJPEGRepresentation(self.dealerImage.image, 1.0);
    [self.navigationController pushViewController:ptvc animated:YES];
}

- (void)commenterProfileButtonClicked:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    Comment *comment = [self.commentsForPreview objectAtIndex:button.tag];
    ProfileTableViewController *ptvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileID"];
    ptvc.dealerID = comment.dealer.dealerID;
    [self.navigationController pushViewController:ptvc animated:YES];
}


#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.commentsTableView) {
        
        if (self.deal.comments.count <= 3) {
            
            self.commentsPreviewCount = [NSNumber numberWithLong:self.deal.comments.count].integerValue + 1;
            return self.commentsPreviewCount; // The +1 is for the add comment button.
            
        } else {
            
            self.commentsPreviewCount = 4;
            return self.commentsPreviewCount;
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.commentsTableView) {
        
        if (self.commentsPreviewCount - 1 != indexPath.row) {
            
            static NSString *commentsTableCellIdentifier = @"CommentsTableCell";
            CommentTableViewCell *cell = (CommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:commentsTableCellIdentifier];
            Comment *comment = [self.commentsForPreview objectAtIndex:indexPath.row];
            
            if (!cell) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommentsTableCell" owner:nil options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            if (comment.dealer.dealerID.intValue == self.appDelegate.dealer.dealerID.intValue) {
                cell.dealerProfilePic.alpha = 1.0;
                [cell.dealerProfilePic setImage:[appDelegate myProfilePic] forState:UIControlStateNormal];
            } else if (!comment.dealer.photo) {
                if (!comment.dealer.downloadingPhoto) {
                    cell.dealerProfilePic.alpha = 0;
                    comment.dealer.downloadingPhoto = YES;
                    [appDelegate otherProfilePic:comment.dealer forTarget:@"Commenter's Photo" notificationName:NAME_FOR_NOTIFICATIONS atIndexPath:indexPath];
                }
            } else {
                cell.dealerProfilePic.alpha = 1.0;
                [cell.dealerProfilePic setImage:[UIImage imageWithData:comment.dealer.photo] forState:UIControlStateNormal];
            }
            
            [cell.dealerProfilePic setTag:indexPath.row];
            [cell.dealerProfilePic addTarget:self action:@selector(commenterProfileButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.dealerName setTitle:comment.dealer.fullName forState:UIControlStateNormal];
            [cell.dealerName setTag:indexPath.row];
            [cell.dealerName addTarget:self action:@selector(commenterProfileButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.commentDate.text = [comment.dateFormatter stringFromDate:comment.uploadDate];
            cell.commentBody.text = comment.text;
            
            [cell.contentView layoutIfNeeded];
            
            NSLog(@"\n\nComment body size: %f, %f", cell.commentBody.frame.size.width, cell.commentBody.frame.size.height);
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
            
        } else {
            
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            
            cell.backgroundColor = [UIColor clearColor];
            
            UIImageView *yourCommentProfilePic = [[UIImageView alloc] initWithFrame:CGRectMake(iconsLeftMargin, 12, 40, 40)];
            yourCommentProfilePic.image = [appDelegate myProfilePic];
            yourCommentProfilePic.layer.cornerRadius = yourCommentProfilePic.frame.size.width / 2;
            yourCommentProfilePic.layer.masksToBounds = YES;
            yourCommentProfilePic.contentMode = UIViewContentModeScaleAspectFill;
            [cell.contentView addSubview:yourCommentProfilePic];
            
            CGFloat x = 58;
            CGFloat y = 12;
            CGFloat width = 244;
            CGFloat height = 39;
            
            UIView *addCommentBackground = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
            addCommentBackground.backgroundColor = [UIColor whiteColor];
            addCommentBackground.layer.cornerRadius = 8.0;
            addCommentBackground.layer.masksToBounds = YES;
            
            [cell.contentView addSubview:addCommentBackground];
            
            UILabel *addCommentTitle = [[UILabel alloc] initWithFrame:CGRectMake(x + 8, y, width - 8 * 2, height)];
            addCommentTitle.textColor = textGray;
            addCommentTitle.font = [UIFont fontWithName:@"Avenir-Roman" size:16.0];
            
            if (self.deal.comments.count == 0) {
                addCommentTitle.text = NSLocalizedString(@"Be the first to comment...", nil);
            } else {
                addCommentTitle.text = NSLocalizedString(@"Add a comment...", nil);
            }
            
            [cell.contentView addSubview:addCommentTitle];
            
            UIButton *addComment = [UIButton buttonWithType:UIButtonTypeCustom];
            [addComment setFrame:addCommentBackground.frame];
            [addComment setBackgroundColor:[UIColor clearColor]];
            [addComment addTarget:self action:@selector(CommentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:addComment];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.separatorInset = UIEdgeInsetsMake(0, [[UIScreen mainScreen]bounds].size.width * 2, 0, 0);
            
            return cell;
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.commentsTableView) {
        
        if (self.commentsPreviewCount - 1 > indexPath.row) { // Checking if the indexPath represents the last row (add comment field). If so, skip.
            
            Comment *comment = [self.commentsForPreview objectAtIndex:indexPath.row];
            
            self.cellPrototype.commentBody.text = comment.text;
            
            CGFloat commentBodyHeight = [self labelHeight:self.cellPrototype.commentBody];
            
            return MAX(commentBodyHeight, tableView.rowHeight);
            
        } else {
            
            return tableView.rowHeight;
        }
        
    } else {
        return tableView.rowHeight;
    }
}

- (CGFloat)labelHeight:(UILabel *)label
{
    NSDictionary *attributes = @{NSFontAttributeName : label.font};
    CGSize boundingRect = CGSizeMake(250.0f, 0);
    CGRect commentBodyFrame = [self.cellPrototype.commentBody.text boundingRectWithSize:boundingRect
                                                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                                             attributes:attributes
                                                                                context:nil];
    
    label.frame = CGRectMake(label.frame.origin.x,
                             label.frame.origin.y,
                             label.frame.size.width,
                             commentBodyFrame.size.height);
    
    // Calculate cell height
    CGFloat height = 12.0f + self.cellPrototype.dealerName.frame.size.height + 6.0f + 12.0f + commentBodyFrame.size.height;
    
    return height;
}

- (void)loadPreviewWithLastThreeComments
{
    self.commentsForPreview = [[NSMutableArray alloc]init];
    
    if (self.deal.comments.count > 3) {
        
        NSInteger count = self.deal.comments.count - 1;
        
        Comment *comment1 = [self.deal.comments objectAtIndex:count - 2];
        Comment *comment2 = [self.deal.comments objectAtIndex:count - 1];
        Comment *comment3 = [self.deal.comments objectAtIndex:count];
        
        [self.commentsForPreview addObject:comment1];
        [self.commentsForPreview addObject:comment2];
        [self.commentsForPreview addObject:comment3];
        
    } else {
        
        self.commentsForPreview = self.deal.comments;
    }
}


#pragma mark - General Methods

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = self.cameraScrollView.frame.size.width;
    currentpage = floor((self.cameraScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = currentpage;
}

- (void)checkForUnconvertedKeys
{
    if (self.deal.category.length == 2) {
        
        self.deal.category = [appDelegate getCategoryValueForKey:self.deal.category];
    }
    
    if (self.deal.currency.length == 2) {
        
        self.deal.currency = [appDelegate getCurrencySign:self.deal.currency];
    }
    
    if (self.deal.discountType.length == 2) {
        
        self.deal.discountType = [appDelegate getDiscountType:self.deal.discountType];
    }
}

- (void)loadPhotosToView:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    
    if ([[info objectForKey:@"target"] isEqualToString:@"Deal Dealer's Photo"]) {
        
        self.dealerImage.alpha = 0;
        self.dealerImage.image = [info objectForKey:@"image"];
        [UIView animateWithDuration:0.3 animations:^{
            self.dealerImage.alpha = 1;
        }];
        
    } else if ([[info objectForKey:@"target"] isEqualToString:@"Commenter's Photo"]) {
        
        NSArray *indexPathes = [self.commentsTableView indexPathsForVisibleRows];
        
        NSIndexPath *receivedIndexPath = [info objectForKey:@"indexPath"];
        
        for (int i = 0; i < indexPathes.count; i++) {
            
            if ([indexPathes[i] isEqual:receivedIndexPath]) {
                
                CommentTableViewCell *cell = (CommentTableViewCell *)[self.commentsTableView cellForRowAtIndexPath:indexPathes[i]];
                
                if ([cell isMemberOfClass:[CommentTableViewCell class]]) {
                    [cell.dealerProfilePic setImage:[info objectForKey:@"image"] forState:UIControlStateNormal];
                    [UIView animateWithDuration:0.3 animations:^{ cell.dealerProfilePic.alpha = 1.0; }];
                    break;
                }
            }
        }
    }
}

- (void)deallocMapView {
    switch (_mapView.mapType) {
        case MKMapTypeHybrid:
        {
            _mapView.mapType = MKMapTypeStandard;
        }
            
            break;
        case MKMapTypeStandard:
        {
            _mapView.mapType = MKMapTypeHybrid;
        }
            
            break;
        default:
            break;
    }
    
    [_mapView removeFromSuperview];
    _mapView.showsUserLocation = NO;
    _mapView=nil;
}

- (void)screenshotSharedView
{
    self.sharedImage = [[UIImage alloc]init];
    
    UIView *sharedView = [self.scroll viewWithTag:sharedViewTag];
    
    CGRect screenShotRect = sharedView.bounds;
    
    UIGraphicsBeginImageContextWithOptions(sharedView.bounds.size, YES, 0.0);
    [sharedView drawViewHierarchyInRect:screenShotRect afterScreenUpdates:YES];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    //    NSData *screenshotData = UIImagePNGRepresentation(screenshot);
    UIGraphicsEndImageContext();
    
    self.sharedImage = screenshot;
}

- (void)whatsAppShare
{
    if ([[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"whatsapp://app"]]){
        
        UIImage     * iconImage = self.sharedImage;
        NSString    * savePath  = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/whatsAppTmp.wai"];
        
        [UIImageJPEGRepresentation(iconImage, 1.0) writeToFile:savePath atomically:YES];
        
        _documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:savePath]];
        _documentInteractionController.UTI = @"net.whatsapp.image";
        _documentInteractionController.delegate = self;
        
        [_documentInteractionController presentOpenInMenuFromRect:CGRectMake(0, 0, 0, 0) inView:self.scroll animated:YES];
        
        
    } else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"WhatsApp not installed.", nil)
                                                         message:NSLocalizedString(@"Your device should have WhatsApp installed.", nil)
                                                        delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                               otherButtonTitles:nil];
        [alert show];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: { // Edit Deal:
            UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"EditDeal"];
            EditDealTableViewController *edtvc = (EditDealTableViewController *)[navigationController topViewController];
            edtvc.deal = self.deal;
            edtvc.delegate = self;
            if (self.deal.dealer.dealerID.intValue == appDelegate.dealer.dealerID.intValue || appDelegate.dealer.dealerID.intValue == 1) {
                edtvc.canDeleteDeal = YES;
            } else {
                edtvc.canDeleteDeal = NO;
            }
            
            [self presentViewController:navigationController animated:YES completion:nil];
        }
            break;
            
        case 1: { // Report as Spam:
            
            UIAlertView *reportAsSpam = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Report as Spam?", nil)
                                                                   message:NSLocalizedString(@"Does this post includes inappropriate content?", nil)
                                                                  delegate:self
                                                         cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                         otherButtonTitles:NSLocalizedString(@"Report", nil), nil];
            reportAsSpam.tag = REPORT_ALERT;
            [reportAsSpam show];
        }
            break;
            
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == REPORT_ALERT) {
        if (buttonIndex == 1) {
            
            Report *report = [[Report alloc] init];
            
            report.dealID = self.deal.dealID;
            report.reportingDealerID = appDelegate.dealer.dealerID;
            report.report = @"Spam";
            
            [[RKObjectManager sharedManager] postObject:report
                                                   path:@"/reportdeals/"
                                             parameters:nil
                                                success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                    
                                                    NSLog(@"Report sent successfuly!");
                                                    
                                                    [reportSent show:YES];
                                                    [reportSent hide:YES afterDelay:1.5];
                                                }
                                                failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                    
                                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                                                                    message:nil
                                                                                                   delegate:nil
                                                                                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                                                          otherButtonTitles:nil];
                                                    [alert show];
                                                }];
        }
    }
}

- (void)setProgressIndicator
{
    reportSent = [[MBProgressHUD alloc]initWithView:self.tabBarController.view];
    reportSent.delegate = self;
    reportSent.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Complete"]];
    reportSent.mode = MBProgressHUDModeCustomView;
    reportSent.labelText = NSLocalizedString(@"Report Sent", nil);
    reportSent.labelFont = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    reportSent.animationType = MBProgressHUDAnimationZoomIn;
    
    [self.tabBarController.view addSubview:reportSent];
}


@end
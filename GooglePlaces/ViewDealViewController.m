//
//  ViewDealViewController.m
//  Dealers
//
//  Created by Gilad Lumbroso on 3/12/15.
//
//

#import "ViewDealViewController.h"

#define AWS_S3_BUCKET_NAME @"dealers-app"
#define NAME_FOR_NOTIFICATIONS @"View Deal Photos Notifications"
#define APPSTORE_LINK @"https://appsto.re/il/12CB5.i"
#define SHARED_VIEW 9898
#define REPORT_ALERT 43454
#define COMMENTS_OVERVIEW_BUTTON 123456789

static CGFloat const iconHeight = 30.0;
static CGFloat const iconsVerticalSpace = 12.0;
static CGFloat const iconsLeftMargin = 15.0;
static CGFloat const iconsLeftMarginSharedView = 18.0;
static CGFloat const labelsLeftMarginSharedView = 48.0;
static NSString * const commentCellIdentifier = @"CommentTableViewCell";

@implementation ViewDealViewController

@synthesize appDelegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialize];
    [self setNavigationBar];
    [self setProgressIndicator];
    [self registerForNotifications];
    
    if (!self.deal && self.dealID) {
        self.navigationItem.titleView.userInteractionEnabled = NO;
        [self downloadDeal];
    } else {
        self.navigationItem.titleView.userInteractionEnabled = YES;
        [self setDealDetails];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self checkIfDealLikedByUser];
    
    if (self.didChangesInComments) {
        [self configureCommentsPreviewTableView];
        [self.view layoutIfNeeded];
        self.didChangesInComments = NO;
    }
    
    if (self.afterEditing) {
        [self setDealDetails];
        self.afterEditing = NO;
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
        
        NSMutableArray *dealersThatLikedArray = [[NSMutableArray alloc] initWithArray:self.deal.dealAttrib.dealersThatLiked];
        
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

- (void)initialize
{
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imagesScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self setDateFormatter];
    
    self.afterEditing = NO;
    self.didChangesInComments = NO;
    shouldAddID = NO;
    shouldRemoveID = NO;
    self.screenName = @"View Deal";
    
    textGray = [appDelegate textGrayColor];
}

- (void)setDateFormatter
{
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
}

- (void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadPhotosToView:)
                                                 name:NAME_FOR_NOTIFICATIONS
                                               object:nil];
}

- (void)setNavigationBar
{
    UIView *actionsTitleView = [[UIView alloc] init];
    actionsTitleView.frame = CGRectMake(0, 0, 130, 30);
    actionsTitleView.translatesAutoresizingMaskIntoConstraints = YES;
    
    self.likeBarButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.likeBarButton setImage:[UIImage imageNamed:@"Like Bar Button"] forState:UIControlStateNormal];
    [self.likeBarButton setFrame:CGRectMake(0, 0, 30, 30)];
    [self.likeBarButton addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
    [actionsTitleView addSubview:self.likeBarButton];
    
    self.likeBarButtonSelected = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.likeBarButtonSelected setImage:[UIImage imageNamed:@"Like Bar Button Selected"] forState:UIControlStateNormal];
    [self.likeBarButtonSelected setFrame:CGRectMake(0, 0, 30, 30)];
    [self.likeBarButtonSelected addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
    [self.likeBarButtonSelected setHidden:YES];
    [actionsTitleView addSubview:self.likeBarButtonSelected];
    
    self.commentBarButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.commentBarButton setImage:[UIImage imageNamed:@"Comment Bar Button"] forState:UIControlStateNormal];
    [self.commentBarButton setFrame:CGRectMake(50, 0, 30, 30)];
    [self.commentBarButton addTarget:self action:@selector(comment:) forControlEvents:UIControlEventTouchUpInside];
    [actionsTitleView addSubview:self.commentBarButton];
    
    self.shareBarButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.shareBarButton setImage:[UIImage imageNamed:@"Share Bar Button"] forState:UIControlStateNormal];
    [self.shareBarButton setFrame:CGRectMake(100, 0, 30, 30)];
    [self.shareBarButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [actionsTitleView addSubview:self.shareBarButton];
    
    self.navigationItem.titleView = actionsTitleView;
    
    UIBarButtonItem *options = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Options Button"]
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(options:)];
    [options setImageInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    self.navigationItem.rightBarButtonItem = options;
}

- (void)checkIfDealLikedByUser
{
    if ([self.deal.dealAttrib.dealersThatLiked containsObject:appDelegate.dealer.dealerID]) {
        self.isDealLikedByUser = YES;
    } else {
        self.isDealLikedByUser = NO;
    }
    
    if (self.isDealLikedByUser) {
        self.likeBarButton.hidden = YES;
        self.likeBarButtonSelected.hidden = NO;
    } else {
        self.likeBarButton.hidden = NO;
        self.likeBarButtonSelected.hidden = YES;
    }
}

- (void)downloadDeal
{
    NSString *path = [NSString stringWithFormat:@"/alldeals/%@/", self.dealID];
    
    [self startLoadingAnimation];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:path
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  NSLog(@"Deal downloaded successfuly!");
                                                  
                                                  self.deal = mappingResult.firstObject;
                                                  [self setDealDetails];
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

- (void)startLoadingAnimation
{
    self.whiteLoadingBackground = [[UIView alloc] initWithFrame:self.view.frame];
    self.whiteLoadingBackground.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.whiteLoadingBackground];
    self.loadingAnimation = [appDelegate loadingAnimationPurple];
    self.loadingAnimation.frame = CGRectMake(self.view.center.x - 15.0, 15.0, 30.0, 30.0);
    [self.loadingAnimation startAnimating];
    [self.whiteLoadingBackground addSubview:self.loadingAnimation];
}

- (void)stopLoadingAnimation
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.loadingAnimation.transform = CGAffineTransformMakeScale(0.001, 0.001);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.3
                                          animations:^{
                                              self.whiteLoadingBackground.alpha = 0;
                                          }
                                          completion:^(BOOL finished) {
                                              [self.loadingAnimation stopAnimating];
                                              self.loadingAnimation.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                          }];
                     }];
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


#pragma mark - Setting Deal's Deatils

- (void)setDealDetails
{
    [self configureImagesScrollView];
    [self setBasicDetails];
    [self setLikesCounter];
    [self setDealerSection];
    [self configureCommentsPreviewTableView];
    [self setMapAndStoreDetails];
    
    [self.view layoutIfNeeded];
}

- (void)configureImagesScrollView
{
    self.photosURLArray = [appDelegate photosURLArray:self.deal];
    [self setImagesScrollViewSize];
    [self setImagesContentViewWidth];
    [self downloadImages];
    [self setPageControl];
}

- (void)setImagesScrollViewSize
{
    self.imagesScrollViewWidthConstraint.constant = self.view.bounds.size.width;
    
    if (self.photosURLArray.count == 0) {
        self.imagesScrollViewHeightConstraint.constant = 0;
    } else {
        self.imagesScrollViewHeightConstraint.constant = self.view.bounds.size.width * 0.678125; // 217:320 ratio
        self.capturedImage1.image = self.deal.photo1;
    }
}

- (void)setImagesContentViewWidth
{
    CGFloat screenWidth = self.view.bounds.size.width;
    self.imagesContentViewWidthConstraint.constant = screenWidth * self.photosURLArray.count;
}

- (void)downloadImages
{
    if (self.photosURLArray.count > 0) {
        
        // Download photos from S3
        AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
        
        for (int i = 0; i < self.photosURLArray.count; i++) {
            
            NSString *downloadingFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:
                                             [NSString stringWithFormat:@"downloaded_image_%@_%i.jpg", self.deal.dealID, i + 1]];
            NSURL *downloadingFileURL = [NSURL fileURLWithPath:downloadingFilePath];
            NSString *key;
            UIImageView *capturedImage;
            UIActivityIndicatorView *loadingIndicator;
            
            switch (i) {
                    
                case 0:
                    if (self.deal.photo1) {
                        // The deal's photo is already inserted in the capture image view.
                        continue;
                    }
                    key = self.deal.photoURL1;
                    capturedImage = self.capturedImage1;
                    loadingIndicator = self.loadingIndicator1;
                    break;
                case 1:
                    if (self.deal.photo2) {
                        self.capturedImage2.image = self.deal.photo2;
                        self.capturedImage2.alpha = 1.0;
                        [self.loadingIndicator2 stopAnimating];
                        continue;
                    }
                    key = self.deal.photoURL2;
                    capturedImage = self.capturedImage2;
                    loadingIndicator = self.loadingIndicator2;
                    break;
                case 2:
                    if (self.deal.photo3) {
                        self.capturedImage3.image = self.deal.photo3;
                        self.capturedImage3.alpha = 1.0;
                        [self.loadingIndicator3 stopAnimating];
                        continue;
                    }
                    key = self.deal.photoURL3;
                    capturedImage = self.capturedImage3;
                    loadingIndicator = self.loadingIndicator3;
                    break;
                case 3:
                    if (self.deal.photo4) {
                        self.capturedImage4.image = self.deal.photo4;
                        self.capturedImage4.alpha = 1.0;
                        [self.loadingIndicator4 stopAnimating];
                        continue;
                    }
                    key = self.deal.photoURL4;
                    capturedImage = self.capturedImage4;
                    loadingIndicator = self.loadingIndicator4;
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
                                                                                   capturedImage.alpha = 1;
                                                                               }];
                                                                           }
                                                                       }
                                                                       
                                                                       if (task.result) {
                                                                           
                                                                           __block UIImage *dealPhoto = [UIImage imageWithContentsOfFile:downloadingFilePath];
                                                                           capturedImage.image = dealPhoto;
                                                                           capturedImage.alpha = 0;
                                                                           [UIView animateWithDuration:0.5 animations:^{
                                                                               [loadingIndicator stopAnimating];
                                                                               capturedImage.alpha = 1;
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

- (void)setPageControl
{
    self.pageControl.numberOfPages = self.photosURLArray.count;
    if (self.pageControl.numberOfPages <= 1) {
        self.verticalSpaceImagesTitle.constant = 16.0;
    } else {
        self.verticalSpaceImagesTitle.constant = 12.0;
    }
}

- (void)setBasicDetails
{
    [self setDealTitleAndStore];
    [self setPriceAndDiscount];
    [self setCategory];
    [self setExpirationDate];
    [self setDealDescription];
}

- (void)setDealTitleAndStore
{
    self.dealTitle.text = self.deal.title;
    self.store.text = self.deal.store != nil ? self.deal.store.name : @"No store";
}

- (void)setPriceAndDiscount
{
    [self checkForUnconvertedKeys];
    
    if (self.deal.price.floatValue > 0) {
        self.price.text = [self.deal.currency stringByAppendingString:self.deal.price.stringValue];
    } else {
        self.price.text = nil;
    }
    
    if (self.deal.discountValue.floatValue > 0) {
        if ([self.deal.discountType isEqualToString:@"%"]) {
            self.discount.text = [self.deal.discountValue.stringValue stringByAppendingString:self.deal.discountType];
        } else if ([self.deal.discountType isEqualToString:@"lastPrice"]){
            NSDictionary *attributes = @{ NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle] };
            NSString *lastPriceDiscount = [self.deal.currency stringByAppendingString:self.deal.discountValue.stringValue];
            NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:lastPriceDiscount attributes:attributes];
            self.discount.attributedText = attrText;
        }
    } else {
        self.discount.text = nil;
    }
    
    if (!self.price.text && !self.discount.text) {
        self.priceIconHeightConstraint.constant = 0;
        self.verticalSpacePriceIconCategoryIconConstraint.constant = 0;
    } else {
        self.priceIconHeightConstraint.constant = iconHeight;
        self.verticalSpacePriceIconCategoryIconConstraint.constant = iconsVerticalSpace;
    }
    
    if (self.price.text && self.discount.text) {
        self.horizontalSpacePriceDiscountConstraint.constant = 20.0;
    } else if (!self.price.text && self.discount.text) {
        self.horizontalSpacePriceDiscountConstraint.constant = 0;
        self.priceIcon.image = [UIImage imageNamed:@"Discount Icon"];
    } else {
        self.horizontalSpacePriceDiscountConstraint.constant = 0;
    }
}

- (void)setCategory
{
    if (self.deal.category) {
        self.category.text = self.deal.category;
        self.categoryIconHeightConstraint.constant = iconHeight;
        self.verticalSpaceCategoryIconExpirationDateIconConstraint.constant = iconsVerticalSpace;
    } else {
        self.category.text = nil;
        self.categoryIconHeightConstraint.constant = 0;
        self.verticalSpaceCategoryIconExpirationDateIconConstraint.constant = 0;
    }
}

- (void)setExpirationDate
{
    if (self.deal.expiration) {
        self.expirationDate.text = [NSLocalizedString(@"Expires on ", nil) stringByAppendingString:[self.dateFormatter stringFromDate:self.deal.expiration]];
        self.expirationDateIconHeightConstraint.constant = iconHeight;
        self.verticalSpaceExpirationDateIconDescriptionIconConstraint.constant = iconsVerticalSpace;
    }
    else {
        self.expirationDate.text = nil;
        self.expirationDateIconHeightConstraint.constant = 0;
        self.verticalSpaceExpirationDateIconDescriptionIconConstraint.constant = 0;
    }
    [self checkIfDealExpired];
    [self.view needsUpdateConstraints];
}

- (void)checkIfDealExpired
{
    if ([appDelegate didDealExpired:self.deal]) {
        [self setExpiredDeal];
        self.expiredTag.hidden = NO;
        self.expirationDateBackgroundWhenExpired.hidden = NO;
    } else {
        self.expiredTag.hidden = YES;
        self.expirationDateBackgroundWhenExpired.hidden = YES;
    }
}

- (void)setExpiredDeal
{
    self.expiredTag.layer.cornerRadius = 5.0;
    self.expiredTag.layer.masksToBounds = YES;
    self.expiredTag.layer.borderWidth = 1.5;
    self.expiredTag.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.expirationDateBackgroundWhenExpired.layer.cornerRadius = 8.0;
    self.expirationDateBackgroundWhenExpired.layer.masksToBounds = YES;
    self.expirationDate.text = [NSLocalizedString(@"Expired on ", nil) stringByAppendingString:[self.dateFormatter stringFromDate:self.deal.expiration]];
}

- (void)setDealDescription
{
    if (self.deal.moreDescription.length > 0 && ![self.deal.moreDescription isEqualToString:@"None"]) {
        self.dealDescription.text = [NSLocalizedString(@"Description: ", nil) stringByAppendingString:self.deal.moreDescription];
        self.descriptionIconHeightConstraint.constant = iconHeight;
        self.verticalSpaceBasicDetailsLikesConstraint.constant = 25.0;
        self.verticalSpaceDescriptionLabelLikeIconConstraint.constant = 25.0;
    } else {
        self.dealDescription.text = nil;
        self.descriptionIconHeightConstraint.constant = 0;
        self.verticalSpaceBasicDetailsLikesConstraint.constant = 25.0 - iconsVerticalSpace;
        self.verticalSpaceDescriptionLabelLikeIconConstraint.constant = 0;
    }
}

- (void)setLikesCounter
{
    NSInteger likes = self.deal.dealAttrib.dealersThatLiked.count;
    self.likeCounter = [NSNumber numberWithInteger:likes];
    NSInteger likeCounter = self.likeCounter.integerValue;
    
    if (likeCounter > 0) {
        self.likesIconHeightConstraint.constant = 17.0;
        self.verticalSpaceLikesIconDealerProfilePicConstraint.constant = 25.0;
        self.likes.hidden = NO;
        self.likesButton.hidden = NO;
        if (likeCounter == 1) {
            self.likes.text = [NSString stringWithFormat:NSLocalizedString(@"1 person likes this", nil)];
        } else {
            self.likes.text = [NSString stringWithFormat:NSLocalizedString(@"%@ people like this", nil), self.likeCounter];
        }
    } else {
        self.likesIconHeightConstraint.constant = 0;
        self.verticalSpaceLikesIconDealerProfilePicConstraint.constant = 0;
        self.likes.hidden = YES;
        self.likesButton.hidden = YES;
        self.likes.text = nil;
    }
}

- (void)setDealerSection
{
    self.dealerProfilePlaceholder.layer.cornerRadius = self.dealerProfilePlaceholder.frame.size.width / 2;
    self.dealerProfilePlaceholder.layer.masksToBounds = YES;
    self.dealerProfilePic.layer.cornerRadius = self.dealerProfilePic.frame.size.width / 2;
    self.dealerProfilePic.layer.masksToBounds = YES;
    
    self.dealerName.text = self.deal.dealer.fullName;
    
    if (self.deal.uploadDate) {
        self.uploadDate.text = [NSLocalizedString(@"Uploaded on ", nil) stringByAppendingString:[self.dateFormatter stringFromDate:self.deal.uploadDate]];
    }
    
    if (!self.dealerProfilePic.image) {
        
        if (self.deal.dealer.dealerID.intValue == appDelegate.dealer.dealerID.intValue) {
            self.deal.dealer = self.appDelegate.dealer;
            self.dealerProfilePic.image = [appDelegate myProfilePic];
        } else {
            [appDelegate otherProfilePic:self.deal.dealer forTarget:@"Deal Dealer's Photo" notificationName:NAME_FOR_NOTIFICATIONS atIndexPath:nil];
        }
    }
}

- (void)configureCommentsPreviewTableView
{
    self.commentsPreviewTableView.rowHeight = 64.0;
    self.commentsPreviewTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.commentsPreviewTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self loadPreviewWithLastThreeComments];
    commentsPreviewCount =  [self setCommentsPreviewCount];
    self.commentsPreviewTableView.dataSource = self;
    self.commentsPreviewTableView.delegate = self;
    self.cellsHeights = [[NSMutableArray alloc] initWithCapacity:commentsPreviewCount];
    
    if (self.didChangesInComments) {
        [self.cellsHeights removeAllObjects];
        [self.commentsPreviewTableView reloadData];
    }
}

- (NSInteger)setCommentsPreviewCount
{
    if (self.deal.comments.count <= 3) {
        return self.commentsForPreview.count + 1; // The +1 is for the add comment button.
    } else {
        return 4;
    }
}

- (void)loadPreviewWithLastThreeComments
{
    self.commentsForPreview = [[NSMutableArray alloc] init];
    
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

- (void)setTableViewHeight
{
    CGFloat tableViewHeight = headerHeight + footerHeight;
    for (NSNumber *height in self.cellsHeights) {
        tableViewHeight += height.doubleValue;
    }
    self.commentsPreviewTableViewHeightConstraint.constant = tableViewHeight;
}

- (void)setMapAndStoreDetails
{
    if (self.deal.store.latitude.doubleValue != 0) {
        [self setMapScreenshot];
        [self setStoreInfo];
        [self setWazeButton];
    }
}

- (void)setMapScreenshot
{
    [self.view layoutIfNeeded];
    
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:self.mapImageView.frame];
    
    lastCoords.latitude = [self.deal.store.latitude doubleValue];
    lastCoords.longitude = [self.deal.store.longitude doubleValue];
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.01;     // 0.0 is min value u van provide for zooming
    span.longitudeDelta = 0.01;
    region.span = span;
    region.center = lastCoords;     // to locate to the center
    [mapView setRegion:region animated:NO];
    [mapView regionThatFits:region];
    
    // Adding the circle which shows the specific location
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:region.center radius:100];
    [mapView addOverlay:circle];
    
    MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
    options.region = mapView.region;
    options.size = mapView.frame.size;
    
    __weak typeof(self) weakSelf = self;
    
    MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:options];
    [snapshotter startWithCompletionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
        
        CGPoint center = [snapshot pointForCoordinate:region.center];
        if (!weakSelf.locationCircle) {
            weakSelf.locationCircle = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
            weakSelf.locationCircle.center = center;
            weakSelf.locationCircle.backgroundColor = [UIColor colorWithRed:150.0/255.0 green:0.0/255.0 blue:180.0/255.0 alpha:0.3];
            weakSelf.locationCircle.layer.borderColor = [[UIColor colorWithRed:150.0/255.0 green:0.0/255.0 blue:180.0/255.0 alpha:0.6]CGColor];
            weakSelf.locationCircle.layer.borderWidth = 1.0;
            weakSelf.locationCircle.layer.cornerRadius = weakSelf.locationCircle.frame.size.width / 2;
            weakSelf.locationCircle.layer.masksToBounds = YES;
            [weakSelf.mapImageView addSubview:weakSelf.locationCircle];
        }
        weakSelf.mapImageView.image = snapshot.image;
        weakSelf.mapImageView.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^{ weakSelf.mapImageView.alpha = 1.0; }];
    }];
}

- (void)setStoreInfo
{
    self.storeTitle.text = self.deal.store.name;
    
    if (self.deal.store.address.length > 1 && ![self.deal.store.address isEqualToString:@"None"]) {
        self.storeAddress.text = self.deal.store.address;
        if (self.deal.store.city.length > 0 && ![self.deal.store.city isEqualToString:@"None"]) {
            NSString *cityAddition = [NSString stringWithFormat:@", %@", self.deal.store.city];
            self.storeAddress.text = [self.storeAddress.text stringByAppendingString:cityAddition];
        }
    } else {
        self.storeAddress.text = nil;
    }
    
    if (self.deal.store.url.length > 1 && ![self.deal.store.url isEqualToString:@"None"]) {
        self.storeWebsite.text = self.deal.store.url;
        self.verticalSpaceStoreAddressStoreWebsiteIconConstraint.constant = 12.0;
        self.storeWebsiteIconHeightConstraint.constant = 20.0;
        self.storeWebsite.scrollEnabled = NO;
        self.storeWebsite.textContainer.maximumNumberOfLines = 1;
        self.storeWebsite.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    } else {
        self.storeWebsite.text = nil;
        self.verticalSpaceStoreAddressStoreWebsiteIconConstraint.constant = 0;
        self.storeWebsiteIconHeightConstraint.constant = 0;
    }
    
    if (self.deal.store.phone.length > 1 && ![self.deal.store.phone isEqualToString:@"None"]) {
        self.storePhone.text = self.deal.store.phone;
        self.verticalSpaceStoreWebsiteIconStorePhoneIconConstraint.constant = 15.0;
        self.storePhoneIconHeightConstraint.constant = 20.0;
        self.storePhone.scrollEnabled = NO;
        self.storePhone.textContainer.maximumNumberOfLines = 1;
        self.storeWebsite.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    } else {
        self.storePhone.text = nil;
        self.verticalSpaceStoreWebsiteIconStorePhoneIconConstraint.constant = 0;
        self.storePhoneIconHeightConstraint.constant = 0;
    }
}

- (void)setWazeButton
{
    [self.wazeButton.layer setCornerRadius:8.0];
    [self.wazeButton.layer setMasksToBounds:YES];
    [self.wazeButton.layer setBorderWidth:1.5];
    [self.wazeButton.layer setBorderColor:[[UIColor colorWithRed:150.0/255.0 green:0/255.0 blue:180.0/255.0 alpha:0.9] CGColor]];
}

- (IBAction)connectToWaze:(id)sender
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

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKCircleRenderer *circleView = [[MKCircleRenderer alloc]initWithCircle:overlay];
    circleView.fillColor = [UIColor colorWithRed:150.0/255.0 green:0.0/255.0 blue:180.0/255.0 alpha:0.4];
    circleView.strokeColor = [UIColor colorWithRed:150.0/255.0 green:0.0/255.0 blue:180.0/255.0 alpha:0.8];
    circleView.lineWidth = 2;
    
    return circleView;
}

- (void)setSharedView
{
    CGFloat sharedViewWidth = self.view.bounds.size.width;
    
    UIView *sharedView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height + 1000, sharedViewWidth, sharedViewWidth)];
    sharedView.backgroundColor = [UIColor whiteColor];
    sharedView.tag = SHARED_VIEW;
    [self.view addSubview:sharedView];
    
    // Setting the shared view content:
    
    UIImageView *dealPic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, sharedViewWidth, sharedViewWidth * 0.678125)];
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
    UIImageView *titleBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, dealPic.frame.size.height - titleBackgroundHeight, sharedViewWidth, titleBackgroundHeight)];
    titleBackground.image = [UIImage imageNamed:@"Title Background"];
    
    if (self.deal.photo1) {
        titleBackground.alpha = 0.75;
    } else {
        titleBackground.alpha = 0;
    }
    
    [sharedView addSubview:titleBackground];
    
    CGFloat titleLabelHeight = 48.0;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconsLeftMarginSharedView,
                                                                    dealPic.frame.size.height - titleLabelHeight - 5,
                                                                    sharedViewWidth - iconsLeftMarginSharedView * 2,
                                                                    titleLabelHeight)];
    titleLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.numberOfLines = 2;
    titleLabel.text = self.dealTitle.text;
    [sharedView addSubview:titleLabel];
    
    CGFloat detailsVerticalGap = 9.0;
    CGFloat detailsLowestYPoint;
    CGSize iconSize = CGSizeMake(22.0, 22.0);
    CGSize labelSize = CGSizeMake(sharedViewWidth - labelsLeftMarginSharedView - iconsLeftMarginSharedView, 22.0);
    CGFloat priceXPoint = labelsLeftMarginSharedView;
    BOOL hasPriceOrDiscount = NO;
    
    UIImageView *storeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(iconsLeftMarginSharedView,
                                                                           dealPic.frame.size.height + detailsVerticalGap,
                                                                           iconSize.width,
                                                                           iconSize.height)];
    storeIcon.image = [UIImage imageNamed:@"Store Icon"];
    [sharedView addSubview:storeIcon];
    
    UILabel *storeLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelsLeftMarginSharedView,
                                                                    storeIcon.frame.origin.y,
                                                                    labelSize.width,
                                                                    labelSize.height)];
    storeLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:15.0];
    storeLabel.textColor = textGray;
    storeLabel.numberOfLines = 1;
    storeLabel.text = self.store.text;
    [sharedView addSubview:storeLabel];
    
    detailsLowestYPoint = CGRectGetMaxY(storeIcon.frame);
    
    if (self.price.text.length > 0 || self.discount.text.length > 0) {
        
        hasPriceOrDiscount = YES;
        
        UIImageView *priceIcon = [[UIImageView alloc] initWithFrame:CGRectMake(iconsLeftMarginSharedView,
                                                                               detailsLowestYPoint + detailsVerticalGap,
                                                                               iconSize.width,
                                                                               iconSize.height)];
        priceIcon.image = self.priceIcon.image;
        [sharedView addSubview:priceIcon];
        
        if (self.price.text.length > 0) {
            
            UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelsLeftMarginSharedView,
                                                                            priceIcon.frame.origin.y,
                                                                            labelSize.width,
                                                                            priceIcon.frame.size.height)];
            priceLabel.text = self.price.text;
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
        
        if (self.discount.text.length > 0) {
            
            UILabel *discountLabel = [[UILabel alloc]initWithFrame:CGRectMake(priceXPoint,
                                                                              priceIcon.frame.origin.y,
                                                                              labelSize.width,
                                                                              priceIcon.frame.size.height)];
            if ([self.deal.discountType isEqualToString:@"lastPrice"]) {
                discountLabel.attributedText = self.discount.attributedText;
            } else {
                discountLabel.text = self.discount.text;
            }
            discountLabel.font = [UIFont fontWithName:@"Avenir-Light" size:17.0];
            [discountLabel sizeToFit];
            discountLabel.center = priceIcon.center;
            CGRect discountLabelFrame = discountLabel.frame;
            discountLabelFrame.origin.x = priceXPoint;
            discountLabel.frame = discountLabelFrame;
            
            discountLabel.textColor = textGray;
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
        addressLabel.textColor = textGray;
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
    //        expirationLabel.textColor = textGray;
    //        expirationLabel.numberOfLines = 1;
    //        expirationLabel.text = self.expirelabel.text;
    //        [sharedView addSubview:expirationLabel];
    //    }
}

- (void)screenshotSharedView
{
    self.sharedImage = [[UIImage alloc] init];
    
    UIView *sharedView = [self.view viewWithTag:SHARED_VIEW];
    
    CGRect screenShotRect = sharedView.bounds;
    
    UIGraphicsBeginImageContextWithOptions(sharedView.bounds.size, YES, 0.0);
    [sharedView drawViewHierarchyInRect:screenShotRect afterScreenUpdates:YES];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.sharedImage = screenshot;
}


#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return commentsPreviewCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (commentsPreviewCount - 1 != indexPath.row) {
        return [self commentCellForIndexPath:indexPath];
    } else {
        return [self configureAddCommentCell];
    }
}

- (CommentTableViewCell *)commentCellForIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell *cell = [self.commentsPreviewTableView dequeueReusableCellWithIdentifier:commentCellIdentifier];
    
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommentTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(CommentTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Comment *comment = [self.commentsForPreview objectAtIndex:indexPath.row];
    
    [self setDealerImageForCell:cell comment:comment indexPath:indexPath];
    [self setDealerProfileLinkForCell:cell indexPath:indexPath];
    [self setBasicDetailsForCell:cell comment:comment];
}

- (void)setDealerImageForCell:(CommentTableViewCell *)cell comment:(Comment *)comment indexPath:(NSIndexPath *)indexPath
{
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
}

- (void)setDealerProfileLinkForCell:(CommentTableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    [cell.dealerProfilePic setTag:indexPath.row];
    [cell.dealerProfilePic addTarget:self action:@selector(commenterProfileButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.dealerName setTag:indexPath.row];
    [cell.dealerName addTarget:self action:@selector(commenterProfileButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setBasicDetailsForCell:(CommentTableViewCell *)cell comment:(Comment *)comment
{
    [cell.dealerName setTitle:comment.dealer.fullName forState:UIControlStateNormal];
    cell.commentDate.text = [comment.dateFormatter stringFromDate:comment.uploadDate];
    cell.commentBody.text = comment.text;
}

- (UITableViewCell *)configureAddCommentCell
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    cell.backgroundColor = [UIColor clearColor];
    
    UIImageView *yourCommentProfilePic = [[UIImageView alloc] initWithFrame:CGRectMake(15.0, 12, 40, 40)];
    yourCommentProfilePic.image = [appDelegate myProfilePic];
    yourCommentProfilePic.layer.cornerRadius = yourCommentProfilePic.frame.size.width / 2;
    yourCommentProfilePic.layer.masksToBounds = YES;
    yourCommentProfilePic.contentMode = UIViewContentModeScaleAspectFill;
    [cell.contentView addSubview:yourCommentProfilePic];
    
    CGFloat x = 63;
    CGFloat y = 12;
    CGFloat width = self.view.bounds.size.width - 15.0 * 2 - yourCommentProfilePic.bounds.size.width - 8.0;
    CGFloat height = 39;
    
    UIView *addCommentBackground = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    addCommentBackground.backgroundColor = [UIColor whiteColor];
    addCommentBackground.layer.cornerRadius = 8.0;
    addCommentBackground.layer.masksToBounds = YES;
    
    [cell.contentView addSubview:addCommentBackground];
    
    UILabel *addCommentTitle = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width - 8 * 2, height)];
    addCommentTitle.textColor = textGray;
    addCommentTitle.font = [UIFont fontWithName:@"Avenir-Roman" size:15.0];
    
    if (self.deal.comments.count == 0) {
        addCommentTitle.text = NSLocalizedString(@"Be the first to comment...", nil);
    } else {
        addCommentTitle.text = NSLocalizedString(@"Add a comment...", nil);
    }
    
    [cell.contentView addSubview:addCommentTitle];
    
    UIButton *addComment = [UIButton buttonWithType:UIButtonTypeCustom];
    [addComment setFrame:addCommentBackground.frame];
    [addComment setBackgroundColor:[UIColor clearColor]];
    [addComment addTarget:self action:@selector(comment:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:addComment];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (commentsPreviewCount - 1 != indexPath.row) {
        return [self heightForCellAtIndexPath:indexPath];
    } else {
        [self.cellsHeights setObject:@(self.commentsPreviewTableView.rowHeight) atIndexedSubscript:commentsPreviewCount - 1];
        [self setTableViewHeight];
        return self.commentsPreviewTableView.rowHeight;
    }
}

- (CGFloat)heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    static CommentTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.commentsPreviewTableView dequeueReusableCellWithIdentifier:commentCellIdentifier];
        if (!sizingCell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommentTableViewCell" owner:nil options:nil];
            sizingCell = [nib objectAtIndex:0];
        }
    });
    
    [self configureCell:sizingCell atIndexPath:indexPath];
    NSNumber *height = @([self calculateHeightForConfiguredSizingCell:sizingCell]);
    [self.cellsHeights setObject:height atIndexedSubscript:indexPath.row];
    return height.doubleValue;
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell
{
    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.commentsPreviewTableView.frame), CGRectGetHeight(sizingCell.bounds));
    
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.deal.comments.count > 0) {
        return [self configureTableViewHeader];
    } else {
        return [self commentsPreviewTableViewPadding];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [self commentsPreviewTableViewPadding];
}

- (UIView *)configureTableViewHeader
{
    self.tableViewHeader = [[UIView alloc] init];
    
    CGRect overviewFrame = CGRectMake(iconsLeftMargin,
                                      8.0,
                                      self.view.frame.size.width - iconsLeftMargin * 2,
                                      36.0);
    UIFont *font = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    UIColor *color = [appDelegate darkTextGrayColor];
    
    if (self.deal.comments.count > 3) {
        
        UIButton *commentsOverview = [UIButton buttonWithType:UIButtonTypeSystem];
        [commentsOverview setFrame:overviewFrame];
        NSString *buttonTitle = [NSString stringWithFormat:NSLocalizedString(@"View all %@ comments", nil), [NSNumber numberWithUnsignedInteger:self.deal.comments.count]];
        [commentsOverview setTitle:buttonTitle forState:UIControlStateNormal];
        commentsOverview.titleLabel.font = font;
        commentsOverview.tintColor = color;
        [commentsOverview addTarget:self action:@selector(comment:) forControlEvents:UIControlEventTouchUpInside];
        commentsOverview.tag = COMMENTS_OVERVIEW_BUTTON;
        
        [self.tableViewHeader addSubview:commentsOverview];
        
    } else {
        
        UILabel *commentsTitle = [[UILabel alloc] initWithFrame:overviewFrame];
        commentsTitle.text = NSLocalizedString(@"Comments", nil);
        commentsTitle.font = font;
        commentsTitle.textColor = color;
        commentsTitle.textAlignment = NSTextAlignmentCenter;
        
        [self.tableViewHeader addSubview:commentsTitle];
    }
    
    return self.tableViewHeader;
}

- (UIView *)commentsPreviewTableViewPadding
{
    UIView *padding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 10.0)];
    padding.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return padding;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.deal.comments.count > 0) {
        headerHeight = 40.0;
        return headerHeight;
    } else {
        headerHeight = 10.0;
        return headerHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    footerHeight = 10.0;
    return footerHeight;
}

#pragma mark - Actions

- (void)like:(id)sender
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
        self.likes.text = [NSString stringWithFormat:NSLocalizedString(@"1 person likes this", nil)];
    } else {
        self.likes.text = [NSString stringWithFormat:NSLocalizedString(@"%@ people like this", nil), self.likeCounter];
    }
}

- (void)comment:(id)sender {
    
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

- (void)share:(id)sender {

    NSString *messageText = [NSString stringWithFormat:NSLocalizedString(@"Hear from others about great deals at Dealers: %@", nil), APPSTORE_LINK];
    NSArray *activityItems = @[messageText, self.sharedImage];
    NSArray *excludedActivities = @[UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeSaveToCameraRoll];
    
    ActivityTypeWhatsApp *whatsappActivity = [[ActivityTypeWhatsApp alloc] init];
    NSArray *appActivities = @[whatsappActivity];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:appActivities];
    
    activityController.excludedActivityTypes = excludedActivities;
    
    __weak ViewDealViewController *weakSelf = self;
    
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

- (void)options:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:NSLocalizedString(@"Edit Deal", nil), NSLocalizedString(@"Report as Spam", nil), nil];
    
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (IBAction)presentLikers:(id)sender
{
    DealersTableViewController *dtvc = [self.storyboard instantiateViewControllerWithIdentifier:@"DealersTableViewController"];
    dtvc.mode = @"Likers";
    dtvc.dealID = self.deal.dealID;
    [self.navigationController pushViewController:dtvc animated:YES];
}

- (IBAction)dealerProfile:(id)sender
{
    ProfileTableViewController *ptvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileID"];
    ptvc.dealer = self.deal.dealer;
    ptvc.dealer.photo = UIImageJPEGRepresentation(self.dealerProfilePic.image, 1.0);
    [self.navigationController pushViewController:ptvc animated:YES];
}

- (void)commenterProfileButtonClicked:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    Comment *comment = [self.commentsForPreview objectAtIndex:button.tag];
    ProfileTableViewController *ptvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileID"];
    ptvc.dealerID = comment.dealer.dealerID;
    [self.navigationController pushViewController:ptvc animated:YES];
}


#pragma mark - General methods

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = self.imagesScrollView.frame.size.width;
    NSInteger currentPage = floor((self.imagesScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = currentPage;
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
        
        self.dealerProfilePic.alpha = 0;
        self.dealerProfilePic.image = [info objectForKey:@"image"];
        [UIView animateWithDuration:0.3 animations:^{
            self.dealerProfilePic.alpha = 1;
        }];
        
    } else if ([[info objectForKey:@"target"] isEqualToString:@"Commenter's Photo"]) {
        
        NSArray *indexPathes = [self.commentsPreviewTableView indexPathsForVisibleRows];
        
        NSIndexPath *receivedIndexPath = [info objectForKey:@"indexPath"];
        
        for (int i = 0; i < indexPathes.count; i++) {
            
            if ([indexPathes[i] isEqual:receivedIndexPath]) {
                
                CommentTableViewCell *cell = (CommentTableViewCell *)[self.commentsPreviewTableView cellForRowAtIndexPath:indexPathes[i]];
                
                if ([cell isMemberOfClass:[CommentTableViewCell class]]) {
                    [cell.dealerProfilePic setImage:[info objectForKey:@"image"] forState:UIControlStateNormal];
                    [UIView animateWithDuration:0.3 animations:^{ cell.dealerProfilePic.alpha = 1.0; }];
                    break;
                }
            }
        }
    }
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
        
        [_documentInteractionController presentOpenInMenuFromRect:CGRectMake(0, 0, 0, 0) inView:self.scrollView animated:YES];
        
        
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

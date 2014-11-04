//
//  ViewonedealViewController.m
//  GooglePlaces
//
//  Created by itzik berrebi on 9/26/13.
//
//

#import "ViewonedealViewController.h"
#import "ProfileViewController.h"
#import "ExploretableViewController.h"
#import "AppDelegate.h"
#import "WhereIsTheDeal.h"
#import "LikesCell.h"
#import <QuartzCore/QuartzCore.h>
#import "OnlineViewController.h"
#import "ActivityTypeWhatsApp.h"
#import "CommentsTableViewController.h"

#define GAP 15
#define sectionGap 25
#define loadingIndicatorTag 1111
#define sharedViewTag 9898

#define iconsLeftMargin 12
#define labelsLeftMargin 52

#define S3_PHOTOS_ADDRESS @"https://s3-eu-west-1.amazonaws.com/dealers-app/"

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

-(void) setMapAndStoreInfo
{
    self.mapAndStoreSection = [[UIView alloc]initWithFrame:CGRectMake(0, lowestYPoint + sectionGap, self.view.frame.size.width, 500)];
    [self.scroll addSubview:self.mapAndStoreSection];
    
    if (![[self.deal dealStoreLatitude] isEqualToString:@"0"]) {
        
        self.mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 240)];
        
        lastCoords.latitude = [[_deal dealStoreLatitude] doubleValue];
        lastCoords.longitude = [[_deal dealStoreLongitude] doubleValue];
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        span.latitudeDelta = 0.01;     // 0.0 is min value u van provide for zooming
        span.longitudeDelta = 0.01;
        region.span = span;
        region.center = lastCoords;     // to locate to the center
        [self.mapView setRegion:region animated:NO];
        [self.mapView regionThatFits:region];
        
        UIImageView *mapSnapshot = [[UIImageView alloc]initWithFrame:self.mapView.frame];
        [self.mapAndStoreSection addSubview:mapSnapshot];
        
        UIView *mapDarkerScreen = [[UIView alloc]initWithFrame:mapSnapshot.frame];
        mapDarkerScreen.backgroundColor = [UIColor blackColor];
        mapDarkerScreen.alpha = 0;
        [self.mapAndStoreSection addSubview:mapDarkerScreen];
        
        MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
        options.region = self.mapView.region;
        options.size = self.mapView.frame.size;
        
        MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:options];
        [snapshotter startWithCompletionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
            
            mapSnapshot.image = snapshot.image;
            mapSnapshot.alpha = 0;
            [UIView animateWithDuration:0.3 animations:^{ mapSnapshot.alpha = 1.0; }];
        }];
        
        CGFloat mapBottom = CGRectGetMaxY(mapSnapshot.frame);
        
        UIImageView *storeTitleBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Title Background"]];
        storeTitleBackground.frame = CGRectMake(0, mapBottom - 100, self.view.frame.size.width, 100);
        storeTitleBackground.alpha = 0.65;
        [self.mapAndStoreSection addSubview:storeTitleBackground];
        
        UILabel *storeTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, mapBottom - 44, 300, 20)];
        [storeTitle setFont:[UIFont fontWithName:@"Avenir-Roman" size:19.0]];
        storeTitle.text = self.deal.store.name;
        storeTitle.textColor = [UIColor whiteColor];
        [self.mapAndStoreSection addSubview:storeTitle];
        
        if (![self.deal.dealStoreAddress isEqualToString:@"0"]) {
            
            UILabel *storeAddress = [[UILabel alloc]initWithFrame:CGRectMake(10, mapBottom - 20, 300, 14)];
            [storeAddress setFont:[UIFont fontWithName:@"Avenir-Roman" size:13.0]];
            storeAddress.text = [_deal dealStoreAddress];
            storeAddress.textColor = [UIColor whiteColor];
            [self.mapAndStoreSection addSubview:storeAddress];
        }
        
        UIButton *wazeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        UIImage *wazeImage = [[UIImage imageNamed:@"Waze Button"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [wazeButton setImage:wazeImage forState:UIControlStateNormal];
        wazeButton.frame = CGRectMake(0, 0, 208, 45);
        CGFloat buttonCenterY = self.mapView.frame.size.height + wazeButton.frame.size.height/2 + GAP;
        wazeButton.center = CGPointMake(self.view.center.x, buttonCenterY);
        wazeButton.alpha = 0.9;
        [wazeButton addTarget:self action:@selector(connectToWaze) forControlEvents: UIControlEventTouchUpInside];
        [self.mapAndStoreSection addSubview:wazeButton];
        
        self.mapAndStoreSection.frame = CGRectMake(self.mapAndStoreSection.frame.origin.x,
                                                   self.mapAndStoreSection.frame.origin.y,
                                                   self.mapAndStoreSection.frame.size.width,
                                                   CGRectGetMaxY(wazeButton.frame) + sectionGap);
        lowestYPoint = CGRectGetMaxY(self.mapAndStoreSection.frame);
        [self setScrollSize];
    }
}

-(void) connectToWaze
{
    if ([[UIApplication sharedApplication]
         canOpenURL:[NSURL URLWithString:@"waze://"]]) {
        // Waze is installed. Launch Waze and start navigation
        NSString *urlStr =
        [NSString stringWithFormat:@"waze://?ll=%f,%f&navigate=yes",[[_deal dealStoreLatitude] doubleValue], [[_deal dealStoreLongitude] doubleValue]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    } else {
        // Waze is not installed. Launch AppStore to install Waze app
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/id323229106"]];
    }
}

- (void)setLikesAndButtonsSection
{
    CGFloat originY = CGRectGetMaxY(self.dealerSection.frame);
    self.likesAndButtonsSection.frame = CGRectMake(0, originY, self.view.frame.size.width, self.likesAndButtonsSection.frame.size.height);
    
    if ([self.isDealLikedByUser isEqualToString:@"yes"]) {
        
        self.likeButton.hidden = YES;
        self.likeButtonSelected.hidden = NO;
    } else {
        self.likeButton.hidden = NO;
        self.likeButtonSelected.hidden = YES;
    }
    
    if (self.deal.dealAttrib.likeCounter > 0) {
        
        CGRect likesSectionFrame = self.likesAndButtonsSection.frame;
        likesSectionFrame.origin.y = lowestYPoint + 7;
        self.likesAndButtonsSection.frame = likesSectionFrame;
        
        NSString *likesCountPrefix = [NSString stringWithFormat:@"%@", self.deal.dealAttrib.likeCounter];
        NSString *likesCountSuffix = @" people like this deal";
        NSString *likeCount = [likesCountPrefix stringByAppendingString:likesCountSuffix];
        self.likesCountLabel.text = likeCount;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"" forState:UIControlStateNormal];
        button.frame = self.likesCountLabel.frame;
        [button addTarget:self action:@selector(whoLikesTheDeal:) forControlEvents: UIControlEventTouchUpInside];
        [self.likesAndButtonsSection addSubview:button];
        
    } else {
        self.likesCountImage.hidden = YES;
        self.likesCountLabel.hidden = YES;
        
        self.likesAndButtonsSection.frame = CGRectMake(0, originY, self.likesAndButtonsSection.frame.size.width, self.likeButton.frame.size.height + sectionGap * 2 - 4);
    }
    
    lowestYPoint = CGRectGetMaxY(self.likesAndButtonsSection.frame);
    
    [self setScrollSize];
}

- (void)setCommentsSection
{
    CGFloat sectionHeight = sectionGap * 2 + 10;
    
    self.commentsSection = [[UIView alloc]init];
    
    [self setCommentsOverview];
    
    [self setCommentsTableViewAtPoint: sectionGap * 2 + 10];
    
    sectionHeight += self.commentsTableView.frame.size.height;
    
    self.commentsSection.frame = CGRectMake(0,
                                            lowestYPoint,
                                            self.view.frame.size.width,
                                            sectionHeight);
    
    self.commentsSection.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self.scroll addSubview:self.commentsSection];
    
    lowestYPoint = CGRectGetMaxY(self.commentsSection.frame);
}

- (void)setCommentsOverview
{
    UIButton *commentsOverview = [UIButton buttonWithType:UIButtonTypeSystem];
    [commentsOverview setFrame:CGRectMake(iconsLeftMargin,
                                         sectionGap,
                                         self.view.frame.size.width - iconsLeftMargin * 2,
                                         19)];
    NSString *buttonTitle = [NSString stringWithFormat:@"View all %lu comments", (unsigned long)self.comments.count];
    [commentsOverview setTitle:buttonTitle forState:UIControlStateNormal];
    commentsOverview.titleLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    commentsOverview.tintColor = [UIColor colorWithRed:130.0/255.0 green:130.0/255.0 blue:136.0/255.0 alpha:1.0];
    commentsOverview.titleLabel.text = [NSString stringWithFormat:@"View all %lu comments", (unsigned long)self.comments.count];
    [commentsOverview addTarget:self action:@selector(CommentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    commentsOverview.tag = 123456789;
    
    [self.commentsSection addSubview:commentsOverview];
}

- (void)setCommentsTableViewAtPoint:(CGFloat)originPoint
{
    self.commentsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, originPoint, self.view.frame.size.width, 0) style:UITableViewStylePlain];
    //    self.commentsTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.commentsTableView.delegate = self;
    self.commentsTableView.dataSource = self;
    self.commentsTableView.backgroundColor = [UIColor clearColor];
    
    static NSString *cellIdentifier = @"CommentsTableCell";
    [self.commentsTableView registerNib:[UINib nibWithNibName:@"CommentsTableCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.cellPrototype = (CommentsTableCell *)[self.commentsTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    [self.commentsTableView reloadData];
    
    CGRect tableFrame = self.commentsTableView.frame;
    tableFrame.size = self.commentsTableView.contentSize;
    self.commentsTableView.frame = tableFrame;
    
    [self.commentsSection addSubview:self.commentsTableView];
}

-(void) setScrollSize
{
    [scroll setContentSize:CGSizeMake(320, lowestYPoint)];
}

-(void) locateIconsInPlace
{
    int offset;
    if ([[_deal photoSum]intValue] == 0) {
        offset = 10;
    } else offset = 184;
    
    self.TitleIcon.frame = CGRectMake(10, offset, self.TitleIcon.frame.size.width, self.TitleIcon.frame.size.height);
    titlelabel.frame = CGRectMake(iconsLeftMargin, offset + 4, 290, 22);
    titlelabel.numberOfLines = 0;
    [titlelabel sizeToFit];
    
    lowestYPoint = (CGRectGetMaxY(self.TitleIcon.frame) > CGRectGetMaxY(titlelabel.frame)) ? CGRectGetMaxY(self.TitleIcon.frame) : CGRectGetMaxY(titlelabel.frame);
    
    CGFloat fieldsWidth = self.view.frame.size.width - iconsLeftMargin - self.StoreIcon.frame.size.width - labelsLeftMargin - 10;
    
    self.StoreIcon.frame = CGRectMake(iconsLeftMargin, lowestYPoint + GAP, self.StoreIcon.frame.size.width, self.StoreIcon.frame.size.height);
    storelabel.frame = CGRectMake(labelsLeftMargin, lowestYPoint+3+GAP, fieldsWidth, storelabel.frame.size.height);
    
    if ([[_deal type] isEqualToString:@"online"]) {
        _urlSiteButton.frame = CGRectMake(labelsLeftMargin, lowestYPoint+3+GAP, storelabel.frame.size.width, storelabel.frame.size.height);
    } else _urlSiteButton.hidden=YES;
    
    lowestYPoint = (CGRectGetMaxY(self.StoreIcon.frame) > CGRectGetMaxY(storelabel.frame)) ? CGRectGetMaxY(self.StoreIcon.frame) : CGRectGetMaxY(storelabel.frame);
    
    maxXPoint = 50;
    
    if (pricelabel.text.length > 0) {
        [pricelabel sizeToFit];
        self.PriceIcon.frame = CGRectMake(iconsLeftMargin, lowestYPoint + GAP, self.PriceIcon.frame.size.width, self.PriceIcon.frame.size.height);
        pricelabel.frame = CGRectMake(maxXPoint, lowestYPoint+3+GAP, pricelabel.frame.size.width, pricelabel.frame.size.height);
        maxXPoint= CGRectGetMaxX (pricelabel.frame) + 20;
    } else {
        pricelabel.hidden = YES;
    }
    
    if (discountlabel.text.length > 0) {
        
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
        lowestYPoint=(CGRectGetMaxY(self.PriceIcon.frame) > CGRectGetMaxY(discountlabel.frame)) ? CGRectGetMaxY(self.PriceIcon.frame) : CGRectGetMaxY(discountlabel.frame);
    } else {
        discountlabel.hidden=YES;
        if (pricelabel.text .length > 0) {
            lowestYPoint=(CGRectGetMaxY(self.PriceIcon.frame) > CGRectGetMaxY(pricelabel.frame)) ? CGRectGetMaxY(self.PriceIcon.frame) : CGRectGetMaxY(pricelabel.frame);
        }
    }
    
    if ((pricelabel.hidden == YES) && (discountlabel.hidden == YES)) self.PriceIcon.hidden=YES;
    
    if (self.categorylabel.text.length > 0 && [self.categorylabel.text rangeOfString:@"No Category"].location == NSNotFound) {
        self.CategoryIcon.frame = CGRectMake(iconsLeftMargin, lowestYPoint + GAP, self.CategoryIcon.frame.size.width, self.CategoryIcon.frame.size.height);
        categorylabel.frame = CGRectMake(labelsLeftMargin, lowestYPoint+3+GAP, fieldsWidth, categorylabel.frame.size.height);
        lowestYPoint = (CGRectGetMaxY(self.CategoryIcon.frame) > CGRectGetMaxY(categorylabel.frame)) ? CGRectGetMaxY(self.CategoryIcon.frame) : CGRectGetMaxY(categorylabel.frame);
    } else {
        categorylabel.hidden=YES;
        self.CategoryIcon.hidden=YES;
    }
    
    if (((![expirelabel.text isEqualToString:@"0000-00-00 00:00:00"]) && (![expirelabel.text isEqualToString:@"0"])) && expirelabel.text.length > 0) {
        self.ExpireIcon.frame = CGRectMake(iconsLeftMargin, lowestYPoint + GAP, self.ExpireIcon.frame.size.width, self.ExpireIcon.frame.size.height);
        expirelabel.frame = CGRectMake(labelsLeftMargin, lowestYPoint+3+GAP, fieldsWidth, expirelabel.frame.size.height);
        lowestYPoint=(CGRectGetMaxY(self.ExpireIcon.frame) > CGRectGetMaxY(expirelabel.frame)) ? CGRectGetMaxY(self.ExpireIcon.frame) : CGRectGetMaxY(expirelabel.frame);
    } else {
        expirelabel.hidden = YES;
        self.ExpireIcon.hidden = YES;
    }
    
    if (descriptionlabel.text.length > 0) {
        descriptionlabel.numberOfLines = 0;
        [descriptionlabel sizeToFit];
        self.DescriptionIcon.frame = CGRectMake(iconsLeftMargin, lowestYPoint + GAP, self.DescriptionIcon.frame.size.width, self.DescriptionIcon.frame.size.height);
        descriptionlabel.frame = CGRectMake(labelsLeftMargin, lowestYPoint+3+GAP, fieldsWidth, descriptionlabel.frame.size.height);
        lowestYPoint = (CGRectGetMaxY(self.DescriptionIcon.frame) > CGRectGetMaxY(descriptionlabel.frame)) ? CGRectGetMaxY(self.DescriptionIcon.frame) : CGRectGetMaxY(descriptionlabel.frame);
    } else {
        descriptionlabel.hidden = YES;
        self.DescriptionIcon.hidden = YES;
    }
}

- (void)loadImagesFromUrl {
    
    int photosNumber = [[_deal photoSum]intValue];
    
    if (photosNumber != 0) {
        
        if (!self.captureImage.image) {     // In case the photo wasn't downloaded yet.
            
            NSString *imageURL = [S3_PHOTOS_ADDRESS stringByAppendingString:self.deal.photoID1];
            self.deal.photo1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
            self.captureImage.alpha = 0;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIActivityIndicatorView *loadingIndicator = (UIActivityIndicatorView *)[self.scroll viewWithTag:loadingIndicatorTag];
                [UIView animateWithDuration:0.5 animations:^{
                    loadingIndicator.alpha = 0;
                    self.captureImage.alpha = 1;
                } completion:^(BOOL finished) { [loadingIndicator removeFromSuperview]; }];
            });
        }
        
        if (photosNumber == 2) {
            _urlImage2 = [S3_PHOTOS_ADDRESS stringByAppendingString:self.deal.photoID2];
            self.deal.photo2 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_urlImage2]]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.captureImage2.image = self.deal.photo2;
                [UIView animateWithDuration:0.5 animations:^{
                    [self.imageLoading2 stopAnimating];
                    self.captureImage2.alpha = 1;
                }];
            });
        }
        if (photosNumber == 3) {
            
            _urlImage2 = [S3_PHOTOS_ADDRESS stringByAppendingString:self.deal.photoID2];
            self.deal.photo2 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_urlImage2]]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.captureImage2.image = self.deal.photo2;
                [UIView animateWithDuration:0.5 animations:^{
                    [self.imageLoading2 stopAnimating];
                    self.captureImage2.alpha = 1;
                }];
            });
            
            _urlImage3 = [S3_PHOTOS_ADDRESS stringByAppendingString:self.deal.photoID3];
            self.deal.photo3 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_urlImage3]]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.captureImage3.image = self.deal.photo3;
                [UIView animateWithDuration:0.5 animations:^{
                    [self.imageLoading3 stopAnimating];
                    self.captureImage3.alpha = 1;
                }];
            });
        }
        if (photosNumber == 4) {
            
            _urlImage2 = [S3_PHOTOS_ADDRESS stringByAppendingString:self.deal.photoID2];
            self.deal.photo2 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_urlImage2]]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.captureImage2.image = self.deal.photo2;
                
                [UIView animateWithDuration:0.5 animations:^{
                    [self.imageLoading2 stopAnimating];
                    self.captureImage2.alpha = 1;
                }];
            });
            
            _urlImage3 = [S3_PHOTOS_ADDRESS stringByAppendingString:self.deal.photoID3];
            self.deal.photo3 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_urlImage3]]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.captureImage3.image = self.deal.photo3;
                
                [UIView animateWithDuration:0.5 animations:^{
                    [self.imageLoading3 stopAnimating];
                    self.captureImage3.alpha = 1;
                }];
            });
            
            _urlImage4 = [S3_PHOTOS_ADDRESS stringByAppendingString:self.deal.photoID4];
            self.deal.photo4 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_urlImage4]]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.captureImage4.image = self.deal.photo4;
                
                [UIView animateWithDuration:0.5 animations:^{
                    [self.imageLoading4 stopAnimating];
                    self.captureImage4.alpha = 1;
                }];
            });
        }
    }
}

-(void) loadVarsFromDeal{
    
    titlelabel.text = [_deal title];
    storelabel.text = self.deal.store != nil ? [@"Store: " stringByAppendingString:self.deal.store.name] : @"No store";
    pricelabel.text = self.deal.price != nil ? [self.deal.currency stringByAppendingString:self.deal.price.stringValue] : nil;
    discountlabel.text = self.deal.discountValue != nil ? [self.deal.discountValue stringValue] : nil;
    
    if (self.deal.category.length > 0 && ![self.deal.category isEqualToString:@"No Category"]) {
        
        NSString *category = [appDelegate getCategoryValueForKey:self.deal.category];
        categorylabel.text = category != nil ? [@"Category: " stringByAppendingString:category] : @"No Category";;
        
    } else
        categorylabel.text = nil;
    
    if (self.deal.expiration)
        expirelabel.text = [@"Expires on " stringByAppendingString:[self.dateFormatter stringFromDate:self.deal.expiration]];
    else
        expirelabel.text = nil;
    
    if (self.deal.moreDescription.length > 0)
        descriptionlabel.text = [@"Description: " stringByAppendingString:self.deal.moreDescription];
    else
        descriptionlabel.text = nil;
    
    likelabel = [[_deal likeCounter] stringValue];
    commentlabel = [[_deal commentCounter] stringValue];
    LikeOrUnlike = TRUE;
}

- (void)setDealerSection
{
    CGRect dealerSectionFrame = self.dealerSection.frame;
    dealerSectionFrame.origin.y = lowestYPoint + sectionGap;
    self.dealerSection.frame = dealerSectionFrame;
    lowestYPoint = (CGRectGetMaxY(self.dealerSection.frame));
    
    self.dealerSection.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    Dealer *dealer = self.deal.dealer;
    
    self.dealerImage.layer.cornerRadius = self.dealerImage.frame.size.width / 2;
    self.dealerImage.layer.masksToBounds = YES;
    
    self.dealersNameLabel.text = dealer.fullName;
    
    if (self.deal.uploadDate) {
        self.uploadDateLabel.text = [@"Uploaded on " stringByAppendingString:[self.dateFormatter stringFromDate:self.deal.uploadDate]];
    }
    
    if (self.deal.dealer.photoID.length > 0) {
        
        self.dealerImage.alpha = 0;
        
        dispatch_queue_t queue = dispatch_queue_create("com.MyQueue3", NULL);
        dispatch_async(queue, ^{
            
            NSString *urlImage = [S3_PHOTOS_ADDRESS stringByAppendingString:dealer.photoID];
            UIImage *dealerImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlImage]]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.dealerImage.image = dealerImage;
                [UIView animateWithDuration:0.3 animations:^{ self.dealerImage.alpha = 1; }];
            });
        });
        
    } else {
        
        self.dealerImage.image = [UIImage imageNamed:@"Profile Pic Placeholder"];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    if (self.afterEditing) { // If the user edited the deal, then it should load iteself again in order to present the updated info.
        
        // Run the refreash method now. (Need to create it....)
        
    }
    
    if ([self.isShortCell isEqualToString:@"yes"]) {
        self.cameraScrollView.hidden = YES;
        
    } else {
        self.captureImage.image = self.deal.photo1;
        
        if (!self.captureImage.image) { // In case the photo didn't downloaded in the my feed yet.
            UIActivityIndicatorView *loadingIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            loadingIndicator.center = self.captureImage.center;
            loadingIndicator.tag = loadingIndicatorTag;
            [loadingIndicator startAnimating];
            [self.scroll addSubview:loadingIndicator];
        }
        
        if ([[self.deal photoSum]intValue] >= 2) {
            self.pageControl.hidden = NO;
        } else {
            self.pageControl.hidden = YES;
        }
        
        dispatch_queue_t queue = dispatch_queue_create("com.MyQueue", NULL);
        dispatch_async(queue, ^{
            
            [self loadImagesFromUrl];
        });
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialize];
    
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Dealers Logo"]];
    
    [self loadVarsFromDeal];
    [self setPageControlView];
    [self setDummyCommentsArray];
    [self locateIconsInPlace];
    [self setDealerSection];
    [self setLikesAndButtonsSection];
    [self setCommentsSection];
    [self setMapAndStoreInfo];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self setSharedView];
    [self screenshotSharedView];
    
    UIButton *plusButton = (UIButton *)[self.tabBarController.view viewWithTag:123];
    
    [self performSelector:@selector(bringPlusButtonToFront:) withObject:plusButton afterDelay:0.01];
    
    [self setDealAttribRequestDescriptor];
}

- (void)bringPlusButtonToFront:(UIButton *)plusButton
{
    [self.tabBarController.view bringSubviewToFront:plusButton];
}

- (void)initialize
{
    self.appDelegate = [[UIApplication sharedApplication]delegate];
    
    [self setDateFormatter];
    
    _tableViewLikes.hidden = YES;
    
    self.scroll.frame = [[UIScreen mainScreen] bounds];
    
    cellNumberInScrollView = 0;
    likesView = NO;
    self.afterEditing = NO;
}

- (void)setDealAttribRequestDescriptor
{
    RKObjectMapping *dealAttribMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [dealAttribMapping addAttributeMappingsFromDictionary:@{
                                                            @"likeCounter" : @"like_counter",
                                                            @"shareCounter" : @"share_counter",
                                                            @"objectiveRank" : @"objective_rank",
                                                            @"dealReliability" : @"deal_reliability",
                                                            }];
    
    RKRequestDescriptor *dealAttribRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:dealAttribMapping
                                                                                             objectClass:[DealAttrib class]
                                                                                             rootKeyPath:nil
                                                                                                  method:RKRequestMethodAny];
    
    [[RKObjectManager sharedManager] addRequestDescriptor:dealAttribRequestDescriptor];
}

-(void)setDateFormatter
{
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
}

- (void)setPageControlView
{
    self.pageControl.numberOfPages = [[self.deal photoSum]intValue];
    [self.cameraScrollView setContentSize:((CGSizeMake(320*[[self.deal photoSum]intValue], 165)))];
    [self.cameraScrollView setScrollEnabled:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self deallocMapView];
    // Dispose of any resources that can be recreated.
}

- (void)setDummyCommentsArray
{
    self.comments = [[NSMutableArray alloc]init];
    
    Comment *comment = [[Comment alloc]init];
    comment.dealer = self.appDelegate.dealer;
    comment.text = @"This is a really nice deal! The interesting part is that bla bla bla bla bla bla bla bla. GO check it out!";
    comment.uploadDate = [NSDate date];
    [self.comments addObject:comment];
    
    comment = [[Comment alloc]init];
    comment.dealer = self.appDelegate.dealer;
    comment.text = @"Hey whats up....? \n good good";
    comment.uploadDate = [NSDate date];
    [self.comments addObject:comment];
    
    comment = [[Comment alloc]init];
    comment.dealer = self.appDelegate.dealer;
    comment.text = @"This is a really nice deal! The interesting part is that bla bla bla bla bla bla bla bla. GO check it out!";
    comment.uploadDate = [NSDate date];
    [self.comments addObject:comment];
    
    comment = [[Comment alloc]init];
    comment.dealer = self.appDelegate.dealer;
    comment.text = @":)";
    comment.uploadDate = [NSDate date];
    [self.comments addObject:comment];
    
    comment = [[Comment alloc]init];
    comment.dealer = self.appDelegate.dealer;
    comment.text = @"Hey whats up my name is Gilad and I love mostly sports and electronics. If you want to see go offers in these categories, contuct me!";
    comment.uploadDate = [NSDate date];
    [self.comments addObject:comment];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (IBAction)LikeButtonAction:(id)sender
{
    if (self.likeButtonSelected.hidden) {
        
        self.likeButtonSelected.hidden = NO;
        self.likeButtonSelected.alpha = 0;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.likeButtonSelected.transform = CGAffineTransformMakeScale(0.3, 0.3);
            self.likeButtonSelected.transform = CGAffineTransformMakeScale(1.0, 1.0);
            self.likeButtonSelected.alpha = 1.0;
        } completion:^(BOOL finished) {
            self.likeButton.hidden = YES;
        }];
        
        self.deal.dealAttrib.likeCounter = [NSNumber numberWithInt:self.deal.dealAttrib.likeCounter.intValue + 1];
        
    } else {
        
        self.likeButton.hidden = NO;
        self.likeButton.alpha = 1.0;
        
        [UIView animateWithDuration:0.15 animations:^{
            self.likeButtonSelected.alpha = 0;
        } completion:^(BOOL finished) {
            self.likeButtonSelected.hidden = YES;
        }];
        
        self.deal.dealAttrib.likeCounter = [NSNumber numberWithInt:self.deal.dealAttrib.likeCounter.intValue - 1];
    }
    
    NSLog(@"Likes count: %@", self.deal.dealAttrib.likeCounter);
}

- (void)performLikeAction
{
    if (!self.likeButtonSelected.hidden && !self.isDealLikedByUser) {
        
        // The deal wasn't liked by the user and now he likes it
        
        // Send the new dealAttrib
        
        NSString *path = [NSString stringWithFormat:@"/dealatribs/%@", self.deal.dealAttrib.dealAttribID];
        
        [[RKObjectManager sharedManager] patchObject:self.deal.dealAttrib
                                                path:path
                                          parameters:nil
                                             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                 
                                                 // is this returning 201...?
                                             }
                                             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                 [alert show];
                                             }];
        
        // Create and send a notification to the recipient
        
        Notification *notification = [[Notification alloc]init];
        
        [[RKObjectManager sharedManager] postObject:self.deal.dealAttrib
                                               path:path
                                         parameters:nil
                                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                
                                                // is this returning 201...?
                                            }
                                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                [alert show];
                                            }];
    }
}

-(void) loadDataFromDB {
    NSString *url = [NSString stringWithFormat:@"http://www.dealers.co.il/setLikeToDeal.php?Indicator=%@&Dealid=%@",@"wholikesthedeal",[_deal dealID]];
    NSData *URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSString *DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    _DealersDataWhoLikesTheDealArray = [DataResult componentsSeparatedByString:@"."];
    
    _dealersNameArray = [[NSMutableArray alloc]init];
    _dealersPhotoArray = [[NSMutableArray alloc]init];
    _dealersPhotoDataArray = [[NSMutableArray alloc]init];
    _dealersidArray = [[NSMutableArray alloc]init];
    
    for (int i=0; i<([[_DealersDataWhoLikesTheDealArray copy]count]-1); i=i+3) {
        [_dealersidArray addObject:[_DealersDataWhoLikesTheDealArray objectAtIndex:i]];
        [_dealersNameArray addObject:[_DealersDataWhoLikesTheDealArray objectAtIndex:i+1]];
        [_dealersPhotoArray addObject:[_DealersDataWhoLikesTheDealArray objectAtIndex:i+2]];
        [_dealersPhotoDataArray addObject:@"0"];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView ==_tableViewLikes) {
        if ([_dealersNameArray count] == 0) {
            return 0;
        }
        return [_dealersNameArray count];
        
    } else if (tableView == self.commentsTableView) {
        if (self.comments.count <= 3) {
            self.commentsPreviewCount = self.comments.count;
            return self.comments.count + 1; // The +1 is for the add comment button.
        } else {
            self.commentsPreviewCount = 4;
            return 4;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LikesCell *Cell=nil;
    
    if (tableView == _tableViewLikes) {
        
        static NSString *CellIdentifier = @"likescell";
        Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!Cell) Cell = [[LikesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        if (indexPath.row<[_dealersNameArray count]) {
            Cell.dealerName.text = [_dealersNameArray objectAtIndex:indexPath.row];
        } else Cell.dealerName.text = @"Unknown";
        
        if ([[_dealersPhotoDataArray objectAtIndex:indexPath.row] isEqual:@"0"]) {
            dispatch_queue_t queue = dispatch_queue_create("com.MyQueue3", NULL);
            dispatch_async(queue, ^{
                // Do some computation here.
                NSString *FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/%@.jpg",[_dealersPhotoArray objectAtIndex:indexPath.row]];
                NSData *URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
                // Update UI after computation.
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Update the UI on the main thread.
                    UIImage *image = [UIImage imageWithData:URLData];
                    [_dealersPhotoDataArray replaceObjectAtIndex:indexPath.row withObject:image];
                    Cell.dealerImage.image = image;
                    CALayer *mask = [CALayer layer];
                    mask.contents=(id)[[UIImage imageNamed:@"My Feed+View Deal (final)_Deal Pic mask.png"]CGImage];
                    mask.frame = CGRectMake(0, 0, 40, 40);
                    Cell.dealerImage.layer.mask = mask;
                    Cell.dealerImage.layer.masksToBounds = YES;
                    
                    [_tableViewLikes beginUpdates];
                    [_tableViewLikes reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
                    [_tableViewLikes endUpdates];
                });
            });
            
        } else {
            Cell.dealerImage.image = [_dealersPhotoDataArray objectAtIndex:indexPath.row];
            CALayer *mask = [CALayer layer];
            mask.contents=(id)[[UIImage imageNamed:@"My Feed+View Deal (final)_Deal Pic mask.png"]CGImage];
            mask.frame = CGRectMake(0, 0, 40, 40);
            Cell.dealerImage.layer.mask = mask;
            Cell.dealerImage.layer.masksToBounds = YES;
        }
    }
    
    else if (tableView == self.commentsTableView) {
        
        if (self.commentsPreviewCount - 1 != indexPath.row) {
            
            static NSString *commentsTableCellIdentifier = @"CommentsTableCell";
            Comment *comment = [self.comments objectAtIndex:indexPath.row];
            CommentsTableCell *cell = (CommentsTableCell *)[tableView dequeueReusableCellWithIdentifier:commentsTableCellIdentifier];
            
            if (!cell) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommentsTableCell" owner:nil options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            cell.dealerProfilePic.image = self.appDelegate.dealer.photo;
            cell.dealerName.text = comment.dealer.fullName;
            cell.commentDate.text = [comment.dateFormatter stringFromDate:comment.uploadDate];
            cell.commentBody.text = comment.text;
            [cell.commentBody sizeToFit];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSLog(@"\n origin x: %f \n origin y: %f \n width: %f \n height: %f",
                  cell.commentBody.frame.origin.x,
                  cell.commentBody.frame.origin.y,
                  cell.commentBody.frame.size.width,
                  cell.commentBody.frame.size.height);
            
            return cell;
            
        } else {
            
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            
            cell.backgroundColor = [UIColor clearColor];
            
            UIImageView *yourCommentProfilePic = [[UIImageView alloc]initWithFrame:CGRectMake(iconsLeftMargin, 12, 40, 40)];
            yourCommentProfilePic.image = self.appDelegate.dealer.photo;
            yourCommentProfilePic.layer.cornerRadius = yourCommentProfilePic.frame.size.width / 2;
            yourCommentProfilePic.layer.masksToBounds = YES;
            [cell.contentView addSubview:yourCommentProfilePic];
            
            UILabel *addCommentTitle = [[UILabel alloc]initWithFrame:CGRectMake(58, 12, 244, 39)];
            addCommentTitle.textColor = [UIColor lightGrayColor];
            addCommentTitle.font = [UIFont fontWithName:@"Avenir-Light" size:16.0];
            addCommentTitle.text = @"  Add a comment...";
            addCommentTitle.backgroundColor = [UIColor whiteColor];
            addCommentTitle.layer.cornerRadius = 4.0;
            addCommentTitle.layer.masksToBounds = YES;
            [cell.contentView addSubview:addCommentTitle];
            
            UIButton *addComment = [UIButton buttonWithType:UIButtonTypeCustom];
            [addComment setFrame:addCommentTitle.frame];
            [addComment setBackgroundColor:[UIColor clearColor]];
            [addComment addTarget:self action:@selector(CommentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:addComment];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.separatorInset = UIEdgeInsetsMake(0, [[UIScreen mainScreen]bounds].size.width * 2, 0, 0);
            
            return cell;
        }
    }
    
    return Cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.commentsTableView) {
        
        Comment *comment = [self.comments objectAtIndex:indexPath.row];
        self.cellPrototype.commentBody.text = comment.text;
        [self.cellPrototype layoutSubviews];
        
        self.tableViewHeight += self.cellPrototype.requiredCellHeight;
        
        return MAX(self.cellPrototype.requiredCellHeight, 60.0f);
        
    } else {
        return tableView.rowHeight;
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"likescell"]) {
        NSIndexPath *indexpath = [_tableViewLikes indexPathForSelectedRow];
        NSString *string;
        string = [_dealersidArray objectAtIndex:indexpath.row];
        [[segue destinationViewController] setDealerId:string];
        [[segue destinationViewController] setDidComeFromLikesTable:@"yes"];
    }
}

-(void)whoLikesTheDeal:(id)sender
{
    if (![likelabel isEqualToString:@"0"]) {
        likesView=YES;
        dispatch_queue_t queue = dispatch_queue_create("com.MyQueue4", NULL);
        dispatch_async(queue, ^{
            // Do some computation here.
            [self loadDataFromDB];
            // Update UI after computation.
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI on the main thread.
                _ViewLikes.hidden=NO;
                [_tableViewLikes reloadData];
            });
        });
    }
}

- (IBAction)CommentButtonAction:(id)sender {
    
    CommentsTableViewController *ctvc = [self.storyboard instantiateViewControllerWithIdentifier:@"Comments"];
    ctvc.comments = self.comments;
    ctvc.deal = self.deal;
    [ctvc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:ctvc animated:YES];
    
    UIButton *senderButton = (UIButton *)sender;
    
    if (senderButton.tag == 123456789) {
        ctvc.isKeyboardReady = NO;
    } else {
        ctvc.isKeyboardReady = YES;
    }
}

- (IBAction)ShareButtonAction:(id)sender {
    
    NSString *messageText = @"Hear from others about great deals at Dealers!";
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
        }
    }];
    
    [self presentViewController:activityController animated:YES completion:nil];
}

- (IBAction)optionsAction:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"Cancel"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@"Edit Deal", @"Report as Spam", nil];
    
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    
    self.optionsButtonSelected.hidden = NO;
    self.optionsButtonSelected.alpha = 0;
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.optionsButtonSelected.alpha = 1.0;
                         self.optionsButton.alpha = 0; }
                     completion:^(BOOL finished){
                         self.optionsButton.hidden = YES; }];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = self.cameraScrollView.frame.size.width;
    currentpage = floor((self.cameraScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = currentpage;
}

-(void) deallocMapView {
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

-(void) deallocMemory {
    [self deallocMapView];
    self.DealersDataWhoLikesTheDealArray=nil;
    _dealersNameArray=nil;
    _dealersLocationArray=nil;
    _dealersPhotoArray=nil;
    _dealersPhotoDataArray=nil;
    _dealersidArray=nil;
    _dealsPhotosidArray=nil;
    _dealsPhotosArray=nil;
    _deal=nil;
    _isShortCell=nil;
    _isDealLikedByUser=nil;
    _urlImage=nil;
    _urlImage2=nil;
    _urlImage3=nil;
    _urlImage4=nil;
}

- (IBAction)dealerProfileButtonClicked:(id)sender {
    ProfileViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"profile"];
    controller.dealerId=[_deal dealUserID];
    controller.didComeFromLikesTable=@"yes";
    UINavigationController *navigationController = self.navigationController;
    [navigationController pushViewController:controller animated:YES];
}

- (IBAction)urlSiteButtonClicked:(id)sender {
    NSString *DataResult;
    if (![[_deal dealUrlSite] isEqualToString:@"0"]) {
        DataResult = [@"http://" stringByAppendingString:[_deal dealUrlSite]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:DataResult]];
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
    
    UIImageView *dealPic = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, self.captureImage.frame.size.height)];
    dealPic.image = self.captureImage.image;
    [sharedView addSubview:dealPic];
    
    CGFloat titleBackgroundHeight = 78.0;
    UIImageView *titleBackground = [[UIImageView alloc]initWithFrame:CGRectMake(0, dealPic.frame.size.height - titleBackgroundHeight, screenWidth, titleBackgroundHeight)];
    titleBackground.image = [UIImage imageNamed:@"Title Background"];
    titleBackground.alpha = 0.65;
    [sharedView addSubview:titleBackground];
    
    CGFloat titleLabelHeight = 48.0;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(iconsLeftMargin,
                                                                   dealPic.frame.size.height - titleLabelHeight - 5,
                                                                   screenWidth - iconsLeftMargin * 2,
                                                                   titleLabelHeight)];
    titleLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:17.0];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.numberOfLines = 2;
    titleLabel.text = self.titlelabel.text;
    [sharedView addSubview:titleLabel];
    
    CGFloat detailsVerticalGap = 7.0;
    CGFloat detailsLowestYPoint;
    CGFloat priceXPoint = labelsLeftMargin;
    UIColor *detailsTextColor = [UIColor colorWithRed:160.0/255.0 green:160.0/255.0 blue:168.0/255.0 alpha:1.0];
    
    UIImageView *storeIcon = [[UIImageView alloc]initWithFrame:CGRectMake(iconsLeftMargin,
                                                                          dealPic.frame.size.height + detailsVerticalGap,
                                                                          self.StoreIcon.frame.size.width,
                                                                          self.StoreIcon.frame.size.height)];
    storeIcon.image = [UIImage imageNamed:@"Store Icon"];
    [sharedView addSubview:storeIcon];
    
    UILabel *storeLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelsLeftMargin,
                                                                   storeIcon.frame.origin.y,
                                                                   self.storelabel.frame.size.width,
                                                                   storeIcon.frame.size.height)];
    storeLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:15.0];
    storeLabel.textColor = detailsTextColor;
    storeLabel.numberOfLines = 1;
    storeLabel.text = self.storelabel.text;
    [sharedView addSubview:storeLabel];
    
    detailsLowestYPoint = CGRectGetMaxY(storeIcon.frame);
    
    if (self.pricelabel.text.length > 0 || self.discountlabel.text.length > 0) {
        
        UIImageView *priceIcon = [[UIImageView alloc]initWithFrame:CGRectMake(iconsLeftMargin,
                                                                              detailsLowestYPoint + detailsVerticalGap,
                                                                              self.PriceIcon.frame.size.width,
                                                                              self.PriceIcon.frame.size.height)];
        priceIcon.image = [UIImage imageNamed:@"Price Icon"];
        [sharedView addSubview:priceIcon];
        
        if (self.pricelabel.text.length > 0) {
            
            UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelsLeftMargin,
                                                                           priceIcon.frame.origin.y,
                                                                           self.pricelabel.frame.size.width,
                                                                           priceIcon.frame.size.height)];
            priceLabel.text = self.pricelabel.text;
            [priceLabel sizeToFit];
            priceLabel.center = priceIcon.center;
            CGRect priceLabelFrame = priceLabel.frame;
            priceLabelFrame.origin.x = labelsLeftMargin;
            priceLabel.frame = priceLabelFrame;
            
            priceLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:15.0];
            priceLabel.textColor = detailsTextColor;
            priceLabel.numberOfLines = 1;
            [sharedView addSubview:priceLabel];
            
            priceXPoint = CGRectGetMaxX(priceLabel.frame) + 20;
        }
        
        if (self.discountlabel.text.length > 0) {
            
            UILabel *discountLabel = [[UILabel alloc]initWithFrame:CGRectMake(priceXPoint,
                                                                              priceIcon.frame.origin.y,
                                                                              self.pricelabel.frame.size.width,
                                                                              priceIcon.frame.size.height)];
            discountLabel.text = self.discountlabel.text;
            [discountLabel sizeToFit];
            discountLabel.center = priceIcon.center;
            CGRect discountLabelFrame = discountLabel.frame;
            discountLabelFrame.origin.x = priceXPoint;
            discountLabel.frame = discountLabelFrame;
            
            discountLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:15.0];
            discountLabel.textColor = detailsTextColor;
            discountLabel.numberOfLines = 1;
            [sharedView addSubview:discountLabel];
        }
        
        detailsLowestYPoint = CGRectGetMaxY(priceIcon.frame);
    }
    
    if (self.categorylabel.text.length > 0 && [self.categorylabel.text rangeOfString:@"No Category"].location == NSNotFound) {
        
        UIImageView *categoryIcon = [[UIImageView alloc]initWithFrame:CGRectMake(iconsLeftMargin,
                                                                                 detailsLowestYPoint + detailsVerticalGap,
                                                                                 self.CategoryIcon.frame.size.width,
                                                                                 self.CategoryIcon.frame.size.height)];
        categoryIcon.image = [UIImage imageNamed:@"Category Icon"];
        [sharedView addSubview:categoryIcon];
        
        UILabel *categoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelsLeftMargin,
                                                                          categoryIcon.frame.origin.y,
                                                                          self.categorylabel.frame.size.width,
                                                                          categoryIcon.frame.size.height)];
        categoryLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:15.0];
        categoryLabel.textColor = detailsTextColor;
        categoryLabel.numberOfLines = 1;
        categoryLabel.text = self.categorylabel.text;
        [sharedView addSubview:categoryLabel];
        
        detailsLowestYPoint = CGRectGetMaxY(categoryIcon.frame);
    }
    
    if (![expirelabel.text isEqualToString:@"0000-00-00 00:00:00"] && ![expirelabel.text isEqualToString:@"0"] && expirelabel.text.length > 0) {
        
        UIImageView *expirationIcon = [[UIImageView alloc]initWithFrame:CGRectMake(iconsLeftMargin,
                                                                                   detailsLowestYPoint + detailsVerticalGap,
                                                                                   self.ExpireIcon.frame.size.width,
                                                                                   self.ExpireIcon.frame.size.height)];
        storeIcon.image = [UIImage imageNamed:@"Expiration Date Icon"];
        [sharedView addSubview:expirationIcon];
        
        UILabel *expirationLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelsLeftMargin,
                                                                            expirationIcon.frame.origin.y,
                                                                            self.expirelabel.frame.size.width,
                                                                            expirationIcon.frame.size.height)];
        expirationLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:15.0];
        expirationLabel.textColor = detailsTextColor;
        expirationLabel.numberOfLines = 1;
        expirationLabel.text = self.expirelabel.text;
        [sharedView addSubview:expirationLabel];
        
        detailsLowestYPoint = CGRectGetMaxY(expirationLabel.frame);
    }
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
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"WhatsApp not installed." message:@"Your device should have WhatsApp installed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
            
            [self presentViewController:navigationController animated:YES completion:nil];
        }
            break;
            
        case 1: // Report as Spam:
            // ...
            break;
            
        default:
            break;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.optionsButton.hidden = NO;
    self.optionsButton.alpha = 0;
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.optionsButtonSelected.alpha = 0;
                         self.optionsButton.alpha = 1.0; }
                     completion:^(BOOL finished){
                         self.optionsButtonSelected.hidden = YES; }];
}

@end

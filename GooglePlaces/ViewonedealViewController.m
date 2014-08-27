//
//  ViewonedealViewController.m
//  GooglePlaces
//
//  Created by itzik berrebi on 9/26/13.
//
//

#import "ViewonedealViewController.h"
#import "MoreViewController.h"
#import "ProfileViewController.h"
#import "ExploretableViewController.h"
#import "AppDelegate.h"
#import "TableViewController.h"
#import "LikesCell.h"
#import <QuartzCore/QuartzCore.h>
#import "OnlineViewController.h"

#define GAP 15
#define sectionGap 20
#define loadingIndicatorTag 1111

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

-(void) startLoadingUploadImage
{
    _loadingImage.animationImages = [NSArray arrayWithObjects:
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
    _loadingImage.animationDuration = 0.3;
    [_loadingImage startAnimating];
    [UIView animateWithDuration:0.2 animations:^{_loadingImage.alpha = 1.0; _loadingImage.transform =CGAffineTransformMakeScale(0,0);
        _loadingImage.transform =CGAffineTransformMakeScale(1,1);}];
}

-(void) setMapAndStoreInfo
{
    self.mapAndStoreSection = [[UIView alloc]initWithFrame:CGRectMake(0, lowestYPoint, self.view.frame.size.width, 500)];
    [self.scroll addSubview:self.mapAndStoreSection];
    
    if (![[self.dealClass dealStoreLatitude] isEqualToString:@"0"]) {
        
        self.mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 240)];
        
        lastCoords.latitude = [[_dealClass dealStoreLatitude] doubleValue];
        lastCoords.longitude = [[_dealClass dealStoreLongitude] doubleValue];
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
        storeTitle.text = [_dealClass store];
        storeTitle.textColor = [UIColor whiteColor];
        [self.mapAndStoreSection addSubview:storeTitle];
        
        if (![self.dealClass.dealStoreAddress isEqualToString:@"0"]) {
            
            UILabel *storeAddress = [[UILabel alloc]initWithFrame:CGRectMake(10, mapBottom - 20, 300, 14)];
            [storeAddress setFont:[UIFont fontWithName:@"Avenir-Roman" size:13.0]];
            storeAddress.text = [_dealClass dealStoreAddress];
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
        [NSString stringWithFormat:@"waze://?ll=%f,%f&navigate=yes",[[_dealClass dealStoreLatitude] doubleValue], [[_dealClass dealStoreLongitude] doubleValue]];
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
    
    if (![[self.dealClass likeCounter] isEqualToString:@"0"]) {
        CGRect likesSectionFrame = self.likesAndButtonsSection.frame;
        likesSectionFrame.origin.y = lowestYPoint + 7;
        self.likesAndButtonsSection.frame = likesSectionFrame;
        
        NSString *likesCountPrefix = [NSString stringWithFormat:@"%@",[_dealClass likeCounter]];
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
        
        self.likesAndButtonsSection.frame = CGRectMake(0, originY, self.likesAndButtonsSection.frame.size.width, self.LikeButton.frame.size.height + sectionGap * 2);
    }
    
    lowestYPoint = (CGRectGetMaxY(self.likesAndButtonsSection.frame));
    
    [self setScrollSize];
}

-(void) setScrollSize
{
    [scroll setContentSize:CGSizeMake(320, lowestYPoint)];
}

-(void) locateIconsInPlace
{
    flag = NO;
    int offset;
    if ([[_dealClass photoSum]intValue]==0) {
        offset = 10;
    } else offset = 184;
    
    self.TitleIcon.frame = CGRectMake(10, offset, self.TitleIcon.frame.size.width, self.TitleIcon.frame.size.height);
    titlelabel.frame = CGRectMake(12, offset + 4, titlelabel.frame.size.width, titlelabel.frame.size.height);
    titlelabel.numberOfLines = 0;
    [titlelabel sizeToFit];
    
    lowestYPoint=(CGRectGetMaxY(self.TitleIcon.frame) > CGRectGetMaxY(titlelabel.frame)) ? CGRectGetMaxY(self.TitleIcon.frame) : CGRectGetMaxY(titlelabel.frame);
    
    self.StoreIcon.frame = CGRectMake(10, lowestYPoint + GAP, self.StoreIcon.frame.size.width, self.StoreIcon.frame.size.height);
    storelabel.frame = CGRectMake(50, lowestYPoint+3+GAP, storelabel.frame.size.width, storelabel.frame.size.height);
    
    if ([[_dealClass type] isEqualToString:@"online"]) {
        _urlSiteButton.frame = CGRectMake(50, lowestYPoint+3+GAP, storelabel.frame.size.width, storelabel.frame.size.height);
    } else _urlSiteButton.hidden=YES;
    
    lowestYPoint = (CGRectGetMaxY(self.StoreIcon.frame) > CGRectGetMaxY(storelabel.frame)) ? CGRectGetMaxY(self.StoreIcon.frame) : CGRectGetMaxY(storelabel.frame);
    
    maxXPoint = 50;
    
    if (![pricelabel.text isEqualToString:@"0"]) {
        [pricelabel sizeToFit];
        self.PriceIcon.frame = CGRectMake(10, lowestYPoint + GAP, self.PriceIcon.frame.size.width, self.PriceIcon.frame.size.height);
        pricelabel.frame = CGRectMake(maxXPoint, lowestYPoint+3+GAP, pricelabel.frame.size.width, pricelabel.frame.size.height);
        flag = YES;
        maxXPoint= CGRectGetMaxX (pricelabel.frame)+20;
    } else {
        pricelabel.hidden=YES;
    }
    
    if (![discountlabel.text isEqualToString:@"0"]) {
        discountlabel.text = [discountlabel.text stringByAppendingString:@"%"];
        self.PriceIcon.frame = CGRectMake(10, lowestYPoint + GAP, self.PriceIcon.frame.size.width, self.PriceIcon.frame.size.height);
        discountlabel.frame = CGRectMake(maxXPoint, lowestYPoint+3+GAP, discountlabel.frame.size.width, discountlabel.frame.size.height);
        lowestYPoint=(CGRectGetMaxY(self.PriceIcon.frame) > CGRectGetMaxY(discountlabel.frame)) ? CGRectGetMaxY(self.PriceIcon.frame) : CGRectGetMaxY(discountlabel.frame);
    } else {
        discountlabel.hidden=YES;
        if (![pricelabel.text isEqualToString:@"0"]) {
            lowestYPoint=(CGRectGetMaxY(self.PriceIcon.frame) > CGRectGetMaxY(pricelabel.frame)) ? CGRectGetMaxY(self.PriceIcon.frame) : CGRectGetMaxY(pricelabel.frame);
        }
    }
    
    if ((pricelabel.hidden == YES) && (discountlabel.hidden == YES)) self.PriceIcon.hidden=YES;
    
    if ((![categorylabel.text isEqualToString:@""]) || (![categorylabel.text isEqualToString:@"No Category"])) {
        self.CategoryIcon.frame = CGRectMake(10, lowestYPoint + GAP, self.CategoryIcon.frame.size.width, self.CategoryIcon.frame.size.height);
        categorylabel.frame = CGRectMake(50, lowestYPoint+3+GAP, categorylabel.frame.size.width, categorylabel.frame.size.height);
        lowestYPoint=(CGRectGetMaxY(self.CategoryIcon.frame) > CGRectGetMaxY(categorylabel.frame)) ? CGRectGetMaxY(self.CategoryIcon.frame) : CGRectGetMaxY(categorylabel.frame);
    } else {
        categorylabel.hidden=YES;
        self.CategoryIcon.hidden=YES;
    }
    
    if (((![expirelabel.text isEqualToString:@"0000-00-00 00:00:00"]) && (![expirelabel.text isEqualToString:@"0"])) && ([expirelabel.text length] > 0)) {
        self.ExpireIcon.frame = CGRectMake(10, lowestYPoint + GAP, self.ExpireIcon.frame.size.width, self.ExpireIcon.frame.size.height);
        expirelabel.frame = CGRectMake(50, lowestYPoint+3+GAP, expirelabel.frame.size.width, expirelabel.frame.size.height);
        lowestYPoint=(CGRectGetMaxY(self.ExpireIcon.frame) > CGRectGetMaxY(expirelabel.frame)) ? CGRectGetMaxY(self.ExpireIcon.frame) : CGRectGetMaxY(expirelabel.frame);
    } else {
        expirelabel.hidden = YES;
        self.ExpireIcon.hidden = YES;
    }
    
    if (![descriptionlabel.text isEqualToString:@"0"]) {
        descriptionlabel.numberOfLines=0;
        [descriptionlabel sizeToFit];
        self.DescriptionIcon.frame = CGRectMake(10, lowestYPoint + GAP, self.DescriptionIcon.frame.size.width, self.DescriptionIcon.frame.size.height);
        descriptionlabel.frame = CGRectMake(50, lowestYPoint+3+GAP, descriptionlabel.frame.size.width, descriptionlabel.frame.size.height);
        lowestYPoint = (CGRectGetMaxY(self.DescriptionIcon.frame) > CGRectGetMaxY(descriptionlabel.frame)) ? CGRectGetMaxY(self.DescriptionIcon.frame) : CGRectGetMaxY(descriptionlabel.frame);
    } else {
        descriptionlabel.hidden = YES;
        self.DescriptionIcon.hidden = YES;
    }
}

- (void)loadImageFromUrl {
    int photosNumber = [[_dealClass photoSum]intValue];
    if (photosNumber != 0) {
        
        if (!self.captureImage.image) {     // In case the photo wasn't downloaded yet.
            NSString *imageURL = [NSString stringWithFormat:@"http://www.dealers.co.il/%@.jpg",[_dealClass photoID1]];
            self.dealClass.photo1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
        }
        
        if (photosNumber == 2) {
            _urlImage2 = [NSString stringWithFormat:@"http://www.dealers.co.il/%@.jpg",[_dealClass photoID2]];
            self.dealClass.photo2 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_urlImage2]]];
        }
        if (photosNumber == 3) {
            _urlImage2 = [NSString stringWithFormat:@"http://www.dealers.co.il/%@.jpg",[_dealClass photoID2]];
            _urlImage3 = [NSString stringWithFormat:@"http://www.dealers.co.il/%@.jpg",[_dealClass photoID3]];
            self.dealClass.photo2 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_urlImage2]]];
            self.dealClass.photo3 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_urlImage3]]];
        }
        if (photosNumber == 4) {
            _urlImage2 = [NSString stringWithFormat:@"http://www.dealers.co.il/%@.jpg",[_dealClass photoID2]];
            _urlImage3 = [NSString stringWithFormat:@"http://www.dealers.co.il/%@.jpg",[_dealClass photoID3]];
            _urlImage4 = [NSString stringWithFormat:@"http://www.dealers.co.il/%@.jpg",[_dealClass photoID4]];
            self.dealClass.photo2 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_urlImage2]]];
            self.dealClass.photo3 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_urlImage3]]];
            self.dealClass.photo4 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_urlImage4]]];
        }
    }
    
}

- (void)loadImage
{
    int photosNumber = [[self.dealClass photoSum]intValue];
    
    if (!self.captureImage.image) {
        self.captureImage.alpha = 0;
        self.captureImage.image = self.dealClass.photo1;
        
        UIActivityIndicatorView *loadingIndicator = (UIActivityIndicatorView *)[self.scroll viewWithTag:loadingIndicatorTag];
        [UIView animateWithDuration:0.5 animations:^{
            loadingIndicator.alpha = 0;
            self.captureImage.alpha = 1;
        } completion:^(BOOL finished) { [loadingIndicator removeFromSuperview]; }];
    }
    
    if (photosNumber==2) {
        self.captureImage2.image = self.dealClass.photo2;
    }
    if (photosNumber==3) {
        self.captureImage2.image = self.dealClass.photo2;
        self.captureImage3.image = self.dealClass.photo3;
    }
    if (photosNumber==4) {
        self.captureImage2.image = self.dealClass.photo2;
        self.captureImage3.image = self.dealClass.photo3;
        self.captureImage4.image = self.dealClass.photo4;
    }
    
    [_loadingImage stopAnimating];
    _loadingImage.hidden=YES;
}

-(void) loadVarsFromDeal{
    
    titlelabel.text = [_dealClass title];
    storelabel.text = [_dealClass store];
    categorylabel.text = [_dealClass category];
    pricelabel.text = ![_dealClass.price isEqualToString:@"0"] ? [_dealClass.currency stringByAppendingString:_dealClass.price] : @"0";
    discountlabel.text = [_dealClass discountValue];
    expirelabel.text = [self.dateFormatter stringFromDate:self.dealClass.expiration];
    descriptionlabel.text = [_dealClass moreDescription];
    likelabel = [_dealClass likeCounter];
    commentlabel = [_dealClass commentCounter];
    LikeOrUnlike=TRUE;
}

- (void)setDealerSection
{
    CGRect dealerSectionFrame = self.dealerSection.frame;
    dealerSectionFrame.origin.y = lowestYPoint + sectionGap;
    self.dealerSection.frame = dealerSectionFrame;
    lowestYPoint = (CGRectGetMaxY(self.dealerSection.frame));
    
    self.dealerSection.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIView *dealerSectionBackground = [[UIView alloc]initWithFrame:self.dealerSection.frame];
    dealerSectionBackground.backgroundColor = self.dealerSection.backgroundColor;
    [self.scroll insertSubview:dealerSectionBackground belowSubview:self.dealerSection];
    
    self.dealerSection.alpha = 0;
    
    self.dealerImage.layer.cornerRadius = self.dealerImage.frame.size.width / 2;
    self.dealerImage.layer.masksToBounds = YES;
    
    dispatch_queue_t queue = dispatch_queue_create("com.MyQueue3", NULL);
    dispatch_async(queue, ^{
        
        NSString *FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/setLikeToDeal.php?Indicator=whodiduploadthedeal&Dealid=%@",[_dealClass dealID]];
        NSData *URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
        NSString *DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
        NSArray *DataArray = [DataResult componentsSeparatedByString:@"^"];
        NSString *urlImage = [NSString stringWithFormat:@"http://www.dealers.co.il/%@.jpg",[DataArray objectAtIndex:2]];
        UIImage *dealerImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlImage]]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.uploadDateLabel.text = [@"Uploaded on " stringByAppendingString:[DataArray objectAtIndex:0]];
            self.dealersNameLabel.text = [DataArray objectAtIndex:1];
            self.dealerImage.image = dealerImage;
            
            [UIView animateWithDuration:0.3 animations:^{ self.dealerSection.alpha = 1; }];
        });
    });
    
}

-(void)viewWillAppear:(BOOL)animated
{
    if ([self.isShoetCell isEqualToString:@"yes"]) {
        self.cameraScrollView.hidden = YES;
        
    } else {
        self.captureImage.image = self.dealClass.photo1;
        
        if (!self.captureImage.image) { // In case the photo didn't downloaded in the my feed yet.
            UIActivityIndicatorView *loadingIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            loadingIndicator.center = self.captureImage.center;
            loadingIndicator.tag = loadingIndicatorTag;
            [loadingIndicator startAnimating];
            [self.scroll addSubview:loadingIndicator];
        }
        
        if ([[self.dealClass photoSum]intValue] >= 2) {
            self.pageControl.hidden = NO;
        } else {
            self.pageControl.hidden = YES;
        }
        [self startLoadingUploadImage];
        
        dispatch_queue_t queue = dispatch_queue_create("com.MyQueue", NULL);
        dispatch_async(queue, ^{
            
            [self loadImageFromUrl];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self loadImage];
            });
        });
    }
}

- (void)viewDidLoad
{
    _tableViewLikes.hidden = YES;
    
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Dealers Logo"]];
    
    self.scroll.frame = [[UIScreen mainScreen] bounds];
    
    if ([_likeornotLabelFromMyFeeds isEqualToString:@"yes"]) {
        //        _LikeButton.enabled = NO;
        self.LikeButton.hidden = YES;
        self.likeButtonSelected.hidden = NO;
    }
    
    self.pageControl.numberOfPages=[[_dealClass photoSum]intValue];
    [self.cameraScrollView setContentSize:((CGSizeMake(320*[[_dealClass photoSum]intValue], 165)))];
    [self.cameraScrollView setScrollEnabled:YES];
    
    cellNumberInScrollView = 0;
    likesView = NO;
    
    [self loadVarsFromDeal];
    
    [self locateIconsInPlace];
    [self setDealerSection];
    [self setLikesAndButtonsSection];
    [self setMapAndStoreInfo];
    
    [self setDateFormatter];
    
    [super viewDidLoad];
}

-(void)setDateFormatter
{
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self deallocMapView];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (IBAction)LikeButtonAction:(id)sender
{
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    if ([self.likeornotLabelFromMyFeeds isEqualToString:@"no"]) {
        //        self.LikeButton.enabled = NO;
        self.likeornotLabelFromMyFeeds = @"yes";
        
        self.likeButtonSelected.hidden = NO;
        self.likeButtonSelected.alpha = 0;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.likeButtonSelected.transform = CGAffineTransformMakeScale(0.2, 0.2);
            self.likeButtonSelected.transform = CGAffineTransformMakeScale(1, 1);
            self.likeButtonSelected.alpha = 1.0;
        } completion:^(BOOL finished) {
            self.LikeButton.hidden = YES;
        }];
        
        int IntLike = [likelabel intValue];
        IntLike++;
        likelabel = [NSString stringWithFormat:@"%d",IntLike];
        
        dispatch_queue_t queue = dispatch_queue_create("com.MyQueue3", NULL);
        dispatch_async(queue, ^{
            NSString *url = [NSString stringWithFormat:@"http://www.dealers.co.il/setLikeToDeal.php?Userid=%@&Indicator=%@&Dealid=%@",app.UserID,@"updatelikestables",[_dealClass dealID]];
            NSLog(@"url updatin after like: %@", url);
//            NSData *URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
//            NSString *DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
        });
    }
}

-(void) loadDataFromDB {
    NSString *url = [NSString stringWithFormat:@"http://www.dealers.co.il/setLikeToDeal.php?Indicator=%@&Dealid=%@",@"wholikesthedeal",[_dealClass dealID]];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==_tableViewLikes) {
        NSLog(@"count=%lu",(unsigned long)[_dealersNameArray count]);
        if ([_dealersNameArray count] == 0) {
            return 0;
        }
        return [_dealersNameArray count];
    } else return [_dealersNameArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LikesCell *Cell=nil;
    if (tableView==_tableViewLikes) {
        
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
    return Cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableViewLikes deselectRowAtIndexPath:indexPath animated:YES];
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
    
    if ([[segue identifier] isEqualToString:@"editDealID"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        EditDealTableViewController *edtvc = (EditDealTableViewController *)[navigationController topViewController];
        edtvc.originalDeal = self.dealClass;
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
}

- (IBAction)ShareButtonAction:(id)sender {
    NSString *name = @"Dealers";
    NSArray *activityItems = @[name];
    UIActivityViewController *acv = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:acv animated:YES completion:nil];
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
    _dealClass=nil;
    _isShoetCell=nil;
    _likeornotLabelFromMyFeeds=nil;
    _urlImage=nil;
    _urlImage2=nil;
    _urlImage3=nil;
    _urlImage4=nil;
}

-(void)viewDidDisappear:(BOOL)animated {
    [self deallocMapView];
}

- (IBAction)dealerProfileButtonClicked:(id)sender {
    ProfileViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"profile"];
    controller.dealerId=[_dealClass dealUserID];
    controller.didComeFromLikesTable=@"yes";
    UINavigationController *navigationController = self.navigationController;
    [navigationController pushViewController:controller animated:YES];
}

- (IBAction)urlSiteButtonClicked:(id)sender {
    NSString *DataResult;
    if (![[_dealClass dealUrlSite] isEqualToString:@"0"]) {
        DataResult = [@"http://" stringByAppendingString:[_dealClass dealUrlSite]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:DataResult]];
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
    UINavigationController *navigationController = self.navigationController;
    NSArray *viewControllers = self.navigationController.viewControllers;
    [navigationController popToViewController:[viewControllers objectAtIndex:2] animated:NO];
    [navigationController pushViewController:controller animated:NO];
}

-(void) func2 {
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    app.previousViewControllerAddDeal=@"online";
    app.onlineOrLocal=@"online";
    OnlineViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"OnlineView"];
    UINavigationController *navigationController = self.navigationController;
    NSArray *viewControllers = self.navigationController.viewControllers;
    [navigationController popToViewController:[viewControllers objectAtIndex:2] animated:NO];
    [navigationController pushViewController:controller animated:NO];
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
    
    //    UIButton *selectDealButton9=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [selectDealButton9 setTitle:@"" forState:UIControlStateNormal];
    //    selectDealButton9.frame=CGRectMake(0, 0,([[UIScreen mainScreen] bounds].size.width),([[UIScreen mainScreen] bounds].size.height-68));
    //    selectDealButton9.tag=110;
    //    [selectDealButton9 setBackgroundColor:[UIColor whiteColor]];
    //    selectDealButton9.alpha=0.0;
    //    [[self view] addSubview:selectDealButton9];
    
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
    
    UILabel *label7=[[UILabel alloc]initWithFrame:CGRectMake(0, ([[UIScreen mainScreen] bounds].size.height)-246, 320, 22)];
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
    [self deallocMemory];
    UINavigationController *navigationController = self.navigationController;
    NSArray *viewControllers = self.navigationController.viewControllers;
    [navigationController popToViewController:[viewControllers objectAtIndex:2] animated:NO];
}

-(void) exploreClicked:(id)sender {
    [self deallocMemory];
    ExploretableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"explore"];
    UINavigationController *navigationController = self.navigationController;
    NSArray *viewControllers = self.navigationController.viewControllers;
    [navigationController popToViewController:[viewControllers objectAtIndex:2] animated:NO];
    [navigationController pushViewController:controller animated:NO];
}

-(void) moreClicked:(id)sender {
    [self deallocMemory];
    MoreViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"more"];
    UINavigationController *navigationController = self.navigationController;
    NSArray *viewControllers = self.navigationController.viewControllers;
    [navigationController popToViewController:[viewControllers objectAtIndex:2] animated:NO];
    [navigationController pushViewController:controller animated:NO];
}

-(void) profileClicked:(id)sender {
    [self deallocMemory];
    ProfileViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"profile"];
    UINavigationController *navigationController = self.navigationController;
    NSArray *viewControllers = self.navigationController.viewControllers;
    [navigationController popToViewController:[viewControllers objectAtIndex:2] animated:NO];
    [navigationController pushViewController:controller animated:NO];
}

-(void) hideLocalOrOnlineView {
    NSLog(@"remove cover");
    UIButton *button1 = (UIButton*)[self.view viewWithTag:100];
    UIButton *button2 = (UIButton*)[self.view viewWithTag:101];
    UIButton *button3 = (UIButton*)[self.view viewWithTag:102];
    UILabel *label1 = (UILabel*)[self.view viewWithTag:103];
    UILabel *label2 = (UILabel*)[self.view viewWithTag:104];
    
    [UIView animateWithDuration:0.5 animations:^{button1.alpha=0.0;
        button2.alpha=0.0;
        button3.alpha=0.0;
        label1.alpha=0.0;
        label2.alpha=0.0;
    }];
    
}

-(void) showLocalOrOnlineView:(id)sender {
    UIButton *button1 = (UIButton*)[self.view viewWithTag:100];
    UIButton *button2 = (UIButton*)[self.view viewWithTag:101];
    UIButton *button3 = (UIButton*)[self.view viewWithTag:102];
    UILabel *label1 = (UILabel*)[self.view viewWithTag:103];
    UILabel *label2 = (UILabel*)[self.view viewWithTag:104];
    UIButton *button4 = (UIButton*)[self.view viewWithTag:120];
    [self.view bringSubviewToFront:button4];
    
    [UIView animateWithDuration:0.5 animations:^{button1.alpha=0.8;
        button2.alpha=1.0;
        button3.alpha=1.0;
        label1.alpha=1.0;
        label2.alpha=1.0;
    }];
    
}

-(void) showWhiteCover {
    UIButton *button1 = (UIButton*)[self.view viewWithTag:110];
    UIButton *button2 = (UIButton*)[self.view viewWithTag:120];
    [self.view bringSubviewToFront:button1];
    [self.view bringSubviewToFront:button2];
    button1.alpha=0.8;
}

-(void) removeWhiteCover {
    NSLog(@"remove white cover");
    UIButton *button1 = (UIButton*)[self.view viewWithTag:110];
    button1.alpha=0.0;
}


@end

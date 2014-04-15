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


#define GAP 12

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
@synthesize productimage;
@synthesize clientimage,ReturnButton,ReturnButtonFull,BlueButtonsView,OnlineButton,OnlineText,LocalButton,LocalText,LockTableButton;

-(void) startLoadingUploadImage {
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
    [UIView animateWithDuration:0.2 animations:^{_loadingImage.alpha=1.0; _loadingImage.transform =CGAffineTransformMakeScale(0,0);
        _loadingImage.transform =CGAffineTransformMakeScale(1,1);}];
}

-(void) maskUserProfileImage {
    CALayer *mask = [CALayer layer];
    mask.contents=(id)[[UIImage imageNamed:@"Registration_Email button.png"]CGImage];
    mask.frame = CGRectMake(0, 0, 60, 60);
    clientimage.layer.mask = mask;
    clientimage.layer.masksToBounds = YES;
}

-(void) setViewUnderDealParameters {
    CGRect frame = self.SecondView.frame;
    frame.origin.y = 7+lowestYPoint;
    self.SecondView.frame = frame;
    
}
-(void) setScrollSize {
    [scroll setScrollEnabled:YES];
    int BottumCoordinate=CGRectGetMaxY(self.SecondView.frame);
    [scroll setContentSize:((CGSizeMake(320, BottumCoordinate)))];
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

-(void) locateIconsInPlace {
    
    [self maskUserProfileImage];
    flag = NO;
    int offset;
    if (numofpics==0) {
        offset=10;
    } else offset=184;
    
    self.TitleIcon.frame = CGRectMake(10, offset, self.TitleIcon.frame.size.width, self.TitleIcon.frame.size.height);
    titlelabel.frame = CGRectMake(50, offset+4, titlelabel.frame.size.width, titlelabel.frame.size.height);
    titlelabel.numberOfLines=0;
    [titlelabel sizeToFit];
    
    lowestYPoint=(CGRectGetMaxY(self.TitleIcon.frame) > CGRectGetMaxY(titlelabel.frame)) ? CGRectGetMaxY(self.TitleIcon.frame) : CGRectGetMaxY(titlelabel.frame);
    
    self.StoreIcon.frame = CGRectMake(10, lowestYPoint + GAP, self.StoreIcon.frame.size.width, self.StoreIcon.frame.size.height);
    storelabel.frame = CGRectMake(50, lowestYPoint+3+GAP, storelabel.frame.size.width, storelabel.frame.size.height);
    
    lowestYPoint=(CGRectGetMaxY(self.StoreIcon.frame) > CGRectGetMaxY(storelabel.frame)) ? CGRectGetMaxY(self.StoreIcon.frame) : CGRectGetMaxY(storelabel.frame);
    
    
    if ((![categorylabel.text isEqualToString:@""]) || (![categorylabel.text isEqualToString:@"No Category"])) {
        self.CategoryIcon.frame = CGRectMake(10, lowestYPoint + GAP, self.CategoryIcon.frame.size.width, self.CategoryIcon.frame.size.height);
        categorylabel.frame = CGRectMake(50, lowestYPoint+3+GAP, categorylabel.frame.size.width, categorylabel.frame.size.height);
        lowestYPoint=(CGRectGetMaxY(self.CategoryIcon.frame) > CGRectGetMaxY(categorylabel.frame)) ? CGRectGetMaxY(self.CategoryIcon.frame) : CGRectGetMaxY(categorylabel.frame);
    } else {
        categorylabel.hidden=YES;
        self.CategoryIcon.hidden=YES;
    }
    
    maxXPoint=50;
    
    if (![pricelabel.text isEqualToString:@"0"]) {
        pricelabel.text = [pricelabel.text stringByAppendingString:[self currencySymbol:self.signLabelFromMyFeeds]];
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
    
    NSLog(@"expire=%@",expirelabel.text);
    if ((![expirelabel.text isEqualToString:@"0000-00-00 00:00:00"])&&([expirelabel.text length]>0)) {
        self.ExpireIcon.frame = CGRectMake(10, lowestYPoint + GAP, self.ExpireIcon.frame.size.width, self.ExpireIcon.frame.size.height);
        expirelabel.frame = CGRectMake(50, lowestYPoint+3+GAP, expirelabel.frame.size.width, expirelabel.frame.size.height);
        lowestYPoint=(CGRectGetMaxY(self.ExpireIcon.frame) > CGRectGetMaxY(expirelabel.frame)) ? CGRectGetMaxY(self.ExpireIcon.frame) : CGRectGetMaxY(expirelabel.frame);
    } else {
        expirelabel.hidden=YES;
        self.ExpireIcon.hidden=YES;
    }
    
    
    if (!([descriptionlabel.text length]==0)) {
        descriptionlabel.numberOfLines=0;
        [descriptionlabel sizeToFit];
        self.DescriptionIcon.frame = CGRectMake(10, lowestYPoint + GAP, self.DescriptionIcon.frame.size.width, self.DescriptionIcon.frame.size.height);
        descriptionlabel.frame = CGRectMake(50, lowestYPoint+3+GAP, descriptionlabel.frame.size.width, descriptionlabel.frame.size.height);
        lowestYPoint=(CGRectGetMaxY(self.DescriptionIcon.frame) > CGRectGetMaxY(descriptionlabel.frame)) ? CGRectGetMaxY(self.DescriptionIcon.frame) : CGRectGetMaxY(descriptionlabel.frame);
    } else {
        descriptionlabel.hidden=YES;
        self.DescriptionIcon.hidden=YES;
    }
    
    [self setViewUnderDealParameters];
    [self setScrollSize];
}

-(void) loadImageFromUrl {
    if (numofpics!=0) {
        NSString *FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/setLikeToDeal.php?Indicator=bringphotos&Dealid=%@",_dealidLabelFromMyFeeds];
        NSLog(@"%d",numofpics);
        NSData *URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
        NSString *DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
        NSArray *DataArray = [DataResult componentsSeparatedByString:@"^"];
        
        if (numofpics==1) {
            _urlImage = [NSString stringWithFormat:@"http://www.dealers.co.il/%@.jpg",self.photoIdLabelFromMyFeeds];
            _tempImage=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_urlImage]]];
        }
        if (numofpics==2) {
            _urlImage = [NSString stringWithFormat:@"http://www.dealers.co.il/%@.jpg",self.photoIdLabelFromMyFeeds];
            _urlImage2 = [NSString stringWithFormat:@"http://www.dealers.co.il/%@.jpg",DataArray[0]];
            _tempImage=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_urlImage]]];
            _tempImage2=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_urlImage2]]];
            
        }
        if (numofpics==3) {
            _urlImage = [NSString stringWithFormat:@"http://www.dealers.co.il/%@.jpg",self.photoIdLabelFromMyFeeds];
            _urlImage2 = [NSString stringWithFormat:@"http://www.dealers.co.il/%@.jpg",DataArray[0]];
            _urlImage3 = [NSString stringWithFormat:@"http://www.dealers.co.il/%@.jpg",DataArray[1]];
            _tempImage=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_urlImage]]];
            _tempImage2=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_urlImage2]]];
            _tempImage3=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_urlImage3]]];
            
            
        }
        if (numofpics==4) {
            _urlImage = [NSString stringWithFormat:@"http://www.dealers.co.il/%@.jpg",self.photoIdLabelFromMyFeeds];
            _urlImage2 = [NSString stringWithFormat:@"http://www.dealers.co.il/%@.jpg",DataArray[0]];
            _urlImage3 = [NSString stringWithFormat:@"http://www.dealers.co.il/%@.jpg",DataArray[1]];
            _urlImage4 = [NSString stringWithFormat:@"http://www.dealers.co.il/%@.jpg",DataArray[2]];
            _tempImage=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_urlImage]]];
            _tempImage2=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_urlImage2]]];
            _tempImage3=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_urlImage3]]];
            _tempImage4=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_urlImage4]]];
            
        }
    }
    
}

-(void) loadImage {
    if (numofpics==0) {
        self.captureImage.image=[UIImage imageNamed:@"nodeal.jpeg"];
    }
    if (numofpics==1) {
        self.captureImage.image = _tempImage;
    }
    if (numofpics==2) {
        self.captureImage.image = _tempImage;
        self.captureImage2.image = _tempImage2;
    }
    if (numofpics==3) {
        self.captureImage.image = _tempImage;
        self.captureImage2.image = _tempImage2;
        self.captureImage3.image = _tempImage3;
    }
    if (numofpics==4) {
        self.captureImage.image = _tempImage;
        self.captureImage2.image = _tempImage2;
        self.captureImage3.image = _tempImage3;
        self.captureImage4.image = _tempImage4;
    }
    _tempImage=nil;
    _tempImage2=nil;
    _tempImage3=nil;
    _tempImage4=nil;
    
    [_loadingImage stopAnimating];
    _loadingImage.hidden=YES;
}

-(void) loadVarsFromDeal{
    titlelabel.text = self.titleLabelFromMyFeeds;
    storelabel.text = self.storeLabelFromMyFeeds;
    categorylabel.text = self.categoryLabelFromMyFeeds;
    pricelabel.text = self.priceLabelFromMyFeeds;
    discountlabel.text = self.discountLabelFromMyFeeds;
    expirelabel.text = self.expireLabelFromMyFeeds;
    descriptionlabel.text = self.descriptionLabelFromMyFeeds;
    likelabel.text = self.likeLabelFromMyFeeds;
    commentlabel.text = self.commentLabelFromMyFeeds;
    LikeOrUnlike=TRUE;
}

-(int) numOfPicturesInTheDeal {
    NSString *FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/setLikeToDeal.php?Indicator=howmanyphotos&Dealid=%@",_dealidLabelFromMyFeeds];
    NSData *URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
    NSString *DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    return [DataResult intValue];
}

-(void) dealerViewInitialize {
    dispatch_queue_t queue = dispatch_queue_create("com.MyQueue2", NULL);
    dispatch_async(queue, ^{
        // Do some computation here.
        NSString *FindURL = [NSString stringWithFormat:@"http://www.dealers.co.il/setLikeToDeal.php?Indicator=whodiduploadthedeal&Dealid=%@",_dealidLabelFromMyFeeds];
        NSData *URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:FindURL]];
        NSString *DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
        NSArray *DataArray = [DataResult componentsSeparatedByString:@"^"];
        NSString *urlImage = [NSString stringWithFormat:@"http://www.dealers.co.il/%@.jpg",[DataArray objectAtIndex:2]];
        // Update UI after computation.
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI on the main thread.
            _uploadDateLabel.text=[DataArray objectAtIndex:0];
            _dealersNameLabel.text=[DataArray objectAtIndex:1];
            self.clientimage.image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlImage]]];
        });
    });
    
}

- (void)viewDidLoad
{
    numofpics=[self numOfPicturesInTheDeal];
    if (numofpics==0) {
        self.cameraScrollView.hidden=YES;
    }
    if ([_likeornotLabelFromMyFeeds isEqualToString:@"yes"]) {
        _LikeButton.enabled=NO;
    }
    viewDidApear=YES;
    cellNumberInScrollView=0;
    likesView = NO;
    [super viewDidLoad];
    [self startLoadingUploadImage];
    [self loadVarsFromDeal];
    [self locateIconsInPlace];
    [self dealerViewInitialize];
    if (numofpics>=2) {
        _pageControl.hidden=NO;
    } else _pageControl.hidden=YES;
    self.pageControl.numberOfPages=numofpics;
    _ViewLikes.hidden=YES;
    [self.cameraScrollView setContentSize:((CGSizeMake(320*numofpics, 155)))];
    [self.cameraScrollView setScrollEnabled:YES];
    if ([_likeornotLabelFromMyFeeds isEqualToString:@"yes"]) {
        NSLog(@"changing the button, %@",_likeornotLabelFromMyFeeds);
        [_LikeButton setImage:[UIImage imageNamed:@"My Feed+View Deal (final)_Like button (selected).png"] forState:UIControlStateNormal];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    if (viewDidApear) {
        viewDidApear=NO;
        dispatch_queue_t queue = dispatch_queue_create("com.MyQueue", NULL);
        dispatch_async(queue, ^{
            // Do some computation here.
            [self loadImageFromUrl];
            // Update UI after computation.
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI on the main thread.
                [self loadImage];
            });
        });
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (IBAction)ReturnButtonAction:(id)sender {
    
    if (likesView) {
        _ViewLikes.hidden=YES;
        likesView=NO;
    } else {
        //AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        //app.AfterAddDeal=@"yes";
        ReturnButtonFull.alpha=1.0;
        ReturnButton.alpha=0.0;
        [UIView animateWithDuration:0.2 animations:^{self.ReturnButtonFull.alpha=0.0;}];
        [UIView animateWithDuration:0.2 animations:^{self.ReturnButton.alpha=1.0;}];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (IBAction)myfeedbutton:(id)sender{
    [self deallocMemory];
    
    UINavigationController *navigationController = self.navigationController;
    [navigationController popViewControllerAnimated:YES];
}
- (IBAction)morebutton:(id)sender{
    [self deallocMemory];
    
    MoreViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"more"];
    UINavigationController *navigationController = self.navigationController;
    [navigationController popViewControllerAnimated:NO];
    [navigationController pushViewController:controller animated:NO];
}

- (IBAction)profilebutton:(id)sender{
    [self deallocMemory];
    
    ProfileViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"profile"];
    UINavigationController *navigationController = self.navigationController;
    [navigationController popViewControllerAnimated:NO];
    [navigationController pushViewController:controller animated:NO];
}

- (IBAction)explorebutton:(id)sender{
    [self deallocMemory];
    ExploretableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"explore"];
    UINavigationController *navigationController = self.navigationController;
    [navigationController popViewControllerAnimated:NO];
    [navigationController pushViewController:controller animated:NO];
}

- (IBAction)Adddeal:(id)sender {
    LockTableButton.alpha=1.0;
    [UIView animateWithDuration:0.5 animations:^{BlueButtonsView.alpha=1.0;}];
}

-(IBAction)UNLockButtonAction:(id)sender{
    LockTableButton.alpha=0.0;
    [UIView animateWithDuration:0.5 animations:^{BlueButtonsView.alpha=0.0;}];
}

-(void) AddDealFunction {
    [self deallocMemory];
    TableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TableView"];
    UINavigationController *navigationController = self.navigationController;
    [navigationController popViewControllerAnimated:NO];
    [navigationController pushViewController:controller animated:NO];
    self.BlueButtonsView.alpha=0.0;
    LockTableButton.alpha=0.0;
}

-(void)LocalButtonAction:(id)sender{
    [self deallocMemory];
    [UIView animateWithDuration:0.5 animations:^{self.BlueButtonsView.alpha=0.0;}];
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(AddDealFunction) userInfo:nil repeats:NO];
}

-(void)OnlineButtonAction:(id)sender{
    
}

- (IBAction)LikeButtonAction:(id)sender {
    
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    if ([_likeornotLabelFromMyFeeds isEqualToString:@"no"]) {
        _LikeButton.enabled=NO;
        _likeornotLabelFromMyFeeds=@"yes";
        [self.LikeButton setImage:[UIImage imageNamed:@"My Feed+View Deal (final)_Like button (selected).png"] forState:UIControlStateNormal];
        int IntLike = [likelabel.text intValue];
        IntLike++;
        likelabel.text=[NSString stringWithFormat:@"%d",IntLike];
        NSString *url = [NSString stringWithFormat:@"http://www.dealers.co.il/setLikeToDeal.php?Userid=%@&Indicator=%@&Dealid=%@",app.UserID,@"updatelikestables",_dealidLabelFromMyFeeds];
        NSLog(@"url updatin after like: %@", url);
        NSData *URLData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        NSString *DataResult = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    }
}

/*-(void) hiddenWhiteCoverView {
 [UIView animateWithDuration:0.5 animations:^{self.whiteCoverView.alpha=0.0;}];
 [self.LoadingImage stopAnimating];
 }*/

-(void) loadDataFromDB {
    NSString *url = [NSString stringWithFormat:@"http://www.dealers.co.il/setLikeToDeal.php?Indicator=%@&Dealid=%@",@"wholikesthedeal",_dealidLabelFromMyFeeds];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableViewLikes deselectRowAtIndexPath:indexPath animated:YES];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"likescell"]) {
        NSIndexPath *indexpath = [_tableViewLikes indexPathForSelectedRow];
        NSString *string;
        string = [_dealersidArray objectAtIndex:indexpath.row];
        [[segue destinationViewController] setDealerId:string];
        [[segue destinationViewController] setDidComeFromLikesTable:@"yes"];
        
    }
}


- (IBAction)whoLikesTheDeal:(id)sender{
    
    if (![likelabel.text isEqualToString:@"0"]) {
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
    self.pageControl.currentPage=currentpage;
}

-(void) deallocMemory {
    self.titleLabelFromMyFeeds=nil;
    self.storeLabelFromMyFeeds=nil;
    self.categoryLabelFromMyFeeds=nil;
    self.priceLabelFromMyFeeds=nil;
    self.discountLabelFromMyFeeds=nil;
    self.expireLabelFromMyFeeds=nil;
    self.descriptionLabelFromMyFeeds=nil;
    self.photoIdLabelFromMyFeeds=nil;
    self.likeLabelFromMyFeeds=nil;
    self.commentLabelFromMyFeeds=nil;
    self.clientIdLabelFromMyFeeds=nil;
    self.signLabelFromMyFeeds=nil;
    NSLog(@"dealloc viewdeal");
}
-(void)viewDidDisappear:(BOOL)animated {
    /*
     self.titleLabelFromMyFeeds=nil;
     self.storeLabelFromMyFeeds=nil;
     self.categoryLabelFromMyFeeds=nil;
     self.priceLabelFromMyFeeds=nil;
     self.discountLabelFromMyFeeds=nil;
     self.expireLabelFromMyFeeds=nil;
     self.descriptionLabelFromMyFeeds=nil;
     self.photoIdLabelFromMyFeeds=nil;
     self.likeLabelFromMyFeeds=nil;
     self.commentLabelFromMyFeeds=nil;
     self.clientIdLabelFromMyFeeds=nil;
     self.signLabelFromMyFeeds=nil;
     NSArray *viewsToRemove = [self.view subviews];
     for (UIView *v in viewsToRemove) {
     [v removeFromSuperview];
     }
     [self.view removeFromSuperview];
     self.view=nil;
     NSLog(@"dealloc viewdeal");*/
}


@end

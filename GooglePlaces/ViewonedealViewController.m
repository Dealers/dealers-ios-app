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


#define GAP 10

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
    mask.frame = CGRectMake(0, 0, 70, 70);
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
    
    self.TitleIcon.frame = CGRectMake(15, 194, self.TitleIcon.frame.size.width, self.TitleIcon.frame.size.height);
    titlelabel.frame = CGRectMake(56, 195, titlelabel.frame.size.width, titlelabel.frame.size.height);
    titlelabel.numberOfLines=0;
    [titlelabel sizeToFit];

    lowestYPoint=(CGRectGetMaxY(self.TitleIcon.frame) > CGRectGetMaxY(titlelabel.frame)) ? CGRectGetMaxY(self.TitleIcon.frame) : CGRectGetMaxY(titlelabel.frame);
    
    self.StoreIcon.frame = CGRectMake(15, lowestYPoint + GAP, self.StoreIcon.frame.size.width, self.StoreIcon.frame.size.height);
    storelabel.frame = CGRectMake(56, lowestYPoint+1+GAP, storelabel.frame.size.width, storelabel.frame.size.height);
    
    lowestYPoint=(CGRectGetMaxY(self.StoreIcon.frame) > CGRectGetMaxY(storelabel.frame)) ? CGRectGetMaxY(self.StoreIcon.frame) : CGRectGetMaxY(storelabel.frame);

    
    if ((![categorylabel.text isEqualToString:@""]) || (![categorylabel.text isEqualToString:@"No Category"])) {
        self.CategoryIcon.frame = CGRectMake(15, lowestYPoint + GAP, self.CategoryIcon.frame.size.width, self.CategoryIcon.frame.size.height);
        categorylabel.frame = CGRectMake(56, lowestYPoint+1+GAP, categorylabel.frame.size.width, categorylabel.frame.size.height);
        lowestYPoint=(CGRectGetMaxY(self.CategoryIcon.frame) > CGRectGetMaxY(categorylabel.frame)) ? CGRectGetMaxY(self.CategoryIcon.frame) : CGRectGetMaxY(categorylabel.frame);
    } else {
        categorylabel.hidden=YES;
        self.CategoryIcon.hidden=YES;
    }
    
    maxXPoint=56;
    
    if (![pricelabel.text isEqualToString:@"0"]) {
        pricelabel.text = [pricelabel.text stringByAppendingString:[self currencySymbol:self.signLabelFromMyFeeds]];
        [pricelabel sizeToFit];
        self.PriceIcon.frame = CGRectMake(15, lowestYPoint + GAP, self.PriceIcon.frame.size.width, self.PriceIcon.frame.size.height);
        pricelabel.frame = CGRectMake(maxXPoint, lowestYPoint+1+GAP, pricelabel.frame.size.width, pricelabel.frame.size.height);
        flag = YES;
        maxXPoint= CGRectGetMaxX (pricelabel.frame)+20;
    } else {
        pricelabel.hidden=YES;
    }
    
    if (![discountlabel.text isEqualToString:@"0"]) {
        discountlabel.text = [discountlabel.text stringByAppendingString:@"%"];
        self.PriceIcon.frame = CGRectMake(15, lowestYPoint + GAP, self.PriceIcon.frame.size.width, self.PriceIcon.frame.size.height);
        discountlabel.frame = CGRectMake(maxXPoint, lowestYPoint+1+GAP, discountlabel.frame.size.width, discountlabel.frame.size.height);
        lowestYPoint=(CGRectGetMaxY(self.PriceIcon.frame) > CGRectGetMaxY(discountlabel.frame)) ? CGRectGetMaxY(self.PriceIcon.frame) : CGRectGetMaxY(discountlabel.frame);
    } else {
        discountlabel.hidden=YES;
        if (![pricelabel.text isEqualToString:@"0"]) {
            lowestYPoint=(CGRectGetMaxY(self.PriceIcon.frame) > CGRectGetMaxY(pricelabel.frame)) ? CGRectGetMaxY(self.PriceIcon.frame) : CGRectGetMaxY(pricelabel.frame);
        }
    }
    

    if ((pricelabel.hidden == YES) && (discountlabel.hidden == YES)) self.PriceIcon.hidden=YES;
    
    if (![expirelabel.text isEqualToString:@"0000-00-00 00:00:00"]) {
        self.ExpireIcon.frame = CGRectMake(15, lowestYPoint + GAP, self.ExpireIcon.frame.size.width, self.ExpireIcon.frame.size.height);
        expirelabel.frame = CGRectMake(56, lowestYPoint+1+GAP, expirelabel.frame.size.width, expirelabel.frame.size.height);
        lowestYPoint=(CGRectGetMaxY(self.ExpireIcon.frame) > CGRectGetMaxY(expirelabel.frame)) ? CGRectGetMaxY(self.ExpireIcon.frame) : CGRectGetMaxY(expirelabel.frame);
    } else {
        expirelabel.hidden=YES;
        self.ExpireIcon.hidden=YES;
    }

    
    if (!([descriptionlabel.text length]==0)) {
        descriptionlabel.numberOfLines=0;
        [descriptionlabel sizeToFit];
        self.DescriptionIcon.frame = CGRectMake(15, lowestYPoint + GAP, self.DescriptionIcon.frame.size.width, self.DescriptionIcon.frame.size.height);
        descriptionlabel.frame = CGRectMake(56, lowestYPoint+1+GAP, descriptionlabel.frame.size.width, descriptionlabel.frame.size.height);
        lowestYPoint=(CGRectGetMaxY(self.DescriptionIcon.frame) > CGRectGetMaxY(descriptionlabel.frame)) ? CGRectGetMaxY(self.DescriptionIcon.frame) : CGRectGetMaxY(descriptionlabel.frame);
    } else {
        descriptionlabel.hidden=YES;
        self.DescriptionIcon.hidden=YES;
    }

    [self setViewUnderDealParameters];
    [self setScrollSize];
}

-(void) loadImageFromUrl {
    _urlImage = [NSString stringWithFormat:@"http://www.dealers.co.il/%@.jpg",self.photoIdLabelFromMyFeeds];
}

-(void) loadImage {
    self.captureImage.image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_urlImage]]];
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
    return 1;
}
- (void)viewDidLoad
{
    viewDidApear=YES;
    [super viewDidLoad];
    [self startLoadingUploadImage];
    [self loadVarsFromDeal];
    [self locateIconsInPlace];
    self.pageControl.numberOfPages=0;//[self numOfPicturesInTheDeal];
    [self.cameraScrollView setContentSize:((CGSizeMake(320*numofpics, 155)))];
    [self.cameraScrollView setScrollEnabled:YES];
    NSLog(@"%@",_likeornotLabelFromMyFeeds);
    if (_likeornotLabelFromMyFeeds) {
        [_LikeButton setImage:[UIImage imageNamed:@"My Feed+View Deal (final)_Like button (pushed).png"] forState:UIControlStateNormal];
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
    ReturnButtonFull.alpha=1.0;
    ReturnButton.alpha=0.0;
    [UIView animateWithDuration:0.2 animations:^{self.ReturnButtonFull.alpha=0.0;}];
    [UIView animateWithDuration:0.2 animations:^{self.ReturnButton.alpha=1.0;}];
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)myfeedbutton:(id)sender{
    //ViewalldealsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"myfeeds"];
    //[self.navigationController pushViewController:controller animated:NO];
}
- (IBAction)morebutton:(id)sender{
   // MoreViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"more"];
   // [self.navigationController pushViewController:controller animated:NO];
}

- (IBAction)profilebutton:(id)sender{
    //ProfileViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"profile"];
   // [self.navigationController pushViewController:controller animated:NO];
    
}
- (IBAction)explorebutton:(id)sender{
   // ExploretableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"explore"];
    //[self.navigationController pushViewController:controller animated:NO];
}

- (IBAction)Adddeal:(id)sender {
    //LockTableButton.alpha=1.0;
    //[UIView animateWithDuration:0.5 animations:^{BlueButtonsView.alpha=1.0;}];
}

-(IBAction)UNLockButtonAction:(id)sender{
    LockTableButton.alpha=0.0;
    [UIView animateWithDuration:0.5 animations:^{BlueButtonsView.alpha=0.0;}];
}

-(void) AddDealFunction {
    TableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TableView"];
    [self.navigationController presentViewController:controller animated:NO completion:nil];
    BlueButtonsView.alpha=0.0;
    LockTableButton.alpha=0.0;
}

-(void)LocalButtonAction:(id)sender{
    [UIView animateWithDuration:0.5 animations:^{self.BlueButtonsView.alpha=0.0;}];
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(AddDealFunction) userInfo:nil repeats:NO];
}

-(void)OnlineButtonAction:(id)sender{
    
}

- (IBAction)LikeButtonAction:(id)sender {
    if (LikeOrUnlike) {
        [self.LikeButton setImage:[UIImage imageNamed:@"My Feed+View Deal (final)_Like button (selected).png"] forState:UIControlStateNormal];
        LikeOrUnlike=FALSE;
        int IntLike = [likelabel.text intValue];
        IntLike++;
        likelabel.text=[NSString stringWithFormat:@"%d",IntLike];
    } else {
        [self.LikeButton setImage:[UIImage imageNamed:@"My Feed+View Deal (final)_Like button.png"] forState:UIControlStateNormal];
        LikeOrUnlike=TRUE;
        int IntLike = [likelabel.text intValue];
        IntLike--;
        likelabel.text=[NSString stringWithFormat:@"%d",IntLike];
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

-(void)viewDidDisappear:(BOOL)animated {
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
    NSLog(@"dealloc viewdeal");
}
@end

//
//  ProfileViewController.m
//  Dealers
//
//  Created by itzik berrebi on 11/6/13.
//
//

#import "ProfileViewController.h"
#import "ViewonedealViewController.h"
#import "MoreViewController.h"
#import "ExploretableViewController.h"
#import "AppDelegate.h"
#import "TableViewController.h"
#define OFFSETSHORTCELL 80
#define OFFSET -40

@interface ProfileViewController ()

@end

@implementation ProfileViewController
@synthesize OnlineButton,OnlineText,LocalButton,LocalText,LockTableButton;

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

-(void) loadDataFromDB {
    
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
    _USERSIDSARRAY = [NSMutableArray arrayWithArray:USERSIDSARRAY_temp];

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
    _CATEGORYARRAY = [[NSMutableArray alloc]init];
    _SIGNARRAY =  [[NSMutableArray alloc]init];
    _DEALIDARRAY = [[NSMutableArray alloc]init];
    _USERSIDSARRAY = [[NSMutableArray alloc]init];
}

-(void) startCreatingDealsCells {

    NSArray *viewsToRemove = [_dealsView subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }

    for (int i=1; ((i<5) && (i<[_TITLEMARRAY count])); i++) {
        NSString *num=[_PHOTOIDMARRAY objectAtIndex:i];
        
        if ([num isEqualToString:@"0"]) {
            isShortCell = YES;
        } else isShortCell = NO;
        
        UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal (final)_Deal background & Shadow.png"]];
        [imageview setFrame:CGRectMake(0, 4+(GAP), 320, 193-(OFFSETSHORTCELL*isShortCell))];
		[[self dealsView] addSubview:imageview];
        
        UIImageView *imageview2 = [[UIImageView alloc]init];
        NSString *URLforphoto = [NSString stringWithFormat:@"http://www.dealers.co.il/%@.jpg",num];
        imageview2.image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:URLforphoto]]];
        [imageview2 setFrame:CGRectMake(7.5, 9+(GAP), 305, 155)];
        CALayer *mask = [CALayer layer];
        mask.contents=(id)[[UIImage imageNamed:@"My Feed+View Deal (final)_Deal Pic mask.png"]CGImage];
        mask.frame = CGRectMake(0, 0, 305, 155);
        imageview2.layer.mask = mask;
        imageview2.layer.masksToBounds = YES;
        imageview2.tag=i;
        if (!isShortCell) [[self dealsView] addSubview:imageview2];
        
        UIImageView *imageview3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal (final)_Title & Store shade.png"]];
        [imageview3 setFrame:CGRectMake(7.5, 86+(GAP)-(OFFSETSHORTCELL*isShortCell), 305, 78)];
        [[self dealsView] addSubview:imageview3];
        
        UIImageView *imageview4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal (final)_Local icon.png"]];
        [imageview4 setFrame:CGRectMake(18, 170+(GAP)-(OFFSETSHORTCELL*isShortCell), 13, 16)];
        [[self dealsView] addSubview:imageview4];
        
        UIImageView *imageview5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal (final)_Likes icon.png"]];
        [imageview5 setFrame:CGRectMake(274, 124+(GAP)-(OFFSETSHORTCELL*isShortCell), 13, 12)];
        [[self dealsView] addSubview:imageview5];
        
        UIImageView *imageview6 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"My Feed+View Deal (final)_Comments icon.png"]];
        [imageview6 setFrame:CGRectMake(274, 143+(GAP)-(OFFSETSHORTCELL*isShortCell), 12, 14)];
        [[self dealsView] addSubview:imageview6];
        
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(18, 119+(GAP)-(OFFSETSHORTCELL*isShortCell), 249, 41)];
        [label setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:15.0]];
        label.text=[_TITLEMARRAY objectAtIndex:i];
        label.backgroundColor=[UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        [[self dealsView] addSubview:label];
        
        UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(35, 167+(GAP)-(OFFSETSHORTCELL*isShortCell), 175, 24)];
        [label2 setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:15.0]];
        label2.text=[_STOREMARRAY objectAtIndex:i];
        label2.backgroundColor=[UIColor clearColor];
        label2.textColor = [UIColor blackColor];
        [[self dealsView] addSubview:label2];
        
        UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(197, 169+(GAP)-(OFFSETSHORTCELL*isShortCell), 53, 21)];
        [label3 setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:13.0]];
        label3.text=[_PRICEMARRAY objectAtIndex:i];
        label3.backgroundColor=[UIColor clearColor];
        label3.textColor = [UIColor colorWithRed:(81/255.0) green:(206/255.0) blue:(72/255.0) alpha:1.0];
        [label3 sizeToFit];
        [[self dealsView] addSubview:label3];
        
        UILabel *label4=[[UILabel alloc]initWithFrame:CGRectMake(247, 169+(GAP)-(OFFSETSHORTCELL*isShortCell), 53, 21)];
        [label4 setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:13.0]];
        label4.text=[_DISCOUNTMARRAY objectAtIndex:i];
        label4.backgroundColor=[UIColor clearColor];
        label4.textColor = [UIColor colorWithRed:(255/255.0) green:(58/255.0) blue:(48/255.0) alpha:1.0];
        [label4 sizeToFit];
        [[self dealsView] addSubview:label4];
        
        UILabel *label5=[[UILabel alloc]initWithFrame:CGRectMake(290, 119+(GAP)-(OFFSETSHORTCELL*isShortCell), 21, 21)];
        [label5 setFont:[UIFont fontWithName:@"Avenir-Medium" size:13.0]];
        label5.text=[_LIKEMARRAY objectAtIndex:i];
        label5.backgroundColor=[UIColor clearColor];
        label5.textColor = [UIColor whiteColor];
        [label5 sizeToFit];
        [[self dealsView] addSubview:label5];
        
        UILabel *label6=[[UILabel alloc]initWithFrame:CGRectMake(290, 139+(GAP)-(OFFSETSHORTCELL*isShortCell), 21, 21)];
        [label6 setFont:[UIFont fontWithName:@"Avenir-Medium" size:13.0]];
        label6.text=[_COMMENTMARRAY objectAtIndex:i];
        label6.backgroundColor=[UIColor clearColor];
        label6.textColor = [UIColor whiteColor];
        [label6 sizeToFit];
        [[self dealsView] addSubview:label6];
        
        UIButton *selectDealButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [selectDealButton setTitle:@"" forState:UIControlStateNormal];
        selectDealButton.frame=CGRectMake(0, 4+(GAP), 319, 193-(OFFSETSHORTCELL*isShortCell));
        selectDealButton.tag=i;
        //[selectDealButton addTarget:self action:@selector() forControlEvents: UIControlEventTouchUpInside];
        [[self dealsView] addSubview:selectDealButton];
        
		GAP=CGRectGetMaxY(imageview.frame) + 5;
	}
    _dealsView.frame=CGRectMake(0, 250, 320, GAP);
    _dealsView.backgroundColor=[UIColor clearColor];
    _scrollView.contentSize=CGSizeMake(320,350+GAP);
    [_loadingImage stopAnimating];
    _loadingImage.hidden=YES;
    //[self performSelectorOnMainThread:@selector(hiddenWhiteCoverView) withObject:nil waitUntilDone:NO];
}

-(void) setTopPart {
    
    UIImage *image = [UIImage imageNamed: @"itzik.jpg"];
    _dealerProfileImage.image=image;
    CALayer *mask = [CALayer layer];
    mask.contents=(id)[[UIImage imageNamed:@"Registration_Email button.png"]CGImage];
    mask.frame = CGRectMake(0, 0, 100, 100);
    _dealerProfileImage.layer.mask = mask;
    _dealerProfileImage.layer.masksToBounds = YES;
    
    UIImage *image2 = [UIImage imageNamed: @"Profile_Master Dealer.png"];
    _dealerRankImage.image=image2;
    
    
    _dealerName.text=@"Itzik berrebi";
    
    _dealsCount.text=@"15 Deals";
    
    _followersCount.text=@"25 Followers";
    
    _followingCount.text=@"40 Following";
    
    
}

-(void) setScrollSize {
    //[_scrollView setContentSize:CGSizeMake(320, 500)];
}
-(void) initialize {
    _deals=@"b";
    _likes=@"a";
    GAP = 0;
    _likesView.hidden=YES;
    [self setScrollSize];
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    app.AfterAddDeal=@"aftertapbar";
}
- (void)viewDidLoad
{
    [self startLoadingUploadImage];
    [self initialize];
    [self allocArrays];
    [self setTopPart];
    dispatch_queue_t queue = dispatch_queue_create("com.MyQueue", NULL);
    dispatch_async(queue, ^{
        // Do some computation here.
      //  [self loadDataFromDB];
        // Update UI after computation.
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI on the main thread.
     //       [self startCreatingDealsCells];
        });
    });

    //[self performSelectorInBackground:@selector(loadDataFromDB) withObject:nil];
    [super viewDidLoad];
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
    _CATEGORYARRAY=nil;
    _SIGNARRAY=nil;
    _DEALIDARRAY=nil;
    _USERSIDSARRAY=nil;
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
    [self.navigationController popViewControllerAnimated:NO];
}
- (IBAction)morebutton:(id)sender{
   // MoreViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"more"];
   // [self.navigationController pushViewController:controller animated:NO];
}

- (IBAction)profilebutton:(id)sender{
  //  ProfileViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"profile"];
   // [self.navigationController pushViewController:controller animated:NO];
    
}
- (IBAction)explorebutton:(id)sender{
  //  ExploretableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"explore"];
   // [self.navigationController pushViewController:controller animated:NO];
    
    
}

- (IBAction)dealsViewButtonClicked:(id)sender {
    
    if ([_deals isEqual:@"b"]){
        [_dealsViewButton setImage:[UIImage imageNamed:@"Profile_Deals List tab (Selected).png"] forState:UIControlStateNormal];
        [_likesViewButton setImage:[UIImage imageNamed:@"Profile_Likes List tab.png"] forState:UIControlStateNormal];
        _deals=@"a";
        _likes=@"a";
        _likesView.hidden=YES;
        _dealsView.hidden=NO;
    }
}

- (IBAction)likesViewButtonClicked:(id)sender {
    
    if ([_likes isEqual:@"a"]){
        [_likesViewButton setImage:[UIImage imageNamed:@"Profile_Likes List tab (Selected).png"] forState:UIControlStateNormal];
        [_dealsViewButton setImage:[UIImage imageNamed:@"Profile_Deals List tab.png"] forState:UIControlStateNormal];
        _likes=@"b";
        _deals=@"b";
        _dealsView.hidden=YES;
        _likesView.hidden=NO;
    }
}

- (IBAction)Adddeal:(id)sender {
   // LockTableButton.alpha=1.0;
    //[UIView animateWithDuration:0.5 animations:^{_BlueButtonsView.alpha=1.0;}];
}

-(IBAction)UNLockButtonAction:(id)sender{
    LockTableButton.alpha=0.0;
    [UIView animateWithDuration:0.5 animations:^{_BlueButtonsView.alpha=0.0;}];
}

-(void) AddDealFunction {
    TableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TableView"];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navi animated:NO completion:nil];
    _BlueButtonsView.alpha=0.0;
    LockTableButton.alpha=0.0;
}

-(void)LocalButtonAction:(id)sender{
    [UIView animateWithDuration:0.5 animations:^{_BlueButtonsView.alpha=0.0;}];
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(AddDealFunction) userInfo:nil repeats:NO];
}

-(void)OnlineButtonAction:(id)sender{
    
}


@end
